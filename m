Received: from mta0.migadu.com (out-222.mta0.migadu.com [91.218.175.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E083385A7
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 01:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790733443; cv=none; b=BRAPca495D6r9nou0KEN4VtsnNTlkomce8NFxR14OpDbcQIe3qPLXW6biM8/snZ7EV2Hrqqhao/7xOUOt+swrf7o+WacXb84d+TIK3q7u+9h2q0tLwl4DjP+fiuiKl94QO+JF6h8Nvzxl9uWcHmfh5phS/W79cNMdCs5EXYkPeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790733443; c=relaxed/simple;
	bh=4gjicBS7+xysVtPZ+uaOJ5pxKfc6JICBFUNecihq6yc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OwCUdw8uvIU7F2pUIFsrJ5WYLBIZ+/xyrf3IrHCFK8UIf93Ko0HVQYNBntq0s9i8qADvzOzEnLTTE1fcWyF4sccuEsKF5Ap8BUZS1yErNuas2CJgPvBzRACI42SqD+UDDQO6wAQBsAqqEQGAGGCCKnjzIttaAf+tc1LNw93KmGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kwOmY4wI; arc=none smtp.client-ip=91.218.175.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kwOmY4wI"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=4gjicBS7+xysVtPZ+uaOJ5pxKfc6JICBFUNecihq6yc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790733439; v=1; x=1791338239;
 b=kwOmY4wIgw4XHLor6rKvK7NqOzLf3zOoM7lxfsgtXGn7oe7E4IcClBGV+ENgMQ4J9Az7hGsK
 plOq9zRL0SOsEO1wTdpmizyu8AyooOXvhiRTrv/HEWoUlPmnXKEh62GnalaVSFk/1a5bHww5kng
 FhEV4NRTb665S2MJBuGqiV44=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id adc322b5cf7af8d2;
	Wed, 30 Sep 2026 01:57:19 +0000
X-Mizu-Trace-ID: adc322b5cf7af8d2
X-Migadu-Flow: FLOW_OUT
Message-ID: <3d8bbe2c-8baa-43a6-9926-66669b96bfb9@linux.dev>
Date: Wed, 30 Sep 2026 09:57:11 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup/cpuset: Don't access cpuset_cgrp_subsys.root in
 is_in_v2_mode()
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Andrea Righi <arighi@nvidia.com>
References: <20260930012819.651526-1-longman@redhat.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260930012819.651526-1-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/30/2026 9:28 AM, Waiman Long wrote:
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
>   kernel/cgroup/cpuset.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 19661df6244f..266ce17d1af0 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -147,6 +147,11 @@ static cpumask_var_t	subpartitions_cpus;	/* RWCS */
>    */
>   static cpumask_var_t	isolated_cpus;		/* CSCB */
>   
> +/*
> + * Set if "cpuset_v2_mode" mount option is used
> + */
> +static bool		cpuset_v2_mode;		/* Unprotected */
> +

Nit.

`Unprotected` is wired here, will it be better with:

/* Cached at bind time; accessed via {READ,WRITE}_ONCE */

>   /*
>    * Set if housekeeping cpumasks are to be updated.
>    */
> @@ -439,8 +444,7 @@ static inline bool cpuset_v2(void)
>    */
>   static inline bool is_in_v2_mode(void)
>   {
> -	return cpuset_v2() ||
> -	      (cpuset_cgrp_subsys.root->flags & CGRP_ROOT_CPUSET_V2_MODE);
> +	return cpuset_v2() || READ_ONCE(cpuset_v2_mode);
>   }
>   
>   /**
> @@ -3664,6 +3668,8 @@ static void cpuset_bind(struct cgroup_subsys_state *root_css)
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

