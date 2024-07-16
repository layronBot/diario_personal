import 'package:flutter/material.dart';
import 'package:diario2/db/misdiarios.dart';
import 'package:diario2/modelos/diario.dart';

class BienvenidoPage extends StatefulWidget {
  final int userId;
  final String userName;
  final String userUsername;

  const BienvenidoPage({required this.userId, required this.userName, required this.userUsername, Key? key}) : super(key: key);

  @override
  _BienvenidoPageState createState() => _BienvenidoPageState();
}

class _BienvenidoPageState extends State<BienvenidoPage> {
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Diario> _diarios = [];

  @override
  void initState() {
    super.initState();
    _loadDiarios();
  }

  Future<void> _loadDiarios() async {
    _diarios = await _databaseHelper.getDiarios(widget.userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        title: Row(
          children: [
            Text('Bienvenido ${widget.userName} (${widget.userUsername})'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/abrazo.jpg'), // Reemplaza con tu imagen de fondo
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Color.fromARGB(255, 212, 242, 255).withOpacity(0.8), // Fondo blanco translúcido
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _tituloController,
                      decoration: const InputDecoration(
                        labelText: 'Título',
                        prefixIcon: Icon(Icons.title),
                      ),
                    ),
                    TextFormField(
                      controller: _descripcionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_tituloController.text.isNotEmpty && _descripcionController.text.isNotEmpty) {
                          Diario nuevoDiario = Diario(
                            userId: widget.userId,
                            titulo: _tituloController.text,
                            descripcion: _descripcionController.text,
                            fechahora: DateTime.now(),
                          );
                          await _databaseHelper.insertDiario(nuevoDiario);
                          _tituloController.clear();
                          _descripcionController.clear();
                          _loadDiarios(); // Recarga los diarios después de agregar uno nuevo
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.blue, // Color del texto del botón
                      ),
                      child: const Text('Añadir Diario'),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _diarios.length,
                        itemBuilder: (context, index) {
                          final diario = _diarios[index];
                          return ListTile(
                            leading: const Icon(Icons.book),
                            title: Text(diario.titulo),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(diario.descripcion),
                                const SizedBox(height: 5),
                                Text(
                                  diario.fechahora.toLocal().toString(),
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            onTap: () {
                              // Mostrar opciones para editar o eliminar el diario
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Opciones'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          title: const Text('Editar'),
                                          onTap: () {
                                            // Cerrar el diálogo antes de abrir la pantalla de edición
                                            Navigator.of(context).pop();
                                            _editDiario(diario);
                                          },
                                        ),
                                        ListTile(
                                          title: const Text('Eliminar'),
                                          onTap: () async {
                                            await _databaseHelper.deleteDiario(diario.id!);
                                            _loadDiarios(); // Recargar los diarios después de eliminar uno
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editDiario(Diario diario) {
    _tituloController.text = diario.titulo;
    _descripcionController.text = diario.descripcion;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Diario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 5,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_tituloController.text.isNotEmpty && _descripcionController.text.isNotEmpty) {
                    Diario diarioActualizado = Diario(
                      id: diario.id,
                      userId: diario.userId,
                      titulo: _tituloController.text,
                      descripcion: _descripcionController.text,
                      fechahora: DateTime.now(),
                    );
                    await _databaseHelper.updateDiario(diarioActualizado);
                    _loadDiarios(); // Recarga los diarios después de editar uno
                    Navigator.of(context).pop(); // Cierra el diálogo de edición
                    _tituloController.clear();
                    _descripcionController.clear();
                  }
                },
                child: const Text('Actualizar'),
              ),
            ],
          ),
        );
      },
    );
  }
}








