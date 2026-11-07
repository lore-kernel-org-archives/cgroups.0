Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.158
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794048814;
	b=V0Xmk9s8D9atYFZogz1cZ7z+AslCvAc9/C5NQ9HL9HFBh1HlOimAFy7/uDRsIlos9AWW
	 tEuMH/jTaVrEOcFGGCGSraNhTCqeh2rQ3HNfSs75ZuX2VHj3GZb2Hy3Qnh/GqM5b+h/r5
	 p2T8fGUikzFXwmFEtbLenrkE+sSo+9r3rj8EQR6LOZo3NeBXIijTvVV/a9QRBir2deE9b
	 +g9aq/CSUHUkbbeqmYzlSRVqsXtC+eVCHLm5YMRisHnejOxkbjavXjpii7wRUKDl+GoRY
	 Uio2G2oR9M6dFZA5xxsPNABZ2XuNZVzl8YEiPbwDf4ROLe69MaZJqCq6FHShViNMFHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794048814;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=83piHwpYSzR6zROHuprEnSIuvOzBU+T0roPQgf/SBA8=;
	b=r0v1Q3hgO5wrdv6o2Gm6go6TFDvm1Ou/II82l24h28WmzdF46rYGvJL3f16ut96tmWFf
	 4sf5oP81iJwOBv9R/KL5c/i28/+5SNkVcH921HcCdJCzwT7l4vDxUvXSqUptiiaNyPNN4
	 9Cj3jFMeoTH7Pyir/rJv+vZlRtmpo+thmX5R2q7i7p42nZd5fpBgbnZc5oonP9yIOiCVs
	 Cgw0yKJfVf4ITLcHGCOkGt3mxU5TqQrFtfrofgzHWwpmhI4+4uL4cmEgSb2fU0WfWS+2H
	 8By6W/J7CASOXEPm0q1O+yZdmWBszftpfnmCukCjQiYEioOMXi5uZz3DEr6KtWXnl/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AqqjxcQs;
	arc=none smtp.remote-ip=91.218.175.158
Received: from mta0.migadu.com (out-158.mta0.migadu.com [91.218.175.158])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C4F606A32C
	for <cgroups@vger.kernel.org>; Sat,  7 Nov 2026 10:53:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02C4F606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AqqjxcQs
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jejRIbtJ8blFOjhH4ULa65m0uCrlH4/Znb48G0JTX1A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794048811; v=1; x=1794653611;
 b=AqqjxcQsHYMLk8v6RuuM8PQFzkPHJCHJfhDJP7/9JpEBTgd2w+N19XgbZts+MUO/Bkr0IZ+U
 THPwnblflIrgx9a/Fej3lrgU67Oy2DQxQ206xr3BH85Cb025wHyCI+8BYODPApyLGml5j7Kh0B7
 sZ1h8XUrqYmxXw0d3YNOP+fw=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c87cc596a113beb7;
	Sat, 07 Nov 2026 10:53:30 +0000
X-Mizu-Trace-ID: c87cc596a113beb7
X-Migadu-Flow: FLOW_OUT
Message-ID: <00c4ec9e-d772-4a2e-a336-aa7076328707@linux.dev>
Date: Sat, 7 Nov 2026 18:53:24 +0800
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
Subject: Re: [PATCH v2 3/4] cpuset: settle isolation state when CPUs are given
 back to parent
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: Chen Ridong <chenridong@huawei.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>, Guopeng Zhang <zhangguopeng@kylinos.cn>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261106105538.2915492-1-ridong.chen@linux.dev>
 <20261106105538.2915492-4-ridong.chen@linux.dev>
 <8efc80ab-3b65-4573-aac4-452bfdbb9a80@redhat.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <8efc80ab-3b65-4573-aac4-452bfdbb9a80@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/7/2026 10:28 AM, Waiman Long wrote:
