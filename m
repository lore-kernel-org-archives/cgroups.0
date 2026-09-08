Received: from mta1.migadu.com (out-29.mta1.migadu.com [95.215.58.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE4A526AB7
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 12:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788870363; cv=none; b=jiizd0gPFVN7jryIZ4bmSpax9IkOgayI7sPgMNmZCt2M+CdqXywmiCs50qgbTcy4ttE5QDwJKxdJuoJ4Wdx1IBhlymJiNY2p5byGeNnEFQ0KeS+59Ulk9y6AOkkLSTF4zC+vMKiUMkFDW/Vp8LCBpFMOPo1fGgG5dYNSURgRVdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788870363; c=relaxed/simple;
	bh=tFsgpBV6g8F8xBl+z2QVHBMs7DUcyN+PgiltX0ODWKI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rp15gaLrtcDjlcpifGNLmgSROoxU8y3xO6oiohHvNmMZgNSoZwc4Xydsf+MOfxLTGMks2SGmbFNuvsevKHOGX1apkwNjE/f143PEkP4nSWGEoBgZttGqbavaP+wHQEmds5m5ipq8Gh4ta9DsFQ3h3rzTq8Vc0jEJkSLkay8nf4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C/yxU9RR; arc=none smtp.client-ip=95.215.58.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C/yxU9RR"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=tFsgpBV6g8F8xBl+z2QVHBMs7DUcyN+PgiltX0ODWKI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788870359; v=1; x=1789475159;
 b=C/yxU9RRUdPpzw3c6ATqEYPi9BY3z34WSttUVJkbiWWy9EK8EFgwismOHGohJBY0pSktXJfg
 +omTblRSvAheGPggqCfSWk+OQzW4pX5zpTPZAc8TfxuIRXKzzG6ElYT2c9T5sL8ATrmlnThCVc5
 HcG+QbzC2qqqp1Toim1aN0Ks=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cba39cd4919c1c92;
	Tue, 08 Sep 2026 12:25:59 +0000
X-Mizu-Trace-ID: cba39cd4919c1c92
X-Migadu-Flow: FLOW_OUT
Message-ID: <792a64de-b5fc-49ca-8d7d-98c232d1b7cb@linux.dev>
Date: Tue, 8 Sep 2026 20:25:52 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] cgroup/cpuset: Factor out child partition
 validation
To: Ridong Chen <ridong.chen@linux.dev>, Waiman Long <longman@redhat.com>,
 cgroups@vger.kernel.org
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260902102615.79189-1-guopeng.zhang@linux.dev>
 <20260902102615.79189-2-guopeng.zhang@linux.dev>
 <5842edcd-9283-4a87-afc9-50e51962368e@redhat.com>
 <5e0d1386-b094-4d4e-8569-e6b584f955c5@linux.dev>
 <fe0c93af-5562-44fe-8aee-328c4a450a9b@linux.dev>
 <7c2a545f-7fa2-40d5-8d4f-25a65ec5df24@linux.dev>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <7c2a545f-7fa2-40d5-8d4f-25a65ec5df24@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/9/8 09:40, Ridong Chen 写道:
> 
> 
> On 9/7/2026 5:49 PM, Guopeng Zhang wrote:
>>
>>
>> 在 2026/9/4 09:25, Ridong Chen 写道:
>>>
>>>
>>> On 9/4/2026 2:33 AM, Waiman Long wrote:
>>>> On 9/2/26 6:26 AM, Guopeng Zhang wrote:
>>>>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>>>>
>>>>> compute_partition_effective_cpumask() checks whether each valid child
>>>>> partition remains covered by the parent exclusive CPU mask and whether it
>>>>> would consume all remaining CPUs of a populated parent.
>>>>>
>>>>> Factor these two checks into child_partition_error() so the same rules can
>>>>> be reused when evaluating a proposed parent configuration. This is a
>>>>> preparatory refactoring with no intended functional change.
>>>>>
>>>>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>>>> ---
>>>>>    kernel/cgroup/cpuset.c | 38 +++++++++++++++++++++++++++++---------
>>>>>    1 file changed, 29 insertions(+), 9 deletions(-)
>>>>>
>>>>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>>>>> index 8f24171b6055..6994dc75d940 100644
>>>>> --- a/kernel/cgroup/cpuset.c
>>>>> +++ b/kernel/cgroup/cpuset.c
>>>>> @@ -2085,6 +2085,26 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>>>>>        return 0;
>>>>>    }
>>>>> +/*
>>>>> + * Return the error that will invalidate a child partition under a proposed
>>>>> + * parent partition configuration.
>>>>> + */
>>>>> +static enum prs_errcode
>>>>> +child_partition_error(struct cpuset *child,
>>>>> +              const struct cpumask *partition_cpus,
>>>>> +              const struct cpumask *remaining_cpus,
>>>>> +              bool parent_populated)
>>>> I think you should add some functional comments on what "partition_cpus" and "remaining_cpus" are supposed to be so that caller knows what to pass into this helper.
>>>
>>> Would it help to rename them to excpus and local_excpus?
>>> local already implies "excluding children" (just like cgroup.stat.local), so I think that makes the intent clearer.
>>>
>>
>> Ridong, thanks for your review.
>>
>> Renaming the masks would help, but I think `local_excpus` may be slightly misleading here. When the helper is called, the mask may still contain active CPUs assigned to the current child and to children that have not yet been visited. It excludes only the CPUs of previously visited children that remain valid under the configuration being evaluated, and the mask itself is restricted to active CPUs.
>>
>> In addition, "local" already has the local-versus-remote partition meaning in cpuset.
>>
>> Would `parent_xcpus` for the complete effective exclusive mask, which may include offline CPUs, and `remaining_ecpus` for the remaining active CPUs before evaluating the current child be clearer? I will also document both parameters explicitly.
>>
> 
> Passing struct cpuset *parent into the function simplifies naming, as the needed values become local variables derived from it.
> 
Thanks, Ridong.

