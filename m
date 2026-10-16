Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B77D2D7DDD
	for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 05:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792128500; cv=none; b=uyItNHvBAUGJSPaJXsmTtpo0MDqRb+xeLLSjGewPzK+VhoIsw9WOTim0RKALamXWl47SLn8DXNKDBn1YcYYym+f/FhzWqmmXu8blFs7xjJIr9XSwKgtHZVjbrnP2FZJIgk+pRVuZ0PAtIFXbhUlnGd1Pb3Cz9oKzpvzWFp5b1NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792128500; c=relaxed/simple;
	bh=DNIkf+QrLWl0i+t5cXPAAcLzB+RGxTc/9sfMVPniOD4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AIFOQ8/I//XUWgdpBfOsQnIndE794dUzPtiOKBU6Cxghj4bI+b7VVIn8iPKO4EtSyFaJF+rgww84TMrpHdVgHpBV/Ztnvd3qLWLAixg3QgpwyO4AaB41IIr9aalw4iL2OuV4tss9jdki+zhnXcY/U4dcaeEVbWSrpxfohY7vUvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Cwl8iJG2; arc=none smtp.client-ip=209.85.210.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cwl8iJG2"
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-89e05d31e54so1544367b3a.1
        for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 22:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792128498; x=1792733298; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gCK0TeJ6d1zzXk3Slxk1+vePgTXc6/apx1KzOf+3M8E=;
        b=Cwl8iJG2EAFO9vYlQW4nvucklNQIcJz9w9FN20+KjGZsSsXPSa7eOdS/3qHLo3hxHt
         pgIjqrz6XiH2xUOF7utJ2rM5E2oZhMIj9SmP9L/guzO4HETlQe4l4X3CgbMowmJcfLjl
         A54l30uxkdb4iplqpmtz3ni7w0MMvuyj3s3ZQZtyWWx6w2CHm3I0qPYV4/LPkxGo8hgZ
         KjMt+ZJbWdGmKVuZX7mb2x4m7dvxkAlAZzco0p5OGL1UdE0sYg0oIB9nO1KtqD7AzWfE
         ImDZ7QsczbdoWmLuhpLqzySbGC7fEh3mjqhuUUPtHb7eaV1qbv7AKphnWlUlCLL+9TE5
         I+RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792128498; x=1792733298;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gCK0TeJ6d1zzXk3Slxk1+vePgTXc6/apx1KzOf+3M8E=;
        b=gxU/oiK30X/CPPxmdIlbAHgvFKoowM0Tkq2M2/DT+QInduychS92LnZkYEOSX6kJqK
         VoXjnuDbg0qKqoP9dY5y+fS7R9c4xDTPQyyLHVzeU32SeK/+3Sv7FfPTm4TcHSk/UP78
         oZUtY+RbZFcqh2jMpPW0FwvQDhmkuHr+JWf7B3r6d3+qMiYopk18msO/ytyhFTIY/5oW
         dpaOaHRcRZu4OiD01lPjQf1OuT8sbaKPWxP8XctLfiDsBsmNeiQ9kTUdCGTjGj4+cH3I
         Bv8r1SAv9NFDklX6o1sGfTL8OdxVC9ql28Trjmv6TF8uSI2uW1uNQ/caa6tMzz/EhpCA
         avYg==
X-Forwarded-Encrypted: i=1; AKwUvBxMVli4Lit0cpinC7PazM5XZpJgteNVuniCxT4ci0UolGVWu0ukfNqC/KfHY0LbE+QI2e7Qp2lv@vger.kernel.org
X-Gm-Message-State: AFq9FYLNACm36IgloguUKWmoKCgXTDxBjw8++E9nka49cMyKvaP2AFXo
	J1sHQYfa6z4vpRfMjFVJh7uzy4h2fxCybYkaN09lHc09XAh+pvSBq16yryBvdhHB7KEUU6/Q/S7
	7JucobQ==
X-Received: from pfeu12-n1.prod.google.com ([2002:a05:6a00:c0cc:10b0:88d:74fb:fa56])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3004:b0:87c:f67f:f7d3
 with SMTP id d2e1a72fcca58-897c14ead54mr15295762b3a.0.1792128497673; Thu, 15
 Oct 2026 22:28:17 -0700 (PDT)
Date: Fri, 16 Oct 2026 05:27:48 +0000
In-Reply-To: <20261016052811.3085635-1-kuniyu@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261016052811.3085635-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261016052811.3085635-5-kuniyu@google.com>
Subject: [PATCH 4/5] memcg: Batch mod_memcg_state() for MEMCG_SOCK.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On our production fleet, we saw mem_cgroup_sk_charge() spent over
3x the cycles of try_charge_memcg() although the former should be
a thin wrapper of the latter.

