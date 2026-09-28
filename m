Received: from mta0.migadu.com (out-81.mta0.migadu.com [91.218.175.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DD545D913
	for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 09:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790587961; cv=none; b=d4rojBTJrlOATN8/rMVL4c774vLd9wZy23uuEEElq1IGOznWY6/9xcd8hJw4czAGrxhwg/uwHc4rggS5KgZd8+a6lKldGG/1gUyFiyYp5vvxFMwu2WZJvfGNgx1rgB6cplg+jiBxTLtB5PYD3CyJoEBlwjlFTzGtX/LhRJgXTF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790587961; c=relaxed/simple;
	bh=q/EWnrvfu/By4yIs7thZgSeiec3+1Clq2apXYTQEHY4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oD5NcfMPJVuYBETt83z01sncup1Ply6Qr2KPuq5/5HA17lO5mZV1+SuNn5W09uw72RjXQlUsKLRViDTTEFlm5ZzdRCf5nk7d2X4RmY1y39T7N/YpcZSZmI4lNxfUnN1mbtsNpvkjilCBMXosvxM5GEgIOGo9zovM61wNFObD1FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jdX+9JhY; arc=none smtp.client-ip=91.218.175.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jdX+9JhY"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=q/EWnrvfu/By4yIs7thZgSeiec3+1Clq2apXYTQEHY4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790587958; v=1; x=1791192758;
 b=jdX+9JhYFgeoPO1O36VI/5VbY699cBBGGnvy60mbLIgam22SDfZYY/lbg4XoUwQAyaMDgGcV
 EnzncVm7ujQLG0i23KYplu6P36zw8DPxplCdz8hjBkXkzHINBeRm6YYtQkZLv0GeQwz1mr3bjVe
 G/JKwOTF4MpPGsYsXhXVXw+o=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id aae8f6bbddf91de2;
	Mon, 28 Sep 2026 09:32:27 +0000
X-Mizu-Trace-ID: aae8f6bbddf91de2
X-Migadu-Flow: FLOW_OUT
Message-ID: <8b38cb59-6e3e-4fe2-bbd7-2fc4cdd9312e@linux.dev>
Date: Mon, 28 Sep 2026 17:32:24 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-next v2 1/2] cgroup/cpuset: Run SCHED_DEADLINE shrink test
 on valid partition root only
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hui Peng <benquike@gmail.com>
References: <20260927215319.382422-1-longman@redhat.com>
 <20260927215319.382422-2-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20260927215319.382422-2-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/9/28 05:53, Waiman Long 写道:
> Commit f82f80426f7a ("sched/deadline: Ensure that updates to exclusive
> cpusets don't break AC") adds a check in validate_change() to make
> sure that there is enough bandwidth for SCHED_DEADLINE tasks if we
> shrink a v1 exclusive cpuset that has CS_CPU_EXCLUSIVE flag set.
> 
> With the introduction of cpuset partition in cgroup v2, we keep setting
> the CS_CPU_EXCLUSIVE flag for a partition root so that the SCHED_DEADLINE
> check will continue to work as intended. However it turns out that the
> current code isn't perfect and there are cases where a cpuset isn't
> a valid partition root, but the exclusive flag is still incorrectly
> set. This can leads to SCHED_DEADLINE check being incorrectly triggered
> when there are deadline tasks in the system. This can result in unexpected
> -EBUSY failure when making changes to cpuset control files. Fix that
> by checking for a valid partition root for v2 and is_cpu_exclusive()
> for v1. It is far easier and less cumbersome than to make sure that
> the exclusive flag is only set for valid partition roots.
> 
> Even though commit a86ce68078b2 ("cgroup/cpuset: Extract out
> CS_CPU_EXCLUSIVE & CS_SCHED_LOAD_BALANCE handling") is marked as a
> commit to be fixed, the problem may exist before that.
> 
> Fixes: a86ce68078b2 ("cgroup/cpuset: Extract out CS_CPU_EXCLUSIVE & CS_SCHED_LOAD_BALANCE handling")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/cgroup/cpuset.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 753aa65afcd7..104fe10c336d 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -771,8 +771,8 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
>  	 * For v1, effective_cpus == cpus_allowed & user_xcpus() returns
>  	 * cpus_allowed.
>  	 *
> -	 * For v2, is_cpu_exclusive() & is_sched_load_balance() are true only
> -	 * for non-isolated partition root. At this point, the target
> +	 * For v2, is_partition_valid(cur) & is_sched_load_balance() are true
> +	 * only for non-isolated partition root. At this point, the target
>  	 * effective_cpus isn't computed yet. user_xcpus() is the best
>  	 * approximation.
>  	 *
> @@ -781,7 +781,8 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
>  	 * becomes an issue.
>  	 */
>  	ret = -EBUSY;
> -	if (is_cpu_exclusive(cur) && is_sched_load_balance(cur) &&
> +	if ((is_partition_valid(cur) || (!cpuset_v2() && is_cpu_exclusive(cur))) &&
> +	    is_sched_load_balance(cur) &&
>  	    !cpuset_cpumask_can_shrink(cur->effective_cpus, user_xcpus(trial)))
>  		goto out;
>  

Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Thanks,
Guopeng
