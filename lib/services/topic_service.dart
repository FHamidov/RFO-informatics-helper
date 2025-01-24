import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/topic.dart';

class TopicService {
  static const String _baseUrl = 'https://codeforces.com/api';

  Future<List<Topic>> getTopics() async {
    // Avtomatik mövzular və məsələlər
    return [
      Topic(
        id: '1',
        title: 'Qraf Nəzəriyyəsi',
        description: 'Qraflar və onların alqoritmləri haqqında əsas anlayışlar',
        theoreticalContent: '''
# Qraf Nəzəriyyəsi

Qraf nəzəriyyəsi riyaziyyatın təpələr və tillər haqqında olan sahəsidir.

## Əsas anlayışlar
- Təpə (vertex): Qrafın əsas nöqtələri
- Til (edge): İki təpəni birləşdirən xətt
- Dərəcə (degree): Bir təpəyə birləşən tillərin sayı
- Yol (path): Təpələr ardıcıllığı
- Dövr (cycle): Başlanğıc və son təpəsi eyni olan yol

## Əsas alqoritmlər
1. DFS (Depth-First Search)
   - Rekursiv şəkildə qrafı gəzmək
   - Stack istifadə edərək həyata keçirilir
   
2. BFS (Breadth-First Search)
   - Səviyyə-səviyyə qrafı gəzmək
   - Queue istifadə edərək həyata keçirilir
   
3. Dijkstra
   - Ən qısa yolu tapmaq üçün
   - Priority Queue istifadə edir
   
4. Floyd-Warshall
   - Bütün cütlər arası ən qısa yol
   - Dinamik proqramlaşdırma istifadə edir
''',
        problems: [
          Problem(
            id: '1',
            title: 'Şəhərlər və Yollar',
            description: 'N şəhər və M yol verilir. A şəhərindən B şəhərinə gedən ən qısa yolu tapın.',
            difficulty: 'Orta',
            source: 'Codeforces',
            url: 'https://codeforces.com/problemset/problem/20/C',
            solutionCodes: {
              'C++': '''#include <bits/stdc++.h>
using namespace std;
typedef long long ll;

const ll INF = 1e18;
vector<vector<pair<int, ll>>> adj;
vector<ll> dist;
vector<int> parent;

void dijkstra(int start) {
    int n = adj.size();
    dist.assign(n, INF);
    parent.assign(n, -1);
    dist[start] = 0;
    
    priority_queue<pair<ll, int>, vector<pair<ll, int>>, greater<>> pq;
    pq.push({0, start});
    
    while (!pq.empty()) {
        int v = pq.top().second;
        ll d = pq.top().first;
        pq.pop();
        
        if (d > dist[v]) continue;
        
        for (auto [u, w] : adj[v]) {
            if (dist[v] + w < dist[u]) {
                dist[u] = dist[v] + w;
                parent[u] = v;
                pq.push({dist[u], u});
            }
        }
    }
}

int main() {
    int n, m;
    cin >> n >> m;
    
    adj.resize(n);
    for (int i = 0; i < m; i++) {
        int a, b;
        ll w;
        cin >> a >> b >> w;
        a--; b--;
        adj[a].push_back({b, w});
        adj[b].push_back({a, w});
    }
    
    dijkstra(0);
    
    if (dist[n-1] == INF) {
        cout << -1 << endl;
        return 0;
    }
    
    vector<int> path;
    for (int v = n-1; v != -1; v = parent[v]) {
        path.push_back(v);
    }
    reverse(path.begin(), path.end());
    
    for (int v : path) {
        cout << v+1 << " ";
    }
    cout << endl;
    
    return 0;
}''',
              'Python': '''from heapq import heappush, heappop
from collections import defaultdict

def dijkstra(adj, n, start):
    dist = [float('inf')] * n
    parent = [-1] * n
    dist[start] = 0
    
    pq = [(0, start)]
    while pq:
        d, v = heappop(pq)
        
        if d > dist[v]:
            continue
            
        for u, w in adj[v]:
            if dist[v] + w < dist[u]:
                dist[u] = dist[v] + w
                parent[u] = v
                heappush(pq, (dist[u], u))
                
    return dist, parent

def main():
    n, m = map(int, input().split())
    adj = defaultdict(list)
    
    for _ in range(m):
        a, b, w = map(int, input().split())
        a -= 1
        b -= 1
        adj[a].append((b, w))
        adj[b].append((a, w))
        
    dist, parent = dijkstra(adj, n, 0)
    
    if dist[n-1] == float('inf'):
        print(-1)
        return
        
    path = []
    v = n-1
    while v != -1:
        path.append(v)
        v = parent[v]
    
    print(' '.join(str(v+1) for v in reversed(path)))

if __name__ == '__main__':
    main()''',
            },
            explanation: '''# Dijkstra Alqoritmi ilə Həll

Bu məsələni həll etmək üçün Dijkstra alqoritmindən istifadə edirik. Alqoritm aşağıdakı addımlardan ibarətdir:

1. Hər təpə üçün məsafəni sonsuzluqla inisializasiya edirik
2. Başlanğıc təpənin məsafəsini 0 edirik
3. Priority Queue istifadə edərək ən kiçik məsafəli təpəni seçirik
4. Seçilmiş təpədən gedə biləcəyimiz bütün təpələri yoxlayırıq
5. Əgər yeni məsafə köhnədən kiçikdirsə, məsafəni yeniləyirik

Yolun özünü tapmaq üçün:
1. Parent massivi saxlayırıq
2. Hər məsafə yeniləməsində parent-i də yeniləyirik
3. Sonda son təpədən başlayaraq parent massivi ilə geriyə gedirik

Alqoritmin mürəkkəbliyi: O((N+M)logN)
- N: təpələrin sayı
- M: tillərin sayı''',
          ),
          Problem(
            id: '2',
            title: 'Ağacın Diametri',
            description: 'Verilmiş ağacın diametrini (ən uzun yolun uzunluğunu) tapın.',
            difficulty: 'Asan',
            source: 'CSES',
            url: 'https://cses.fi/problemset/task/1131',
          ),
        ],
      ),
      Topic(
        id: '2',
        title: 'Dinamik Proqramlaşdırma',
        description: 'Məsələləri alt məsələlərə bölərək həll etmək',
        theoreticalContent: '''
# Dinamik Proqramlaşdırma

Dinamik Proqramlaşdırma (DP) mürəkkəb məsələləri daha kiçik alt məsələlərə bölərək həll etmə üsuludur.

## Əsas Prinsiplər
1. Optimal Alt Struktur
2. Təkrarlanan Alt Məsələlər

## Məşhur DP Məsələləri
1. Fibonacci Ardıcıllığı
2. Çanta Məsələsi (Knapsack)
3. Ən Uzun Artan Altardıcıllıq (LIS)
4. Matris Zəncir Vurması

## Həll Üsulları
1. Top-down (Memoization)
2. Bottom-up (Tabulation)
''',
        problems: [
          Problem(
            id: '3',
            title: 'Coin Combinations',
            description: 'Verilmiş pulları istifadə edərək məbləği yığmağın yollarının sayını tapın.',
            difficulty: 'Orta',
            source: 'CSES',
            url: 'https://cses.fi/problemset/task/1635',
          ),
          Problem(
            id: '4',
            title: 'Edit Distance',
            description: 'İki sətir arasındakı edit məsafəsini tapın.',
            difficulty: 'Orta',
            source: 'CSES',
            url: 'https://cses.fi/problemset/task/1639',
          ),
        ],
      ),
      Topic(
        id: '3',
        title: 'Acgöz Alqoritmlər',
        description: 'Hər addımda ən yaxşı seçimi edərək optimal həll tapmaq',
        theoreticalContent: '''
# Acgöz (Greedy) Alqoritmlər

Acgöz alqoritmlər hər addımda lokal optimal seçim edərək qlobal optimal həllə çatmağa çalışır.

## Xüsusiyyətlər
1. Hər addımda ən yaxşı seçim
2. Alt məsələləri həll etmədən qərar vermə
3. Geriyə qayıtmama

## Tətbiq Sahələri
1. Minimal Örtən Ağac
2. Huffman Kodlaması
3. Aktivlik Seçimi
4. Fraksional Çanta Məsələsi
''',
        problems: [
          Problem(
            id: '5',
            title: 'Tasks and Deadlines',
            description: 'Tapşırıqları elə sıralayın ki, ümumi gecikmə minimal olsun.',
            difficulty: 'Orta',
            source: 'CSES',
            url: 'https://cses.fi/problemset/task/1630',
          ),
          Problem(
            id: '6',
            title: 'Stick Lengths',
            description: 'Çubuqları kəsərək eyni uzunluğa gətirmək üçün minimal xərc.',
            difficulty: 'Asan',
            source: 'CSES',
            url: 'https://cses.fi/problemset/task/1074',
          ),
        ],
      ),
      Topic(
        id: '4',
        title: 'Binar Axtarış',
        description: 'Sıralanmış massivdə effektiv axtarış üsulu',
        theoreticalContent: '''
# Binar Axtarış

Binar axtarış sıralanmış massivdə elementi O(log n) zamanda tapmağa imkan verir.

## Əsas Konseptlər
1. Sıralanmış Massiv
2. Ortadan Bölmə
3. Axtarış İntervalı
4. Monotonluq

## Tətbiq Sahələri
1. Massivdə Element Axtarışı
2. Lower/Upper Bound
3. Cavabın Binar Axtarışı
''',
        problems: [
          Problem(
            id: '7',
            title: 'Factory Machines',
            description: 'n məhsulu minimal zamanda istehsal etmək.',
            difficulty: 'Orta',
            source: 'CSES',
            url: 'https://cses.fi/problemset/task/1620',
          ),
          Problem(
            id: '8',
            title: 'Subarray Sums II',
            description: 'Cəmi x olan altmassivin sayını tapın.',
            difficulty: 'Orta',
            source: 'CSES',
            url: 'https://cses.fi/problemset/task/1661',
          ),
        ],
      ),
    ];
  }

