Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794280503;
	b=k77fYbKVdv4CJb9qrQChh1DpbQb7gHuAxJnXJXJj0XNSPRddYr4RPM2gRn7Y1GngU3Yz
	 32vzouZ0MkI1H/s+OnZ09h2LHYVtRDf8rf9vNljCro1lSl9uGWejJNxud3qjvlm14/nI2
	 bRXCUbLWhZKb4unKZ6TecJCV2TNkuXTKaGGBk6PedrireAReYLZKlNW9ZXCH1VOlvy50z
	 8EKH+bQKhXjt7BFHeqnu+LXeKmNV/9eD/n7PSxYrXQhRAVzJs4Hg8GB7ODa4obhdljiJa
	 BPNbgfstyc5DmZURTYxHnWHuTR+csiyEVEbq4/Pe/tvR7+Uo04Mwo1jLqvfXqNJtcrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794280503;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=Yc92nR+ZtJSpwPuVQqN1gY6tzDX+6fRy+1ap3ZVgDXs=;
	b=fbq+gLI6lx89Y+JxeSU0Xy58lTcjEJOt7133O2+Rfngjn3joHyxjuU2lC+KoFQRLQK3l
	 qw6XRR7aZmh1mQbSK+Boq0gVJBMcTH90aOqlKWREjMkr6IfmH3YVRaB3DkqqN7JUGhKYQ
	 wQkW5ayRd/WUzWBUPzGqsgDrOoI/EV64JI9w4gCkYeNqMAkGPD0P2t4HvTZ93k6LNiQie
	 FeY9w3AHxxpfxkCh1oNGXoLg0/ZmZ/2CNxlPJ1aGZTRj7WX9I0DG2G2fX4mmFo3SkmxXX
	 j+jj9xISPCXkJrtzTBFGuT11TM7nXfOwZQisgF1r83Ka50Pl7Q8KhuyTG5p8T9p1QAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GM+FmXY5;
	arc=none smtp.remote-ip=95.215.58.25
Received: from mta1.migadu.com (out-25.mta1.migadu.com [95.215.58.25])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157B0606E639
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 03:15:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 157B0606E639
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GM+FmXY5
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=CGy1YhWkj+TZqSZNz9Xif6iMkjyIARS5VzADbWjKyPc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794280500; v=1; x=1794885300;
 b=GM+FmXY5Yg8VPlm6bK6mGT9vVSuUhQCINf6GzcGpRFgY00lOKkcoZ8oTFMVnTDlVaVSM1seP
 VX7nijgQadBbYGW16aSM161nNUtGM9BU81E/PPp5IIRawvzSRUqd0u5lfdugXXtYS4xXDAup/CA
 GYc86XMFhG5faeVDgFxGCRh4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7ee5ed155d89689d;
	Tue, 10 Nov 2026 03:15:00 +0000
X-Mizu-Trace-ID: 7ee5ed155d89689d
X-Migadu-Flow: FLOW_OUT
Message-ID: <fe49691f-54d9-410e-9110-bf2522ab17e8@linux.dev>
Date: Tue, 10 Nov 2026 11:14:53 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] cpuset: settle isolation state when CPUs are given
 back to parent
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: Chen Ridong <chenridong@huawei.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>, Guopeng Zhang <zhangguopeng@kylinos.cn>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261107120100.3587595-1-ridong.chen@linux.dev>
 <20261107120100.3587595-4-ridong.chen@linux.dev>
 <09c033dd-41dc-4503-9def-4e662e946dc4@redhat.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <09c033dd-41dc-4503-9def-4e662e946dc4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/9/2026 10:51 PM, Waiman Long wrote:
