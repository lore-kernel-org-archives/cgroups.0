Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213441;
	b=a9ad9uQbnU6D8JW8j3n/0B4XUaKpEkZhX1ILmcWg7n5Y0qND0doc63o1UTSrZle0aj1F
	 TFf93Lj3dI7siBW3O0LXbM5jnbgWMlgYSc9oOXCgg2b3xPiMSSAzokaHxfTmYrXD43S7w
	 UsUhk/PL6sjM7T6lMlB3snAzxuesitPu/6E5ERhlp4irhNsE5qgS0HyVh1oaTbmQ/tlRv
	 anQSJmSMuDsNORGv3vkfiq+5MQyiL7zwFhHg5OnSb0Aj8QEc+zK4GboREiFroxBGUIqA0
	 2m7zUzwF2cGKj5S7Jr8EL8X7bUOKK05cqhBRYWUun+HUhtmeqIyimpDlN3WrMxP9nhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213441;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=FBGgckuRPIKFzNN+9A67c3GtbE7TkM7/6OfDMvJvqJE=;
	b=dY+6ux5co0Dt5qNKrLCKJ9fYCMT/d6SFqCfbDAL6c74rCrEyt7uqJK0spTgX6gfJHXHH
	 Opy/Mmx0OXX9sFntI1vDdJNoeOWo0YCCw4u0PUI4PV9Z96CkAfeTIxLb9KoMXWtj31z7G
	 8v0iT8d+RSOq7ClIkw24xlPAkKyyWh05oOcYZcpRf7OiFWDKkSToKzc/FWFwC0Sk7zcli
	 TY4ZPTqIkyLg9j+rjlk0xtYPKnVnQv1aVul58n5KXOw9fRPBDQu84UUJfN9+rEdJwtLhz
	 bHYfFeDOM88mNHQ2+havflAyNoziD6OH8lXmnZiBUmrAOaZ7FMGwsxtIJik33lugCpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BNpmbMzl;
	arc=none smtp.remote-ip=209.85.215.200
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34048606A334
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 18:50:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34048606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BNpmbMzl
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc4216aee8fso1526858a12.1
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 11:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793213440; x=1793818240; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FBGgckuRPIKFzNN+9A67c3GtbE7TkM7/6OfDMvJvqJE=;
        b=BNpmbMzlbevPvB0kuKe7dKfPCZM7qbWb8GGz6sUfvY8MDhU/vsDtTrRXESXqlDp5ke
         +X+4lq/A8VvMxSZuTw1nkKijPQZHaWzRVeiGbtkAGBytJP3WZFHZdImodnuT8Pp6Zm+B
         UBOTVig4V4RrbaptLSNiCVT4pGBMUNrRmBy/Dz408pGCu+r3S+gkY+5M/24tplpIk5L8
         xwbiEFqdyUw2b+43QjQEQaVe6ag2fLXRKN0nNJe4vgCDFILlcc9ZAea1BHSiNpe/4yeC
         tiRsIr+nF5of5Q2cN3x/jSCeaarvHHHJo8oCkRfsuoC1uOzSl/ZT8mCSAFzN45wlDIK6
         qZNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793213440; x=1793818240;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FBGgckuRPIKFzNN+9A67c3GtbE7TkM7/6OfDMvJvqJE=;
        b=BE70drMp5VXJSXM9XhhZnjNaMgrgkoOvrhkfhZ61omM5LptzWItpkrg9RN0Y7rEnfr
         2RwJRMF+vzumiTK2cegvtpGJk0A+SYl8bH3TjX5ka6a3FDh08cVhRaPwGQLujV3h0bhm
         5tvhbtTtyO2r9DXn/wdyNYHRnbrBIn6RSUBP8EMw2VIoWxHQT3W8RIiZ8+1Xzv2XUVZh
         MGCx09oNGbz+w9rpcFxmEeHYPwr3hu9z6e3xmJfEjg1wzGOdc0VPZ9MJrmteCcJps0AN
         +JoNbz5+c1RPNxGwXwR8KaUTUQmOcayJomQiwcNAXaNbUi+1KAzzQuS+hxR/EYwqnhnY
         JdoA==
X-Forwarded-Encrypted: i=1; AKwUvBx62wwhc6wHCO2wOKlB6OW5bBFNuKDkpXyhstVqoPXMTDGmMybN2Ini5S2k7wAkhVtyxx2Q+k9W@vger.kernel.org
X-Gm-Message-State: AFq9FYK7RFdKEyeCzXQKXzoKiqe0dUdjNmlEZhY65nWggOt1wZuIrI8m
	CFuzoXAFHlY9nfe3id+VCRdFBog3bnNF70xSs7OXR6xQvuDhQNWrKFRXBDYDKx0WZURt34WUek2
	6PLXLHQ==
X-Received: from pjvu4.prod.google.com ([2002:a17:90a:dd44:b0:3ad:ce09:ff3])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f4f:b0:3ac:929d:ba5c
 with SMTP id 98e67ed59e1d1-3ae582c2b58mr2301735a91.45.1793213440324; Wed, 28
 Oct 2026 11:50:40 -0700 (PDT)
Date: Wed, 28 Oct 2026 18:50:16 +0000
In-Reply-To: <20261028185034.3607746-1-kuniyu@google.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261028185034.3607746-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261028185034.3607746-5-kuniyu@google.com>
Subject: [PATCH v2 4/6] memcg: Batch mod_memcg_state() for MEMCG_SOCK.
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
single cacheline of struct memcg_stock_pcp, inline the fast path
of consume_stock(), and batch mod_memcg_state() for MEMCG_SOCK
(-64, 64).

