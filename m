Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A4C372EC0
	for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 17:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791824970; cv=none; b=ZCjMFIjWpNhvGg9Dq0h1AyNtXV5tpxswxLgVZapozY9F4i/fFX7iinR/SDYRwZy8cSSDPgYH7XWy+hlJBSONTNTmq4JR6bMxMJgc80IBYhVjMLBA5Bq2DIMPE+OlWmI3J/N3LRdiDtTFr6QWcVfy2JCG69ZmhaR+wkfMRmEGXk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791824970; c=relaxed/simple;
	bh=8wEKSUItEPd2uhqNs/vQ0MschtnHLAx0CDzMjdHn1Ks=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DctGgrSCbS0Nvh6iFnscP/H7wdz0y0kDAQAK5gGcDJaUBhTs95bRGkXOp3lEaekBHynAE/y2a3LHkW0v8rTAKvWCfIQJk5wpqYXR1G48OyELO7va2HxrLsVkR7tO9ptvMT7Bt0BPBzvxPnf9mjwzXvOPqcBhUOsgkzpJrIswOGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SlyNYKcI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SlyNYKcI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791824968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qWyRtyFTfyFKVw0PwgTVGU5UynezuYC/0INjQ7CdKI8=;
	b=SlyNYKcIiHWm6ZPs061+z0Z3EFGeWd8IgbAu//3FWhZQTJXapo5wqLRBTdDQIVuVpvneGF
	dd3Iik3DLocecXSC1VeZHrdhccJ2WMtKNUxYxmrs91pvMaDynazVPm4UQjnQ8rnNuzGbTu
	UgQyGIsHmSAEdFKcKEq3WPNChHZr/9k=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-563-34vftE9GPXKR3pjWWSTB8A-1; Mon,
 12 Oct 2026 17:09:24 +0000
X-MC-Unique: 34vftE9GPXKR3pjWWSTB8A-1
X-Mimecast-MFC-AGG-ID: 34vftE9GPXKR3pjWWSTB8A_1791824963
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA1C319540EE;
	Mon, 12 Oct 2026 17:09:22 +0000 (UTC)
Received: from [100.91.18.181] (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 98CA61800473;
	Mon, 12 Oct 2026 17:09:20 +0000 (UTC)
Message-ID: <11ac41af-f80c-493f-a541-3737808d7137@redhat.com>
Date: Mon, 12 Oct 2026 13:09:19 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] cgroup/cpuset: Invalidate remote partition on
 housekeeping conflict
To: Ridong Chen <ridong.chen@linux.dev>,
 Guopeng Zhang <guopeng.zhang@linux.dev>, Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260929023805.31648-1-guopeng.zhang@linux.dev>
 <585bc1e0-f538-444e-b8b4-28185ee6b19c@linux.dev>
 <cf408084-9b6a-436d-a63a-8a247a49006f@linux.dev>
 <47f5db16-b1ca-44a0-8714-38b0cf4db9e8@linux.dev>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <47f5db16-b1ca-44a0-8714-38b0cf4db9e8@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 10/11/26 9:35 PM, Ridong Chen wrote:
