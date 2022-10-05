From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2] mm/vmscan: check references from all memcgs for
 swapbacked memory
Date: Wed, 5 Oct 2022 15:49:47 -0400
Message-ID: <Yz3f23fPHEx1XJLJ@cmpxchg.org>
References: <20221005173713.1308832-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=KTsXqBLMJ7z5zDaMVeB3mFtjBOaAR2nLT0zyd4+BXeg=;
        b=rL48SW7QvdXgLHL74fCHo4SV8KfIpBhdqZiIQkFNh26QO0TTK/n2jD7rLs5fjZNgXX
         yqzl+73lIDTO9Wo+L+sKEUh5VTyKcrOARmxgyzCkLnBzZGOYGKz1LMCzJrk8y5VEvrXl
         SL9TmligGaKXnhQ7moybwxP0quMm54chKS1ExXoghqPYamj7omGSHq8jkHq0MYM5geLn
         7RLi84RADnmvjggV2xnJHWsRaTXaqRCHbsd+hBNFTax2A3pXm2Lxz0alAp1GkgBPI9f6
         phptnuyHdseoFF1K7kCZfEqfVIJxshHn4QPHCyLp5ZcLGdzlRzgkd9J+CROfJfxgtMrv
         7s2w==
Content-Disposition: inline
In-Reply-To: <20221005173713.1308832-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, Oct 05, 2022 at 05:37:13PM +0000, Yosry Ahmed wrote:
> During page/folio reclaim, we check if a folio is referenced using
> folio_referenced() to avoid reclaiming folios that have been recently
> accessed (hot memory). The rationale is that this memory is likely to be
> accessed soon, and hence reclaiming it will cause a refault.
> 
> For memcg reclaim, we currently only check accesses to the folio from
> processes in the subtree of the target memcg. This behavior was
> originally introduced by commit bed7161a519a ("Memory controller: make
> page_referenced() cgroup aware") a long time ago. Back then, refaulted
> pages would get charged to the memcg of the process that was faulting them
> in. It made sense to only consider accesses coming from processes in the
> subtree of target_mem_cgroup. If a page was charged to memcg A but only
> being accessed by a sibling memcg B, we would reclaim it if memcg A is
> is the reclaim target. memcg B can then fault it back in and get charged
> for it appropriately.
> 
> Today, this behavior still makes sense for file pages. However, unlike
> file pages, when swapbacked pages are refaulted they are charged to the
> memcg that was originally charged for them during swapping out. Which
> means that if a swapbacked page is charged to memcg A but only used by
> memcg B, and we reclaim it from memcg A, it would simply be faulted back
> in and charged again to memcg A once memcg B accesses it. In that sense,
> accesses from all memcgs matter equally when considering if a swapbacked
> page/folio is a viable reclaim target.
> 
> Modify folio_referenced() to always consider accesses from all memcgs if
> the folio is swapbacked.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
