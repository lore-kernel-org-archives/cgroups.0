From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 12/46] mm/memcg: Use the node id in
 mem_cgroup_update_tree()
Date: Fri, 25 Jun 2021 10:05:35 +0200
Message-ID: <YNWOT2iAyo6xtR17@dhcp22.suse.cz>
References: <20210622121551.3398730-1-willy@infradead.org>
 <20210622121551.3398730-13-willy@infradead.org>
 <YNLs+CXPpULk8Y/3@infradead.org>
 <YNSwqfX1EwJccIeu@casper.infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624608337; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zcKRugiQvtyy62Ukgu1W5M8aUXyIgtq7LR6SD9mke1g=;
        b=XtVADPq0THcmtBiqyCLp58Xj8c1uHH3YCFEiYP7MRwbd4BP++b68Cj95158F+4ZlVsuX8L
        ETJoDakF1T7ntRNQrNIs08+qqanBR6SleRr7CTXpExPvUV88U7IDJh704Khsw+G5pJOV10
        JnJxNb+Gcx5LlcnV0uB97EbjEb5LD+Q=
Content-Disposition: inline
In-Reply-To: <YNSwqfX1EwJccIeu-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 24-06-21 17:19:53, Matthew Wilcox wrote:
> On Wed, Jun 23, 2021 at 10:12:40AM +0200, Christoph Hellwig wrote:
> > On Tue, Jun 22, 2021 at 01:15:17PM +0100, Matthew Wilcox (Oracle) wrote:
> > >  static struct mem_cgroup_per_node *
> > > -mem_cgroup_page_nodeinfo(struct mem_cgroup *memcg, struct page *page)
> > > +mem_cgroup_nodeinfo(struct mem_cgroup *memcg, int nid)
> > >  {
> > > -	int nid = page_to_nid(page);
> > > -
> > >  	return memcg->nodeinfo[nid];
> > >  }
> > 
> > I'd just kill this function entirely and open code it into the only
> > caller
> 
> Done.

This makes sense.

> > > -	mctz = soft_limit_tree_from_page(page);
> > > +	mctz = soft_limit_tree_node(nid);
> > 
> > And while were at it, soft_limit_tree_node seems like a completely
> > pointless helper that does nothing but obsfucating the code.  While
> > you touch this area it might be worth to spin another patch to just
> > remove it as well.

Yeah, the whole soft limit reclaim code is kinda pain to even look at.
Opencoding those two will certainly not make it worse so fine with me.

> I'm scared that if I touch this file too much, people will start to
> think I know something about memcgs.  Happy to add it on; cc'ing
> maintainers.

get_maintainers will surely notice ;)

-- 
Michal Hocko
SUSE Labs