>
>
> On 10/11/2026 7:23 PM, Guopeng Zhang wrote:
>>
>> Hi Ridong,
>> 在 2026/10/11 09:42, Ridong Chen 写道:
>>>
>>>
>>> On 9/29/2026 10:38 AM, Guopeng Zhang wrote:
>>>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>>>
>>>> Widening an ancestor's exclusive CPU mask can add a boot-isolated CPU
>>>> to a valid remote partition root without touching the partition's own
>>>> control files. The partition then load balances that CPU, silently
>>>> defeating isolcpus=domain for it.
>>>>
>>>> This can be reproduced on a 32-CPU system booted with
>>>> isolcpus=domain,4:
>>>>
>>>>       cd /sys/fs/cgroup
>>>>       echo +cpuset > cgroup.subtree_control
>>>>       mkdir -p A/B
>>>>       echo +cpuset > A/cgroup.subtree_control
>>>>       echo 2-4 > A/cpuset.cpus
>>>>       echo 2-3 > A/cpuset.cpus.exclusive
>>>>       echo 2-4 > A/B/cpuset.cpus
>>>>       echo 2-4 > A/B/cpuset.cpus.exclusive
>>>>       echo root > A/B/cpuset.cpus.partition
>>>>       cat A/B/cpuset.cpus.effective               # 2-3
>>>>       echo 2-4 > A/cpuset.cpus.exclusive
>>>>       cat A/B/cpuset.cpus.partition               # root
>>>>       cat A/B/cpuset.cpus.effective               # 2-4
>>>>
>>>> The last write returns 0 and leaves the hierarchy in this state:
>>>>
>>>>       root (cpuset.cpus.effective=0-1,5-31)
>>>>       |
>>>>       \-- A (member):           cpuset.cpus=2-4
>>>>           |                     cpuset.cpus.exclusive=2-4
>>>>           \-- B (root, remote): cpuset.cpus=2-4
>>>>                                 cpuset.cpus.effective=2-4
>>>>
>>>> B is a remote partition: it takes its CPUs directly from the root
>>>> cpuset, and A only passes its exclusive list down. Before the last
>>>> write, that list is 2-3, so B holds 2-3 and CPU 4 stays in the
>>>> root cpuset as a boot-isolated CPU. The write widens A's exclusive
>>>> list to 2-4, which additionally grants CPU 4 to B. Nothing rejects
>>>> the grant: B remains a valid root partition, and CPU 4 is still
>>>> listed in cpuset.cpus.isolated while sitting in a load-balanced
>>>> partition.
>>>>
>>>> remote_partition_enable() already rejects such grants through
>>>> prstate_housekeeping_conflict(). remote_cpus_update(), which applies
>>>> ancestor changes to a remote partition, does not.
>>>>
>>>> Both paths also open-code remote partition validation. Move those
>>>> checks into validate_remote_partition(), and check the resulting
>>>> effective exclusive CPU mask for a housekeeping conflict there. The
>>>> existing prs_err path then invalidates the remote partition instead of
>>>> assigning it a boot-isolated CPU.
>>>>
>>>> Fixes: f62a5d39368e ("cgroup/cpuset: Remove 
>>>> remote_partition_check() & make update_cpumasks_hier() handle 
>>>> remote partition")
>>>> Suggested-by: Ridong Chen <ridong.chen@linux.dev>
>>>> Suggested-by: Tejun Heo <tj@kernel.org>
>>>> Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
>>>> Reviewed-by: Waiman Long <longman@redhat.com>
>>>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>>> ---
>>>>
>>>> Changes since v2:
>>>> - Pass the enable/update mode explicitly to 
>>>> validate_remote_partition()
>>>>     instead of deriving it from cs->remote_partition, which can 
>>>> remain set
>>>>     after a failed partition state transition, as suggested by Tejun.
>>>>
>>>> Changes since v1:
>>>> - Consolidate remote partition validation in a common helper, as
>>>>     suggested by Ridong.
>>>> - Check housekeeping conflicts against the resulting effective 
>>>> exclusive
>>>>     CPU mask.
>>>> - Rebase onto cgroup/for-7.3-fixes.
>>>>
>>>>    kernel/cgroup/cpuset.c | 69 
>>>> ++++++++++++++++++++++++++++--------------
>>>>    1 file changed, 47 insertions(+), 22 deletions(-)
>>>>
>>>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>>>> index 1fcec89a28b9..d0a45241c070 100644
>>>> --- a/kernel/cgroup/cpuset.c
>>>> +++ b/kernel/cgroup/cpuset.c
>>>> @@ -1561,6 +1561,43 @@ static inline bool is_local_partition(struct 
>>>> cpuset *cs)
>>>>        return is_partition_valid(cs) && !is_remote_partition(cs);
>>>>    }
>>>>    +/**
>>>> + * validate_remote_partition - Validate a remote partition CPU change
>>>> + * @prs: partition root state to validate
>>>> + * @updating: true for an update, false for an enable
>>>> + * @excpus: resulting effective exclusive CPU mask
>>>> + * @addcpus: exclusive CPUs to be added
>>>> + * @delcpus: exclusive CPUs to be deleted, can be NULL
>>>> + *
>>>> + * Return: PERR_NONE if valid, otherwise an appropriate error code
>>>> + */
>>>> +static enum prs_errcode
>>>> +validate_remote_partition(int prs, bool updating,
>>>> +              struct cpumask *excpus,
>>>> +              struct cpumask *addcpus,
>>>> +              struct cpumask *delcpus)
>>>> +{
>>>> +    if (!capable(CAP_SYS_ADMIN))
>>>> +        return PERR_ACCESS;
>>>> +
>>>> +    if (!updating &&
>>>> +        (!cpumask_intersects(excpus, cpu_active_mask) ||
>>>> +         cpumask_subset(top_cpuset.effective_cpus, addcpus)))
>>>> +        return PERR_INVCPUS;
>>>> +
>>>
>>> Do we really need the updating flag? I mean, whether or not it's an 
>>> updating partition, it should still be an invalid remote partition, 
>>> right? So why do we have to distinguish between updating and not 
>>> updating?
>>>
>>
>> Both paths do invalidate the remote partition when validation fails, but
>> the flag was added when factoring out this helper to preserve the
>> different semantics of the two paths.
>>
>> For example, suppose the top cpuset has only CPU 4 left:
>>
>>      top_cpuset.effective_cpus = 4
>>
>> When enabling a new remote partition:
>>
>>      addcpus = 4
>>
>> cpumask_subset(top_cpuset.effective_cpus, addcpus) is true, and the
>> existing enable path returns PERR_INVCPUS.
>>
>> Now suppose an existing remote partition owns CPUs 2-3 and is updated
>> to add CPU 4:
>>
>>      old excpus = 2-3
>>      addcpus    = 4
>>      new excpus = 2-4
>>
>> The same cpumask_subset() condition is true, but the existing update
>> path returns PERR_NOCPUS. The active CPU check also differs: the enable
>> path requires the resulting mask to contain at least one active CPU,
>> while the update path only checks whether the resulting mask is empty.
>>
>
> What we want to do is to unify the remote partition check. I think 
> enabling and updating should return the same error when the same 
> condition check fails.
>
> So I think we may change it 'a little' if it is reasonable. In my 
> opinion, returning PERR_NOCPUS when the top_cpuset.effective_cpus 
> becomes empty is reasonable. And I do not want to see some special 
> case, which makes the code complicated.
>
> I would like to see what Longman's opinion is.

There are slight inconsistency in the type of sanity check done in 
different code paths. So I like the idea of extract them out into a 
common helper to make them consistent. As for the special updating flag, 
I think we should remove it as long as it won't cause a false positive. 
BTW, I am going to post a v3 version of my cpuset patch that will 
combine the addmask & delmask into a single new_cpus mask that should 
make the elimination of the updating flag possible.

Cheers,
Longman

