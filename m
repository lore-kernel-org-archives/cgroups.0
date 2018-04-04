From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/3] mm: memcontrol: Use cgroup_rstat for event accounting
Date: Wed, 4 Apr 2018 10:08:55 -0400
Message-ID: <20180404140855.GA28966@cmpxchg.org>
References: <20180324160901.512135-1-tj@kernel.org>
 <20180324160901.512135-2-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YKal12uGutGg8W7Aqt2cr8p8hPK22ME6PRh+ImrD7cQ=; b=HiTyPycMd6wPT2mX600ZCoUB06
        aGez13+l3G22o1kIu3kYA0hxEDNRm1SIjQYqj3TMowjXtG1K/ghOFQqgOR18NzYJ2lZxfaxS8A3sL
        +suiOmX/1CtpR5N7RuTrGaxfs4A4H4SfCY7349ISSmkI3gQJ6izPcQ7lorTjt7Incg9U=;
Content-Disposition: inline
In-Reply-To: <20180324160901.512135-2-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: mhocko@kernel.org, vdavydov.dev@gmail.com, guro@fb.com, riel@surriel.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, linux-mm@kvack.org

On Sat, Mar 24, 2018 at 09:08:59AM -0700, Tejun Heo wrote:
> @@ -91,6 +91,9 @@ struct mem_cgroup_stat_cpu {
>  	unsigned long events[MEMCG_NR_EVENTS];
>  	unsigned long nr_page_events;
>  	unsigned long targets[MEM_CGROUP_NTARGETS];
> +
> +	/* for cgroup rstat delta calculation */
> +	unsigned long last_events[MEMCG_NR_EVENTS];
>  };
>  
>  struct mem_cgroup_reclaim_iter {
> @@ -233,7 +236,11 @@ struct mem_cgroup {
>  
>  	struct mem_cgroup_stat_cpu __percpu *stat_cpu;
>  	atomic_long_t		stat[MEMCG_NR_STAT];
> -	atomic_long_t		events[MEMCG_NR_EVENTS];
> +
> +	/* events is managed by cgroup rstat */
> +	unsigned long long	events[MEMCG_NR_EVENTS];	/* local */
> +	unsigned long long	tree_events[MEMCG_NR_EVENTS];	/* subtree */
> +	unsigned long long	pending_events[MEMCG_NR_EVENTS];/* propagation */

The lazy updates are neat, but I'm a little concerned at the memory
footprint. On a 64-cpu machine for example, this adds close to 9000
words to struct mem_cgroup. And we really only need the accuracy for
the 4 cgroup items in memory.events, not all VM events and stats.

Why not restrict the patch to those? It would also get rid of the
weird sharing between VM and cgroup enums.
