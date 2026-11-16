Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794825299;
	b=SL4VIJMZm8mV80Mlp4YQsgDbVUrxJWAWa5X5NpBKmp98zEF/avnVxrljS+eInfKqDe60
	 5zzzZyBjZZjUsfJT+EHim3q5HaGmcYHniruuOAG8tUI77lp+gLAibkvHugHxUhnERLpWr
	 iZ9yMRbrjg23uQmGTR602YQ0OPK/4H2AVzAIASquToiIb8U8j9FGg1z7F6vA7pzuzAgNw
	 VSmC3vwshCDLys6CdOVKEeQWoiWJv0EQch2gOFSQCyKQVircx+Lhji4uC8en0ZZ9eGeEH
	 sT/Qsv3+AnoTY2/zyC7ZUfMR2z+DbvGZArS3Pp2e+1wXv1V6cSJPlDCIm2cOeZEezgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794825299;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=yikXnRJLxnLtVC9Ln+DjCqllVeUBUbcwr+u9b9IybI0=;
	b=I1U/Q0Xdq9vXB6Xxa6QylFlsh/Kxo3h/+UYYg/fcLST4YjANB8V3LXgTqc4yADzhA3uK
	 WLa34gMPrsglVKfj762niur1L5gdO3NIxNfpp5Ty0NS6zEmftxETJRihmZtlW5u5V1ZE1
	 D1C4S/wcKl8xojeLAg8ANpSqDhr+xmchUg+wLdLELpKLYWuxMxUwuQ1I0lwUl7HJ2fxUi
	 Ha4suCzeQIPU4TsXonHDtJVbPJSEbANz9fkSGfWBc0wXdbx6ZAeKZIqOS/uZPGoIt/fGU
	 Spk5sKQ/xVyxDYGEP9fLZXFribsvvMKPri2tAk5iPGQ9AreIg/ziocujuqtKvRyzrzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="n/BhCQ/g";
	arc=none smtp.remote-ip=95.215.58.176
Received: from mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA2D606A330
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 10:34:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DA2D606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=n/BhCQ/g
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=DiiFUk/4tUTLvbNzUGI2/8Tf6ZVtfi2gRA7MyWTek2I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794825297; v=1; x=1795430097;
 b=n/BhCQ/gqUAjCwWAmbZ7GXBn6RbR1/EScd9hLcXvfNFXFiFCDRX5rIALbhjs0+PqL7Fa49jo
 jsJW8TiJhVFatNkP+bx4g2i26nwZvsOxeg74gRyaP5nynntCJMKfy8TtKSclNodHBXv5T2fVsUW
 owLwFKwCIPdQAEpuE3/pwihM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 45cbc879b98febbf;
	Mon, 16 Nov 2026 10:34:57 +0000
X-Mizu-Trace-ID: 45cbc879b98febbf
X-Migadu-Flow: FLOW_OUT
Message-ID: <e330c9bd-c454-4bdd-b786-052dd2e263d9@linux.dev>
Date: Mon, 16 Nov 2026 18:34:53 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-next v4 6/6] cgroup/cpuset: Fix lockdep_is_cpuset_held()
To: Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20261116012330.2271010-1-longman@redhat.com>
 <20261116012330.2271010-7-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261116012330.2271010-7-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/11/16 09:23, Waiman Long 写道:
