From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol:rewrite mem_cgroup_page_lruvec()
Date: Fri, 6 Nov 2020 17:30:14 -0800
Message-ID: <20201106173014.e13b5fe5edec41d1f7fdf072@linux-foundation.org>
References: <20201104142516.GA106571@rlk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604712615;
        bh=5ja+hHDhLaw834klWxEIsEobJjKzEYlU1fK3r77mU5g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jZrN5F7/+Zu3GmPA5iLrAhldT/HnmmgsyZF2eKJZ9aZUKndfgBlXBzDVBKRlKB20J
         gnoQgoeBoM9JlKv5BRD526px7a20WshtiPv/94Md18VkK2B5uF32W2PcQAXlnjhxJP
         wyfF6u9yfTq52lPBu14DkQlLqPNi719Z1w4wjAJ4=
In-Reply-To: <20201104142516.GA106571@rlk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hui Su <sh_def-9Onoh4P/yGk@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, 4 Nov 2020 22:25:16 +0800 Hui Su <sh_def-9Onoh4P/yGk@public.gmane.org> wrote:

> mem_cgroup_page_lruvec() in memcontrol.c and
> mem_cgroup_lruvec() in memcontrol.h is very similar
> except for the param(page and memcg) which also can be
> convert to each other.
> 
> So rewrite mem_cgroup_page_lruvec() with mem_cgroup_lruvec().

Alex Shi's "mm/memcg: warning on !memcg after readahead page charged"
(https://lkml.kernel.org/r/1604283436-18880-3-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org)
changes mem_cgroup_page_lruvec() thusly:

--- a/mm/memcontrol.c~mm-memcg-warning-on-memcg-after-readahead-page-charged
+++ a/mm/memcontrol.c
@@ -1325,10 +1325,7 @@ struct lruvec *mem_cgroup_page_lruvec(st
 	}
 
 	memcg = page_memcg(page);
-	/*
-	 * Swapcache readahead pages are added to the LRU - and
-	 * possibly migrated - before they are charged.
-	 */
+	VM_WARN_ON_ONCE_PAGE(!memcg, page);
 	if (!memcg)
 		memcg = root_mem_cgroup;
 
So the patch didn't apply.

That's easily fixed, but it does make one wonder whether this:

> -struct lruvec *mem_cgroup_page_lruvec(struct page *, struct pglist_data *);
> +/**
> + * mem_cgroup_page_lruvec - return lruvec for isolating/putting an LRU page
> + * @page: the page
> + * @pgdat: pgdat of the page
> + *
> + * This function relies on page->mem_cgroup being stable.
> + */
> +static inline struct lruvec *mem_cgroup_page_lruvec(struct page *page,
> +						struct pglist_data *pgdat)
> +{
> +	struct mem_cgroup *memcg = page->mem_cgroup;
> +
> +	return mem_cgroup_lruvec(memcg, pgdat);
> +}

Should be using page_memcg()?