I agree that passing `parent` would make the interface simpler, but I don't think `parent` alone provides all the state needed by this helper.

In `compute_partition_effective_cpumask()`, the remaining active CPU mask is temporary state maintained during the child walk:

compute_excpus(cs, new_ecpus);
cpumask_and(new_ecpus, new_ecpus, cpu_active_mask);

cpuset_for_each_child(child, css, cs) {
	...

	if (child_err)
		continue;

	cpumask_andnot(new_ecpus, new_ecpus,
		       child->effective_xcpus);
}

So `new_ecpus` changes as valid children are processed and cannot be replaced by `parent->effective_cpus`. In this update path, `parent->effective_cpus` still contains the previously published effective mask, while `new_ecpus` already represents the active CPUs remaining before the current child is evaluated.

For example, assume CPUs 1-3 are active, the parent is populated, and child A is visited before child B. Initially:

parent:
        effective_xcpus = 1-3
        effective_cpus  = 3

child A:
        effective_xcpus = 1

child B:
        effective_xcpus = 2

If the parent's effective exclusive mask is changed to `1-2`, this update path publishes the new `effective_xcpus` before recomputing `effective_cpus`. Therefore, when entering `compute_partition_effective_cpumask()`:

parent->effective_xcpus = 1-2
parent->effective_cpus  = 3
new_ecpus               = 1-2

After child A remains valid, its CPU is removed from `new_ecpus`:

new_ecpus = 2

So when child B is evaluated, the `PERR_NOCPUS` check uses:

cpumask_subset(new_ecpus, child_B->effective_xcpus)
= cpumask_subset(2, 2)
= true

Since the parent is populated, the `PERR_NOCPUS` condition is met for child B.

At the same point:

remaining mask needed by the check = 2
parent->effective_cpus             = 3

Using `parent->effective_cpus` instead would give:

cpumask_subset(parent->effective_cpus,
               child_B->effective_xcpus)
= cpumask_subset(3, 2)
= false

and would miss the condition.

So unless `cs_partition_error()` also takes over or reconstructs the relevant child-walk state, passing only `parent` cannot provide the remaining active CPU mask needed to evaluate the current child.

The next patch also reuses this helper for a trial parent configuration. In that case, the complete mask being evaluated comes from `trialcs->effective_xcpus`, rather than from the currently published state in the real parent. The follow-up child-invalidation fix similarly needs to distinguish the complete effective exclusive mask from the remaining active CPU mask.

So for now, I will use the more general `cs_partition_error()` name, but keep the two masks explicit in the interface.

In the next version, I plan to include the remaining patches related to this helper and the associated invalidation paths so that all the call sites and use cases can be reviewed together.

I may still be thinking within the constraints of the current code structure, so if you see a cleaner interface once the full picture is visible, I would very much appreciate your suggestion.

Thanks,
Guopeng

