Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2873F39CD
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 06:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786431309; cv=none; b=SWH2aezmnsOwEIDGEPb6QAAAz7C4PHyXSnOk/6dpTy7aFdyzb0BVUqXEdY9gYhREBzyPUisIKR+I6ussLCkZglfS0iBCz0GlMAcGZGVsAGoIcDTLcnPKu1QN1XIDAN+accdX3lQ/AS1Nlh1y7rJQWgdIE6vgw39iOPYdZIBFfRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786431309; c=relaxed/simple;
	bh=fBJdYOM8b5cNVs4nQavtlaUXXvDarmlY4HCkJLsBuAw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W3rVhqRcs8jLeUXI2Kg0wY15pvcL1aQoBGArt8IwFMD6NelblqddhQCgdVauj5/mfX6p4V0c0E3shltK8qQv7sEfcAYIjHhUD1xcf+5vNSyYfALL9Vz583KFU4MANvRf/93ZGG03aD6gkvP+HZXRhZacM+bByZ8JFt8vY03pHag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N4jGYd1o; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N4jGYd1o"
Message-ID: <e2bdbc1f-9a51-4195-b4d2-c4f2eb3d74ae@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786431303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R4wj55OycU0seMEzLO2toBDaqflH+H9Az1nuYCB0ous=;
	b=N4jGYd1o2u9hnOdBzALEG1MEhzGMXdlNbAmCkoNn3hXrVpxfd5ar6l2axXKsyktHClIatn
	gqOK5dYv/NVMxVkUgugu96P6iOqr/Z+o+lxx5AGAQM9BOssOvqmUVZMJZdJbeJcs63p5Oq
	HUxvODTEhhksHnfdqJ4bKD11htBGHgw=
Date: Tue, 11 Aug 2026 14:54:34 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] cgroup/cpuset: Remove obsolete PFA_SPREAD_SLAB task flag
To: Waiman Long <longman@redhat.com>, ridong.chen@linux.dev,
 cgroups@vger.kernel.org
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
 peterz@infradead.org, corbet@lwn.net, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260810100234.78144-1-guopeng.zhang@linux.dev>
 <093753d0-70b8-4442-a12a-155eaeff9ebb@redhat.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <093753d0-70b8-4442-a12a-155eaeff9ebb@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2026/8/10 23:46, Waiman Long 写道:
