Received: from mta0.migadu.com (out-149.mta0.migadu.com [91.218.175.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4073E499F31
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 17:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786641311; cv=none; b=Z+C6upUppHsQ8Q3n5zEpdJLZN1RI4D13LST8a1b6HFPdUbFqwDtTB599mzKCcUdrcVda7YcFYUFQ8FqfkTJysaYyeYc4pWdxaNHvy5JKO9TZOkpDfSNomxyXLL0wuGe344wXEKwIVr/5AebAQIRb9Qo8NZHiwS/KZnjk/9ftJnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786641311; c=relaxed/simple;
	bh=Yec5Wj8ZUY9zXGuHPs7l8wD80d+XYwicM6WJm2aA3IY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XXIYxadGm/I+tDHKwy85fEVdk98zNMA8ieERRFdhoP9Xj2cmDiopj1CH6bkYto0Z2ONFSGsc3W/OCnffoqYB5h2vo2+9yN/pqCYpbnivBf0NbNkO0BRLEME3NIAlPYtykjREAiPyabu/6rBMNyK/904+xue5PznmNqJc+D45GVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YA7ZfcUJ; arc=none smtp.client-ip=91.218.175.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YA7ZfcUJ"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Yec5Wj8ZUY9zXGuHPs7l8wD80d+XYwicM6WJm2aA3IY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786641307; v=1; x=1787246107;
 b=YA7ZfcUJa2liuDoGBWGG+/y0Iv+PY4Q13Hgtd/L0Hl6Phnrqy6mjVyTCAnNtxVhfAWXwmqNU
 lKrIBlDTJq9K2icM7myrhlDxbmYs0Vy7wtFHm/nd04iIR08a2KnOja5fT1xl7pq1bPJPhuNM4l0
 f5U922JvjCfjbskRa2bRhaYA=
X-Envelope-To: cgroups@vger.kernel.org
Received: from [IPV6:2a03:83e0:1126:4:9d:a05e:5bd8:c200] (2620:10d:c092:500::6:def8)
	by smtp.migadu.com with ESMTPS id de41cf8ec9c54807;
	Thu, 13 Aug 2026 17:14:57 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <017721a3-5eae-449e-8b86-75cffb503dd3@linux.dev>
Date: Thu, 13 Aug 2026 18:14:50 +0100
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master] [mm/vmpressure] ea928e9e18:
 stress-ng.mremap.ops_per_sec 36.2% regression
To: Shakeel Butt <shakeel.butt@linux.dev>,
 kernel test robot <yi1.lai@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
 cgroups@vger.kernel.org
References: <202608131743.c6a7dda4-lkp@intel.com> <an34C2N-yqfok2Nn@linux.dev>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <an34C2N-yqfok2Nn@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 13/08/2026 18:01, Shakeel Butt wrote:
> On Thu, Aug 13, 2026 at 09:16:22PM +0800, kernel test robot wrote:
>>
>>
>> Hello,
>>
>> kernel test robot noticed a 36.2% regression of stress-ng.mremap.ops_per_sec on:
>>
>> commit: ea928e9e18da682e9a5bc40aa862bff7ce5ae42e ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c") https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
>>
>> in testcase: stress-ng
>> version: stress-ng-x86_64-29ce10a2c-1_20260712
>> with following parameters:
>>
>> 	nr_threads: 100%
>> 	testtime: 60s
>> 	test: mremap
>> 	cpufreq_governor: performance
>>
>>
>>
>> config: x86_64-rhel-9.4 (CONFIG_MEMCG=y and CONFIG_MEMCG_V1 is not set)
>> compiler: gcc-14
>> test machine: 256 threads 4 sockets INTEL(R) XEON(R) PLATINUM 8592+ (Emerald Rapids) with 256G memory
>>
>> (please refer to attached dmesg/kmsg for entire log/backtrace)
>>
> 
> Hi there,
> 
> Can you please test the following patch and see if it fixes the regression?
> 
> 
> From 84c0b05b3bc5cf73ee66ead75aafb1ad684462c3 Mon Sep 17 00:00:00 2001
> From: Shakeel Butt <shakeel.butt@linux.dev>
> Date: Thu, 13 Aug 2026 09:38:28 -0700
> Subject: [PATCH] memcg: keep vmstats_percpu off the memory_events[] cacheline
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  include/linux/memcontrol.h | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index e78bc98ab229..e25d5b9a1db8 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -246,8 +246,13 @@ struct mem_cgroup {
>  	/* handle for "memory.swap.events" */
>  	struct cgroup_file swap_events_file;
>  
> -	/* memory.stat */
> +	/* Read-mostly. */
>  	struct memcg_vmstats	*vmstats;
> +	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
> +	int			kmemcg_id;
> +
> +	/* Write-hot from here on; do not let it share with the above. */
> +	CACHELINE_PADDING(_pad_);
>  
>  	/* memory.events */
>  	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
> @@ -266,9 +271,6 @@ struct mem_cgroup {
>  #if BITS_PER_LONG < 64
>  	seqlock_t		socket_pressure_seqlock;
>  #endif
> -	int kmemcg_id;
> -
> -	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
>  
>  #ifdef CONFIG_CGROUP_WRITEBACK
>  	struct list_head cgwb_list;


I was currently testing this diff, not sure which one would be better.

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e78bc98ab229b..215e2e87f42b2 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -268,10 +268,15 @@ struct mem_cgroup {
 #endif
        int kmemcg_id;

-       struct memcg_vmstats_percpu __percpu *vmstats_percpu;
-
 #ifdef CONFIG_CGROUP_WRITEBACK
        struct list_head cgwb_list;
+#endif
+
+       /* Keep the hot per-CPU stats pointer away from memory event counters. */
+       struct memcg_vmstats_percpu __percpu *vmstats_percpu
+               ____cacheline_aligned_in_smp;
+
+#ifdef CONFIG_CGROUP_WRITEBACK
        struct wb_domain cgwb_domain;
        struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
 #endif

