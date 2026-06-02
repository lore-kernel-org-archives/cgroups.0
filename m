Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B93E363C7F
	for <cgroups@vger.kernel.org>; Tue,  2 Jun 2026 13:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780407660; cv=none; b=ul2+GN32sOXC3xO+2C3THsQoGjzx0MYG/uwMAbkOByydiZwkeGymUCOPqtnYm58SvP9LqBJivI4Q07W1brc+gf5wFeev3SFanloWToSUQE0aMulOLpeF6u9StqH3ES9+oiNUPuUQEhErcbD/uVxNEgAIN/fUHykWPOvdQ91OlXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780407660; c=relaxed/simple;
	bh=TaTackL1FweCj2bGM4u47L293AwMdUJA8ySvdzIUWxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Scf/CWhHHBEYIe6Wi5OOEsbkpJyKjQIyKjq3lJQsTNyJtWfYi4Bx4HndSGKMxNhxvH7Ihry8R4yfSZ1hBFC2XcNUkb85sPqtHEYFndEak68obUL++9anqoFez/6CHIj8A5fDFL1PasKgc+hfQTlvTfJl9v0ldt57GLWbY/U/IeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OnZVFc4Z; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OnZVFc4Z"
Message-ID: <3776c490-f618-409b-b499-42f586a2acff@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780407646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rhvp0LBbA5W0BiQIUOQz5t+QYq2pweGffHyXDXdyOJw=;
	b=OnZVFc4ZNYGOBEESBJiT17XEGBElAUS+0iCfV0l+Jzvzi9ouIjsuR6dwOT4Xm9kBmJbOAd
	5ei57DAxQHf5jVHKJXAgl/Q+rhRYOVcFhysjsTJDD9cVs1Hpel7nfi2q7rw4nea6vFREJ9
	GH/MMPZaOKs1EKrt+v9qt50HhUv6HtA=
Date: Tue, 2 Jun 2026 21:40:35 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH-next v5 2/6] cgroup/cpuset: Add a cpuset_reserve_dl_bw()
 helper
To: Waiman Long <longman@redhat.com>, Chen Ridong
 <chenridong@huaweicloud.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Peter Zijlstra <peterz@infradead.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Aaron Tomlin <atomlin@atomlin.com>, Guopeng Zhang <guopeng.zhang@linux.dev>
References: <20260602023203.248077-1-longman@redhat.com>
 <20260602023203.248077-3-longman@redhat.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260602023203.248077-3-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 2026/6/2 10:31, Waiman Long wrote:
> Extract the DL bandwidth allocation code in cpuset_attach() to a new
> cpuset_reserve_dl_bw() helper to simplify code.
> 
> No functional change is expected.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>

LGTM.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>

> ---
>  kernel/cgroup/cpuset.c | 53 ++++++++++++++++++++++++------------------
>  1 file changed, 30 insertions(+), 23 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 987456b6d879..5c1f3ee48d5d 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2991,6 +2991,25 @@ static int cpuset_can_attach_check(struct cpuset *cs)
>  	return 0;
>  }
>  
> +static int cpuset_reserve_dl_bw(struct cpuset *cs)
> +{
> +	int cpu, ret;
> +
> +	if (!cs->sum_migrate_dl_bw)
> +		return 0;
> +
> +	cpu = cpumask_any_and(cpu_active_mask, cs->effective_cpus);
> +	if (unlikely(cpu >= nr_cpu_ids))
> +		return -EINVAL;
> +
> +	ret = dl_bw_alloc(cpu, cs->sum_migrate_dl_bw);
> +	if (ret)
> +		return ret;
> +
> +	cs->dl_bw_cpu = cpu;
> +	return 0;
> +}
> +
>  static void reset_migrate_dl_data(struct cpuset *cs)
>  {
>  	cs->nr_migrate_dl_tasks = 0;
> @@ -3005,7 +3024,7 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
>  	struct cpuset *cs, *oldcs;
>  	struct task_struct *task;
>  	bool setsched_check;
> -	int cpu, ret;
> +	int ret;
>  
>  	/* used later by cpuset_attach() */
>  	cpuset_attach_old_cs = task_cs(cgroup_taskset_first(tset, &css));
> @@ -3061,31 +3080,19 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
>  		}
>  	}
>  
> -	if (!cs->sum_migrate_dl_bw)
> -		goto out_success;
> -
> -	cpu = cpumask_any_and(cpu_active_mask, cs->effective_cpus);
> -	if (unlikely(cpu >= nr_cpu_ids)) {
> -		ret = -EINVAL;
> -		goto out_unlock;
> -	}
> -
> -	ret = dl_bw_alloc(cpu, cs->sum_migrate_dl_bw);
> -	if (ret)
> -		goto out_unlock;
> -
> -	cs->dl_bw_cpu = cpu;
> -
> -out_success:
> -	/*
> -	 * Mark attach is in progress.  This makes validate_change() fail
> -	 * changes which zero cpus/mems_allowed.
> -	 */
> -	cs->attach_in_progress++;
> +	ret = cpuset_reserve_dl_bw(cs);
>  
>  out_unlock:
> -	if (ret)
> +	if (ret) {
>  		reset_migrate_dl_data(cs);
> +	} else {
> +		/*
> +		 * Mark attach is in progress.  This makes validate_change() fail
> +		 * changes which zero cpus/mems_allowed.
> +		 */
> +		cs->attach_in_progress++;
> +	}
> +
>  	mutex_unlock(&cpuset_mutex);
>  	return ret;
>  }

-- 
Best regards,
Ridong
