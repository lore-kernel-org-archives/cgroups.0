Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF3543FD3B;
	Wed, 23 Sep 2026 15:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790176225; cv=none; b=KVECR582DBqiuGarwPFADn5mc7BLb8i/7N2Mt3cUgL1XKvoceW1SbPf281A0QpjzgrHDCj8dEXed8YfTWo6c7xaPNpnYyfGrXv/WVbieVTHZum+IG35kcFRh090fkS0lvvuZ3V3a2q6kgXtibVuSEHioRCh1j7p8cnAaQUM0t+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790176225; c=relaxed/simple;
	bh=at2ImG+nwBZnQyFS0leQzpdxnffE9yzkexjfJ7M+OA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LT3ZEyaLAZNljvwGLJNdti0R+pExiWOGoyPBGSiPHQgc3SFTM4xzH6EW+AFNXzijk5+MzRL+WI5Zt+vjZrB0tlmak9SmjlsnSiBQ+HS3JrSIzrmpzyMcgLYlMJ0/eM2DbiaMAJXfG1Te9/Jf4qf7y0aqVBHhBo0KbD7j0Bo+QNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JTnDjQjO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JTnDjQjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BE11F00893;
	Wed, 23 Sep 2026 15:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790176223;
	bh=51RRl+Xsm0NCcAOAAlXh+RlqfeUmTAnaklaOitPld54=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JTnDjQjOBZCgJaQ9iRTveKfpMXLzO7LrByaBCWAwsQmNW6GVYVSrEPmZhrKMuxYvW
	 E5yVx3t/wvFLrFq4M+XYZ6ET9wF+1hqPJMc78aCVykjWw+rbxTVecJIUWmNDAMJSvw
	 ajBGAY1dXbNCRKFNiYshITlGZQdT4VxgyuqlVP3OLz2qxsu5ykMuMy0O5CFXDQFMuz
	 2idxHeht+VSUGwbxnpjEse6U8Xexi1Wil75cN31JPH5HBUaeMPGj5OPLJjP8l/1+C3
	 en9WAF3sYi1P6iANxtSaAVIWNOE5F5yd0XQcA/wWrsgKW1Bsi0f1meB2zVtCqNt14v
	 5K8tYouOBHi2g==
Date: Wed, 23 Sep 2026 17:10:20 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Jing Wu <realwujing@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Tejun Heo <tj@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Qiliang Yuan <yuanql9@chinatelecom.cn>
Subject: Re: [PATCH v4 03/11] cgroup/cpuset: Drive kernel-noise housekeeping
 updates from isolated partitions
Message-ID: <arPr3GXOdzGmjWAT@localhost.localdomain>
References: <20260710-wujing-dhm-v4-0-2e912e5d9645@gmail.com>
 <20260710-wujing-dhm-v4-3-2e912e5d9645@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260710-wujing-dhm-v4-3-2e912e5d9645@gmail.com>

Le Fri, Jul 10, 2026 at 11:28:14AM +0800, Jing Wu a écrit :
> An isolated cpuset partition already updates the HK_TYPE_DOMAIN
> housekeeping mask.  Extend it to also update the kernel-noise masks
> (HK_TYPE_KERNEL_NOISE and HK_TYPE_MANAGED_IRQ) so that creating or
> destroying an isolated partition reconfigures the full set of
> housekeeping cpumasks.
> 
> The sched domain mask is updated first because the workqueue flush and
> timer migration paths depend on it; the kernel-noise masks are updated
> afterwards via housekeeping_update_types().
> 
> housekeeping_update() and housekeeping_update_types() are called after
> dropping cpus_read_lock and cpuset_mutex, with only cpuset_top_mutex held
> for mutual exclusion.
> 
> Co-developed-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
> Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
> Signed-off-by: Jing Wu <realwujing@gmail.com>
> ---
>  kernel/cgroup/cpuset.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 5c33ab20cc208..80f43a24d3c8a 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1347,17 +1347,36 @@ static void cpuset_update_sd_hk_unlock(void)
>  		rebuild_sched_domains_locked();
>  
>  	if (update_housekeeping) {
> +		static const unsigned long noise_types =
> +			BIT(HK_TYPE_KERNEL_NOISE) | BIT(HK_TYPE_MANAGED_IRQ);
> +
>  		update_housekeeping = false;
>  		cpumask_copy(isolated_hk_cpus, isolated_cpus);
>  
> +		mutex_unlock(&cpuset_mutex);
> +		cpus_read_unlock();
> +
>  		/*
>  		 * housekeeping_update() is now called without holding
>  		 * cpus_read_lock and cpuset_mutex. Only cpuset_top_mutex
>  		 * is still being held for mutual exclusion.
>  		 */
> -		mutex_unlock(&cpuset_mutex);
> -		cpus_read_unlock();
> +
> +		/*
> +		 * Update the sched domain mask first; it must succeed
> +		 * before the kernel-noise types because workqueue flush
> +		 * and timer migration depend on the sched domain mask.
> +		 */
>  		WARN_ON_ONCE(housekeeping_update(isolated_hk_cpus));
> +
> +		/*
> +		 * Update the kernel-noise housekeeping masks
> +		 * (HK_TYPE_KERNEL_NOISE and HK_TYPE_MANAGED_IRQ).  The tick,
> +		 * RCU and managed-interrupt state is reconfigured as the
> +		 * affected CPUs are cycled through the CPU hotplug machinery.
> +		 */
> +		WARN_ON_ONCE(housekeeping_update_types(noise_types,
> +						       isolated_hk_cpus));

We rely on the fact that target CPUs are offline in order to set them
as HK_TYPE_KERNEL_NOISE, right? So, should we keep cpus_read_lock held
to prevent from concurrent hotplug events?

Thanks.

>  		mutex_unlock(&cpuset_top_mutex);
>  	} else {
>  		cpuset_full_unlock();
> 
> -- 
> 2.43.0
> 

-- 
Frederic Weisbecker
SUSE Labs