Looking at perf during tcp_rr, most of the cycles were spent in
mod_memcg_state(MEMCG_SOCK), which incurred two heavy memory stalls
due to cache line misses:

  mem_cgroup_sk_charge  vmlinux [Percent: local period]
  ...
     1.74 =E2=94=82       mov     cpu_number,%esi
     0.70 =E2=94=82       movslq  %ebx,%rcx
     0.31 =E2=94=82       mov     0x518(%r14),%rdx
     8.99 =E2=94=82       add     %rcx,%gs:0x18(%rdx,%rax,8)
                  ^-- this_cpu_add(memcg->vmstats_percpu->state[i], val);
                      in mod_memcg_state()
 >> 31.21 =E2=94=82       test    %ebx,%ebx
     0.05 =E2=94=82     =E2=86=93 je      97
          =E2=94=82       mov     %r14,%rdi
          =E2=94=82     =E2=86=92 call    __css_rstat_updated
     0.31 =E2=94=82       mov     0x518(%r14),%rdx
          =E2=94=82 72:   test    %rdx,%rdx
     0.06 =E2=94=82     =E2=86=93 je      97
          =E2=94=82       mov     this_cpu_off,%rsi
     0.17 =E2=94=82       mov     0x10(%rsi,%rdx,1),%rax
     6.59 =E2=94=82       mov     0xc18(%rax),%eax
                  ^-- atomic_read(&vmstats->stats_updates)
                      in memcg_vmstats_needs_flush()
 >> 26.02 =E2=94=82       mov     __num_online_cpus,%ecx
 ...
     0.65 =E2=94=82 e5:   mov     %r14,%rdi
          =E2=94=82       mov     %edx,%esi
     1.88 =E2=94=82       mov     %ebx,%edx
          =E2=94=82     =E2=86=92 call    try_charge_memcg
     1.56 =E2=94=82       xor     %ebp,%ebp
     0.18 =E2=94=82       test    %eax,%eax
     0.22 =E2=94=82     =E2=86=91 jne     9f
          =E2=94=82     =E2=86=91 jmp     31

Even worse, after the 2nd cache line miss, the subsequent
atomic_add() for statc->vmstats->stats_updates invalidates the
cache for other CPUs.

Moreover, try_charge_memcg() returned just after consume_stock()
in most cases, but it was not inlined even with FDO.

Usually, skb is charged and uncharged immediately, and caching
the counter in struct memcg_stock_pcp helps.

Let's reduce NR_MEMCG_STOCK from 7 to 6 to fit nr_sock[] in the
single cacheline of struct memcg_stock_pcp, inline the stock
fast path, and batch mod_memcg_state() for MEMCG_SOCK (-64, 64).

With this change, tcp_rr w/ 20000 flows achieves ~9% more
throughput and the TCP stack spends far fewer cycles on memcg.
Note that p90 latency improves only slightly because batching
amortises mod_memcg_state() and drain_stock() into every 64th
page.

  tcp_rr (20000 flows, 128 threads, 60s, average of 3 runs):

  Metric                     |       Baseline |        Patched |    Diff
  ---------------------------+----------------+----------------+--------
  Throughput (RPS)           |     22,408,523 |     24,360,262 |  +8.71%
  Latency Mean (us)          |         891.92 |         820.31 |  -8.03%
  Latency p50 (us)           |         877.22 |         744.10 | -15.18%
  Latency p90 (us)           |       1,085.43 |       1,082.02 |  -0.31%

  perf cycles (20000 flows, 10s, average of 3 runs):

  Server (M cycles / %)      |           Baseline |            Patched |   =
 Diff
  ---------------------------+--------------------+--------------------+---=
-----
  Host Total Cycles          |        4,994,342 M |        4,793,242 M |   =
-4.0%
  tcp_rcv_established()      | 213,968 M (4.283%) | 210,418 M (4.390%) |   =
-1.7%
  mem_cgroup_sk_charge()     |  12,322 M (0.247%) |   6,390 M (0.133%) |  -=
48.1%
  try_charge_memcg()         |   8,326 M (0.167%) |       0 M (0.000%) | -1=
00.0%
  mem_cgroup_sk_uncharge()   |   7,492 M (0.150%) |   5,752 M (0.120%) |  -=
23.2%
  refill_stock()             |   7,988 M (0.160%) |       0 M (0.000%) | -1=
00.0%
  Charge Total               |  20,648 M (0.413%) |   6,390 M (0.133%) |  -=
69.1%
  Uncharge Total             |  15,480 M (0.310%) |   5,752 M (0.120%) |  -=
