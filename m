From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 3/3] memcg: reduce size of memcg vmstats structures
Date: Fri, 9 Sep 2022 02:23:02 +0200
Message-ID: <YxqHZtOx2+LUYZth@blackbook>
References: <20220907043537.3457014-1-shakeelb@google.com>
 <20220907043537.3457014-4-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1662682984; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RUcUYAJZGU901kXStidccK27lsK7j2zOm94hwmU7LWc=;
        b=p3QIvpvvl1+OlHebZtJU5545iMnFcY++IJbcSYaNlcbllQWhTrKccHI+ZKQu1Ppix3rQsk
        78KYNcOprAr6pSy/mMr57cubhvkeX0n6mcs8iwaIN/7DOBLF73HQEwlRHVr5dm3vMsV/zo
        FlmTC47AB1hzLgp6jz/TBPL5aSIfWqc=
Content-Disposition: inline
In-Reply-To: <20220907043537.3457014-4-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello.

On Wed, Sep 07, 2022 at 04:35:37AM +0000, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>  /* Subset of vm_event_item to report for memcg event stats */
>  static const unsigned int memcg_vm_event_stat[] = {
> +	PGPGIN,
> +	PGPGOUT,
>  	PGSCAN_KSWAPD,
>  	PGSCAN_DIRECT,
>  	PGSTEAL_KSWAPD,

What about adding a dummy entry at the beginning like:

 static const unsigned int memcg_vm_event_stat[] = {
+	NR_VM_EVENT_ITEMS,
+	PGPGIN,
+	PGPGOUT,
 	PGSCAN_KSWAPD,
 	PGSCAN_DIRECT,


> @@ -692,14 +694,30 @@ static const unsigned int memcg_vm_event_stat[] = {
>  #endif
>  };
>  
> +#define NR_MEMCG_EVENTS ARRAY_SIZE(memcg_vm_event_stat)
> +static int mem_cgroup_events_index[NR_VM_EVENT_ITEMS] __read_mostly;
> +
> +static void init_memcg_events(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < NR_MEMCG_EVENTS; ++i)
> +		mem_cgroup_events_index[memcg_vm_event_stat[i]] = i + 1;

Start such loops from i = 1, save i to the table.

> +}
> +
> +static inline int memcg_events_index(enum vm_event_item idx)
> +{
> +	return mem_cgroup_events_index[idx] - 1;
> +}

And the there'd be no need for the reverse transforms -1.

I.e. it might be just a negligible micro-optimization but since the
event updates are on some fast (albeit longer) paths, it may be worth
sacrificing one of the saved 8Bs in favor of no arithmetics.

What do you think about this?

>  static unsigned long memcg_events(struct mem_cgroup *memcg, int event)
>  {
> -	return READ_ONCE(memcg->vmstats->events[event]);
> +	int index = memcg_events_index(event);
> +
> +	if (index < 0)
> +		return 0;

As a bonus these undefined maps could use the zero at the dummy location
without branch (slow paths though).


> @@ -5477,7 +5511,7 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
>  			parent->vmstats->state_pending[i] += delta;
>  	}
>  
> -	for (i = 0; i < NR_VM_EVENT_ITEMS; i++) {
> +	for (i = 0; i < NR_MEMCG_EVENTS; i++) {

I applaud this part :-)


Michal
