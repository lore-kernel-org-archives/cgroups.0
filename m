Received: from mta0.migadu.com (out-226.mta0.migadu.com [91.218.175.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7E345FFD2
	for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 07:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790581626; cv=none; b=gKSD62dv0lGTpcBqr8QIcx0cq6xdX/1dE0TuS2B0Jks/oKmyz+HGGstYDLGJAzd7iDxRDlGcjJX2HR4ym28msyR+kyK/A39XZ9HJWIInRBNR8VQ7bgwgIbnu1zGqfUepz8PuSB5EPOmdqPbGS0mH9qX7sVSjXd4ciAKUOA+NZo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790581626; c=relaxed/simple;
	bh=0ZBxtusrkUwe3BRrbG7eDoQq7t2MC7aQDv03qnnAI5U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qIlRh9gB5Lu8QtPB+sErux/JJZ7utfi0Awn98scY+q41oGIfj6mBd1my8dHO68sgchHAB6pZegsSYoTpGAFJvltqoiyI17+UVqvuSofBFvhG9DqAT4+yMDJ96s5O1s2X4FCv4proHTPlR6xJYANh5FwCHvjgrOnCod1fY+GoW0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K+V6s3D7; arc=none smtp.client-ip=91.218.175.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K+V6s3D7"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0ZBxtusrkUwe3BRrbG7eDoQq7t2MC7aQDv03qnnAI5U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790581620; v=1; x=1791186420;
 b=K+V6s3D77VZfwYCDGVM9bjAeNvGmmaYgH2xT1Xb9hYM4fKfeZpwEnyeiQJ2HROQuMpfmIcg+
 9CVksi3sPD9sqZfl2nOx54SLReggTdIZ66mVG20Cj3qg3Hj61aVooxSHEE+Icvn2T7eyk7ewRVh
 7dzMCRoLRlod41RIq5wP9H0g=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1589a60bc4c36ce2;
	Mon, 28 Sep 2026 07:47:00 +0000
X-Mizu-Trace-ID: 1589a60bc4c36ce2
X-Migadu-Flow: FLOW_OUT
Message-ID: <4844cad2-5460-470c-a367-200a6a995ff1@linux.dev>
Date: Mon, 28 Sep 2026 15:46:52 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-next v2 1/2] cgroup/cpuset: Run SCHED_DEADLINE shrink test
 on valid partition root only
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hui Peng <benquike@gmail.com>, Guopeng Zhang <guopeng.zhang@linux.dev>
References: <20260927215319.382422-1-longman@redhat.com>
 <20260927215319.382422-2-longman@redhat.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260927215319.382422-2-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/28/2026 5:53 AM, Waiman Long wrote:
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
>   kernel/cgroup/cpuset.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 753aa65afcd7..104fe10c336d 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -771,8 +771,8 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
>   	 * For v1, effective_cpus == cpus_allowed & user_xcpus() returns
>   	 * cpus_allowed.
>   	 *
> -	 * For v2, is_cpu_exclusive() & is_sched_load_balance() are true only
> -	 * for non-isolated partition root. At this point, the target
> +	 * For v2, is_partition_valid(cur) & is_sched_load_balance() are true
> +	 * only for non-isolated partition root. At this point, the target
>   	 * effective_cpus isn't computed yet. user_xcpus() is the best
>   	 * approximation.
>   	 *
> @@ -781,7 +781,8 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
>   	 * becomes an issue.
>   	 */
>   	ret = -EBUSY;
> -	if (is_cpu_exclusive(cur) && is_sched_load_balance(cur) &&
> +	if ((is_partition_valid(cur) || (!cpuset_v2() && is_cpu_exclusive(cur))) &&
> +	    is_sched_load_balance(cur) &&
>   	    !cpuset_cpumask_can_shrink(cur->effective_cpus, user_xcpus(trial)))
>   		goto out;
>   
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.
-- 
Best regards
Ridong

