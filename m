From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch] mm, memcg: provide an anon_reclaimable stat
Date: Fri, 17 Jul 2020 10:39:02 -0400
Message-ID: <20200717143902.GA266388@cmpxchg.org>
References: <20200715071522.19663-1-sjpark@amazon.com>
 <alpine.DEB.2.23.453.2007151031020.2788464@chino.kir.corp.google.com>
 <alpine.DEB.2.23.453.2007161357490.3209847@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=STv7WsxvA8+TLcU34mj2MS3Xd7Gr7Bu4P1KzwtIAOuE=;
        b=nxkPNAOOmMGSq8vdVAA45szRlpUlEv1fwfOC/OOzpgnTUQHlx85q/CguxHfQAzzEJD
         8klFI7rewse8RvzYNgGppXlmSetz04nEL8MZ6IQdzlPEERJj5iHptUllNKRePqwhTg+4
         RaDMHisQI+f8ikCcgQGwdRk9s5MoR6ZMQ1TA/1sx5NletxVp3ubJ7LNHbYThF00qLfcI
         KisWyutsRTi24ry8UsqpxYbxaKW01FZkYeASduAh6oXvL/5EdEMRU//NZjMDQmnnWfAC
         xK8+loM+0EYxajNdy33qCNAqyc85ZB8hBeynDAUnBAFw0/M8ZcBXlJ3IQqVbIsUOvvTF
         Jo2A==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.23.453.2007161357490.3209847-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: SeongJae Park <sjpark-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, Jul 16, 2020 at 01:58:19PM -0700, David Rientjes wrote:
> @@ -1350,6 +1350,32 @@ static bool mem_cgroup_wait_acct_move(struct mem_cgroup *memcg)
>  	return false;
>  }
>  
> +/*
> + * Returns the amount of anon memory that is charged to the memcg that is
> + * reclaimable under memory pressure without swap, in pages.
> + */
> +static unsigned long memcg_anon_reclaimable(struct mem_cgroup *memcg)
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

Unfortunately, we don't know if these have been reused after the
madvise until we actually do the rmap walk in page reclaim. All of
these could have dirty ptes and require swapout after all.

The MADV_FREE tradeoff was that the freed pages can get reused by
userspace without another context switch and tlb flush in the common
case, by exploiting the fact that the MMU sets the dirty bit for
us. The downside is that the kernel doesn't know what state these
pages are in until it takes a close-up look at them one by one.
