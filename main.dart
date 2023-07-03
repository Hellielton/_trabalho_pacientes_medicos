import 'package:flutter/material.dart';

void main() {
  runApp(PacientesMedicosApp());
}

class PacientesMedicosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pacientes Médicos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PacientesListScreen(),
    );
  }
}

class PacientesListScreen extends StatefulWidget {
  @override
  _PacientesListScreenState createState() => _PacientesListScreenState();
}

class _PacientesListScreenState extends State<PacientesListScreen> {
  List<Paciente> pacientes = [
    Paciente('João', 25, 'Masculino', 'Rua A, 123', '(11) 99999-9999', '123456789'),
    Paciente('Maria', 30, 'Feminino', 'Rua B, 456', '(11) 88888-8888', '987654321'),
    Paciente('Pedro', 35, 'Masculino', 'Rua C, 789', '(11) 77777-7777', '456789123'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pacientes Médicos'),
      ),
      body: ListView.builder(
        itemCount: pacientes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(pacientes[index].nome),
            subtitle: Text('CPF: ${pacientes[index].cpf}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PacienteDetailsScreen(
                    paciente: pacientes[index],
                  ),
                ),
              ).then((pacienteEditado) {
                if (pacienteEditado != null) {
                  setState(() {
                    pacientes[index] = pacienteEditado;
                  });
                }
              });
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditPacienteScreen(paciente: pacientes[index]),
                      ),
                    ).then((pacienteEditado) {
                      if (pacienteEditado != null) {
                        setState(() {
                          pacientes[index] = pacienteEditado;
                        });
                      }
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _excluirPaciente(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditPacienteScreen(),
            ),
          ).then((novoPaciente) {
            if (novoPaciente != null) {
              _adicionarPaciente(novoPaciente);
            }
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      persistentFooterButtons: [
        ElevatedButton(
          child: Text('Gerar Relatório'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RelatorioPacientesScreen(pacientes: pacientes),
              ),
            );
          },
        ),
      ],
    );
  }

  void _adicionarPaciente(Paciente paciente) {
    setState(() {
      pacientes.add(paciente);
    });
  }

  void _excluirPaciente(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir paciente'),
        content: Text('Deseja realmente excluir este paciente?'),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('Excluir'),
            onPressed: () {
              setState(() {
                pacientes.removeAt(index);
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class Paciente {
  String nome;
  int idade;
  String genero;
  String endereco;
  String telefone;
  String cpf;

  Paciente(this.nome, this.idade, this.genero, this.endereco, this.telefone, this.cpf);
}

class PacienteDetailsScreen extends StatefulWidget {
  final Paciente paciente;

  PacienteDetailsScreen({required this.paciente});

  @override
  _PacienteDetailsScreenState createState() => _PacienteDetailsScreenState();
}

class _PacienteDetailsScreenState extends State<PacienteDetailsScreen> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _idadeController = TextEditingController();
  TextEditingController _generoController = TextEditingController();
  TextEditingController _enderecoController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _cpfController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.paciente.nome;
    _idadeController.text = widget.paciente.idade.toString();
    _generoController.text = widget.paciente.genero;
    _enderecoController.text = widget.paciente.endereco;
    _telefoneController.text = widget.paciente.telefone;
    _cpfController.text = widget.paciente.cpf;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do paciente'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _idadeController,
              decoration: InputDecoration(labelText: 'Idade'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _generoController,
              decoration: InputDecoration(labelText: 'Gênero'),
            ),
            TextField(
              controller: _enderecoController,
              decoration: InputDecoration(labelText: 'Endereço'),
            ),
            TextField(
              controller: _telefoneController,
              decoration: InputDecoration(labelText: 'Telefone'),
            ),
            TextField(
              controller: _cpfController,
              decoration: InputDecoration(labelText: 'CPF'),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                ElevatedButton(
                  child: Text('Salvar'),
                  onPressed: () {
                    _salvarEdicao();
                  },
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _salvarEdicao() {
    String nome = _nomeController.text;
    int idade = int.tryParse(_idadeController.text) ?? 0;
    String genero = _generoController.text;
    String endereco = _enderecoController.text;
    String telefone = _telefoneController.text;
    String cpf = _cpfController.text;

    Paciente pacienteEditado = Paciente(nome, idade, genero, endereco, telefone, cpf);

    Navigator.pop(context, pacienteEditado);
  }
}

class AddEditPacienteScreen extends StatefulWidget {
  final Paciente? paciente;

  AddEditPacienteScreen({this.paciente});

  @override
  _AddEditPacienteScreenState createState() => _AddEditPacienteScreenState();
}

class _AddEditPacienteScreenState extends State<AddEditPacienteScreen> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _idadeController = TextEditingController();
  TextEditingController _generoController = TextEditingController();
  TextEditingController _enderecoController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _cpfController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.paciente != null) {
      _nomeController.text = widget.paciente!.nome;
      _idadeController.text = widget.paciente!.idade.toString();
      _generoController.text = widget.paciente!.genero;
      _enderecoController.text = widget.paciente!.endereco;
      _telefoneController.text = widget.paciente!.telefone;
      _cpfController.text = widget.paciente!.cpf;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.paciente != null ? 'Editar Paciente' : 'Adicionar Paciente'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _idadeController,
              decoration: InputDecoration(labelText: 'Idade'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _generoController,
              decoration: InputDecoration(labelText: 'Gênero'),
            ),
            TextField(
              controller: _enderecoController,
              decoration: InputDecoration(labelText: 'Endereço'),
            ),
            TextField(
              controller: _telefoneController,
              decoration: InputDecoration(labelText: 'Telefone'),
            ),
            TextField(
              controller: _cpfController,
              decoration: InputDecoration(labelText: 'CPF'),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                ElevatedButton(
                  child: Text('Salvar'),
                  onPressed: () {
                    _salvarPaciente();
                  },
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _salvarPaciente() {
    String nome = _nomeController.text;
    int idade = int.tryParse(_idadeController.text) ?? 0;
    String genero = _generoController.text;
    String endereco = _enderecoController.text;
    String telefone = _telefoneController.text;
    String cpf = _cpfController.text;

    Paciente novoPaciente = Paciente(nome, idade, genero, endereco, telefone, cpf);

    Navigator.pop(context, novoPaciente);
  }
}

class RelatorioPacientesScreen extends StatelessWidget {
  final List<Paciente> pacientes;

  RelatorioPacientesScreen({required this.pacientes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatório de Pacientes'),
      ),
      body: ListView.builder(
        itemCount: pacientes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(pacientes[index].nome),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Idade: ${pacientes[index].idade}'),
                Text('Gênero: ${pacientes[index].genero}'),
                Text('Endereço: ${pacientes[index].endereco}'),
                Text('Telefone: ${pacientes[index].telefone}'),
                Text('CPF: ${pacientes[index].cpf}'),
              ],
            ),
          );
        },
      ),
    );
  }
}