> 
> On 11/6/26 5:55 AM, Ridong Chen wrote:
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
>> isolated_cpus_release() is no longer needed and is removed.
>>
>> Acked-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   kernel/cgroup/cpuset.c | 86 +++++++++++-------------------------------
>>   1 file changed, 23 insertions(+), 63 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 85e5b529d144..a5ab9396eb61 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1264,42 +1264,21 @@ static void isolated_cpus_update(int old_prs, int 
>> new_prs, struct cpumask *xcpus
>>   }
>>   /*
>> - * isolated_cpus_release - Remove the relevant CPUs in @xcpus from isolated_cpus
>> - * @cs: the current cpuset
>> - * @xcpus: the set of effective xcpus to be considered for removal
>> - *
>> - * This function is called when an isolated partition is invalidated or when
>> - * some of its effective xcpus are to be removed from isolated_cpus due to
>> - * changes in parent cpuset. The given @xcpus must be modifiable as the function
>> - * will update its value to determine the right set of CPUs to be removed.
>> + * isolated_cpus_set_state - Set the isolation state of @xcpus
>> + * @prs: partition root state that @xcpus will belong to
>> + * @xcpus: exclusive CPUs whose isolation state may change
>>    */
>> -static void isolated_cpus_release(struct cpuset *cs, struct cpumask *xcpus)
>> +static void isolated_cpus_set_state(int prs, struct cpumask *xcpus)
>>   {
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
>> +    bool updated = false;
>> +    int cpu;
>> -    spin_lock_irq(&callback_lock);
>> -    isolated_cpus_update(PRS_ISOLATED, PRS_ROOT, xcpus);
>> -    spin_unlock_irq(&callback_lock);
>> +    lockdep_assert_held(&callback_lock);
>> +    lockdep_assert_held(&cpuset_mutex);
>> +    for_each_cpu(cpu, xcpus)
>> +        updated |= isolated_cpu_update(prs, cpu);
>> +    if (updated)
>> +        update_housekeeping = true;
>>   }
> 
> isolated_cpus_set_state() is almost the same as isolated_cpus_update(). 
> isolated_cpus_update() just assumes that parent and child prs state should be 
> different. You are right that we should proceed no matter if the parent and 
> child has the same state or not. So you should consider merging these two 
> functions as well.
> 

Hi Longman,

Thanks for the review. You're right, these two functions should be merged.

I didn't touch partition_xcpus_add() because the rework never hit a
problem there, so I added isolated_cpus_set_state() instead of changing
isolated_cpus_update(). However, that's not the right approach;

In the next version, I'll drop the @old_prs argument and the
WARN_ON_ONCE() from isolated_cpus_update(), use it everywhere, and
remove isolated_cpus_set_state(). The state check in
partition_xcpus_add() will go away too, since updating CPUs that are
already in the right state is a no-op.

> 
>>   /*
>> @@ -1355,9 +1334,8 @@ static void partition_xcpus_del(int old_prs, struct 
>> cpuset *parent,
>>       if (parent == &top_cpuset)
>>           cpumask_andnot(subpartitions_cpus, subpartitions_cpus, xcpus);
>> -    if (old_prs != parent->partition_root_state)
>> -        isolated_cpus_update(old_prs, parent->partition_root_state,
>> -                     xcpus);
>> +    /* CPUs given back, including those of descendants, take parent's state */
>> +    isolated_cpus_set_state(parent->partition_root_state, xcpus);
>>       cpumask_or(parent->effective_cpus, parent->effective_cpus, xcpus);
>>       cpumask_and(parent->effective_cpus, parent->effective_cpus, 
>> cpu_active_mask);
>> @@ -1612,6 +1590,7 @@ static void compute_partition_effective_cpumask(struct 
>> cpuset *cs,
>>       struct cgroup_subsys_state *css;
>>       struct cpuset *child;
>>       bool populated = partition_is_populated(cs, NULL);
>> +    static cpumask_t xcpus;        /* Protected by cpuset_mutex */
>>       /*
>>        * Check child partition roots to see if they should be invalidated
>> @@ -1640,14 +1619,15 @@ static void compute_partition_effective_cpumask(struct 
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
>> +            isolated_cpus_set_state(parent_prs, &xcpus);
>>               child->partition_root_state = -old_prs;
>>               spin_unlock_irq(&callback_lock);
>>               notify_partition_change(child, old_prs);
>> @@ -2080,22 +2060,8 @@ static int update_parent_effective_cpumask(struct 
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
>> @@ -2341,18 +2307,12 @@ static void update_cpumasks_hier(struct cpuset *cs, 
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
> 

-- 
Best regards
Ridong