62.8%
  Memcg Sock Total           |  36,128 M (0.723%) |  12,142 M (0.253%) |  -=
66.4%

As a side effect, "sock" in memory.stat can be off by up to
MEMCG_CHARGE_BATCH pages per CPU until the slot is drained,
like memory.current with nr_pages[].  This is acceptable, as
flushing nr_sock[] every 2 seconds (FLUSH_TIME) across all CPUs
would rather cause cache line invalidation and hurt performance.

Note that MEMCG_CHARGE_BATCH is unsigned int, so (int) cast is
needed, and stock_sock is declared as int rather than int8_t
to avoid potential overflow for MEMCG_CHARGE_BATCH > 64 and to
generate better asm without 8-bit partial-register operations
or extra sign-extension before mod_memcg_state().

Also, __always_inline is needed for both __consume_stock() and
__refill_stock(), otherwise, FDO branch weight is calculated
from two callers with mixed states (nr_sock =3D=3D 0 vs nr_sock !=3D 0).

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 mm/memcontrol.c | 84 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 73 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cc3d78938b34..52831ae7fd0f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2045,13 +2045,14 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *=
memcg)
=20
 /*
  * The value of NR_MEMCG_STOCK is selected to keep the cached memcgs and t=
heir
- * nr_pages in a single cacheline. This may change in future.
+ * nr_pages and nr_sock in a single cacheline. This may change in future.
  */
-#define NR_MEMCG_STOCK 7
+#define NR_MEMCG_STOCK 6
 #define FLUSHING_CACHED_CHARGE	0
 struct memcg_stock_pcp {
 	local_trylock_t lock;
 	uint8_t nr_pages[NR_MEMCG_STOCK];
+	int8_t nr_sock[NR_MEMCG_STOCK];
 	struct mem_cgroup *cached[NR_MEMCG_STOCK];
=20
 	struct work_struct work;
@@ -2111,9 +2112,10 @@ static bool obj_stock_flush_required(struct obj_stoc=
k_pcp *stock,
 				     struct mem_cgroup *root_memcg);
=20
 /**
- * consume_stock: Try to consume stocked charge on this cpu.
+ * __consume_stock: Try to consume stocked charge on this cpu.
  * @memcg: memcg to consume from.
  * @nr_pages: how many pages to charge.
+ * @nr_sock: how many pages to account for MEMCG_SOCK.
  *
  * Consume the cached charge if enough nr_pages are present otherwise retu=
rn
  * failure. Also return failure for charge request larger than
@@ -2121,10 +2123,13 @@ static bool obj_stock_flush_required(struct obj_sto=
ck_pcp *stock,
  *
  * returns true if successful, false otherwise.
  */
-static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
+static __always_inline bool __consume_stock(struct mem_cgroup *memcg,
+					    unsigned int nr_pages,
+					    unsigned int nr_sock)
 {
 	struct memcg_stock_pcp *stock;
 	uint8_t stock_pages;
+	int stock_sock =3D 0;
 	bool ret =3D false;
 	int i;
=20
@@ -2144,7 +2149,19 @@ static bool consume_stock(struct mem_cgroup *memcg, =
unsigned int nr_pages)
=20
 		stock_pages -=3D nr_pages;
 		WRITE_ONCE(stock->nr_pages[i], stock_pages);
-		if (unlikely(!stock_pages)) {
+
+		if (nr_sock) {
+			stock_sock =3D stock->nr_sock[i] + nr_sock;
+
+			if (likely(stock_sock < (int)MEMCG_CHARGE_BATCH)) {
+				WRITE_ONCE(stock->nr_sock[i], stock_sock);
+				stock_sock =3D 0;
+			} else {
+				WRITE_ONCE(stock->nr_sock[i], 0);
+			}
+		}
+
+		if (unlikely(!stock_pages && !stock->nr_sock[i])) {
 			css_put(&memcg->css);
 			WRITE_ONCE(stock->cached[i], NULL);
 		}
@@ -2155,9 +2172,17 @@ static bool consume_stock(struct mem_cgroup *memcg, =
unsigned int nr_pages)
=20
 	local_unlock(&memcg_stock.lock);
=20
+	if (unlikely(stock_sock))
+		mod_memcg_state(memcg, MEMCG_SOCK, stock_sock);
+
 	return ret;
 }
=20
+static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	return __consume_stock(memcg, nr_pages, 0);
+}
+
 static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages=
)
 {
 	page_counter_uncharge(&memcg->memory, nr_pages);
@@ -2172,6 +2197,7 @@ static void drain_stock(struct memcg_stock_pcp *stock=
, int i)
 {
 	struct mem_cgroup *old =3D stock->cached[i];
 	uint8_t stock_pages;
+	int stock_sock;
=20
 	if (!old)
 		return;
@@ -2182,6 +2208,12 @@ static void drain_stock(struct memcg_stock_pcp *stoc=
k, int i)
 		WRITE_ONCE(stock->nr_pages[i], 0);
 	}
=20
+	stock_sock =3D stock->nr_sock[i];
+	if (stock_sock) {
+		mod_memcg_state(old, MEMCG_SOCK, stock_sock);
+		WRITE_ONCE(stock->nr_sock[i], 0);
+	}
+
 	css_put(&old->css);
 	WRITE_ONCE(stock->cached[i], NULL);
 }