  Future<Problem> getDailyChallenge() async {
    final problems = [
      Problem(
        id: 'daily-1',
        title: 'Günün Məsələsi: İkili Ağac Balansı',
        description: 'Verilmiş ikili ağacın balanslaşdırılmış olub-olmadığını yoxlayın.',
        difficulty: 'Çətin',
        source: 'LeetCode',
        url: 'https://leetcode.com/problems/balanced-binary-tree/',
      ),
      Problem(
        id: 'daily-2',
        title: 'Günün Məsələsi: Minimal Örtən Ağac',
        description: 'N kompüteri minimal xərclə şəbəkəyə qoşun.',
        difficulty: 'Çətin',
        source: 'CSES',
        url: 'https://cses.fi/problemset/task/1675',
      ),
      Problem(
        id: 'daily-3',
        title: 'Günün Məsələsi: Oyun Nəzəriyyəsi',
        description: 'İki oyunçu növbə ilə daşları götürür. Qalib kim olacaq?',
        difficulty: 'Çətin',
        source: 'Codeforces',
        url: 'https://codeforces.com/problemset/problem/1451/D',
      ),
    ];

    // Random bir məsələ seçirik
    final now = DateTime.now();
    final index = now.day % problems.length;
    return problems[index];
  }

  Future<List<Problem>> getProblemsForTopic(String topicId) async {
    final topics = await getTopics();
    final topic = topics.firstWhere((t) => t.id == topicId);
    return topic.problems;
  }
} 