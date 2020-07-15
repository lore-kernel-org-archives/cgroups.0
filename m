From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] mm, memcg: provide a stat to describe reclaimable
 memory
Date: Wed, 15 Jul 2020 00:00:03 -0700 (PDT)
Message-ID: <alpine.DEB.2.23.453.2007142353350.2694999@chino.kir.corp.google.com>
References: <alpine.DEB.2.23.453.2007142018150.2667860@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=yBPygJDADyMNow8RF1wBXyoTGHqGjUzbugs5/7dNL0M=;
        b=n3ujhdyrkJ3XIm1Z2m0bjNTlOXVZRaAKbX073AtF4CoZfp+JL5moww96IYfa2Zp6CO
         Z6Hpm2uebEQCM39VwWuSv++0g/CcDGivEP6viEe3torjfdNt+1bgd5ow3ddxRujlYM1r
         Kiul0VFbezJQl35UeARAsbD+a2xyGDc6at7km2HIaGUEGtwGicYcaBJW2GGB5fUWLhel
         brUXOz/U12156GNtfE9BR15WhuZAUbuq85QdwqByA23LPsYe1f108hICSjufwSdbH/Vy
         5NHSLei0PXIsxhmxPDQ06sW0iedaGzmzOl6dLXc4qRJnfKeJNvQd4chCnVs7uO8C8FuJ
         i8/A==
In-Reply-To: <alpine.DEB.2.23.453.2007142018150.2667860-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, 14 Jul 2020, David Rientjes wrote:

> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1314,6 +1314,18 @@ PAGE_SIZE multiple when read back.
>  		Part of "slab" that cannot be reclaimed on memory
>  		pressure.
>  
> +	  avail
> +		An estimate of how much memory can be made available for
> +		starting new applications, similar to MemAvailable from
> +		/proc/meminfo (Documentation/filesystems/proc.rst).
> +
> +		This is derived by assuming that half of page cahce and
> +		reclaimable slab can be uncharged without significantly
> +		impacting the workload, similar to MemAvailable.  It also
> +		factors in the amount of lazy freeable memory (MADV_FREE) and
> +		compound pages that can be split and uncharged under memory
> +		pressure.
> +
>  	  pgfault
>  		Total number of page faults incurred
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1350,6 +1350,35 @@ static bool mem_cgroup_wait_acct_move(struct mem_cgroup *memcg)
>  	return false;
>  }
>  
> +/*
> + * Returns an estimate of the amount of available memory that can be reclaimed
> + * for a memcg, in pages.
> + */
> +static unsigned long mem_cgroup_avail(struct mem_cgroup *memcg)
> +{
> +	long deferred, lazyfree;
> +
> +	/*
> +	 * Deferred pages are charged anonymous pages that are on the LRU but
> +	 * are unmapped.  These compound pages are split under memory pressure.
> +	 */
> +	deferred = max_t(long, memcg_page_state(memcg, NR_ACTIVE_ANON) +
> +			       memcg_page_state(memcg, NR_INACTIVE_ANON) -
> +			       memcg_page_state(memcg, NR_ANON_MAPPED), 0);
> +	/*
> +	 * Lazyfree pages are charged clean anonymous pages that are on the file
> +	 * LRU and can be reclaimed under memory pressure.
> +	 */
> +	lazyfree = max_t(long, memcg_page_state(memcg, NR_ACTIVE_FILE) +
> +			       memcg_page_state(memcg, NR_INACTIVE_FILE) -
> +			       memcg_page_state(memcg, NR_FILE_PAGES), 0);
> +
> +	/* Using same heuristic as si_mem_available() */
> +	return (unsigned long)deferred + (unsigned long)lazyfree +
> +	       (memcg_page_state(memcg, NR_FILE_PAGES) +
> +		memcg_page_state(memcg, NR_SLAB_RECLAIMABLE)) / 2;
> +}
> +
>  static char *memory_stat_format(struct mem_cgroup *memcg)
>  {
>  	struct seq_buf s;
> @@ -1417,6 +1446,12 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
>  	seq_buf_printf(&s, "slab_unreclaimable %llu\n",
>  		       (u64)memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE) *
>  		       PAGE_SIZE);
> +	/*
> +	 * All values in this buffer are read individually, no implied
> +	 * consistency amongst them.
> +	 */
> +	seq_buf_printf(&s, "avail %llu\n",
> +		       (u64)mem_cgroup_avail(memcg) * PAGE_SIZE);
>  
>  	/* Accumulated memory events */
>  
> 

An alternative to this would also be to change from an "available" metric 
to an "anon_reclaimable" metric since both the deferred split queues and 
lazy freeable memory would pertain to anon.  This would no longer attempt 
to mimic MemAvailable and leave any such calculation to userspace
(anon_reclaimable + (file + slab_reclaimable) / 2).

With this route, care would need to be taken to clearly indicate that 
anon_reclaimable is not necessarily a subset of the "anon" metric since 
reclaimable memory from compound pages on deferred split queues is not 
mapped, so it doesn't show up in NR_ANON_MAPPED.

I'm indifferent to either approach and would be happy to switch to 
anon_reclaimable if others agree and doesn't foresee any extensibility 
issues.
