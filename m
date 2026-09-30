Received: from mta1.migadu.com (out-146.mta1.migadu.com [95.215.58.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A79F35C68E
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 04:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790741603; cv=none; b=tmyZXdZB0TsINTyLj6/MiZgskTbzVVR5O6B3kYDXvFcgFnTfE4YRFIZb3NLxn2/qVQGgc6lFK/+CbNiI3TebTzD27JySbFl4fyF/PPdPJss0T1jSKiG8Wp5C4pd//ub+Fubw+IiXkXC+FQ2KLUyi6BXlarJIHqs5Yv+vuTeoSxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790741603; c=relaxed/simple;
	bh=+YMgdyQ3kqxTH63sfeairkBZNu2g9beRZTZOyKzE0B0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i03kF997kDRA5DaVVfZx8qKrIJuxLN09duaEJwnOBDdpBM4YrmZoqJc+nxkB/ypqDWgR45a5+zV9ALsUo6BH6JFcgw8cZOEIreg7lBelmu8qIBtAbsBU9zlLu/ECwo5b/mi/AektkoaRQcpJAwWnYJ+AiO27nHbDb4a3WevqGNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IbKyIsrO; arc=none smtp.client-ip=95.215.58.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IbKyIsrO"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=+YMgdyQ3kqxTH63sfeairkBZNu2g9beRZTZOyKzE0B0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790741599; v=1; x=1791346399;
 b=IbKyIsrOF2G6y61qX3Mft0F3H/3HrfM+pYOdY0y5TNcQTvZ8rk+wvLbLBzH5qMuXmbel0Hc1
 gMqrYHablqtN5bcH6f6EzJoh3JDffeqxdRbqwMVSOSWub+3MX6MAoJWC791yv2Cckl4WXgUueVP
 uA+r/LMxcvWMCV+1S/55Q6Jw=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8dfc395441b677a1;
	Wed, 30 Sep 2026 04:13:19 +0000
X-Mizu-Trace-ID: 8dfc395441b677a1
X-Migadu-Flow: FLOW_OUT
Message-ID: <f00b6340-c86f-4c8d-8424-26faab877de4@linux.dev>
Date: Wed, 30 Sep 2026 12:13:13 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] cgroup/cpuset: Don't access cpuset_cgrp_subsys.root in
 is_in_v2_mode()
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Andrea Righi <arighi@nvidia.com>
References: <20260930031833.660267-1-longman@redhat.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260930031833.660267-1-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/30/2026 11:18 AM, Waiman Long wrote:
> After seeing the patch [1] to guard is_in_v2_mode() with RCU, it makes
> me realize that is_in_v2_mode() may be called in a context where a new
> cgroup filesystem is being rebound with stale cpuset_cgrp_subsys.root
> pointer. Avoid this potential UaF situation by adding a new cpuset_v2_mode
> flag which is set when the cpuset_v2_mode mount option is used. This
> flag is written into only when cpuset_bind() is being called with a
> stable cpuset_cgrp_subsys.root value. The is_in_v2_mode() helper is
> modified to read the new cpuset_v2_mode flag instead of accessing
> cpuset_cgrp_subsys.root directly.
> 
> [1] https://lore.kernel.org/lkml/20260929084124.626693-2-arighi@nvidia.com
> 
> Fixes: b8d1b8ee93df ("cpuset: Allow v2 behavior in v1 cgroup")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>   kernel/cgroup/cpuset.c | 11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)
> 
> [v2] Update the comment as suggested by Ridong
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 19661df6244f..4a2b6f154609 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -152,6 +152,12 @@ static cpumask_var_t	isolated_cpus;		/* CSCB */
>    */
>   static bool		update_housekeeping;	/* RWCS */
>   
> +/*
> + * Set if "cpuset_v2_mode" mount option is used
> + * Cached at bind time and not lock protected; accessed via {READ,WRITE}_ONCE
> + */
> +static bool		cpuset_v2_mode;
> +
>   /*
>    * Copy of isolated_cpus to be passed to housekeeping_update()
>    */
> @@ -439,8 +445,7 @@ static inline bool cpuset_v2(void)
>    */
>   static inline bool is_in_v2_mode(void)
>   {
> -	return cpuset_v2() ||
> -	      (cpuset_cgrp_subsys.root->flags & CGRP_ROOT_CPUSET_V2_MODE);
> +	return cpuset_v2() || READ_ONCE(cpuset_v2_mode);
>   }
>   
>   /**
> @@ -3664,6 +3669,8 @@ static void cpuset_bind(struct cgroup_subsys_state *root_css)
>   	mutex_lock(&cpuset_mutex);
>   	spin_lock_irq(&callback_lock);
>   
> +	WRITE_ONCE(cpuset_v2_mode,
> +		   !!(cpuset_cgrp_subsys.root->flags & CGRP_ROOT_CPUSET_V2_MODE));
>   	if (is_in_v2_mode()) {
>   		cpumask_copy(top_cpuset.cpus_allowed, cpu_possible_mask);
>   		cpumask_copy(top_cpuset.effective_xcpus, cpu_possible_mask);

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong

