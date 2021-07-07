From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 10/18] mm/memcg: Convert mem_cgroup_uncharge() to take
 a folio
Date: Wed, 7 Jul 2021 13:09:05 +0100
Message-ID: <YOWZYWWQvGSVeCs9@casper.infradead.org>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-11-willy@infradead.org>
 <YN1sHPnWUysOZiJm@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RXoWcuIuDvfEGN36dlaWaQFgjdyKKyiHEIwv1084Sds=; b=dOeQ1dmEFArkaUwQG0GlkB/Y9C
        bDVBYDR1vEAJslZf/p4DKECDxKXSGnbscuT9ClyULCkJ2Rof48rCeXy1uSNem1vVUJvcv7E2nLenF
        mHcqmGHR9eKBEr/xTP+AP5UwpJXg+F0gQXCP16t2mL8kzKlXvhqCjfTv7FhxqxE5tD5fX0mwXQST2
        5tlVl62OZunHsjopsZIKCqD16RmPYahjVUp0Q0WYsvD8HYq0t2FZl75ji3mfzl7o/54P0B/7+vHot
        KAGJcsUvbdap0kQ/RYVZqMTAXE5x5CobSi6YidZGE77tj2o094yBmFmr4HgbFhqltTD4tQspCmKQH
        ZYk/LzLw==;
Content-Disposition: inline
In-Reply-To: <YN1sHPnWUysOZiJm-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu, Jul 01, 2021 at 08:17:48AM +0100, Christoph Hellwig wrote:
> On Wed, Jun 30, 2021 at 05:00:26AM +0100, Matthew Wilcox (Oracle) wrote:
> > -void mem_cgroup_uncharge(struct page *page);
> > +void mem_cgroup_uncharge(struct folio *);
> 
> why do you drop the parameter name?

I usually do where it's 'struct foo *foo' or 'foo_t foo'.  If the best
you can do is say "it's a page", well, yes, I knew that from the type.
But since you've complained, I've added the pointless 'folio' to it.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