With this change, tcp_rr w/ 10000 flows achieves ~29% more
throughput with lower latency on machine w/ AMD EPYC 7B12 64-Core
Processor (Zen 2 Rome, 2 sockets, 256 vCPU), and the TCP stack
spends far fewer cycles on memcg.

  tcp_rr (10000 flows, 128 threads, 60s, average of 3 runs):

  Metric                     |       Baseline |        Patched |    Diff
  ---------------------------+----------------+----------------+--------
  Throughput (RPS)           |     20,884,499 |     26,960,730 | +29.09%
  Latency Mean (us)          |         478.46 |         370.50 | -22.56%
  Latency p50 (us)           |         453.96 |         361.80 | -20.30%
  Latency p90 (us)           |         669.00 |         482.98 | -27.81%
  Latency p99 (us)           |         969.38 |         622.92 | -35.74%

  perf cycles (10000 flows, 10s, average of 3 runs):

  Server (M cycles / %)      |           Baseline |            Patched |   =
 Diff
  ---------------------------+--------------------+--------------------+---=
-----
  Host Total Cycles          |        4,566,914 M |        4,575,636 M |   =
+0.2%
  tcp_rcv_established()      | 158,009 M (3.460%) | 152,520 M (3.333%) |   =
-3.5%
  mem_cgroup_sk_charge()     |  18,420 M (0.403%) |   7,474 M (0.163%) |  -=
59.4%
  mem_cgroup_sk_uncharge()   |  16,593 M (0.363%) |   8,541 M (0.187%) |  -=
48.5%
  __css_rstat_updated()      |   3,502 M (0.077%) |       0 M (0.000%) | -1=
00.0%
  Memcg Sock Total           |  38,515 M (0.843%) |  16,015 M (0.350%) |  -=
58.4%

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
v2
  * Benchmark again after rebase and update numbers
  * Check in_nmi() in __refill_stock()
---
 mm/memcontrol.c | 85 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 74 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a04b44656b38..b92e952c076a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2065,9 +2065,9 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *me=
mcg)
=20
 /*
  * The value of NR_MEMCG_STOCK is selected to keep the cached memcgs and t=
heir
- * nr_pages in a single cacheline. This may change in future.
+ * nr_pages and nr_sock in a single cacheline. This may change in future.
  */
-#define NR_MEMCG_STOCK 7
+#define NR_MEMCG_STOCK 6
=20
 /*
  * Watermarks for a charge stock slot, in the spirit of pcp->high and
@@ -2081,6 +2081,7 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *me=
mcg)
 struct memcg_stock_pcp {
 	local_trylock_t lock;
 	uint8_t nr_pages[NR_MEMCG_STOCK];
+	int8_t nr_sock[NR_MEMCG_STOCK];
 	struct mem_cgroup *cached[NR_MEMCG_STOCK];
=20
 	struct work_struct work;
@@ -2140,9 +2141,10 @@ static bool obj_stock_flush_required(struct obj_stoc=
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
@@ -2150,10 +2152,13 @@ static bool obj_stock_flush_required(struct obj_sto=
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
@@ -2173,7 +2178,19 @@ static bool consume_stock(struct mem_cgroup *memcg, =
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
 			WRITE_ONCE(stock->cached[i], NULL);
 			css_put(&memcg->css);
 		}
@@ -2184,9 +2201,17 @@ static bool consume_stock(struct mem_cgroup *memcg, =
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
@@ -2201,6 +2226,7 @@ static void drain_stock(struct memcg_stock_pcp *stock=
, int i)
 {
 	struct mem_cgroup *old =3D stock->cached[i];
 	uint8_t stock_pages;
+	int stock_sock;
=20
 	if (!old)
 		return;
@@ -2211,6 +2237,12 @@ static void drain_stock(struct memcg_stock_pcp *stoc=
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
 	WRITE_ONCE(stock->cached[i], NULL);
 	css_put(&old->css);
 }
@@ -2255,12 +2287,15 @@ static void drain_local_obj_stock(struct work_struc=
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
 	unsigned int stock_pages;
 	int empty_slot =3D -1;
+	int stock_sock =3D 0;
 	int i;
=20
 	/*
@@ -2274,13 +2309,15 @@ static void refill_stock(struct mem_cgroup *memcg, =
unsigned int nr_pages)
 	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
=20
 	if (unlikely(nr_pages > MEMCG_CHARGE_BATCH ||
+		     (IS_ENABLED(CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC) &&
+		      in_nmi()) ||
 		     !local_trylock(&memcg_stock.lock))) {
 		/*
 		 * In case of larger than batch refill or unlikely failure to
 		 * lock the percpu memcg_stock.lock, uncharge memcg directly.
 		 */
 		memcg_uncharge(memcg, nr_pages);
-		return;
+		goto update_sock;
 	}
=20
 	stock =3D this_cpu_ptr(&memcg_stock);
@@ -2301,7 +2338,22 @@ static void refill_stock(struct mem_cgroup *memcg, u=
nsigned int nr_pages)
=20
 		WRITE_ONCE(stock->nr_pages[i], stock_pages);
=20
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
 		local_unlock(&memcg_stock.lock);
+
+		if (unlikely(stock_sock))
+			mod_memcg_state(memcg, MEMCG_SOCK, stock_sock);
+
 		return;
 	}
=20
@@ -2318,6 +2370,15 @@ static void refill_stock(struct mem_cgroup *memcg, u=
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
@@ -2333,7 +2394,8 @@ static bool is_memcg_drain_needed(struct memcg_stock_=
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
@@ -5798,6 +5860,9 @@ bool mem_cgroup_sk_charge(const struct sock *sk, unsi=
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
@@ -5820,9 +5885,7 @@ void mem_cgroup_sk_uncharge(const struct sock *sk, un=
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
2.56.0.313.g2479322e68-goog

