Received: from mta0.migadu.com (out-42.mta0.migadu.com [91.218.175.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BCB48987D
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 17:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786640496; cv=none; b=MnHaJv4RanpHEb+kLs2ALQTASHvEbeXRqKtRJx/f613s2Z35FHH4cLCMMwv/2pKPOtbKX0xZgs/kzMWYmV6Ls7PlUKXKz29JhJedvgiK6ND+BPiV7DHCb7XeDYSIqTYhf/x6MBZps36tJ6S5rftcik98fdPKYNPCdLBK2ArL0dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786640496; c=relaxed/simple;
	bh=IC8q4K8Uk8A6ZcbO1N8MmnhqRx/RYea67hNdi4ByC2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fIDo3w5YthHGpltINoaqv81GyYH33G3wJEnwm08T1znmeOHVwuSSZjo/KDGXHPrcXGw4CMjJIz8t5Fyra4LMivM4nz/NABaoRHpx03OOcQeAKvZyjhRl34A+LDd5w0+02Te2ORj+VbFtqT2zEfoJWMVKMTvldr5CKos4S/pd00g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fmcicwuy; arc=none smtp.client-ip=91.218.175.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fmcicwuy"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=IC8q4K8Uk8A6ZcbO1N8MmnhqRx/RYea67hNdi4ByC2M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786640492; v=1; x=1787245292;
 b=fmcicwuyYKZGa9cctgECIqS6qHyydsMds4LJ50CHMUVzXG98WasU3SXHoI0jKwnGumHqDjjz
 T1t2xMey64ZG4wbuqGWX9M49kVo9sG4PKyFEffdYmg9ze5eficVfI1G30r8+kOetKMP9Eig7YdK
 j2k2KtEjAdeHmaE39l1bwGM8=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:42::)
	by smtp.migadu.com with ESMTPS id ac65b9794b46e62b;
	Thu, 13 Aug 2026 17:01:22 +0000
X-Migadu-Flow: FLOW_OUT
Date: Thu, 13 Aug 2026 10:01:19 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: kernel test robot <yi1.lai@intel.com>
Cc: Usama Arif <usama.arif@linux.dev>, oe-lkp@lists.linux.dev, 
	lkp@intel.com, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org
Subject: Re: [linux-next:master] [mm/vmpressure]  ea928e9e18:
 stress-ng.mremap.ops_per_sec 36.2% regression
Message-ID: <an34C2N-yqfok2Nn@linux.dev>
References: <202608131743.c6a7dda4-lkp@intel.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202608131743.c6a7dda4-lkp@intel.com>

On Thu, Aug 13, 2026 at 09:16:22PM +0800, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed a 36.2% regression of stress-ng.mremap.ops_per_sec on:
> 
> commit: ea928e9e18da682e9a5bc40aa862bff7ce5ae42e ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c") https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> in testcase: stress-ng
> version: stress-ng-x86_64-29ce10a2c-1_20260712
> with following parameters:
> 
> 	nr_threads: 100%
> 	testtime: 60s
> 	test: mremap
> 	cpufreq_governor: performance
> 
> 
> 
> config: x86_64-rhel-9.4 (CONFIG_MEMCG=y and CONFIG_MEMCG_V1 is not set)
> compiler: gcc-14
> test machine: 256 threads 4 sockets INTEL(R) XEON(R) PLATINUM 8592+ (Emerald Rapids) with 256G memory
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 

Hi there,

Can you please test the following patch and see if it fixes the regression?


From 84c0b05b3bc5cf73ee66ead75aafb1ad684462c3 Mon Sep 17 00:00:00 2001
From: Shakeel Butt <shakeel.butt@linux.dev>
Date: Thu, 13 Aug 2026 09:38:28 -0700
Subject: [PATCH] memcg: keep vmstats_percpu off the memory_events[] cacheline

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e78bc98ab229..e25d5b9a1db8 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -246,8 +246,13 @@ struct mem_cgroup {
 	/* handle for "memory.swap.events" */
 	struct cgroup_file swap_events_file;
 
-	/* memory.stat */
+	/* Read-mostly. */
 	struct memcg_vmstats	*vmstats;
+	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
+	int			kmemcg_id;
+
+	/* Write-hot from here on; do not let it share with the above. */
+	CACHELINE_PADDING(_pad_);
 
 	/* memory.events */
 	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
@@ -266,9 +271,6 @@ struct mem_cgroup {
 #if BITS_PER_LONG < 64
 	seqlock_t		socket_pressure_seqlock;
 #endif
-	int kmemcg_id;
-
-	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
 
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct list_head cgwb_list;
-- 
2.53.0-Meta


