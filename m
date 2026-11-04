Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793833380;
	b=TFHQK4oqkdpUpbj7KNVNd825GwYqZvxfiSERG0Io/L09N9Mqs516pPC1LZlZfxMrRO11
	 Cqa2gxV5nUxoFXkiTB457SfQ6i8N49vxE4khsvR/XdENezgO7GgSVn6Zw94pYonbvxW6A
	 tUj5m6gi24LixkJg/FdSy1v/a1+yHRcs7JPKmtBdyFoqPQk+WvXoGWOZXZhUP99QK3Jfv
	 k/0ZwUhGqRLN4Eq/98fphhcjMcfoaNpGqmirdHlr2YGpO5rp1AjGcTL5zINhKK0tZE30c
	 mLkcD3ofhndoWRmeaJFg8oL7z8oOi84zHEsjQKS+Qwcv3Fmow7xO7gvEqgyUMZByIXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793833380;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=RtDJVlSwaDZV2kPnN+e71gVYTRxFI7GApJtZA+uD56Q=;
	b=fIDiXpe/hTV51S/JKrMiIJEPLiRwOFawSC02hba230vkU1rLZ6ATpZw38GS2zjyHA1J9
	 4hAv86QYbatD3NO077NQVWzlK1RZB+R0o1qsn3G9hRkNq3ri8uBxH4RNZ4KQ1qPLZeCGG
	 3LHemKnUJVN+Ot4T267mk4UhSDjM2CXw+zoS9ig05HwJOVk3SReMpQaCTnn/4zw8qvQmF
	 dUW0OafxAfheBKUAkdhIv/HrWzMMj1CrIiLKWniQ1fOou9Qj7o1nlqkSDpVMu8tjUqRJP
	 SCf6U1XXupe6fBmFPnkpF4VcKGGzQTMRefL9aUXyL9pRDFPjDLVspFmKQ73RejNEW6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UuYi+P0t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D33B606A335
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 23:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UuYi+P0t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9BF1F00A21;
	Wed,  4 Nov 2026 23:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793833379;
	bh=RtDJVlSwaDZV2kPnN+e71gVYTRxFI7GApJtZA+uD56Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UuYi+P0trryxGTFIB7MaSORDfU4+JZ1hS7sHUVk1M7row6E1je8aH4BekGP7golkS
	 1miU+ExvCZpGvWuGN23th4WuCq0iCxaVaUWeLE5/5xT4vnZDgSEXoCChzWCZNt/h+v
	 4srV9O8Mpsdtmiqvst4vAAkRpWRRM0wVDOdCHVPk=
Date: Wed, 4 Nov 2026 15:02:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Kuniyuki
 Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v3 0/4] memcg: Misc cleanup and perf improvement for
 TCP.
Message-Id: <20261104150258.56cf6be2efe442cdf5ff8da1@linux-foundation.org>
In-Reply-To: <20261029194452.3189365-1-kuniyu@google.com>
References: <20261029194452.3189365-1-kuniyu@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 29 Oct 2026 19:44:11 +0000 Kuniyuki Iwashima <kuniyu@google.com> wrote:

> On host w/ AMD EPYC 9B45 128-Core Processor (Zen 5 Turin,
> 2 sockets, 512 vCPUs), tcp_rr w/ 20000 flows throughput often
> degrades by ~50%, 32M -> 17M~27M.
> 
> In the bad case, the number of involuntary context switches
> was extremely high by 12x (241733 -> 3093367).
> 
> The root cause was that refill_stock() calls memcg_uncharge()
> or drain_stock() while holding memcg_stock.lock.
> 
> Patch 1~3 are misc cleanup for better asm output and patch 4
> moves heavy operations to out of local_lock(&memcg_stock.lock).
> 
> This series removes the flakiness and gives ~3% gain on the
> 512 vCPU platform.
> 
> In addition, on machine w/ AMD EPYC 7B12 64-Core Processor
> (Zen 2 Rome, 2 sockets, 256 vCPU), tcp_rr w/ 10000 flows achieves
> 36% more throughput with lower latency.
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

Thanks, that all checks out here.  I fed the series into my
LLM-controlled live kernel testing setup.  tl;dr: no correctness issues
but the performance gains on this setup are much more humble.

Gory details for the morbidly interested:


: I tested all four patches before/after on Linux 7.4.0-rc1.
: 
: Correctness testing used a four-vCPU, 8 GiB Debian QEMU/KVM guest
: with KASAN and lockdep. Both kernels passed all 22 memcg/kmem
: selftests, cgroup/socket churn, guest CPU hotplug, socket lifetime
: across migration/cgroup removal, and payload-checked TCP transfers
: under memory pressure. Final socket charges and dying descendants
: reached zero, with no unexpected kernel diagnostics. Traces confirmed
: stock trimming, eviction and fallback coverage.
: 
: Performance testing used 56 guest vCPUs pinned individually to 56
: physical cores of a 64-core Threadripper 3995WX, with 32 GiB and
: KASAN/lockdep disabled. Host and guest each had one socket/NUMA node;
: the guest exposed one thread per core. Neper used 10,000 flows and
: one-byte requests/responses. All 24 runs completed: three 60-second
: runs per kernel/condition, with alternating A/B boot blocks.
: 
: Median throughput changes for the full series:
: 
:     Workers per endpoint     RPS off     RPS on
:                       28      +1.21%     +1.38%
:                      128      +0.14%     +0.72%
: 
: The smaller machine likely explains much of the difference from your
: 36% gain. Your reported systems have two sockets and 256/512 vCPUs.
: Here each endpoint had just 28 vCPUs backed by 28 physical cores;
: 128 workers oversubscribed those CPUs rather than adding parallelism.
: There was no physical inter-socket traffic. These differences can
: reduce shared-counter contention and the lock-held interval behind
: the RPS/charge-fallback/ksoftirqd amplification you described. I
: exercised stock and RPS paths, but did not reproduce your collapse
: or establish comparable amplification. This explanation is plausible,
: not demonstrated by the measurements.
: 
: Three conditions consistently favored B; 128 workers/RPS-off was
: essentially tied. Frequency was uncontrolled, limiting sub-percent
: claims. Both kernels had VM CPU-feature/watchdog diagnostics without
: an unstable-clock message, and softnet drops with RPS off.

