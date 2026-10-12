Received: from mta0.migadu.com (out-133.mta0.migadu.com [91.218.175.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CCD2D9EE7
	for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 01:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791768920; cv=none; b=Z0rl/C8xHUg0PI1YSONnvV0OpHOaDb32xNcMz7QLDCzqRWAHvZtqWNjP0t9Qnqz1/fq4nU1n5+IUd0BDueFVfKvvseXg2Fnsv2/eVLaFYgur69V7IlRO/deoxKdwxS24QZipmdxJbEK18skqT2vNm0s81tHM44K+DZ1b5VAsqi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791768920; c=relaxed/simple;
	bh=eQHPrEnDL1xhxQp+o/8piBcp2L8OUcBBuyYsUoVONDk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YHGF1wsHmELGpuBY3sHHAnFt7RQSJG/wMsYhkIP8XhQf6j3R0gcuSEN6rrl5GSGssGm3uDWKhz3oLsQEoUwNIQS3PnQdYiU6oAZarc0DhC9kMsKfFNQ2ZDAmgIQxF6wtTpZsUEVgCgpz3vsK3VI8t6lRyL8XSJoInp4+b26xVDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eDvQZAmw; arc=none smtp.client-ip=91.218.175.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eDvQZAmw"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=eQHPrEnDL1xhxQp+o/8piBcp2L8OUcBBuyYsUoVONDk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791768914; v=1; x=1792373714;
 b=eDvQZAmwlTQlus/bnCIdjPUrKhofYb+97HpoCguQe897IL/P7QV5Ei+tnrAN92NnRhzO1T65
 GdHB4i8G2Z+WsUK6O5WO6BIU2FVEelKkBho4fNfB/CGx7A84J9RARMKNsYsMUZRakkj8bDL53rG
 LNtIluh0Hix8pdONvnB8vSAA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1d193c05b31374f3;
	Mon, 12 Oct 2026 01:35:12 +0000
X-Mizu-Trace-ID: 1d193c05b31374f3
X-Migadu-Flow: FLOW_OUT
Message-ID: <47f5db16-b1ca-44a0-8714-38b0cf4db9e8@linux.dev>
Date: Mon, 12 Oct 2026 09:35:09 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] cgroup/cpuset: Invalidate remote partition on
 housekeeping conflict
To: Guopeng Zhang <guopeng.zhang@linux.dev>, Waiman Long
 <longman@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260929023805.31648-1-guopeng.zhang@linux.dev>
 <585bc1e0-f538-444e-b8b4-28185ee6b19c@linux.dev>
 <cf408084-9b6a-436d-a63a-8a247a49006f@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <cf408084-9b6a-436d-a63a-8a247a49006f@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 10/11/2026 7:23 PM, Guopeng Zhang wrote:
> 
> Hi Ridong,
> 在 2026/10/11 09:42, Ridong Chen 写道:
>>
>>
>> On 9/29/2026 10:38 AM, Guopeng Zhang wrote:
>>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>>
>>> Widening an ancestor's exclusive CPU mask can add a boot-isolated CPU
>>> to a valid remote partition root without touching the partition's own
>>> control files. The partition then load balances that CPU, silently
>>> defeating isolcpus=domain for it.
>>>
>>> This can be reproduced on a 32-CPU system booted with
>>> isolcpus=domain,4:
>>>
>>>       cd /sys/fs/cgroup
>>>       echo +cpuset > cgroup.subtree_control
>>>       mkdir -p A/B
>>>       echo +cpuset > A/cgroup.subtree_control
>>>       echo 2-4 > A/cpuset.cpus
>>>       echo 2-3 > A/cpuset.cpus.exclusive
>>>       echo 2-4 > A/B/cpuset.cpus
>>>       echo 2-4 > A/B/cpuset.cpus.exclusive
>>>       echo root > A/B/cpuset.cpus.partition
>>>       cat A/B/cpuset.cpus.effective               # 2-3
>>>       echo 2-4 > A/cpuset.cpus.exclusive
>>>       cat A/B/cpuset.cpus.partition               # root
>>>       cat A/B/cpuset.cpus.effective               # 2-4
>>>
>>> The last write returns 0 and leaves the hierarchy in this state:
>>>
>>>       root (cpuset.cpus.effective=0-1,5-31)
>>>       |
>>>       \-- A (member):           cpuset.cpus=2-4
>>>           |                     cpuset.cpus.exclusive=2-4
>>>           \-- B (root, remote): cpuset.cpus=2-4
>>>                                 cpuset.cpus.effective=2-4
>>>
>>> B is a remote partition: it takes its CPUs directly from the root
>>> cpuset, and A only passes its exclusive list down. Before the last
>>> write, that list is 2-3, so B holds 2-3 and CPU 4 stays in the
>>> root cpuset as a boot-isolated CPU. The write widens A's exclusive
>>> list to 2-4, which additionally grants CPU 4 to B. Nothing rejects
>>> the grant: B remains a valid root partition, and CPU 4 is still
>>> listed in cpuset.cpus.isolated while sitting in a load-balanced
>>> partition.
>>>
>>> remote_partition_enable() already rejects such grants through
>>> prstate_housekeeping_conflict(). remote_cpus_update(), which applies
>>> ancestor changes to a remote partition, does not.
>>>
>>> Both paths also open-code remote partition validation. Move those
>>> checks into validate_remote_partition(), and check the resulting
>>> effective exclusive CPU mask for a housekeeping conflict there. The
>>> existing prs_err path then invalidates the remote partition instead of
>>> assigning it a boot-isolated CPU.
>>>
>>> Fixes: f62a5d39368e ("cgroup/cpuset: Remove remote_partition_check() & make update_cpumasks_hier() handle remote partition")
>>> Suggested-by: Ridong Chen <ridong.chen@linux.dev>
>>> Suggested-by: Tejun Heo <tj@kernel.org>
>>> Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
>>> Reviewed-by: Waiman Long <longman@redhat.com>
>>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>> ---
>>>
>>> Changes since v2:
>>> - Pass the enable/update mode explicitly to validate_remote_partition()
>>>     instead of deriving it from cs->remote_partition, which can remain set
>>>     after a failed partition state transition, as suggested by Tejun.
>>>
>>> Changes since v1:
>>> - Consolidate remote partition validation in a common helper, as
>>>     suggested by Ridong.
>>> - Check housekeeping conflicts against the resulting effective exclusive
>>>     CPU mask.
>>> - Rebase onto cgroup/for-7.3-fixes.
>>>
>>>    kernel/cgroup/cpuset.c | 69 ++++++++++++++++++++++++++++--------------
>>>    1 file changed, 47 insertions(+), 22 deletions(-)
>>>
>>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>>> index 1fcec89a28b9..d0a45241c070 100644
>>> --- a/kernel/cgroup/cpuset.c
>>> +++ b/kernel/cgroup/cpuset.c
>>> @@ -1561,6 +1561,43 @@ static inline bool is_local_partition(struct cpuset *cs)
>>>        return is_partition_valid(cs) && !is_remote_partition(cs);
>>>    }
>>>    +/**
>>> + * validate_remote_partition - Validate a remote partition CPU change
>>> + * @prs: partition root state to validate
>>> + * @updating: true for an update, false for an enable
>>> + * @excpus: resulting effective exclusive CPU mask
>>> + * @addcpus: exclusive CPUs to be added
>>> + * @delcpus: exclusive CPUs to be deleted, can be NULL
>>> + *
>>> + * Return: PERR_NONE if valid, otherwise an appropriate error code
>>> + */
>>> +static enum prs_errcode
>>> +validate_remote_partition(int prs, bool updating,
>>> +              struct cpumask *excpus,
>>> +              struct cpumask *addcpus,
>>> +              struct cpumask *delcpus)
>>> +{
>>> +    if (!capable(CAP_SYS_ADMIN))
>>> +        return PERR_ACCESS;
>>> +
>>> +    if (!updating &&
>>> +        (!cpumask_intersects(excpus, cpu_active_mask) ||
>>> +         cpumask_subset(top_cpuset.effective_cpus, addcpus)))
>>> +        return PERR_INVCPUS;
>>> +
>>
>> Do we really need the updating flag? I mean, whether or not it's an updating partition, it should still be an invalid remote partition, right? So why do we have to distinguish between updating and not updating?
>>
> 
> Both paths do invalidate the remote partition when validation fails, but
> the flag was added when factoring out this helper to preserve the
> different semantics of the two paths.
> 
> For example, suppose the top cpuset has only CPU 4 left:
> 
>      top_cpuset.effective_cpus = 4
> 
> When enabling a new remote partition:
> 
>      addcpus = 4
> 
> cpumask_subset(top_cpuset.effective_cpus, addcpus) is true, and the
> existing enable path returns PERR_INVCPUS.
> 
> Now suppose an existing remote partition owns CPUs 2-3 and is updated
> to add CPU 4:
> 
>      old excpus = 2-3
>      addcpus    = 4
>      new excpus = 2-4
> 
> The same cpumask_subset() condition is true, but the existing update
> path returns PERR_NOCPUS. The active CPU check also differs: the enable
> path requires the resulting mask to contain at least one active CPU,
> while the update path only checks whether the resulting mask is empty.
> 

What we want to do is to unify the remote partition check. I think enabling and 
updating should return the same error when the same condition check fails.

So I think we may change it 'a little' if it is reasonable. In my opinion, 
returning PERR_NOCPUS when the top_cpuset.effective_cpus becomes empty is 
reasonable. And I do not want to see some special case, which makes the code 
complicated.

I would like to see what Longman's opinion is.

> If we want to remove the flag, I think the cleaner approach is to keep
> the checks specific to each path in their respective callers and leave
> only the shared checks in validate_remote_partition().
> 
> Thanks,
> Guopeng
> 
>>> +    if (cpumask_intersects(addcpus, subpartitions_cpus) ||
>>> +        (updating &&
>>> +         cpumask_subset(top_cpuset.effective_cpus, addcpus)))
>>> +        return PERR_NOCPUS;
>>> +
>>> +    if ((prs == PRS_ISOLATED &&
>>> +         !isolated_cpus_can_update(addcpus, delcpus)) ||
>>> +        prstate_housekeeping_conflict(prs, excpus))
>>> +        return PERR_HKEEPING;
>>> +
>>> +    return PERR_NONE;
>>> +}
>>> +
>>>    /*
>>>     * remote_partition_enable - Enable current cpuset as a remote partition root
>>>     * @cs: the cpuset to update
>>> @@ -1574,11 +1611,7 @@ static inline bool is_local_partition(struct cpuset *cs)
>>>    static int remote_partition_enable(struct cpuset *cs, int new_prs,
>>>                       struct tmpmasks *tmp)
>>>    {
>>> -    /*
>>> -     * The user must have sysadmin privilege.
>>> -     */
>>> -    if (!capable(CAP_SYS_ADMIN))
>>> -        return PERR_ACCESS;
>>> +    enum prs_errcode err;
>>>          /*
>>>         * The requested exclusive_cpus must not be allocated to other
>>> @@ -1591,15 +1624,10 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
>>>         * above it or remote partition root underneath it is not allowed.
>>>         */
>>>        compute_excpus(cs, tmp->new_cpus);
>>> -    if (!cpumask_intersects(tmp->new_cpus, cpu_active_mask) ||
>>> -        cpumask_subset(top_cpuset.effective_cpus, tmp->new_cpus))
>>> -        return PERR_INVCPUS;
>>> -    if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus))
>>> -        return PERR_NOCPUS;
>>> -    if (((new_prs == PRS_ISOLATED) &&
>>> -         !isolated_cpus_can_update(tmp->new_cpus, NULL)) ||
>>> -        prstate_housekeeping_conflict(new_prs, tmp->new_cpus))
>>> -        return PERR_HKEEPING;
>>> +    err = validate_remote_partition(new_prs, false, tmp->new_cpus,
>>> +                    tmp->new_cpus, NULL);
>>> +    if (err)
>>> +        return err;
>>>          spin_lock_irq(&callback_lock);
>>>        partition_xcpus_add(new_prs, NULL, tmp->new_cpus);
>>> @@ -1672,6 +1700,7 @@ static void remote_partition_disable(struct cpuset *cs, struct tmpmasks *tmp)
>>>    static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
>>>                       struct cpumask *excpus, struct tmpmasks *tmp)
>>>    {
>>> +    enum prs_errcode err;
>>>        bool adding, deleting;
>>>        int prs = cs->partition_root_state;
>>>    @@ -1695,14 +1724,10 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
>>>         */
>>>        if (adding) {
>>>            WARN_ON_ONCE(cpumask_intersects(tmp->addmask, subpartitions_cpus));
>>> -        if (!capable(CAP_SYS_ADMIN))
>>> -            WRITE_ONCE(cs->prs_err, PERR_ACCESS);
>>> -        else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
>>> -             cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
>>> -            WRITE_ONCE(cs->prs_err, PERR_NOCPUS);
>>> -        else if ((prs == PRS_ISOLATED) &&
>>> -             !isolated_cpus_can_update(tmp->addmask, tmp->delmask))
>>> -            WRITE_ONCE(cs->prs_err, PERR_HKEEPING);
>>> +        err = validate_remote_partition(prs, true, excpus, tmp->addmask,
>>> +                        tmp->delmask);
>>> +        if (err)
>>> +            WRITE_ONCE(cs->prs_err, err);
>>>            if (cs->prs_err)
>>>                goto invalidate;
>>>        }
>>>
>>> base-commit: 31c88350b7dd1522792f726f79607f31bb55c50f
>>
> 

-- 
Best regards
Ridong