> On 8/10/26 6:02 AM, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> Commit 16a1d968358a ("mm/slab: remove mm/slab.c and slab_def.h")
>> removed the SLAB allocator, the only allocator that implemented cpuset
>> slab spreading. Commit 61a182ab61a6 ("cgroup/cpuset: Remove
>> cpuset_do_slab_mem_spread()") then removed the last task_spread_slab()
>> caller. Commit 3ab67a9ce82f ("cgroup/cpuset: Mark memory_spread_slab as
>> obsolete") marked the legacy control obsolete.
>>
>> cpuset still updates PFA_SPREAD_SLAB when tasks attach to a legacy
>> cpuset and walks all tasks in a cpuset when memory_spread_slab changes.
>> Remove the unused task flag and its helpers, and make spread task
>> updates depend only on memory_spread_page.
>>
>> Keep the memory_spread_slab control and CS_SPREAD_SLAB state so legacy
>> users retain the existing write, readback and inheritance behavior.
>> Update the comments and documentation to describe only page-cache
>> spreading as functional.
>>
>> Assisted-by: LLM
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
>>   .../admin-guide/cgroup-v1/cpusets.rst         | 39 +++++++------------
>>   include/linux/sched.h                         |  5 ---
>>   kernel/cgroup/cpuset-v1.c                     | 13 ++-----
>>   kernel/cgroup/cpuset.c                        | 23 ++++-------
>>   4 files changed, 26 insertions(+), 54 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/cgroup-v1/cpusets.rst b/Documentation/admin-guide/cgroup-v1/cpusets.rst
>> index 52a213aff04e..434612780074 100644
>> --- a/Documentation/admin-guide/cgroup-v1/cpusets.rst
>> +++ b/Documentation/admin-guide/cgroup-v1/cpusets.rst
>> @@ -179,7 +179,7 @@ files describing that cpuset:
>>    - cpuset.mem_hardwall flag:  is memory allocation hardwalled
>>    - cpuset.memory_pressure: measure of how much paging pressure in cpuset
>>    - cpuset.memory_spread_page flag: if set, spread page cache evenly on allowed nodes
>> - - cpuset.memory_spread_slab flag: OBSOLETE. Doesn't have any function.
>> + - cpuset.memory_spread_slab flag: OBSOLETE. Has no effect on allocation behavior.
>>    - cpuset.sched_load_balance flag: if set, load balance within CPUs on that cpuset
>>    - cpuset.sched_relax_domain_level: the searching range when migrating tasks
>>   @@ -318,26 +318,20 @@ times 1000.
>>     1.6 What is memory spread ?
>>   ---------------------------
>> -There are two boolean flag files per cpuset that control where the
>> -kernel allocates pages for the file system buffers and related in
>> -kernel data structures.  They are called 'cpuset.memory_spread_page' and
>> -'cpuset.memory_spread_slab'.
>> +The 'cpuset.memory_spread_page' boolean flag file controls where the kernel
>> +allocates page-cache pages.
>> +The 'cpuset.memory_spread_slab' file is obsolete and has no effect on
>> +allocation behavior, but is retained for compatibility.
>>     If the per-cpuset boolean flag file 'cpuset.memory_spread_page' is set, then
>>   the kernel will spread the file system buffers (page cache) evenly
>>   over all the nodes that the faulting task is allowed to use, instead
>>   of preferring to put those pages on the node where the task is running.
>>   -If the per-cpuset boolean flag file 'cpuset.memory_spread_slab' is set,
>> -then the kernel will spread some file system related slab caches,
>> -such as for inodes and dentries evenly over all the nodes that the
>> -faulting task is allowed to use, instead of preferring to put those
>> -pages on the node where the task is running.
>> -
>> -The setting of these flags does not affect anonymous data segment or
>> +The setting of this flag does not affect anonymous data segment or
>>   stack segment pages of a task.
>>   -By default, both kinds of memory spreading are off, and memory
>> +By default, page cache memory spreading is off, and memory
>>   pages are allocated on the node local to where the task is running,
>>   except perhaps as modified by the task's NUMA mempolicy or cpuset
>>   configuration, so long as sufficient free memory pages are available.
>> @@ -345,18 +339,17 @@ configuration, so long as sufficient free memory pages are available.
>>   When new cpusets are created, they inherit the memory spread settings
>>   of their parent.
>>   -Setting memory spreading causes allocations for the affected page
>> -or slab caches to ignore the task's NUMA mempolicy and be spread
>> -instead.    Tasks using mbind() or set_mempolicy() calls to set NUMA
>> -mempolicies will not notice any change in these calls as a result of
>> -their containing task's memory spread settings.  If memory spreading
>> +Setting page cache memory spreading causes affected allocations to ignore the
>> +task's NUMA mempolicy and be spread instead. Tasks using mbind() or
>> +set_mempolicy() to set NUMA mempolicies will not notice any change as a
>> +result of their containing task's memory spread settings.  If memory spreading
>>   is turned off, then the currently specified NUMA mempolicy once again
>>   applies to memory page allocations.
>>     Both 'cpuset.memory_spread_page' and 'cpuset.memory_spread_slab' are boolean flag
>> -files.  By default they contain "0", meaning that the feature is off
>> -for that cpuset.  If a "1" is written to that file, then that turns
>> -the named feature on.
>> +files whose values are inherited by newly created cpusets. The value of
>> +'cpuset.memory_spread_slab' is retained and can be read back, but it does not
>> +affect allocation behavior.
> I think you should keep the statement about the default value of the flag files.

Good point, thanks for pointing this out. I will restore the default-value 
description and clarify the write semantics.

>>     The implementation is simple.
>>   @@ -367,10 +360,6 @@ is modified to perform an inline check for this PFA_SPREAD_PAGE task
>>   flag, and if set, a call to a new routine cpuset_mem_spread_node()
>>   returns the node to prefer for the allocation.
>>   -Similarly, setting 'cpuset.memory_spread_slab' turns on the flag
>> -PFA_SPREAD_SLAB, and appropriately marked slab caches will allocate
>> -pages from the node returned by cpuset_mem_spread_node().
>> -
>>   The cpuset_mem_spread_node() routine is also simple.  It uses the
>>   value of a per-task rotor cpuset_mem_spread_rotor to select the next
>>   node in the current task's mems_allowed to prefer for the allocation.
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 499943987c1a..8b3d47a325cc 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1869,7 +1869,6 @@ static __always_inline bool is_user_task(struct task_struct *task)
>>   /* Per-process atomic flags. */
>>   #define PFA_NO_NEW_PRIVS        0    /* May not gain new privileges. */
>>   #define PFA_SPREAD_PAGE            1    /* Spread page cache over cpuset */
>> -#define PFA_SPREAD_SLAB            2    /* Spread some slab caches over cpuset */
>>   #define PFA_SPEC_SSB_DISABLE        3    /* Speculative Store Bypass disabled */
>>   #define PFA_SPEC_SSB_FORCE_DISABLE    4    /* Speculative Store Bypass force disabled*/
>>   #define PFA_SPEC_IB_DISABLE        5    /* Indirect branch speculation restricted */
>> @@ -1895,10 +1894,6 @@ TASK_PFA_TEST(SPREAD_PAGE, spread_page)
>>   TASK_PFA_SET(SPREAD_PAGE, spread_page)
>>   TASK_PFA_CLEAR(SPREAD_PAGE, spread_page)
>>   -TASK_PFA_TEST(SPREAD_SLAB, spread_slab)
>> -TASK_PFA_SET(SPREAD_SLAB, spread_slab)
>> -TASK_PFA_CLEAR(SPREAD_SLAB, spread_slab)
>> -
>>   TASK_PFA_TEST(SPEC_SSB_DISABLE, spec_ssb_disable)
>>   TASK_PFA_SET(SPEC_SSB_DISABLE, spec_ssb_disable)
>>   TASK_PFA_CLEAR(SPEC_SSB_DISABLE, spec_ssb_disable)
>> diff --git a/kernel/cgroup/cpuset-v1.c b/kernel/cgroup/cpuset-v1.c
>> index 3e9968dd91e9..562ad35f00d0 100644
>> --- a/kernel/cgroup/cpuset-v1.c
>> +++ b/kernel/cgroup/cpuset-v1.c
>> @@ -204,7 +204,7 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
>>   }
>>     /*
>> - * update task's spread flag if cpuset's page/slab spread flag is set
>> + * Update a task's spread flag if the cpuset's page spread flag is set.
>>    *
>>    * Call with callback_lock or cpuset_mutex held. The check can be skipped
>>    * if on default hierarchy.
>> @@ -219,18 +219,13 @@ void cpuset1_update_task_spread_flags(struct cpuset *cs,
>>           task_set_spread_page(tsk);
>>       else
>>           task_clear_spread_page(tsk);
>> -
>> -    if (is_spread_slab(cs))
>> -        task_set_spread_slab(tsk);
>> -    else
>> -        task_clear_spread_slab(tsk);
>>   }
>>     /**
>> - * cpuset1_update_tasks_flags - update the spread flags of tasks in the cpuset.
>> - * @cs: the cpuset in which each task's spread flags needs to be changed
>> + * cpuset1_update_tasks_flags - update the page spread flag of cpuset tasks
>> + * @cs: the cpuset whose tasks need their page spread flag updated
>>    *
>> - * Iterate through each task of @cs updating its spread flags.  As this
>> + * Iterate through each task of @cs updating its page spread flag.  As this
>>    * function is called with cpuset_mutex held, cpuset membership stays
>>    * stable.
>>    */
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 0a0fffb5673c..9761a5dd006f 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -2862,7 +2862,7 @@ int cpuset_update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
>>   {
>>       struct cpuset *trialcs;
>>       int balance_flag_changed;
>> -    int spread_flag_changed;
>> +    int spread_page_changed;
>>       int err;
>>         trialcs = dup_or_alloc_cpuset(cs);
>> @@ -2881,8 +2881,7 @@ int cpuset_update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
>>       balance_flag_changed = (is_sched_load_balance(cs) !=
>>                   is_sched_load_balance(trialcs));
>>   -    spread_flag_changed = ((is_spread_slab(cs) != is_spread_slab(trialcs))
>> -            || (is_spread_page(cs) != is_spread_page(trialcs)));
>> +    spread_page_changed = is_spread_page(cs) != is_spread_page(trialcs);
>>         spin_lock_irq(&callback_lock);
>>       cs->flags = trialcs->flags;
>> @@ -2895,7 +2894,7 @@ int cpuset_update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
>>               rebuild_sched_domains_locked();
>>       }
>>   -    if (spread_flag_changed)
>> +    if (spread_page_changed)
>>           cpuset1_update_tasks_flags(cs);
>>   out:
>>       free_cpuset(trialcs);
>> @@ -4484,14 +4483,10 @@ void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask)
>>    * cpuset_spread_node() - On which node to begin search for a page
>>    * @rotor: round robin rotor
>>    *
>> - * If a task is marked PF_SPREAD_PAGE or PF_SPREAD_SLAB (as for
>> - * tasks in a cpuset with is_spread_page or is_spread_slab set),
>> - * and if the memory allocation used cpuset_mem_spread_node()
>> - * to determine on which node to start looking, as it will for
>> - * certain page cache or slab cache pages such as used for file
>> - * system buffers and inode caches, then instead of starting on the
>> - * local node to look for a free page, rather spread the starting
>> - * node around the tasks mems_allowed nodes.
>> + * If a task is marked PFA_SPREAD_PAGE and a page cache allocation uses
>> + * cpuset_mem_spread_node() to determine where to start looking, spread the
>> + * starting node around the task's mems_allowed nodes instead of starting on
>> + * the local node.
>>    *
>>    * We don't have to worry about the returned node being offline
>>    * because "it can't happen", and even if it did, it would be ok.
>> @@ -4502,9 +4497,7 @@ void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask)
>>    * offline node.  But if it did, that would be ok, as this routine
>>    * is not returning the node where the allocation must be, only
>>    * the node where the search should start.  The zonelist used by
>> - * the allocator will include all nodes.  If the slab allocator
>> - * is passed an offline node, it will fall back to the local node.
>> - * See kmem_cache_alloc_node().
>> + * the allocator will include all nodes.
> 
> The slab allocator here is the general term that can refer to slub. Is the statement about passing an offline node no longer true?
> 

You are right. Although no slab allocation path currently uses
cpuset_spread_node(), this general fallback statement still applies to
SLUB when __GFP_THISNODE is not set. I will retain it in the next
version. Thanks for pointing this out.

Thanks,
Guopeng

> Cheers,
> Longman
> 
>>    */
>>   static int cpuset_spread_node(int *rotor)
>>   {
> 

