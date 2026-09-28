Received: from mta0.migadu.com (out-86.mta0.migadu.com [91.218.175.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD7F48D884
	for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 09:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790587981; cv=none; b=Ih5EYxqyvgA1EvH4i2t1MBtX7Tni2zQ/L5hPHAQWnWQJsOG9K8IJHVwbgZg8slyCWaqpssSok4v1+PftF05qOlcpVe4PJWb4dqjXes5mXyi6s1SEo+9yHOu3wbVFhi+R34dN1iN8VkeKPqex9/eDeO+AmiOa2CbVVLDIza8j4ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790587981; c=relaxed/simple;
	bh=ETo6rrudRG5VauPFMeWtsoPSY1bTtsOWTm1BHrhl+js=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j+D7S7z27z0D6eXRoU1DfM/1dn6ipXWsdTLxlruhgvUpmIZq+PaXEROMYC8f6MkYUudc8vOPcNlib0DnmqmqIqOx+NPGhMgSB3ZHyrvQQV2i7dvskWhnwpRXJJ8YxoBilrLgcDcc5J66Y4PHIWjtD/t3f2787L2kZLwD/llMjUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SXb1a5V8; arc=none smtp.client-ip=91.218.175.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SXb1a5V8"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ETo6rrudRG5VauPFMeWtsoPSY1bTtsOWTm1BHrhl+js=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790587977; v=1; x=1791192777;
 b=SXb1a5V8y3/3o4wUTqqyyT4lJQUh7wuhXBXSVGpP3LnGzZcEqtkj4i5hwQxt+9bpAbzeSgTU
 +2V9Zz/G3WquoqvAnMXL4VrbcDi8SijUiGtHD3jalhhrBdn2Hk6gM/PWVZfZAZcC+l7Np1jHxUq
 DdyYU+28bKYQszg1bV7U2kxQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a2bb7aa19e2d68f4;
	Mon, 28 Sep 2026 09:32:57 +0000
X-Mizu-Trace-ID: a2bb7aa19e2d68f4
X-Migadu-Flow: FLOW_OUT
Message-ID: <b28adf8c-a147-4452-8f70-ba1db616fae8@linux.dev>
Date: Mon, 28 Sep 2026 17:32:54 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-next v2 2/2] cgroup/cpuset: Remove CS_CPU_EXCLUSIVE
 handling code from v2
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hui Peng <benquike@gmail.com>
References: <20260927215319.382422-1-longman@redhat.com>
 <20260927215319.382422-3-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20260927215319.382422-3-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/9/28 05:53, Waiman Long 写道:
> As the is_cpu_exclusive() function is only used for DEADLINE shrink
> test with v1 there is no need to have the CS_CPU_EXCLUSIVE flag set on
> valid partition root anymore. Remove update_partition_exclusive_flag()
> and other CS_CPU_EXCLUSIVE flag handling code in cpuset.c.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/cgroup/cpuset.c | 52 ++++--------------------------------------
>  1 file changed, 4 insertions(+), 48 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 104fe10c336d..4a915da37bb3 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1174,25 +1174,6 @@ enum partition_cmd {
>  static void update_sibling_cpumasks(struct cpuset *parent, struct cpuset *cs,
>  				    struct tmpmasks *tmp);
>  
> -/*
> - * Update partition exclusive flag
> - *
> - * Return: 0 if successful, an error code otherwise
> - */
> -static int update_partition_exclusive_flag(struct cpuset *cs, int new_prs)
> -{
> -	bool exclusive = (new_prs > PRS_MEMBER);
> -
> -	if (exclusive && !is_cpu_exclusive(cs)) {
> -		if (cpuset_update_flag(CS_CPU_EXCLUSIVE, cs, 1))
> -			return PERR_NOTEXCL;
> -	} else if (!exclusive && is_cpu_exclusive(cs)) {
> -		/* Turning off CS_CPU_EXCLUSIVE will not return error */
> -		cpuset_update_flag(CS_CPU_EXCLUSIVE, cs, 0);
> -	}
> -	return 0;
> -}
> -
>  /*
>   * Update partition load balance flag and/or rebuild sched domain
>   *
> @@ -1248,11 +1229,9 @@ static void reset_partition_data(struct cpuset *cs)
>  
>  	lockdep_assert_held(&callback_lock);
>  
> -	if (cpumask_empty(cs->exclusive_cpus)) {
> +	if (cpumask_empty(cs->exclusive_cpus))
>  		cpumask_clear(cs->effective_xcpus);
> -		if (is_cpu_exclusive(cs))
> -			clear_bit(CS_CPU_EXCLUSIVE, &cs->flags);
> -	}
> +
>  	if (!cpumask_and(cs->effective_cpus, parent->effective_cpus, cs->cpus_allowed))
>  		cpumask_copy(cs->effective_cpus, parent->effective_cpus);
>  }
> @@ -2028,19 +2007,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  	if (!adding && !deleting && (new_prs == old_prs))
>  		return 0;
>  
> -	/*
> -	 * Transitioning between invalid to valid or vice versa may require
> -	 * changing CS_CPU_EXCLUSIVE. In the case of partcmd_update,
> -	 * validate_change() has already been successfully called and
> -	 * CPU lists in cs haven't been updated yet. So defer it to later.
> -	 */
> -	if ((old_prs != new_prs) && (cmd != partcmd_update))  {
> -		int err = update_partition_exclusive_flag(cs, new_prs);
> -
> -		if (err)
> -			return err;
> -	}
> -
>  	/*
>  	 * Change the parent's effective_cpus & effective_xcpus (top cpuset
>  	 * only).
> @@ -2063,9 +2029,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  
>  	spin_unlock_irq(&callback_lock);
>  
> -	if ((old_prs != new_prs) && (cmd == partcmd_update))
> -		update_partition_exclusive_flag(cs, new_prs);
> -
>  	if (adding || deleting) {
>  		cpuset_update_tasks_cpumask(parent, tmp->addmask);
>  		update_sibling_cpumasks(parent, cs, tmp);
> @@ -2942,10 +2905,6 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>  	if (alloc_tmpmasks(&tmpmask))
>  		return -ENOMEM;
>  
> -	err = update_partition_exclusive_flag(cs, new_prs);
> -	if (err)
> -		goto out;
> -
>  	if (!old_prs) {
>  		/*
>  		 * cpus_allowed and exclusive_cpus cannot be both empty.
> @@ -3009,13 +2968,10 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>  	}
>  out:
>  	/*
> -	 * Make partition invalid & disable CS_CPU_EXCLUSIVE if an error
> -	 * happens.
> +	 * Make partition invalid if an error happens.
>  	 */
> -	if (err) {
> +	if (err)
>  		new_prs = -new_prs;
> -		update_partition_exclusive_flag(cs, new_prs);
> -	}
>  
>  	spin_lock_irq(&callback_lock);
>  	cs->partition_root_state = new_prs;

Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Thanks,
Guopeng