> Commit a84097e625f2 ("cgroup/cpuset: Call housekeeping_update()
> without holding cpus_read_lock") changes lockdep_is_cpuset_held()
> to return true if either cpuset_mutex or cpuset_top_mutex is held.
> lockdep_is_cpuset_held() is used by housekeeping_dereference_check()
> as one of the conditions that rcu_read_lock() is not needed to
> access HK_TYPE_DOMAIN cpumask that can be changed at run time.
> In reality, it should return true only if cpuset_top_mutex is held as
> housekeeping_update() is called with only cpuset_top_mutex held.
> 
> If only cpuset_mutex is held, it is possible that there can be a parallel
> housekeeping_update() call leading to a potential use-after-free situation
> when HK_TYPE_DOMAIN housekeeping cpumask is being accessed. It also
> means that rcu_read_lock will be required if only cpuset_mutex is being
> held like when calling from hotplug, scheduler or cgroup.
> 
> Fixes: a84097e625f2 ("cgroup/cpuset: Call housekeeping_update() without holding cpus_read_lock")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/cgroup/cpuset-v1.c | 16 ++++++++++------
>  kernel/cgroup/cpuset.c    |  9 +++++++--
>  2 files changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset-v1.c b/kernel/cgroup/cpuset-v1.c
> index 7c7f2887dfaf..6bf6da639fec 100644
> --- a/kernel/cgroup/cpuset-v1.c
> +++ b/kernel/cgroup/cpuset-v1.c
> @@ -686,6 +686,7 @@ int cpuset1_generate_sched_domains(cpumask_var_t **domains,
>  	int csn;		/* how many cpuset ptrs in csa so far */
>  	int i, j;		/* indices for partition finding loops */
>  	cpumask_var_t *doms;	/* resulting partition; i.e. sched domains */
> +	cpumask_var_t hk_cpus;	/* HK_TYPE_DOMAIN housekeeping CPUs */
>  	struct sched_domain_attr *dattr;  /* attributes for custom domains */
>  	int ndoms = 0;		/* number of sched domains in result */
>  	int nslot;		/* next empty doms[] struct cpumask slot */
> @@ -698,6 +699,11 @@ int cpuset1_generate_sched_domains(cpumask_var_t **domains,
>  	dattr = NULL;
>  	csa = NULL;
>  
> +	alloc_cpumask_var(&hk_cpus, GFP_KERNEL);
> +	scoped_guard(rcu) {
> +		cpumask_copy(hk_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN));
> +	}
> +

Can alloc_cpumask_var() fail? Should we add the following check?

	if (!alloc_cpumask_var(&hk_cpus, GFP_KERNEL))
		goto done;

Thanks,
Guopeng

>  	/* Special case for the 99% of systems with one, full, sched domain */
>  	if (is_sched_load_balance(&top_cpuset)) {
>  		ndoms = 1;
> @@ -710,9 +716,7 @@ int cpuset1_generate_sched_domains(cpumask_var_t **domains,
>  			*dattr = SD_ATTR_INIT;
>  			update_domain_attr_tree(dattr, &top_cpuset);
>  		}
> -		cpumask_and(doms[0], top_cpuset.effective_cpus,
> -			    housekeeping_cpumask(HK_TYPE_DOMAIN));
> -
> +		cpumask_and(doms[0], top_cpuset.effective_cpus, hk_cpus);
>  		goto done;
>  	}
>  
> @@ -736,8 +740,7 @@ int cpuset1_generate_sched_domains(cpumask_var_t **domains,
>  		 */
>  		if (!cpumask_empty(cp->cpus_allowed) &&
>  		    !(is_sched_load_balance(cp) &&
> -		      cpumask_intersects(cp->cpus_allowed,
> -					 housekeeping_cpumask(HK_TYPE_DOMAIN))))
> +		      cpumask_intersects(cp->cpus_allowed, hk_cpus)))
>  			continue;
>  
>  		if (is_sched_load_balance(cp) &&
> @@ -794,7 +797,7 @@ int cpuset1_generate_sched_domains(cpumask_var_t **domains,
>  						*(dattr + nslot) = SD_ATTR_INIT;
>  				}
>  				cpumask_or(dp, dp, csa[j]->effective_cpus);
> -				cpumask_and(dp, dp, housekeeping_cpumask(HK_TYPE_DOMAIN));
> +				cpumask_and(dp, dp, hk_cpus);
>  				if (dattr)
>  					update_domain_attr_tree(dattr + nslot, csa[j]);
>  			}
> @@ -806,6 +809,7 @@ int cpuset1_generate_sched_domains(cpumask_var_t **domains,
>  
>  done:
>  	kfree(csa);
> +	free_cpumask_var(hk_cpus);
>  
>  	/*
>  	 * Fallback to the default domain if kmalloc() failed.
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 64cbcbdbf6da..d18439e13bce 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -343,10 +343,13 @@ void cpuset_full_unlock(void)
>  }
>  
>  #ifdef CONFIG_LOCKDEP
> +/*
> + * Holding cpuset_top_mutex will guarantee that a parallel
> + * housekeeping_update() call modifying housekeeping cpumasks is not possible.
> + */
>  bool lockdep_is_cpuset_held(void)
>  {
> -	return lockdep_is_held(&cpuset_mutex) ||
> -	       lockdep_is_held(&cpuset_top_mutex);
> +	return lockdep_is_held(&cpuset_top_mutex);
>  }
>  #endif
>  
> @@ -1416,8 +1419,10 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
>  		}
>  	}
>  
> +	rcu_read_lock();
>  	cpumask_and(full_hk_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
>  		    housekeeping_cpumask(HK_TYPE_DOMAIN));
> +	rcu_read_unlock();
>  	cpumask_andnot(full_hk_cpus, full_hk_cpus, isolated_cpus);
>  	cpumask_and(full_hk_cpus, full_hk_cpus, cpu_active_mask);
>  	res = !cpumask_weight_andnot(full_hk_cpus, new_cpus);

