From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v20 08/20] mm: page_idle_get_page() does not need lru_lock
Date: Mon, 2 Nov 2020 14:49:27 +0000
Message-ID: <20201102144927.GN27442@casper.infradead.org>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-9-git-send-email-alex.shi@linux.alibaba.com>
 <20201102144110.GB724984@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9Y50BuvtY/Iv9iX09V09H3tcMOFeUq4GX0ITyW7hR88=; b=Fc5EzzbP5uGjYagLwVWe4N7rSc
        dT4LPqKUJQefMq0cWg6QZxnZyzdW0BT/rLNPNmIIzGjo6rnnJx/uNQnCaukD43QfeUz4egAOUJTEN
        EsUPSMhMJLUgnontgXLVFf1k9EJkUYkC4BpE+14S9u/W8QEbfXOis468N/nX2cczNVhkRsKScXYHY
        tpj4XWjN+CWDGuX9qefNrodCFBeuiTggLV5g0NTk4c+wGg7MWemnx0Wt1qSxG5lpOvgIFJITFzZ80
        DB3MVpy1gEYCxw9T6tPp5HHxTX30xlGavqhM697UTSooTwW0jmx5PcZIOUmXva0C6VNnW2SiHnAfe
        ROmfwCBA==;
Content-Disposition: inline
In-Reply-To: <20201102144110.GB724984-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Mon, Nov 02, 2020 at 09:41:10AM -0500, Johannes Weiner wrote:
> On Thu, Oct 29, 2020 at 06:44:53PM +0800, Alex Shi wrote:
> > From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > 
> > It is necessary for page_idle_get_page() to recheck PageLRU() after
> > get_page_unless_zero(), but holding lru_lock around that serves no
> > useful purpose, and adds to lru_lock contention: delete it.
> > 
> > See https://lore.kernel.org/lkml/20150504031722.GA2768@blaptop for the
> > discussion that led to lru_lock there; but __page_set_anon_rmap() now
> > uses WRITE_ONCE(),
> 
> That doesn't seem to be the case in Linus's or Andrew's tree. Am I
> missing a dependent patch series?
> 
> > and I see no other risk in page_idle_clear_pte_refs() using
> > rmap_walk() (beyond the risk of racing PageAnon->PageKsm, mostly but
> > not entirely prevented by page_count() check in ksm.c's
> > write_protect_page(): that risk being shared with page_referenced()
> > and not helped by lru_lock).
> 
> Isn't it possible, as per Minchan's description, for page->mapping to
> point to a struct anon_vma without PAGE_MAPPING_ANON set, and rmap
> thinking it's looking at a struct address_space?

I don't think it can point to an anon_vma without the ANON bit set.
Minchan's concern in that email was that it might still be NULL.
