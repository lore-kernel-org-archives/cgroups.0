From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 13/18] mm/memcg: Add folio_memcg_lock() and
 folio_memcg_unlock()
Date: Wed, 7 Jul 2021 20:28:39 +0100
Message-ID: <YOYAZ5+xDFK0Slc8@casper.infradead.org>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-14-willy@infradead.org>
 <YOXfozcU8M/x2RQ4@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BhBZWEYcFlxuVvSAsmS5gv8zy8o+jsEbcEExhMSd3eo=; b=BrPBSSUj/JX65304k1+dRXGvWR
        dZhuNplsCU/8NOxj2QAX23zHkqjvzASJDGZg9JyRcV6Cggsd2/MeFuRbiL0eRTUP4PhIj9Mr7yIM5
        TBGA+az2hYFZMGC393mxnuIdzaH1Y7Okd1BcyLFr80krULTUd+KyPgCX6mZixz0u5Sr1oDXSTcpFd
        +/Kh0a8SgbvSh9BrcomsmviViFOmBCj4Fp8PFpXZ7VJ6ebhTa/NbNygM/CrC0DOnNubdwA067oYGJ
        y3tpw/EJXLXdKKnIPurDGyowfgMbQv0JNYXzfA1yly44GzPsN3wC6QW18Vc1jrps8hW25w2SsSFbr
        Uf7efN7w==;
Content-Disposition: inline
In-Reply-To: <YOXfozcU8M/x2RQ4-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Jul 07, 2021 at 01:08:51PM -0400, Johannes Weiner wrote:
> On Wed, Jun 30, 2021 at 05:00:29AM +0100, Matthew Wilcox (Oracle) wrote:
> > -static void __unlock_page_memcg(struct mem_cgroup *memcg)
> > +static void __memcg_unlock(struct mem_cgroup *memcg)
> 
> This is too generic a name. There are several locks in the memcg, and
> this one only locks the page->memcg bindings in the group.

Fair.  __memcg_move_unlock looks like the right name to me?