@@ -2226,12 +2258,15 @@ static void drain_local_obj_stock(struct work_struc=
t *dummy)
 	local_unlock(&obj_stock.lock);
 }
=20
-static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
+static __always_inline void __refill_stock(struct mem_cgroup *memcg,
+					   unsigned int nr_pages,
+					   unsigned int nr_sock)
 {
 	struct memcg_stock_pcp *stock;
 	struct mem_cgroup *cached;
 	uint8_t stock_pages;
 	int empty_slot =3D -1;
+	int stock_sock =3D 0;
 	int i;
=20
 	/*
@@ -2250,7 +2285,7 @@ static void refill_stock(struct mem_cgroup *memcg, un=
signed int nr_pages)
 		 * lock the percpu memcg_stock.lock, uncharge memcg directly.
 		 */
 		memcg_uncharge(memcg, nr_pages);
-		return;
+		goto update_sock;
 	}
=20
 	stock =3D this_cpu_ptr(&memcg_stock);
@@ -2264,10 +2299,26 @@ static void refill_stock(struct mem_cgroup *memcg, =
unsigned int nr_pages)
=20
 		stock_pages =3D stock->nr_pages[i] + nr_pages;
 		WRITE_ONCE(stock->nr_pages[i], stock_pages);
+
+		if (nr_sock) {
+			stock_sock =3D stock->nr_sock[i] - nr_sock;
+
+			if (likely(stock_sock > -(int)MEMCG_CHARGE_BATCH)) {
+				WRITE_ONCE(stock->nr_sock[i], stock_sock);
+				stock_sock =3D 0;
+			} else {
+				WRITE_ONCE(stock->nr_sock[i], 0);
+			}
+		}
+
 		if (unlikely(stock_pages > MEMCG_CHARGE_BATCH))
 			drain_stock(stock, i);
=20
 		local_unlock(&memcg_stock.lock);
+
+		if (unlikely(stock_sock))
+			mod_memcg_state(memcg, MEMCG_SOCK, stock_sock);
+
 		return;
 	}
=20
@@ -2284,6 +2335,15 @@ static void refill_stock(struct mem_cgroup *memcg, u=
nsigned int nr_pages)
 	WRITE_ONCE(stock->nr_pages[i], nr_pages);
=20
 	local_unlock(&memcg_stock.lock);
+
+update_sock:
+	if (nr_sock)
+		mod_memcg_state(memcg, MEMCG_SOCK, -nr_sock);
+}
+
+static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	__refill_stock(memcg, nr_pages, 0);
 }
=20
 static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
@@ -2299,7 +2359,8 @@ static bool is_memcg_drain_needed(struct memcg_stock_=
pcp *stock,
 		if (!memcg)
 			continue;
=20
-		if (READ_ONCE(stock->nr_pages[i]) &&
+		if ((READ_ONCE(stock->nr_pages[i]) ||
+		     READ_ONCE(stock->nr_sock[i])) &&
 		    mem_cgroup_is_descendant(memcg, root_memcg)) {
 			flush =3D true;
 			break;
@@ -5629,6 +5690,9 @@ bool mem_cgroup_sk_charge(const struct sock *sk, unsi=
gned int nr_pages,
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return memcg1_charge_skmem(memcg, nr_pages, gfp_mask);
=20
+	if (likely(__consume_stock(memcg, nr_pages, nr_pages)))
+		return true;
+
 	if (try_charge_memcg(memcg, gfp_mask, nr_pages) =3D=3D 0) {
 		mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
 		return true;
@@ -5651,9 +5715,7 @@ void mem_cgroup_sk_uncharge(const struct sock *sk, un=
signed int nr_pages)
 		return;
 	}
=20
-	mod_memcg_state(memcg, MEMCG_SOCK, -nr_pages);
-
-	refill_stock(memcg, nr_pages);
+	__refill_stock(memcg, nr_pages, nr_pages);
 }
=20
 void mem_cgroup_flush_workqueue(void)
--=20
2.56.0.212.g129ede20d9-goog

