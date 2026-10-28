Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213442;
	b=jBPKxtG0jda7TxGELqXDB/TJ8bnocy7LJr1mI/EYwu9bxNlCHcmbw0gcTlkeDC0HlLHi
	 6lSHvjc8hzys4ml0kq6JOgBn3B8za7Jq8NgYX7PTXH5MtsTt+iU9DaPu+05BK+gtQ7kFg
	 xd81kxs+rshm/XKp6aAA0Oj0U+/4wKhHN41OO2BoX2fKAy2XP93sK1jJXfJIM7yA2+y1l
	 i0ZpRuReyKy1hcPQw56RlsxTXMZVL021ZkBMMYAvDL+WI3Y87fxbfORHoToJK0RKiQmiA
	 bywYBDpMmkqiL2yvoDpHCTaW84qeO5oawq347N1j1t1Egm9vQn/Z0P4g9iIvIk3rprA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213442;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=bY3jLJiX/CdiZVg7kqP5WkxY/fjYB981acR8Lb4q8Ic=;
	b=OuQI6MdE8h9ivqmO44GBfkW4KLrQ+vQLUa1oN8sKvGuIyDIUU0QKG01kbEKX1zIfZqY3
	 tVJnC6BgQCcoRttCzkrrB3mRoYOaFMIkSwH3JLAbKRlNbixewnd1L5JGac6QhVEdonUsq
	 TZA8gfUvppfUCDt9+wgobdlLGY8zljXgI+MPYNvctyO6KndGyuVbzxGSZq3d5XTJ+aIga
	 yhCv0uL+IiV0F7VnfpaMvC2szMbNEkLhDDK9p74fHQlhvAjQv1CmSiBNkZ0l0j0MFY8pu
	 HgrQQCWNQTyWb5yzh92Cz/c6ZbC+4CFp2uWtspgcHbuvQKWUng0Ut/E7MG41Pb5GuHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Qjak8FeT;
	arc=none smtp.remote-ip=209.85.210.197
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15060606A33D
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 18:50:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15060606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Qjak8FeT
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-89f71ac2e2fso1163387b3a.3
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 11:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793213441; x=1793818241; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bY3jLJiX/CdiZVg7kqP5WkxY/fjYB981acR8Lb4q8Ic=;
        b=Qjak8FeT3e3m3AeNvnHdZoOOWNG2FbWcrNvz4fWnoXd3ouhEVX3NYysZC7X6kD73ds
         cK7svHF83BV5camLkGet7kccFzPwNsGXaI1YrZQ9RpAmnQqJ7TDuZs2lVx4BfKejDrt8
         HdAOnbbIeW40wwd3soyPwGfvoAPB3Gi6LvqFY/UyqmdTIorcWUO3vPO7gazvUlQWa6Zf
         J2MKoqbSsfb7YaGUJMpGFPxQf3uHVgW/xmTt9wb0KFSlHfpdncPSdhUCUosZ5vuGiR53
         DbF7WMa44Tehut5bJ7qarI6jW/krCL5dmU22er93aEQ0yakJ4QUmKEP3T10EXWuGehH2
         +dRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793213441; x=1793818241;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bY3jLJiX/CdiZVg7kqP5WkxY/fjYB981acR8Lb4q8Ic=;
        b=A1GX0oSOFtuqAdqMk31ZQk0uSA7vN6zj/Wh58lfbEwxmZxFhEw/m0ViTbpxBW0AF/l
         pkvaDWZzgEXvlK8OP7Y0R634/mfmGoLtqb+RjoguQ/ynaf3jMTntlHKsHe9u4hf+NmhR
         BZMsxF6O3hukqYVVu24aLWh2CpNowm2gMIMgvxHwbD1A3OobzDcT72swY/gdwdVDcuRb
         hAG5zrMtLjtwgutEgHhc73X7JJmd6YCV5OZ0kzuDU92IqvZYrKysSFY33XXRHPLD/6wO
         j1L/ImcPn3awSRkAj+AlEGmAbgmdHecGuRtNmgGL0tHcH3t0Dt+LgOoyP4J3fUM0Lm7E
         25Pw==
X-Forwarded-Encrypted: i=1; AKwUvBwiJeACRiLcn/5Qo5SOrtCQSua2u09AsdaxXDLjLcn7fAXotJFXADznhzQBePujCcm4ibEL9auy@vger.kernel.org
X-Gm-Message-State: AFq9FYJ1O2iBSTAIC4P5yHvFKsGh7cnzd/Ca1B8bzqK1Ei5kHEWpFXL8
	67cTRCL4iGTL8Uraj93We7ceLrRLxUc01E66ma/1m3X92HokQF7W+KdCosdHo5LwTe99BpH55Ht
	u27YO3g==
X-Received: from pfm28.prod.google.com ([2002:a05:6a00:73c:b0:8a0:7440:ee03])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:f86:b0:880:ea3d:d70a
 with SMTP id d2e1a72fcca58-8a6e78cfed1mr2357885b3a.38.1793213441092; Wed, 28
 Oct 2026 11:50:41 -0700 (PDT)
Date: Wed, 28 Oct 2026 18:50:17 +0000
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
Message-ID: <20261028185034.3607746-6-kuniyu@google.com>
Subject: [PATCH v2 5/6] memcg: Uncharge pages outside memcg_stock.lock in __refill_stock().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On host w/ AMD EPYC 9B45 128-Core Processor (Zen 5 Turin,
2 sockets, 512 vCPUs), tcp_rr w/ 20000 flows throughput often
degrades by ~50%, 32M -> 17M~27M.

In the bad case, the number of involuntary context switches
was extremely high by 12x (241733 -> 3093367).

