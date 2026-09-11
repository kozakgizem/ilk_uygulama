import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ilk_uygulama/core/constants/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SystemStatusPage extends StatefulWidget {
  const SystemStatusPage({super.key});

  @override
  State<SystemStatusPage> createState() => _SystemStatusPageState();
}

class _SystemStatusPageState extends State<SystemStatusPage> {
  Map<String, dynamic>? _metrics;
  List<dynamic> _logs = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchSystemData();
  }

  Future<void> _fetchSystemData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      final dio = Dio();

      final headers = {
        if (token != null) 'Authorization': 'Bearer $token',
      };

      // Metrikleri ve logları aynı anda çekiyoruz
      final metricsResponse = await dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.systemMetrics}',
        options: Options(headers: headers),
      );

      final logsResponse = await dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.systemLogs}',
        options: Options(headers: headers),
      );

      setState(() {
        _metrics = metricsResponse.data;
        _logs = logsResponse.data is List ? logsResponse.data : [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistem Metrikleri ve Loglar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Yenile',
            onPressed: _fetchSystemData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Hata: $_error', style: const TextStyle(color: Colors.red)))
              : RefreshIndicator(
                  onRefresh: _fetchSystemData,
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      const Text(
                        'Sunucu Kaynak Kullanımı',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      // Metrikler kartı
                      Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _metrics != null
                                ? _metrics!.entries.map((entry) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w500)),
                                          Text('${entry.value}', style: const TextStyle(color: Colors.blueGrey)),
                                        ],
                                      ),
                                    );
                                  }).toList()
                                : [const Text('Metrik verisi bulunamadı.')],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Canlı Sistem Logları',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      // Loglar listesi
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: _logs.length,
                          itemBuilder: (context, index) {
                            final log = _logs[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                log.toString(),
                                style: const TextStyle(color: Colors.greenAccent, fontFamily: 'monospace', fontSize: 13),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}