> On 11/7/26 7:00 AM, Ridong Chen wrote:
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> partition_xcpus_del() only updates isolated_cpus when the partition that
>> gives back the CPUs has a different state than its parent. CPUs that were
>> further distributed to descendant isolated partitions are not taken into
>> account, so isolated_cpus_release() has to be called afterwards in
>> several places to walk up the ancestors and fix isolated_cpus.
>>
>> Make partition_xcpus_del() always set the isolation state of the given
>> back CPUs to the state of the parent that receives them. As the
>> effective_xcpus of a partition covers the CPUs distributed to its
>> descendants, the isolation state of those CPUs is settled at the same
>> time. Boot-time isolated CPUs are still preserved by isolated_cpu_update().
>>
>> compute_partition_effective_cpumask() invalidates a child partition
>> without going through partition_xcpus_del(), so do the same there: the
>> CPUs of the invalidated child take the isolation state of its parent.
>>
>> As the parent may be shrunk and its effective_xcpus not updated yet,
>> only do so for the CPUs the parent still owns. This is to keep the
>> isolation state correct for now, the in-place invalidation here will be
>> removed later in the partition rework.
>>
>> isolated_cpus_update() assumes the old and new states are different,
>> which no longer holds now that partition_xcpus_del() proceeds regardless
>> of the states. Drop its @old_prs argument and the WARN_ON_ONCE() so that
>> it simply sets the isolation state of the given CPUs, and use it
>> everywhere. The state check in partition_xcpus_add() is dropped as well,
>> as setting the state is a no-op when the states are the same.
>>
>> isolated_cpus_release() is no longer needed and is removed.
>>
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   kernel/cgroup/cpuset.c | 98 ++++++++----------------------------------
>>   1 file changed, 19 insertions(+), 79 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 85e5b529d144..fc9de6e16ff5 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1244,17 +1244,17 @@ static bool isolated_cpu_update(int new_prs, int cpu)
>>   }
>>   /*
>> - * isolated_cpus_update - Update the isolated_cpus mask
>> - * @old_prs: old partition_root_state
>> - * @new_prs: new partition_root_state
>> - * @xcpus: exclusive CPUs with state change
>> + * isolated_cpus_update - Set the isolation state of @xcpus
>> + * @new_prs: partition root state that @xcpus will belong to
>> + * @xcpus: exclusive CPUs whose isolation state may change
>> + *
>> + * CPUs isolated at boot time are kept isolated.
>>    */
>> -static void isolated_cpus_update(int old_prs, int new_prs, struct cpumask 
>> *xcpus)
>> +static void isolated_cpus_update(int new_prs, struct cpumask *xcpus)
>>   {
>>       bool updated = false;
>>       int cpu;
>> -    WARN_ON_ONCE(old_prs == new_prs);
>>       lockdep_assert_held(&callback_lock);
>>       lockdep_assert_held(&cpuset_mutex);
>>       for_each_cpu(cpu, xcpus)
>> @@ -1263,45 +1263,6 @@ static void isolated_cpus_update(int old_prs, int 
>> new_prs, struct cpumask *xcpus
>>           update_housekeeping = true;
>>   }
>> -/*
>> - * isolated_cpus_release - Remove the relevant CPUs in @xcpus from isolated_cpus
>> - * @cs: the current cpuset
>> - * @xcpus: the set of effective xcpus to be considered for removal
>> - *
>> - * This function is called when an isolated partition is invalidated or when
>> - * some of its effective xcpus are to be removed from isolated_cpus due to
>> - * changes in parent cpuset. The given @xcpus must be modifiable as the function
>> - * will update its value to determine the right set of CPUs to be removed.
>> - */
>> -static void isolated_cpus_release(struct cpuset *cs, struct cpumask *xcpus)
>> -{
>> -    struct cpuset *ancestor = parent_cs(cs);
>> -    struct cpuset *iancestor = NULL;
>> -
>> -    /*
>> -     * Search the furthest isolated partition root ancestor available
>> -     * until top_cpuset or a remote partition root is hit.
>> -     */
>> -    for (; ancestor; ancestor = parent_cs(ancestor)) {
>> -        if (ancestor->partition_root_state == PRS_ISOLATED)
>> -            iancestor = ancestor;
>> -        if (is_remote_partition(ancestor))
>> -            break;
>> -    }
>> -
>> -    /*
>> -     * If a furthest isolated partition acnestor is found, use it to
>> -     * determine which of the CPUs in @xcpus should be removed from
>> -     * isolated_cpus. Otherwise, all of them will be removed.
>> -     */
>> -    if (iancestor && !cpumask_andnot(xcpus, xcpus, iancestor->effective_xcpus))
>> -        return; /* No CPU should be removed from isolated_cpus */
>> -
>> -    spin_lock_irq(&callback_lock);
>> -    isolated_cpus_update(PRS_ISOLATED, PRS_ROOT, xcpus);
>> -    spin_unlock_irq(&callback_lock);
>> -}
>> -
>>   /*
>>    * partition_xcpus_add - Add new exclusive CPUs to partition
>>    * @new_prs: new partition_root_state
>> @@ -1325,9 +1286,7 @@ static void partition_xcpus_add(int new_prs, struct 
>> cpuset *parent,
>>       if (parent == &top_cpuset)
>>           cpumask_or(subpartitions_cpus, subpartitions_cpus, xcpus);
>> -    if (new_prs != parent->partition_root_state)
>> -        isolated_cpus_update(parent->partition_root_state, new_prs,
>> -                     xcpus);
>> +    isolated_cpus_update(new_prs, xcpus);
>>       cpumask_andnot(parent->effective_cpus, parent->effective_cpus, xcpus);
>>   }
>> @@ -1355,9 +1314,8 @@ static void partition_xcpus_del(int old_prs, struct 
>> cpuset *parent,
>>       if (parent == &top_cpuset)
>>           cpumask_andnot(subpartitions_cpus, subpartitions_cpus, xcpus);
>> -    if (old_prs != parent->partition_root_state)
>> -        isolated_cpus_update(old_prs, parent->partition_root_state,
>> -                     xcpus);
>> +    /* CPUs given back, including those of descendants, take parent's state */
>> +    isolated_cpus_update(parent->partition_root_state, xcpus);
>>       cpumask_or(parent->effective_cpus, parent->effective_cpus, xcpus);
>>       cpumask_and(parent->effective_cpus, parent->effective_cpus, 
>> cpu_active_mask);
>> @@ -1612,6 +1570,7 @@ static void compute_partition_effective_cpumask(struct 
>> cpuset *cs,
>>       struct cgroup_subsys_state *css;
>>       struct cpuset *child;
>>       bool populated = partition_is_populated(cs, NULL);
>> +    static cpumask_t xcpus;        /* Protected by cpuset_mutex */
>>       /*
>>        * Check child partition roots to see if they should be invalidated
>> @@ -1640,14 +1599,15 @@ static void compute_partition_effective_cpumask(struct 
>> cpuset *cs,
>>               int parent_prs = cs->partition_root_state;
>>               /*
>> -             * Invalidate child partition and update isolated_cpus
>> -             * if necessary.
>> +             * Invalidate child partition. Its CPUs still owned by
>> +             * cs take the isolation state of cs. effective_xcpus
>> +             * of cs may not be updated yet, so recompute it.
>>                */
>>               spin_lock_irq(&callback_lock);
>>               WRITE_ONCE(child->prs_err, PERR_NOCPUS);
>> -            if ((old_prs == PRS_ISOLATED) && (parent_prs == PRS_ROOT))
>> -                isolated_cpus_update(PRS_ISOLATED, PRS_ROOT,
>> -                             child->effective_xcpus);
>> +            compute_excpus(cs, &xcpus);
>> +            cpumask_and(&xcpus, &xcpus, child->effective_xcpus);
>> +            isolated_cpus_update(parent_prs, &xcpus);
>>               child->partition_root_state = -old_prs;
>>               spin_unlock_irq(&callback_lock);
>>               notify_partition_change(child, old_prs);
>> @@ -2080,22 +2040,8 @@ static int update_parent_effective_cpumask(struct 
>> cpuset *cs, int cmd,
>>            *
>>            * A partition error happens when parent has tasks and all
>>            * its effective CPUs will have to be distributed out.
>> -         *
>> -         * For an isolated partition with a shrunk root partition parent
>> -         * we may need to return some or all of its isolated CPUs.
>>            */
>>           nocpu |= cpumask_empty(tmp->delmask);
>> -        if ((parent_prs == PRS_ROOT) && (old_prs == PRS_ISOLATED)) {
>> -            cpumask_clear(tmp->addmask);
>> -            if (nocpu)
>> -                cpumask_copy(tmp->addmask, cs->effective_xcpus);
>> -            else if (!cpumask_subset(cs->effective_xcpus, parent- 
>> >effective_xcpus))
>> -                cpumask_andnot(tmp->addmask, cs->effective_xcpus,
>> -                                 parent->effective_xcpus);
>> -            if (!cpumask_empty(tmp->addmask))
>> -                isolated_cpus_release(cs, tmp->addmask);
>> -            /* Expansion of parent's effective_xcpus is handled below */
>> -        }
>>           if (nocpu) {
>>               part_error = PERR_NOCPUS;
>>               if (is_partition_valid(cs))
>> @@ -2341,18 +2287,12 @@ static void update_cpumasks_hier(struct cpuset *cs, 
>> struct tmpmasks *tmp,
>>                   /*
>>                    * When parent is not a valid partition root,
>>                    * child partition roots become invalid too.
>> -                 *
>> -                 * For a to be invalidated isolated partition,
>> -                 * call return_isolated_cpus() to remove the
>> -                 * relevant CPUs from isolated_cpus.
>> +                 * The isolation state of their CPUs has been
>> +                 * settled when the parent gave them back.
>>                    */
>>                   if (is_partition_valid(cp))
>>                       new_prs = -old_prs;
>> -                if (old_prs == PRS_ISOLATED) {
>> -                    cpumask_copy(tmp->delmask, cp->effective_xcpus);
>> -                    isolated_cpus_release(cp, tmp->delmask);
>> -                }
>>                   WRITE_ONCE(cp->prs_err,
>>                          is_partition_invalid(parent)
>>                          ? PERR_INVPARENT : PERR_NOTPART);
>> @@ -3108,7 +3048,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>>       if (!is_partition_valid(cs))
>>           reset_partition_data(cs);
>>       else if (isolcpus_updated)
>> -        isolated_cpus_update(old_prs, new_prs, cs->effective_xcpus);
>> +        isolated_cpus_update(new_prs, cs->effective_xcpus);
>>       spin_unlock_irq(&callback_lock);
>>       /* Force update if partition is disabled & update effective_xcpus */
> 
> The code change looks good to me. However this is not just a code restructuring, 
> it also includes a bug fix. I wonder if we should clarify that and maybe add a 
> Fixes tag.
> 
Hi Longman,

Thanks for the review. You are right, it also fixes the isolated CPU
leak reported by Guopeng [1]. When a root partition with an isolated
child partition is invalidated, partition_xcpus_del() gives the CPUs
back to the parent without updating isolated_cpus as both are root
partitions, so the CPUs of the isolated child are left in
isolated_cpus.

I'd like to describe it in the commit message and add the following
tags in the next version:

Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
Reported-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Closes: https://lore.kernel.org/all/20261105130344.664336-4-guopeng.zhang@linux.dev/

Does that look OK to you?

[1] https://lore.kernel.org/all/20261105130344.664336-4-guopeng.zhang@linux.dev/

-- 
Best regards
Ridong

