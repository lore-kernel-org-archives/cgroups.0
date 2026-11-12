Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.217
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794476605;
	b=HzIiRCNmQeUs+g6owSlZWuaIefhuyaMjOUKDACUKh95ZL+gAHpplhImuEAa6GljpBiEd
	 UGLOsQV4MJdG+GBSG1tAmtPGLJRFdJUZjkVvht7uAj5xlyyj+Ir0lkD+WMvfpdACKYHAr
	 kyp0tR74he6G28QOZCV7tqNBAJuQMlcV1u28kxtytwvOdYvKCg3XKkbJa4hz8Z6IkhQq1
	 it3tKHKjY3gTUr65k3YNMoI9u/mR5Tl3/i42RTvnxqFz5J5mhHn1NV06HI0etk88PfnHD
	 Ag0mzMl8nElN9MSotEx2UObTndLwswcMbCf00H1pmRu/A/kd3I2v31rJMwwQyulgYjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794476605;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=rKdnxS57GFUNzWHbYzk3wFQLMm5VzC6vH9U5Eq0QCX8=;
	b=Aj46U16j8aWTQ5prP07ujeX+xc0PabM7hIepHH7WqPSwaRHju1dWRNPpVjUbUWBvtpwJ
	 C0edQK1hlKWK2N/rSdQE54J4RSB294QbO1JS5K/Xo88fFvRWeo6IjCVbfwStVJZnu+kHc
	 46VrZNdUmFPEkxFf6iBrQk1yB8g1liCD85tr7ZNCiZmV9ij00dBMFPvTY+FSI5nlPgrbO
	 fuQRS1pHFAEZgI6V+Hkp7KXb+itFRvfc9MwDWXxvh8qRSodQ3ZQccelDgEXzXJ5R/+O/7
	 hy1U7xCzWAc8f1AphEUdWl4fGRpr7N/Ge90HvGruMF2pty4zDOflXmZTU+HVZlH4ZGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=E6uUH2wg;
	arc=none smtp.remote-ip=95.215.58.217
Received: from mta1.migadu.com (out-217.mta1.migadu.com [95.215.58.217])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14447606A327
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 09:43:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14447606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=E6uUH2wg
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=4eIDGo3k+kc5buVBqIe8K9KZqyIb/OYjgJvJowIrDa0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794476602; v=1; x=1795081402;
 b=E6uUH2wgh65Zqb9Nu42SO6efv/uPlAzfhoaOOgdOikI/UMz+WOf2gKPGLD5GnA5vuFRPM+Qd
 RTUuqGyPStI+xI9jcj9noDcmbVNnZOY3mTPagkboNXx10L3Tg73El/QzoENXJvTMGuk1/BYxyVK
 kVCcYxz2u1HToVLRKFC3CbU8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 948a1701d48ce8a5;
	Thu, 12 Nov 2026 09:43:22 +0000
X-Mizu-Trace-ID: 948a1701d48ce8a5
X-Migadu-Flow: FLOW_OUT
Message-ID: <be68fe2a-b0e8-470c-be47-26780a254d53@linux.dev>
Date: Thu, 12 Nov 2026 17:43:11 +0800
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
Subject: Re: [PATCH v4 1/2] cgroup/cpuset: Keep an active housekeeping CPU in
 the top sched domain
To: Ridong Chen <ridong.chen@linux.dev>, longman@redhat.com
Cc: cgroups@vger.kernel.org, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, shuah@kernel.org, mathieu.desnoyers@efficios.com,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>, Ridong Chen <chenridong@xiaomi.com>
References: <20261111134250.16852-1-guopeng.zhang@linux.dev>
 <20261111134250.16852-2-guopeng.zhang@linux.dev>
 <8b256809-79b1-4438-ae3e-4cceb32cd7c2@linux.dev>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <8b256809-79b1-4438-ae3e-4cceb32cd7c2@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/11/12 11:05, Ridong Chen 写道:
> 
> 
> On 11/11/2026 9:42 PM, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> Boot-isolated CPUs remain in top_cpuset.effective_cpus, but are excluded
>> from its scheduling domain. A partition can therefore take all boot
>> domain housekeeping CPUs while leaving effective_cpus nonempty. For
>> example, on a 32-CPU system with all CPUs online and
>> isolcpus=domain,10-31:
>>
>>    echo 0-9 > A/cpuset.cpus
>>    echo root > A/cpuset.cpus.partition
>>    Oops: general protection fault
>>    RIP: 0010:build_perf_domains+...
>>
>> tasks_nocpu_error() also rejects valid CPU replacements because it does
>> not account for CPUs returned by the update. With a fresh cgroup A under
>> the same boot configuration:
>>
>>    echo 2-31 > A/cpuset.cpus
>>    echo isolated > A/cpuset.cpus.partition
>>    echo 0-4 > A/cpuset.cpus
>>    cat A/cpuset.cpus.partition
>>    isolated invalid (Parent unable to distribute cpu downstream)
>>
>> The update should return CPUs 5-31 to top_cpuset, including housekeeping
>> CPUs 5-9, and leave A valid. This replacement failure also occurs without
>> boot isolation and under populated local parents.
>>
>> Extend tasks_nocpu_error() to take an explicit mask of CPUs being
>> returned and use it for local and remote updates. Require an active
>> HK_TYPE_DOMAIN_BOOT CPU to remain in top_cpuset. For other populated
>> parents, check within their current exclusive grant so an ancestor
>> update cannot credit CPUs that the parent no longer owns.
>>
>> CPU hotplug can also empty the top scheduling domain. Pass no returned
>> CPUs during its availability check, and only invalidate a partition to
>> restore the top domain if it can return an active boot domain
>> housekeeping CPU. Still invalidate a populated partition that has no
>> active CPU of its own.
>>
>> Fixes: 9b496a8bbed9 ("cgroup/cpuset: Prevent leakage of isolated CPUs into sched domains")
>> Fixes: 0c7f293efc87 ("cgroup/cpuset: Add cpuset.cpus.exclusive.effective for v2")
>> Co-developed-by: Ridong Chen <chenridong@xiaomi.com>
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
>>   kernel/cgroup/cpuset.c | 85 ++++++++++++++++++++++++++++++++++--------
>>   1 file changed, 70 insertions(+), 15 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 3052413e41e7..85f92ae0c6f4 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1181,18 +1181,54 @@ static void update_partition_sd_lb(struct cpuset *cs, int old_prs)
>>   }
>>     /*
>> - * tasks_nocpu_error - Return true if tasks will have no effective_cpus
>> + * tasks_nocpu_error - Return true if tasks or the top domain lack active CPUs
>> + * @parent: parent partition, NULL for a remote partition
>> + * @cs: the partition
>> + * @xcpus: exclusive CPUs that @cs will hold after the update
>> + * @del_cpus: exclusive CPUs to be returned to @parent, can be NULL
>> + *
>> + * @del_cpus may include CPUs that are also in @xcpus and will stay in
>> + * @cs. They are skipped by the @xcpus check, so callers can pass the
>> + * current effective_xcpus of @cs without masking it first.
>> + *
>> + * top_cpuset always has tasks. Boot-isolated CPUs remain in its
>> + * effective_cpus but are excluded from its sched domain, which must
>> + * retain an active boot domain housekeeping CPU.
>>    */
>>   static bool tasks_nocpu_error(struct cpuset *parent, struct cpuset *cs,
>> -                  struct cpumask *xcpus)
>> +                  const struct cpumask *xcpus,
>> +                  const struct cpumask *del_cpus)
>>   {
>> +    const struct cpumask *mask;
>> +    int cpu;
>> +
>> +    /* A populated @cs must have an active CPU in @xcpus. */
>> +    if (!cpumask_intersects(xcpus, cpu_active_mask) &&
>> +        partition_is_populated(cs, NULL))
>> +        return true;
>> +
>>       /*
>> -     * A populated partition (cs or parent) can't have empty effective_cpus
>> +     * A populated @parent must keep an active CPU in @mask, either from
>> +     * its effective_cpus or from @del_cpus, that isn't taken by @cs.
>>        */
>> -    return (cpumask_subset(parent->effective_cpus, xcpus) &&
>> -        partition_is_populated(parent, cs)) ||
>> -           (!cpumask_intersects(xcpus, cpu_active_mask) &&
>> -        partition_is_populated(cs, NULL));
>> +    if (!parent)
>> +        parent = &top_cpuset;
>> +
>> +    /* CPUs outside the parent's current grant cannot be returned. */
>> +    mask = parent->effective_xcpus;
>> +    if (parent == &top_cpuset)
>> +        mask = housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT);
>> +    else if (!partition_is_populated(parent, cs))
>> +        return false;
>> +
> 
> The mask selection looks right to me. HK_TYPE_DOMAIN_BOOT is the right
> one for top_cpuset, since CPUs returned by an isolated child are not in
> HK_TYPE_DOMAIN yet. Limiting a local parent to its effective_xcpus also
> correctly drops stale CPUs in del_cpus after the parent shrinks.
> 
> One corner case: validate_partition() also calls this for an invalid
> cs whose parent is not a valid partition. If the parent is an invalid
> partition without cpuset.cpus.exclusive, reset_partition_data() has
> cleared its effective_xcpus, the loop does nothing, and we return true
> when the parent is populated. The child's prs_err then changes from
> PERR_INVPARENT to PERR_NOCPUS, which reports the wrong reason. The old
> code did not do that. How about:
> 
>       else if (!is_partition_valid(parent) ||
>                !partition_is_populated(parent, cs))
>               return false;
>            
> The invalid parent case is already reported by PERR_INVPARENT/PERR_NOTPART.
> 

