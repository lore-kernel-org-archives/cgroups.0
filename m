Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.132
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793303560;
	b=sFywXMS1Mw/mrErvQsCQF1RtyhGM6lODC0Ej4FuPMwQoZ2XfWh8huU576f6uIwjOMYq5
	 UPIHDe7cEEhPAF5LzNGtB/f95LgY18VToj5Lsy3vXWj1+zC/9upFcVellJXE7TgKktyl8
	 PufPrQCY+sb8it3uO5wxOTXTxH46N0ZLB0//Ezk2fdIyYSJYn+a4ZxP1O/Z84J6lOMntp
	 l1s3WfPs7soMS4a3CcPkTx6lADQYMRr+yEqZVNyMs+LNlxiXv570i/IRf292bLUZSQbIL
	 eeq5XeU5hsAFEdOtl3q44/TcgDG1w+4G7mtAZ/yyNEW6hE+m38sdD2x4yW2DvUu6+Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793303560;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=a447cVMtdkqcUJRY7pb6L3o51fer89SCf7m7k3ULuN8=;
	b=XRqbrABLUNbXBoSOxETWO/tJ1/kPuWl5m1Vy22OdPNhPdRtdz8gZe+KQEvxG04teB5VN
	 r6ekQMyLpeYgTMN2Vx2kjjFavpj5wJCGgwZc6lW3P6CIOdaACAdKo3wKSq57SDEGPg3aA
	 CRFTEqvPB5L/qyXu0gxI5rNaXobpJO1m+zU+zXuoXbN/zI+0mt46LqZq2NQJN0FLe5b98
	 AM5KR15WOa99AeDVGhZyzOkYPyfgxXyYh+dJY++2XNmvMuQsypypDYyJE7lrZ4zMH48Yy
	 mQtw1RKoaQH0YSTftX6s5suW9m7BZE36KmRH+ML+E8SHs3tT1nK4WW/804XLzQmubEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BJLkrOXZ;
	arc=none smtp.remote-ip=91.218.175.132
Received: from mta0.migadu.com (out-132.mta0.migadu.com [91.218.175.132])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1391606A31A
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 19:52:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1391606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BJLkrOXZ
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=XZ2azTUUWfrxKE1K4J2pw0GmPL2WGA3CYY9gqmtHK18=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793303557; v=1; x=1793908357;
 b=BJLkrOXZx/1vobWi+dAYt72zpfjVKP52ixGzQxuNg5bTSwDs/wGRXzmwdqhf2jIHhWav8q4s
 GNGJy1yDmOp5m1OqjeANl8gOfVeCqVh9L3cMEl/qLibkW3BR83L7EnAHpVECAR/3PJSqotAedBa
 w4HH65LOIdY9hipBf3AHflLc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 682a9705787ec960;
	Thu, 29 Oct 2026 19:52:37 +0000
X-Mizu-Trace-ID: 682a9705787ec960
X-Migadu-Flow: FLOW_OUT
Date: Thu, 29 Oct 2026 12:52:34 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v3 4/4] memcg: Uncharge pages outside memcg_stock.lock in
 refill_stock().
Message-ID: <auOj3mC-J9QC0hCx@linux.dev>
References: <20261029194452.3189365-1-kuniyu@google.com>
 <20261029194452.3189365-5-kuniyu@google.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029194452.3189365-5-kuniyu@google.com>

