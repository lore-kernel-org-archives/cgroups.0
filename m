Received: from mta0.migadu.com (out-2.mta0.migadu.com [91.218.175.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7020377AAE
	for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 03:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789011698; cv=none; b=WAPaRvumZqXsbcgOugynHf8xW5egaCUlHqumeRrE6+AL5yAwk3Wkh6YbQ1z0tz5agnvnZ9L4H0qhJuhQT4iGk6tHv4c6IsL1MjExGmrDBMAZcU6oPE6QPTdTvWoow1Fsnc5LgrErRnGaUIiJccYlPN+X25vhNbd3+hJwZTj61Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789011698; c=relaxed/simple;
	bh=TO9MO5b8bJXJHjB/YLkQtxGsZmZ1QMZjecPQuYKzAKE=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=AJzRT0t01fCLiReuezCb3US8UaieWJ4Cgs7yhnX4+30LMXkOB+P419/JzF3fVe1EQHTpfciq95PXJri+yaHAm9BvYx17d9gMhzUKLR/C2pisG9LJJ2g6ue7UHv3AfuffF+4219RSK3ItZMAqvLs6noAYR8cv40oFNI//+DTMwu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cW5wMLbl; arc=none smtp.client-ip=91.218.175.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cW5wMLbl"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=TO9MO5b8bJXJHjB/YLkQtxGsZmZ1QMZjecPQuYKzAKE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789011693; v=1; x=1789616493;
 b=cW5wMLblkClkgxEJoNh30xAjz8z07O7j7MGgDXw0ZUHBGm8m6eEWiGn9kuvfIm601GaYDbHZ
 0nheGPlWP/WwYpoKNjmZCysKfpXEj7omqC9ImaylSqoF7ZxXqBAR5TCOU3I8TBMt1fxQ2Mz+vQ3
 eI4WkcRq/FY7MvZyGTvyBVBo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1f201aa16fc70ad7;
	Thu, 10 Sep 2026 03:41:33 +0000
X-Mizu-Trace-ID: 1f201aa16fc70ad7
X-Migadu-Flow: FLOW_OUT
Message-ID: <3830e505-70eb-4c0b-8d1c-74074f066142@linux.dev>
Date: Thu, 10 Sep 2026 11:41:26 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Guopeng Zhang <guopeng.zhang@linux.dev>
Subject: Re: [PATCH 12/17] cgroup/cpuset: Invalidate children outside the new
 CPU mask
To: Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org
Cc: ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, shuah@kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260820124202.517160-1-guopeng.zhang@linux.dev>
 <20260820124202.517160-13-guopeng.zhang@linux.dev>
 <3bf50da2-f13a-4cef-bfb8-cd592f862164@redhat.com>
Content-Language: en-US
In-Reply-To: <3bf50da2-f13a-4cef-bfb8-cd592f862164@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/8/25 23:11, Waiman Long 写道:
> On 8/20/26 8:41 AM, Guopeng Zhang wrote:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> When cpuset.cpus changes, compute_partition_effective_cpumask() builds a
>> new exclusive mask but checks child partitions against
>> cs->effective_xcpus. That field still contains the old mask, so a child
>> that no longer fits can remain valid.
>>
>> Use new_xcpus for the check. A later partcmd_update() may revisit the
>> newly invalid child. Report PERR_INVCPUS if the child CPUs are outside
>> the parent effective exclusive mask so that this visit does not make the
>> child valid again.
>>
>> Fixes: 0c7f293efc87 ("cgroup/cpuset: Add cpuset.cpus.exclusive.effective for v2")
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
>>   kernel/cgroup/cpuset.c | 10 +++++++---
>>   1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index b9faadf4af6d..b3e749ede7d1 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1987,12 +1987,16 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>>                   adding = cpumask_and(tmp->addmask,
>>                                cs->effective_xcpus,
>>                                parent->effective_xcpus);
>> -        } else if (is_partition_invalid(cs) && !cpumask_empty(xcpus) &&
>> -               cpumask_subset(xcpus, parent->effective_xcpus)) {
>> +        } else if (is_partition_invalid(cs) && !cpumask_empty(xcpus)) {
>>               struct cgroup_subsys_state *css;
>>               struct cpuset *child;
>>               bool exclusive = true;
>>   +            if (!cpumask_subset(xcpus, parent->effective_xcpus)) {
>> +                part_error = PERR_INVCPUS;
>> +                goto write_error;
>> +            }
>> +
> A invalid partition means part_error should be set to some error code. This change only makes sure the error code is PERR_INVCPUS. Other than that, I don't see any other tangible change here.

Thanks, Longman.

I think there is a functional difference here. `part_error` is a local variable initialized to `PERR_NONE` on every call to `update_parent_effective_cpumask()`; it is not initialized from `cs->prs_err`.

With the current condition:

} else if (is_partition_invalid(cs) && !cpumask_empty(xcpus) &&
	   cpumask_subset(xcpus, parent->effective_xcpus)) {

an invalid partition whose CPUs are no longer a subset of the parent's effective exclusive mask skips this branch entirely, leaving `part_error` as `PERR_NONE`.

The later state transition then does:

case PRS_INVALID_ROOT:
case PRS_INVALID_ISOLATED:
	if (!part_error)
		new_prs = -old_prs;
	break;

so the partition can be changed back to a valid state.

Therefore, this change does more than set the error code to `PERR_INVCPUS`; it also prevents an out-of-mask invalid partition from being made valid again.

>>               /*
>>                * Convert invalid partition to valid has to
>>                * pass the cpu exclusivity test.
>> @@ -2144,7 +2148,7 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
>>           WARN_ON_ONCE(is_remote_partition(child));
>>           WRITE_ONCE(child->prs_err, 0);
>>           if (!cpumask_subset(child->effective_xcpus,
>> -                    cs->effective_xcpus))
>> +                    new_xcpus))
>>               WRITE_ONCE(child->prs_err, PERR_INVCPUS);
>>           else if (populated &&
>>                cpumask_subset(new_ecpus, child->effective_xcpus))
> 
> This hunk should probably be grouped into the same patch making change to compute_partition_effective_cpumask().

I have included these changes in v4 and moved both changes from this patch into the earlier patch that modifies compute_partition_effective_cpumask().

I have also temporarily dropped all selftest patches, including those posted in v3, as the current test design needs some rework.

Thanks,
Guopeng

