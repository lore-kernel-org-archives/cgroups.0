From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH v5 5/7] mm: rework non-root kmem_cache lifecycle
 management
Date: Tue, 28 May 2019 21:00:26 +0300
Message-ID: <20190528180026.zb6yaxdeapwx5r3v@esperanza>
References: <20190521200735.2603003-1-guro@fb.com>
 <20190521200735.2603003-6-guro@fb.com>
 <20190528170828.zrkvcdsj3d3jzzzo@esperanza>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gzRimgoeRu7R/UsHOkPXtR9NqQokG6oQDoPTeeW4GsA=;
        b=K5mTZO29tbBaLBfmC9xktb9UyEHFJm7cNGH2ho7TmDNYxAatoyUag706Zd7cjqjf28
         KkeBW1GaNsqZpGtuXpPL2jgCnJM5DuHaiEWuudtfGOhqTqHMJOGDCHv8YAGmcWlXiSLK
         tvB79wzMLr5Um6QS7j3cKNsAv1752T6NIpZ/9dqKNuDh+uFqgoopmTVuvev/Ic1UEPV9
         POninSj+/FBXrDQrPHxHzYlplgfdBdt11aQdVLcmU7bI3aGISf73jtSTKnsqq7hOE1Hl
         V+x+dWvcxXzA/c6PZ2CFDN+iGZBodzbs4Zs7PsfeskXJix3j7cStbEXLgSLKM7CJ7KPj
         kKnQ==
Content-Disposition: inline
In-Reply-To: <20190528170828.zrkvcdsj3d3jzzzo@esperanza>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeelb@google.com>, Christoph Lameter <cl@linux.com>, cgroups@vger.kernel.org, Waiman Long <longman@redhat.com>

On Tue, May 28, 2019 at 08:08:28PM +0300, Vladimir Davydov wrote:
> Hello Roman,
> 
> On Tue, May 21, 2019 at 01:07:33PM -0700, Roman Gushchin wrote:
> > This commit makes several important changes in the lifecycle
> > of a non-root kmem_cache, which also affect the lifecycle
> > of a memory cgroup.
> > 
> > Currently each charged slab page has a page->mem_cgroup pointer
> > to the memory cgroup and holds a reference to it.
> > Kmem_caches are held by the memcg and are released with it.
> > It means that none of kmem_caches are released unless at least one
> > reference to the memcg exists, which is not optimal.
> > 
> > So the current scheme can be illustrated as:
> > page->mem_cgroup->kmem_cache.
> > 
> > To implement the slab memory reparenting we need to invert the scheme
> > into: page->kmem_cache->mem_cgroup.
> > 
> > Let's make every page to hold a reference to the kmem_cache (we
> > already have a stable pointer), and make kmem_caches to hold a single
> > reference to the memory cgroup.
> 
> Is there any reason why we can't reference both mem cgroup and kmem
> cache per each charged kmem page? I mean,
> 
>   page->mem_cgroup references mem_cgroup
>   page->kmem_cache references kmem_cache
>   mem_cgroup references kmem_cache while it's online
> 
> TBO it seems to me that not taking a reference to mem cgroup per charged
> kmem page makes the code look less straightforward, e.g. as you
> mentioned in the commit log, we have to use mod_lruvec_state() for memcg
> pages and mod_lruvec_page_state() for root pages.

I think I completely missed the point here. In the following patch you
move kmem caches from a child to the parent cgroup on offline (aka
reparent them). That's why you can't maintain page->mem_cgroup. Sorry
for misunderstanding.
