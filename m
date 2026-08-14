Received: from mta1.migadu.com (out-223.mta1.migadu.com [95.215.58.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2FC3382F4
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 10:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786703553; cv=none; b=sK+aQRsaoXlkdOjluGMiFJdRKY9/8wu5GBr/J1D0knbI757rIXn6gZhqu0wyMjb2h9hTuP+OJR1SF0hRm7jZWYQ+aM8U0wLEFbNNHJtq/kf5U4LEXFRlHj1nrtVsDjEYhAMYT8bqfqRKsYO+8bBi7bbV4brSnrbRzMqAj2XBOxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786703553; c=relaxed/simple;
	bh=t+a+FxRNFjwPm5BphqfBB+v6WxiBUG83wt0tKUTht2U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SA27gkrCwXiBtgoXq6N09npZsrmKdFmLGCSfn8JTqtZICpV9ja30vLH9CS3dY6uVZBBYqy4ZxN9zsBFRrgBK8mZUWw9kuKePGueeciyRe93HgC1wJ2/VefqXYzYfnx2zPxtoqXuUzvhqvrT2Juxc9qOTIOEN9KRu+ausmtddt8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nESwCP6s; arc=none smtp.client-ip=95.215.58.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nESwCP6s"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=t+a+FxRNFjwPm5BphqfBB+v6WxiBUG83wt0tKUTht2U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786703541; v=1; x=1787308341;
 b=nESwCP6sWKpUqbYM4jqpBHIccctzN+Rnwbp85cJU/dyDYkpBKJpeYB5IJHHY9RJnPbprfno6
 FkBgqj/wWVTezT+yeQLWieV2DAr3BgVD0zwXNQxsQY10NxX1+iOd6w0melSHKQunKGcKnA2XfAi
 UjXzRE1jSCUXGaby/wxYUOOg=
X-Envelope-To: cgroups@vger.kernel.org
Received: from [IPV6:2a02:6b6f:e75b:1900:855:edd6:ce7b:4965] (2a02:6b6f:e75b:1900:855:edd6:ce7b:4965)
	by smtp.migadu.com with ESMTPS id 63a03deb27faceb6;
	Fri, 14 Aug 2026 10:32:10 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <f330dd75-d9b8-4259-a02f-9e3ff4bcdc1e@linux.dev>
Date: Fri, 14 Aug 2026 11:32:09 +0100
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master] [mm/vmpressure] ea928e9e18:
 stress-ng.mremap.ops_per_sec 36.2% regression
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: kernel test robot <yi1.lai@intel.com>, oe-lkp@lists.linux.dev,
 lkp@intel.com, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
 cgroups@vger.kernel.org
References: <202608131743.c6a7dda4-lkp@intel.com> <an34C2N-yqfok2Nn@linux.dev>
 <017721a3-5eae-449e-8b86-75cffb503dd3@linux.dev> <an3-aksL0MZPM3ZJ@linux.dev>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <an3-aksL0MZPM3ZJ@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 13/08/2026 18:29, Shakeel Butt wrote:
> On Thu, Aug 13, 2026 at 06:14:50PM +0100, Usama Arif wrote:
>>
>>
>> On 13/08/2026 18:01, Shakeel Butt wrote:
>>> On Thu, Aug 13, 2026 at 09:16:22PM +0800, kernel test robot wrote:
>>>>
>>>>
>>>> Hello,
>>>>
>>>> kernel test robot noticed a 36.2% regression of stress-ng.mremap.ops_per_sec on:
>>>>
>>>> commit: ea928e9e18da682e9a5bc40aa862bff7ce5ae42e ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c") https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
>>>>
>>>> in testcase: stress-ng
>>>> version: stress-ng-x86_64-29ce10a2c-1_20260712
>>>> with following parameters:
>>>>
>>>> 	nr_threads: 100%
>>>> 	testtime: 60s
>>>> 	test: mremap
>>>> 	cpufreq_governor: performance
>>>>
>>>>
>>>>
>>>> config: x86_64-rhel-9.4 (CONFIG_MEMCG=y and CONFIG_MEMCG_V1 is not set)
>>>> compiler: gcc-14
>>>> test machine: 256 threads 4 sockets INTEL(R) XEON(R) PLATINUM 8592+ (Emerald Rapids) with 256G memory
>>>>
>>>> (please refer to attached dmesg/kmsg for entire log/backtrace)
>>>>
>>>
>>> Hi there,
>>>
>>> Can you please test the following patch and see if it fixes the regression?
>>>
>>>
>>> From 84c0b05b3bc5cf73ee66ead75aafb1ad684462c3 Mon Sep 17 00:00:00 2001
>>> From: Shakeel Butt <shakeel.butt@linux.dev>
>>> Date: Thu, 13 Aug 2026 09:38:28 -0700
>>> Subject: [PATCH] memcg: keep vmstats_percpu off the memory_events[] cacheline
>>>
>>> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
>>> ---
>>>  include/linux/memcontrol.h | 10 ++++++----
>>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>>> index e78bc98ab229..e25d5b9a1db8 100644
>>> --- a/include/linux/memcontrol.h
>>> +++ b/include/linux/memcontrol.h
>>> @@ -246,8 +246,13 @@ struct mem_cgroup {
>>>  	/* handle for "memory.swap.events" */
>>>  	struct cgroup_file swap_events_file;
>>>  
>>> -	/* memory.stat */
>>> +	/* Read-mostly. */
>>>  	struct memcg_vmstats	*vmstats;
>>> +	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
>>> +	int			kmemcg_id;
>>> +
>>> +	/* Write-hot from here on; do not let it share with the above. */
>>> +	CACHELINE_PADDING(_pad_);
>>>  
>>>  	/* memory.events */
>>>  	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
>>> @@ -266,9 +271,6 @@ struct mem_cgroup {
>>>  #if BITS_PER_LONG < 64
>>>  	seqlock_t		socket_pressure_seqlock;
>>>  #endif
>>> -	int kmemcg_id;
>>> -
>>> -	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
>>>  
>>>  #ifdef CONFIG_CGROUP_WRITEBACK
>>>  	struct list_head cgwb_list;
>>
>>
>> I was currently testing this diff, not sure which one would be better.
> 
> I was just checking if false sharing of vmstats_percpu is the cause. If your
> patch does not increase the struct size, we can go with that as a backportable
> fix. I am planning to rearrange fields of struct mem_cgroup more drastically and
> have it more stable as future work as we continuously see these regressions keep
> popping up.
> 


Yes this makes sense. I did not expect such a big change in a benchmark
with my patch, although I feel like the microbenchmark is probably not
that realistic.

I think another issue is that its a 4 socket system.
I only have access to a single socket system, and I see a 4.38% regression.

Do you know if there a way for kernel test robot to test the below patch
on its host?


From b862e84e7bd6a54b1546b7f21a6cf991253def18 Mon Sep 17 00:00:00 2001
From: Usama Arif <usama.arif@linux.dev>
Date: Thu, 13 Aug 2026 11:42:05 -0700
Subject: [PATCH] mm/memcontrol: avoid false sharing between vmstats and events

Moving v1 userspace eventfd handling into memcontrol-v1.c shrank
struct vmpressure from 112 to 24 bytes when CONFIG_MEMCG_V1 is disabled.
This moved memory_events_local[MEMCG_SWAP_FAIL] and the hot
vmstats_percpu pointer onto the same cacheline.

The stress-ng mremap stressor exercises MADV_PAGEOUT with swap
disabled, generating about 20 million MEMCG_SWAP_FAIL updates per
60-second run on a 176-CPU test system.  Those writes bounce the line
while memcg statistics paths load vmstats_percpu.

Move cgwb_list into the existing alignment gap and cacheline-align
vmstats_percpu.  This separates the pointer from the event counters
without increasing the size of struct mem_cgroup in the tested
configuration.

The blamed commit reduced median mremap throughput by 4.38% on the
test system with one socket. The patched kernel brings the performance
to within 0.5% of the parent which is within the observed boot-to-boot
spread (up to 1.2%).

Fixes: ea928e9e18da ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c")
Reported-by: kernel test robot <yi1.lai@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202608131743.c6a7dda4-lkp@intel.com
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/memcontrol.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e78bc98ab229b..215e2e87f42b2 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -268,10 +268,15 @@ struct mem_cgroup {
 #endif
 	int kmemcg_id;
 
-	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
-
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct list_head cgwb_list;
+#endif
+
+	/* Keep the hot per-CPU stats pointer away from memory event counters. */
+	struct memcg_vmstats_percpu __percpu *vmstats_percpu
+		____cacheline_aligned_in_smp;
+
+#ifdef CONFIG_CGROUP_WRITEBACK
 	struct wb_domain cgwb_domain;
 	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
 #endif
-- 
2.53.0-Meta



>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index e78bc98ab229b..215e2e87f42b2 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -268,10 +268,15 @@ struct mem_cgroup {
>>  #endif
>>         int kmemcg_id;
>>
>> -       struct memcg_vmstats_percpu __percpu *vmstats_percpu;
>> -
>>  #ifdef CONFIG_CGROUP_WRITEBACK
>>         struct list_head cgwb_list;
>> +#endif
>> +
>> +       /* Keep the hot per-CPU stats pointer away from memory event counters. */
>> +       struct memcg_vmstats_percpu __percpu *vmstats_percpu
>> +               ____cacheline_aligned_in_smp;
>> +
>> +#ifdef CONFIG_CGROUP_WRITEBACK
>>         struct wb_domain cgwb_domain;
>>         struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
>>  #endif
>>