Hi Ridong,

Thanks for the review.

I tested your guard and will add it. However, I reproduced the error
change under slightly different conditions from those you described:
the populated invalid parent still had an explicit exclusive mask.
In that case, v4 changes PERR_INVPARENT to PERR_NOCPUS. Your check
preserves the original reason, and also preserves PERR_NOTPART in the
corresponding case where the parent is a member.

In the case you described, with no explicit exclusive mask and the
parent's effective_xcpus already cleared, I get PERR_INVCPUS in both the
base kernel and v4. compute_trialcs_excpus() also produces an empty child
trial mask, so validate_partition() returns PERR_INVCPUS before calling
tasks_nocpu_error().

> Nit: the comment "Return true if tasks or the top domain lack active
> CPUs" doesn't cover local parents. Maybe "Return true if @cs or @parent
> would lack active CPUs; for top_cpuset, only active boot domain
> housekeeping CPUs count".
> 
Sure, I'll update the comment.
> 
>> +    for_each_cpu_and(cpu, mask, cpu_active_mask) {
>> +        if (cpumask_test_cpu(cpu, xcpus))
>> +            continue;
>> +        if (cpumask_test_cpu(cpu, parent->effective_cpus) ||
>> +            (del_cpus && cpumask_test_cpu(cpu, del_cpus)))
>> +            return false;
>> +    }
>> +    return true;
>>   }
>>     static void reset_partition_data(struct cpuset *cs)
>> @@ -1724,7 +1760,7 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
>>        */
>>       compute_excpus(cs, tmp->new_cpus);
>>       if (!cpumask_intersects(tmp->new_cpus, cpu_active_mask) ||
>> -        cpumask_subset(top_cpuset.effective_cpus, tmp->new_cpus))
>> +        tasks_nocpu_error(NULL, cs, tmp->new_cpus, NULL))
>>           return PERR_INVCPUS;
>>       if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus))
>>           return PERR_NOCPUS;
>> @@ -1828,7 +1864,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
>>           if (!capable(CAP_SYS_ADMIN))
>>               WRITE_ONCE(cs->prs_err, PERR_ACCESS);
>>           else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
>> -             cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
>> +             tasks_nocpu_error(NULL, cs, excpus, cs->effective_xcpus))
>>               WRITE_ONCE(cs->prs_err, PERR_NOCPUS);
>>           else if (prstate_housekeeping_conflict(prs, PRS_ROOT,
>>                                  excpus, tmp->delmask))
>> @@ -1961,7 +1997,8 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>>        */
>>       if ((cmd != partcmd_disable) && !newmask) {
>>           compute_excpus(cs, tmp->delmask);
>> -        nocpu = tasks_nocpu_error(parent, cs, tmp->delmask);
>> +        nocpu = tasks_nocpu_error(parent, cs, tmp->delmask,
>> +                      is_partition_valid(cs) ? cs->effective_xcpus : NULL);
>>       }
>>         if ((cmd == partcmd_enable) || (cmd == partcmd_enablei)) {
>> @@ -2497,7 +2534,9 @@ static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *tri
>>       if (cpumask_empty(trialcs->effective_xcpus))
>>           return PERR_INVCPUS;
>>   -    if (tasks_nocpu_error(parent, cs, trialcs->effective_xcpus))
>> +    if (tasks_nocpu_error(is_remote_partition(cs) ? NULL : parent, cs,
>> +                  trialcs->effective_xcpus,
>> +                  is_partition_valid(cs) ? cs->effective_xcpus : NULL))
>>           return PERR_NOCPUS;
>>         return PERR_NONE;
>> @@ -3997,6 +4036,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>>       static nodemask_t new_mems;
>>       bool cpus_updated;
>>       bool mems_updated;
>> +    bool nocpu;
>>       int partcmd = -1;
>>       struct cpuset *parent;
>>   @@ -4008,9 +4048,23 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>>       if (!tmp || !cs->partition_root_state)
>>           goto update_tasks;
>>   -    if (is_remote_partition(cs) && (cpumask_empty(subpartitions_cpus) ||
>> -                       (cpumask_empty(&new_cpus) &&
>> -                    partition_is_populated(cs, NULL)))) {
>> +    /* Do not count any CPUs as returned during this hotplug check. */
>> +    nocpu = tasks_nocpu_error(is_remote_partition(cs) ? NULL : parent, cs,
>> +                  &new_cpus, NULL);
>> +    if (nocpu && (parent == &top_cpuset || is_remote_partition(cs))) {
>> +        /*
>> +         * Only invalidate a partition for an empty top sched domain if
>> +         * it can return an active boot domain housekeeping CPU. A
>> +         * populated partition with no active CPU must still be invalidated.
>> +         */
>> +        cpumask_and(tmp->addmask, cs->effective_xcpus,
>> +                housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
>> +        if (!cpumask_intersects(tmp->addmask, cpu_active_mask))
>> +            nocpu = cpumask_empty(&new_cpus) &&
>> +                partition_is_populated(cs, NULL);
>> +    }
>> +
> 
> This is hard to follow. nocpu is computed first and then partly undone,
> so that only a partition owning an active housekeeping CPU gets
> invalidated.
> 

v3 used separate branches for these cases. Adapting that structure to
the unified helper, would something like the following be easier to
follow?

        if (parent == &top_cpuset || is_remote_partition(cs)) {
                /*
                 * Do not count child partition CPUs as already returned.
                 * Only invalidate a partition for an empty top domain if
                 * it can return an active boot domain housekeeping CPU.
                 * A populated partition with no active CPU of its own
                 * must still be invalidated.
                 */
                cpumask_and(tmp->addmask, cs->effective_xcpus,
                            housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
                nocpu = cpumask_intersects(tmp->addmask, cpu_active_mask) &&
                        tasks_nocpu_error(NULL, cs, cs->effective_xcpus,
                                          NULL);
                nocpu |= cpumask_empty(&new_cpus) &&
                         partition_is_populated(cs, NULL);
        } else {
                nocpu = tasks_nocpu_error(parent, cs, &new_cpus, NULL);
        }

> Do we really need this? When hotplug leaves top_cpuset with no active
> CPU, cpuset_handle_hotplug() already clears subpartitions_cpus and
> invalidates all the partitions under it. If we handle an empty top
> sched domain the same way, this block can go away.
> 

The check keeps partitions that cannot return an active HK CPU from
being invalidated just because the top domain is empty. For example,
on a 32-CPU system with isolcpus=domain,10-31, A is an isolated partition
holding CPU 10 and its sibling B is a root partition holding CPUs 0,2-9.
When CPU 1 goes offline, v4 invalidates B and keeps A valid.

As I understand it, if we use the reset approach, it can restore the
top scheduling domain, but it should invalidate both A and B. If we
eventually want the same reset policy for an empty top scheduling
domain, I can make that change and update the existing test expectations.

Thanks,
Guopeng

> Longman, what do you think?
> 
>> +    if (is_remote_partition(cs) && (cpumask_empty(subpartitions_cpus) || nocpu)) {
>>           WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
>>           remote_partition_disable(cs, tmp);
>>           compute_effective_cpumask(&new_cpus, cs, parent);
>> @@ -4023,10 +4077,11 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>>        * 2) parent is invalid or doesn't grant any cpus to child
>>        *    partitions.
>>        * 3) subpartitions_cpus is empty.
>> +     * 4) top_cpuset needs an active boot domain housekeeping CPU from cs.
>>        */
>>       if (is_local_partition(cs) &&
>>           (!is_partition_valid(parent) ||
>> -         tasks_nocpu_error(parent, cs, &new_cpus) ||
>> +         nocpu ||
>>            cpumask_empty(subpartitions_cpus)))
>>           partcmd = partcmd_invalidate;
>>       /*
> 