On Thu, Oct 29, 2026 at 07:44:15PM +0000, Kuniyuki Iwashima wrote:
> On host w/ AMD EPYC 9B45 128-Core Processor (Zen 5 Turin,
> 2 sockets, 512 vCPUs), tcp_rr w/ 20000 flows throughput often
> degrades by ~50%, 32M -> 17M~27M.
> 
> In the bad case, the number of involuntary context switches
> was extremely high by 12x (241733 -> 3093367).
> 
> In perf record, 96% samples had the same pattern, where the
> thread was interrupted during page_counter_uncharge() by softirq,
> and later ksoftirqd was woken up:
> 
>   # perf record -C 0-15 -e sched:sched_wakeup -g \
>       -o /tmp/sched_wakeup.data -- sleep 1
>   # perf report -i /tmp/sched_wakeup.data --stdio --no-children
>     96.36%  tcp_rr   [kernel.kallsyms]  [k] wake_up_process
>             |
>             ---wake_up_process
>                |
>                 --96.00%--irq_exit_rcu
>                           |
>                            --95.82%--sysvec_call_function_single
>                                      asm_sysvec_call_function_single
>                                      |
>                                       --95.58%--page_counter_uncharge
>                                                 mem_cgroup_sk_uncharge
>                                                 sock_rfree
>                                                 tcp_recvmsg
>                                                 __x64_sys_recvfrom
>                                                 do_syscall_64
>                                                 entry_SYSCALL_64_after_hwframe
> 
>   # perf script -i /tmp/sched_wakeup.data | grep -A 20 "comm=ksoftirqd"
>   tcp_rr  101952 [001]  9679.340985: sched:sched_wakeup: comm=ksoftirqd/1 pid=23 prio=120 target_cpu=001
>   	ffffffffb64cd0cc wake_up_process+0xe6c ([kernel.kallsyms])
>   	ffffffffb64cb034 irq_exit_rcu+0x264 ([kernel.kallsyms])
>   	ffffffffb68ad31c sysvec_call_function_single+0xcc ([kernel.kallsyms])
>   	ffffffffb560158a asm_sysvec_call_function_single+0x1a ([kernel.kallsyms])
>   	ffffffffb653c4ce page_counter_uncharge+0x2e ([kernel.kallsyms])
>   	ffffffffb6541b28 mem_cgroup_sk_uncharge+0x3c8 ([kernel.kallsyms])
>   	ffffffffb6561383 sock_rfree+0x83 ([kernel.kallsyms])
>   	ffffffffb6577faf tcp_recvmsg+0x2ff ([kernel.kallsyms])
>   	ffffffffb65604d9 __x64_sys_recvfrom+0x159 ([kernel.kallsyms])
> 
> The problem is that when stock_pages exceeds MEMCG_STOCK_HIGH
> or all slots in struct memcg_stock_pcp are full, refill_stock()
> calls memcg_uncharge() or drain_stock() while holding
> memcg_stock.lock.
> 
> Because local_trylock() only disables preemption and leaves
> interrupts and softirqs enabled, an RPS IPI arriving while
> refill_stock() stalls on page_counter_uncharge() invokes
> NET_RX_SOFTIRQ (process_backlog()) on the same CPU while
> memcg_stock.lock is held.
> 
> Every incoming packet in process_backlog() then fails
> local_trylock() in consume_stock() and falls back to
> try_charge_memcg() and refill_stock(), hammering the global
> page_counter atomic twice per packet, and slow processing
> finally wakes up ksoftirqd.
> 
> Let's move memcg_uncharge() and css_put() outside
> local_unlock(&memcg_stock.lock) in refill_stock().
> 
> With the change, the flakiness disappeared on the 512 vCPU platform.
> 
> In addition, on machine w/ AMD EPYC 7B12 64-Core Processor (Zen 2
> Rome, 2 sockets, 256 vCPU), tcp_rr w/ 10000 flows achieves 36% more
> throughput with lower latency.
> 
>   tcp_rr (10000 flows, 128 threads, 60s, average of 3 runs):
> 
>   Metric                     |       Baseline |    Patched |    Diff
>   ---------------------------+----------------+------------+--------
>   Throughput (RPS)           |     20,884,499 | 28,453,051 | +36.24%
>   Latency Mean (us)          |         478.46 |     351.07 | -26.63%
>   Latency p50 (us)           |         453.96 |     343.04 | -24.43%
>   Latency p90 (us)           |         669.00 |     479.57 | -28.32%
>   Latency p99 (us)           |         969.38 |     593.92 | -38.73%
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