In perf record, 96% samples had the same pattern, where the
thread was interrupted during page_counter_uncharge() by softirq,
and later ksoftirqd was woken up:

  # perf record -C 0-15 -e sched:sched_wakeup -g \
      -o /tmp/sched_wakeup.data -- sleep 1
  # perf report -i /tmp/sched_wakeup.data --stdio --no-children
    96.36%  tcp_rr   [kernel.kallsyms]  [k] wake_up_process
            |
            ---wake_up_process
               |
                --96.00%--irq_exit_rcu
                          |
                           --95.82%--sysvec_call_function_single
                                     asm_sysvec_call_function_single
                                     |
                                      --95.58%--page_counter_uncharge
                                                mem_cgroup_sk_uncharge
                                                sock_rfree
                                                tcp_recvmsg
                                                __x64_sys_recvfrom
                                                do_syscall_64
                                                entry_SYSCALL_64_after_hwframe

  # perf script -i /tmp/sched_wakeup.data | grep -A 20 "comm=ksoftirqd"
  tcp_rr  101952 [001]  9679.340985: sched:sched_wakeup: comm=ksoftirqd/1 pid=23 prio=120 target_cpu=001
  	ffffffffb64cd0cc wake_up_process+0xe6c ([kernel.kallsyms])
  	ffffffffb64cb034 irq_exit_rcu+0x264 ([kernel.kallsyms])
  	ffffffffb68ad31c sysvec_call_function_single+0xcc ([kernel.kallsyms])
  	ffffffffb560158a asm_sysvec_call_function_single+0x1a ([kernel.kallsyms])
  	ffffffffb653c4ce page_counter_uncharge+0x2e ([kernel.kallsyms])
  	ffffffffb6541b28 mem_cgroup_sk_uncharge+0x3c8 ([kernel.kallsyms])
  	ffffffffb6561383 sock_rfree+0x83 ([kernel.kallsyms])
  	ffffffffb6577faf tcp_recvmsg+0x2ff ([kernel.kallsyms])
  	ffffffffb65604d9 __x64_sys_recvfrom+0x159 ([kernel.kallsyms])

The problem is that when stock_pages exceeds MEMCG_STOCK_HIGH
or all slots in struct memcg_stock_pcp are full, __refill_stock()
calls memcg_uncharge() or drain_stock() while holding
memcg_stock.lock.

Because local_trylock() only disables preemption and leaves
interrupts and softirqs enabled, an RPS IPI arriving while
__refill_stock() stalls on page_counter_uncharge() invokes
NET_RX_SOFTIRQ (process_backlog()) on the same CPU while
memcg_stock.lock is held.

Every incoming packet in process_backlog() then fails
local_trylock() in __consume_stock() and falls back to
try_charge_memcg() and __refill_stock(), hammering the global
page_counter atomic twice per packet, and slow processing
finally wakes up ksoftirqd.

Let's move memcg_uncharge(), mod_memcg_state(), and css_put()
outside local_unlock(&memcg_stock.lock) in __refill_stock().

With the change, tcp_rr w/ 20000 flows gains ~4% more throughput
and is stable around the highest value.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 mm/memcontrol.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b92e952c076a..87b189aba07d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2331,13 +2331,13 @@ static __always_inline void __refill_stock(struct mem_cgroup *memcg,
 
 		stock_pages = stock->nr_pages[i] + nr_pages;
 		if (unlikely(stock_pages > MEMCG_STOCK_HIGH)) {
-			memcg_uncharge(memcg,
-				       stock_pages - MEMCG_STOCK_LOW);
-			stock_pages = MEMCG_STOCK_LOW;
+			WRITE_ONCE(stock->nr_pages[i], MEMCG_STOCK_LOW);
+			stock_pages -= MEMCG_STOCK_LOW;
+		} else {
+			WRITE_ONCE(stock->nr_pages[i], stock_pages);
+			stock_pages = 0;
 		}
 
-		WRITE_ONCE(stock->nr_pages[i], stock_pages);
-
 		if (nr_sock) {
 			stock_sock = stock->nr_sock[i] - nr_sock;
 
@@ -2353,16 +2353,25 @@ static __always_inline void __refill_stock(struct mem_cgroup *memcg,
 
 		if (unlikely(stock_sock))
 			mod_memcg_state(memcg, MEMCG_SOCK, stock_sock);
+		if (unlikely(stock_pages))
+			memcg_uncharge(memcg, stock_pages);
 
 		return;
 	}
 
+	cached = NULL;
+	stock_pages = 0;
+
 	i = empty_slot;
 	if (i == -1) {
 		i = stock->drain_idx++;
 		if (stock->drain_idx == NR_MEMCG_STOCK)
 			stock->drain_idx = 0;
-		drain_stock(stock, i);
+
+		cached = stock->cached[i];
+		stock_pages = stock->nr_pages[i];
+		stock_sock = stock->nr_sock[i];
+		WRITE_ONCE(stock->nr_sock[i], 0);
 	}
 
 	css_get(&memcg->css);
@@ -2371,6 +2380,14 @@ static __always_inline void __refill_stock(struct mem_cgroup *memcg,
 
 	local_unlock(&memcg_stock.lock);
 
+	if (unlikely(cached)) {
+		if (stock_pages)
+			memcg_uncharge(cached, stock_pages);
+		if (stock_sock)
+			mod_memcg_state(cached, MEMCG_SOCK, stock_sock);
+		css_put(&cached->css);
+	}
+
 update_sock:
 	if (nr_sock)
 		mod_memcg_state(memcg, MEMCG_SOCK, -nr_sock);
-- 
2.56.0.313.g2479322e68-goog

