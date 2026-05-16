import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/leaderboard_controller.dart';

class LeaderboardView extends GetView<LeaderboardController> {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final players = [
      {"rank": 4, "name": "Dodi Prasetyo", "score": "1.950"},
      {"rank": 5, "name": "Eko Putri", "score": "1.820"},
      {"rank": 6, "name": "Fajar", "score": "1.700"},
      {"rank": 7, "name": "Kamu (Gilang)", "score": "1.540", "active": true},
      {"rank": 8, "name": "Hana", "score": "1.410"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // Appbar
              Row(
                children: const [
                  Icon(Icons.arrow_back_ios, size: 18),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Papan Peringkat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff1565D8),
                        ),
                      ),
                    ),
                  ),
                  Icon(Icons.emoji_events_outlined),
                ],
              ),

              const SizedBox(height: 18),

              // Banner
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/anak.png',
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xff4F8EF7),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Text(
                        'Ayo jadi nomor 1!',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Podium
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: _podiumCard(
                      name: "Budi",
                      score: "2.450",
                      height: 78,
                      rank: "2",
                      color: const Color(0xffD9DDE5),
                    ),
                  ),
                  Expanded(
                    child: _podiumCard(
                      name: "Ani",
                      score: "2.850",
                      height: 118,
                      rank: "1",
                      color: const Color(0xffF5D437),
                      center: true,
                    ),
                  ),
                  Expanded(
                    child: _podiumCard(
                      name: "Citra",
                      score: "2.100",
                      height: 68,
                      rank: "3",
                      color: const Color(0xffF4E2CF),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Lainnya',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    final item = players[index];
                    return _rankTile(
                      rank: item["rank"].toString(),
                      name: item["name"].toString(),
                      score: item["score"].toString(),
                      active: item["active"] == true,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _podiumCard({
    required String name,
    required String score,
    required double height,
    required String rank,
    required Color color,
    bool center = false,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: center ? 34 : 26,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: center ? 30 : 22,
            backgroundImage: const AssetImage('assets/images/anak.png'),
          ),
        ),
        const SizedBox(height: 6),
        Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
        Text(
          score,
          style: const TextStyle(color: Colors.black54, fontSize: 12),
        ),
        const SizedBox(height: 6),
        Container(
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
          ),
          child: Center(
            child: Text(
              rank,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }

  Widget _rankTile({
    required String rank,
    required String name,
    required String score,
    bool active = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: active ? const Color(0xff4F8EF7) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Text(
            rank,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: active ? Colors.white : Colors.black54,
            ),
          ),
          const SizedBox(width: 12),
          const CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage('assets/images/anak.png'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : Colors.black87,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              score,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.green.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
