Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793303098;
	b=N0bA/gXSctxYQSP2w0zBhBCuPrpd8DGSQElBWgQ8rP96WZvXnSN+sfw0bx6utkqsHmF5
	 GlbgfT9O5ZheUvZPHqplcsmwjIyeC3KjhrxLEleTL6nbatdADNNPQMzSOzcGza0aiHyPX
	 nMY5jtdwo1aH/CdXHMHU3e3yED7LoF7z00AYNVPyy/pzEzLGblkKAV+fpcf80qSvy7phK
	 OQYLA1QAxJh/dxT4xvAD/piEtDb9ADA6c6ZiVHuQjRf+rb8a44rddyw4d7IOO7JyLxBOi
	 4SMFsDaFgaAIIROWYZEsRJGIeTympamMbP/298JSCgF4KAx+l8EvNCjZtchgzCoINGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793303098;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=TFoNYJUi96cxZ7GAHijH9uanPv7mqKBvmKJStUGrtrk=;
	b=KGS+M4O0H/Nj9NGlJLoq6gPBQew67l2/3cngNBucm47sn00W7uhr+irmSh0a+GdybXt5
	 yAiA6i9lHK2znjvB6EabVUgMVTgJ08XvhMx/YruhyR8Vekvy2sYQOE5qvMiGP/x5bi5iX
	 MFIl/ABo1fg0gTg49hwNhEUIN0l+fv8pR51Flce2XFYXsTRYShWxdUd47/W85j8EIorNz
	 4aqG79nEAAyQ0o78cg6cv/TgPQxZVI0vgFsy9DiSwKv+5MhUvPdLzsos+dPKwyGbNuSs3
	 JYO7N5NEmqs5aKkESSnRNnuN8WbmVX/JVKSmENt7XZm0r3WkfD7ySNHOLApRxnGf1Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="bprtE4T/";
	arc=none smtp.remote-ip=209.85.216.72
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435B7606A31F
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 19:44:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 435B7606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=bprtE4T/
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ac76132001so1870874a91.0
        for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 12:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793303098; x=1793907898; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TFoNYJUi96cxZ7GAHijH9uanPv7mqKBvmKJStUGrtrk=;
        b=bprtE4T/mihyP6u5yh8ylIjZf7xdb0lgZ2r20OFrT9OadsTBHBDQJGqJzqPFgahmbU
         ocD6qmq5Nq5wZNFoLrdmC1PMvqv01VGa/O/WT5qRwc7IiBzbj0rDAQbv/80LlNkKEnKm
         INxvRloqeRI3jnkuhZokwrFOCWDlSBXfv4VP8elbVPivC5Y8GNznYzjytPZrKF/OzsZN
         FGW2B0EanJxRqkapMb30VGhsulF7s6mh4Af5IqiTXgX+1iFEDRwmttEeDaqODRC9NJZj
         GqWsdB9tw2w3eHvH53etC68VLmSOLZE5vWOp2sfAth45r/rwf2FZx6RHi2ylkdPKXP7n
         t72g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793303098; x=1793907898;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TFoNYJUi96cxZ7GAHijH9uanPv7mqKBvmKJStUGrtrk=;
        b=BkHvcSdtgDfKTALPiyn9gH5OmXfBHLQm59Cg+gZHrlXT+hwWj9SYvz2CQCVUNk5olk
         sAH/zUiLjygBVYMwbNMo4GYm7BelDaPFPAFFw0x3eo68doUEbsW0ViLhNHjKjLJoBkpo
         n9LiEZWMYlUE8db06geiJpL4b85F1Qr8F/CGxo/pIxcHt4/FcV+2XGJ6OPLKCF4Y4JO6
         sp2rMhSLnNxreR0+0Qs55kkZ8axv5Nah5+gmCidAycwx2vYCpaYkeIizIhBVjymMO7/q
         ATvl3pUZUN0vnFYiTGpL4UI/vlOlJYK0BlfmXyhMV4SJGYL7H/BGGw4RNsxUjii4ZICY
         zt0g==
X-Forwarded-Encrypted: i=1; AKwUvBwh8Bmat9ihLQ1YFAM5XpaWWhGdS4fhRWJ7TfOigRUsojVLx2uPyd9N8ygOC7R5LzVxEbfIwlSJ@vger.kernel.org
X-Gm-Message-State: AFq9FYJpHx704f2O5jQq5J4pziN1tzpOP3tgwLBonFPaLGK12Z/Wl9SD
	+mjWXhjvBjslSnL4LGVl8xhBSCdu9b1+oFMlYXrZHn8P1ORQbpRalW+21a6ougUtt8lczo3KPMC
	BfXrFiw==
X-Received: from pgfd10-n1.prod.google.com ([2002:a05:6a02:654a:10b0:cd8:ba74:813f])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6b8c:b0:3dd:85a8:cad3
 with SMTP id adf61e73a8af0-3e9289ce7c5mr283305637.42.1793303097365; Thu, 29
 Oct 2026 12:44:57 -0700 (PDT)
Date: Thu, 29 Oct 2026 19:44:15 +0000
In-Reply-To: <20261029194452.3189365-1-kuniyu@google.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261029194452.3189365-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261029194452.3189365-5-kuniyu@google.com>
Subject: [PATCH v3 4/4] memcg: Uncharge pages outside memcg_stock.lock in refill_stock().
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
or all slots in struct memcg_stock_pcp are full, refill_stock()
calls memcg_uncharge() or drain_stock() while holding
memcg_stock.lock.

Because local_trylock() only disables preemption and leaves
interrupts and softirqs enabled, an RPS IPI arriving while
refill_stock() stalls on page_counter_uncharge() invokes
NET_RX_SOFTIRQ (process_backlog()) on the same CPU while
memcg_stock.lock is held.

Every incoming packet in process_backlog() then fails
local_trylock() in consume_stock() and falls back to
try_charge_memcg() and refill_stock(), hammering the global
page_counter atomic twice per packet, and slow processing
finally wakes up ksoftirqd.

Let's move memcg_uncharge() and css_put() outside
local_unlock(&memcg_stock.lock) in refill_stock().

With the change, the flakiness disappeared on the 512 vCPU platform.

In addition, on machine w/ AMD EPYC 7B12 64-Core Processor (Zen 2
Rome, 2 sockets, 256 vCPU), tcp_rr w/ 10000 flows achieves 36% more
throughput with lower latency.

  tcp_rr (10000 flows, 128 threads, 60s, average of 3 runs):

  Metric                     |       Baseline |    Patched |    Diff
  ---------------------------+----------------+------------+--------
  Throughput (RPS)           |     20,884,499 | 28,453,051 | +36.24%
  Latency Mean (us)          |         478.46 |     351.07 | -26.63%
  Latency p50 (us)           |         453.96 |     343.04 | -24.43%
  Latency p90 (us)           |         669.00 |     479.57 | -28.32%
  Latency p99 (us)           |         969.38 |     593.92 | -38.73%

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
v3: Add a new benchmark result without batching stats patch.
---
 mm/memcontrol.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a04b44656b38..ac43c895490a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2294,23 +2294,31 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 
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
 		local_unlock(&memcg_stock.lock);
+
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
 	}
 
 	css_get(&memcg->css);
@@ -2318,6 +2326,13 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	WRITE_ONCE(stock->nr_pages[i], nr_pages);
 
 	local_unlock(&memcg_stock.lock);
+
+	if (unlikely(cached)) {
+		if (stock_pages)
+			memcg_uncharge(cached, stock_pages);
+
+		css_put(&cached->css);
+	}
 }
 
 static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
-- 
2.56.0.317.g454f8302e1-goog

