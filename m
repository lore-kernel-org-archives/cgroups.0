From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/2] sched/isolation: Add cpu_is_isolated() API
Date: Mon, 13 Feb 2023 14:34:26 +0100
Message-ID: <Y+o8Yndho4fpl3IS@dhcp22.suse.cz>
References: <20230203232409.163847-1-frederic@kernel.org>
 <20230203232409.163847-3-frederic@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1676295267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=saciHrBqwPQPzdodH5ZXO9iXT8uGZbs1hjAThfGOX/I=;
        b=BC6hazDDMXHKpRkZWsOSWgGkkhDysckN0BIGsh9eYVLoFwx8ieX8PHP6IdWYj4e7wjhhNy
        4gdwyIdrR3ibbBV1z8mYpZgnP+zyuHhminpQI4ngTo2vGnhBHFQ52LNFASsHh32AJgYZHh
        vYiYeH//eF3kJ8oB0Bkc47W5tRshTgo=
Content-Disposition: inline
In-Reply-To: <20230203232409.163847-3-frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leonardo <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Sat 04-02-23 00:24:09, Frederic Weisbecker wrote:
> Provide this new API to check if a CPU has been isolated either through
> isolcpus= or nohz_full= kernel parameter.
> 
> It aims at avoiding kernel load deemed to be safely spared on CPUs
> running sensitive workload that can't bear any disturbance, such as
> pcp cache draining.
> 
> Suggested-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> Signed-off-by: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Is there any locking required? I do not think so as these should be
boot time configured AFAIR. From the discussion around this I have
understood that this might change in the future once cpusets gain a
better isolation support. Maybe this should be documented at this stage?

Thanks!

> ---
>  include/linux/sched/isolation.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> index b645cc81fe01..088672f08469 100644
> --- a/include/linux/sched/isolation.h
> +++ b/include/linux/sched/isolation.h
> @@ -53,4 +53,10 @@ static inline bool housekeeping_cpu(int cpu, enum hk_type type)
>  	return true;
>  }
>  
> +static inline bool cpu_is_isolated(int cpu)
> +{
> +	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN) ||
> +		 !housekeeping_test_cpu(cpu, HK_TYPE_KERNEL_NOISE);
> +}
> +
>  #endif /* _LINUX_SCHED_ISOLATION_H */
> -- 
> 2.34.1

-- 
Michal Hocko
SUSE Labs
