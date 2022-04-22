import 'package:flutter/material.dart';
import 'package:lab1_provider_messager/src/authentication/authentication_view.dart';
import 'package:lab1_provider_messager/src/chat/chat_view.dart';
import 'package:lab1_provider_messager/src/messager/messager_controller.dart';
import 'package:lab1_provider_messager/src/settings/settings_controller.dart';
import 'package:lab1_provider_messager/src/utils/color_utils.dart';
import 'package:provider/provider.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    Key? key,
    required this.chatName,
    required this.id,
  }) : super(key: key);
  final String chatName;
  final String id;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key('chatTileIndex$id'),
      leading: CircleAvatar(
        backgroundColor: getRandomColor(),
        radius: 20,
        child: Text(
          chatName[0].toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      title: Text(chatName),
      onTap: () => Navigator.restorablePushNamed(
        context,
        ChatView.routeName,
        arguments: id,
      ),
    );
  }
}

class MessagerView extends StatelessWidget {
  static const routeName = '/messager';
  const MessagerView({Key? key}) : super(key: key);

  static const navToAuthIconButtonKey = Key('navToAuthIconButton');

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          title: const Text('Messager'),
          actions: [
            IconButton(
              key: MessagerView.navToAuthIconButtonKey,
              icon: const Icon(Icons.login_outlined),
              onPressed: () {
                Navigator.restorablePushNamed(
                    context, AuthenticationView.routeName);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Consumer<MessagerController>(builder: (_, controller, __) {
              var users = controller.getUsers;
              return SizedBox(
                height: 70,
                child: users.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          var id = users.keys.toList()[index];
                          return Row(
                            children: [
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () async {
                                  var ref = await controller.startChat(id);
                                  Navigator.restorablePushNamed(
                                    context,
                                    ChatView.routeName,
                                    arguments: ref,
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundColor: getRandomColor(),
                                  radius: 20,
                                  child: Text(
                                    users[id]!.displayName![0].toUpperCase(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ],
                          );
                        })
                    : const Center(
                        child: Text('Nobody to chat too, tried login in?')),
              );
            }),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.0),
                        topRight: Radius.circular(24.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Consumer<MessagerController>(
                      builder: (_, controller, __) {
                        return (controller.getChats.isNotEmpty &&
                                controller.getUserModel()!.chatIds.isNotEmpty)
                            ? ListView.builder(
                                itemCount: controller.getChats.length,
                                itemBuilder: (context, index) {
                                  var id =
                                      controller.getChats.keys.toList()[index];
                                  return ChatTile(
                                      chatName:
                                          controller.getUserModelChatName(id),
                                      id: id);
                                },
                              )
                            : const Center(
                                child:
                                    Text('You dont have anyone to chat with.'));
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Consumer<SettingsController>(builder: (_, controller, __) {
        return const IntroOverlay();
        // controller.getIsFirstInit
        //       ?
        // : const SizedBox.shrink(),
        // ),
      })
    ]);
  }
}

class IntroOverlay extends StatefulWidget {
  const IntroOverlay({Key? key}) : super(key: key);

  @override
  State<IntroOverlay> createState() => _IntroOverlayState();
}

class _IntroOverlayState extends State<IntroOverlay>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _curve;
  late Animation<double> _animation;
  bool isForward = true;
  final Duration _duration = const Duration(milliseconds: 1500);
  final double startRad = 400.0;
  double targetRad = 52.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    _curve = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _animation = Tween<double>(begin: startRad, end: targetRad).animate(_curve);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, anim) {
        final _clipper = InvertedClipper(circleSize: _animation.value);
        return CustomPaint(
          painter: _ClipShadowShadowPainter(
            clipper: _clipper,
            shadow: const Shadow(blurRadius: 5),
          ),
          child: ClipPath(
            clipper: _clipper,
            child: Container(
              color: Colors.blue,
              child: Center(child: Text('this is the middle!')),
            ),
          ),
        );
      },
    );
  }
}

class InvertedClipper extends CustomClipper<Path> {
  final double circleSize;

  InvertedClipper({required this.circleSize});

  @override
  Path getClip(Size size) {
    return Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Path()
        ..addOval(Rect.fromCircle(
            center: Offset(size.width - 18, 28), radius: circleSize))
        ..close(),
    );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
