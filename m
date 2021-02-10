From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: page-writeback: simplify memcg handling in
 test_clear_page_writeback()
Date: Wed, 10 Feb 2021 08:22:00 -0800 (PST)
Message-ID: <alpine.LSU.2.11.2102100813050.8131@eggly.anvils>
References: <20210209214543.112655-1-hannes@cmpxchg.org> <alpine.LSU.2.11.2102092058290.7553@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=wc8HtUu6YXXorPykhuoj08SCrBEaocuYohr96nbgn+w=;
        b=fpSdWoUW/YxqsP5HrQVPzNsTdbTt5mOIk6GqFhMMF/biAw553DP/Q7qeQJMjwPShNk
         1tRCVOShdBPkTNGrIargdgle8wgQceXqCAn3IHA7g3D04Ow8R7+9FWnFmuNmYkLtRhc3
         NPZRlQhxOcWweh5MO8A8cXXzWeWCBg+WAxOyFchaYUnrwwxZ4crSYQ0oL8jAS9UrwmfP
         CW1W7cC6X2NLISJ0M4LetFXkBGcA78Y68b1khrpiqAvP7GG9vuz60hI/o+GaUIpyObsJ
         SJ7LZjvLn5dEu4MAlTKTFOVnNmu8Z9Fsn7GavQTkW21qdobIJyuLdv3dBLsT3lnHDn9s
         ymow==
In-Reply-To: <alpine.LSU.2.11.2102092058290.7553-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, 9 Feb 2021, Hugh Dickins wrote:
> On Tue, 9 Feb 2021, Johannes Weiner wrote:
> 
> > Page writeback doesn't hold a page reference, which allows truncate to
> > free a page the second PageWriteback is cleared. This used to require
> > special attention in test_clear_page_writeback(), where we had to be
> > careful not to rely on the unstable page->memcg binding and look up
> > all the necessary information before clearing the writeback flag.
> > 
> > Since commit 073861ed77b6 ("mm: fix VM_BUG_ON(PageTail) and
> > BUG_ON(PageWriteback)") test_clear_page_writeback() is called with an
> > explicit reference on the page, and this dance is no longer needed.
> > 
> > Use unlock_page_memcg() and dec_lruvec_page_stat() directly.
> 
> s/stat()/state()/
> 
> This is a nice cleanup: I hadn't seen that connection at all.
> 
> But I think you should take it further:
> __unlock_page_memcg() can then be static in mm/memcontrol.c,
> and its declarations deleted from include/linux/memcontrol.h?

And further: void lock_page_memcg(page), not returning memcg.

> 
> And further: delete __dec_lruvec_state() and dec_lruvec_state()
> from include/linux/vmstat.h - unless you feel that every "inc"
> ought to be matched by a "dec", even when unused.
> 
> > 
> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> 
> Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> > ---
> >  mm/page-writeback.c | 9 +++------
> >  1 file changed, 3 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > index eb34d204d4ee..f6c2c3165d4d 100644
> > --- a/mm/page-writeback.c
> > +++ b/mm/page-writeback.c
> > @@ -2722,12 +2722,9 @@ EXPORT_SYMBOL(clear_page_dirty_for_io);
> >  int test_clear_page_writeback(struct page *page)
> >  {
> >  	struct address_space *mapping = page_mapping(page);
> > -	struct mem_cgroup *memcg;
> > -	struct lruvec *lruvec;
> >  	int ret;
> >  
> > -	memcg = lock_page_memcg(page);
> > -	lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
> > +	lock_page_memcg(page);
> >  	if (mapping && mapping_use_writeback_tags(mapping)) {
> >  		struct inode *inode = mapping->host;
> >  		struct backing_dev_info *bdi = inode_to_bdi(inode);
> > @@ -2755,11 +2752,11 @@ int test_clear_page_writeback(struct page *page)
> >  		ret = TestClearPageWriteback(page);
> >  	}
> >  	if (ret) {
> > -		dec_lruvec_state(lruvec, NR_WRITEBACK);
> > +		dec_lruvec_page_state(page, NR_WRITEBACK);
> >  		dec_zone_page_state(page, NR_ZONE_WRITE_PENDING);
> >  		inc_node_page_state(page, NR_WRITTEN);
> >  	}
> > -	__unlock_page_memcg(memcg);
> > +	unlock_page_memcg(page);
> >  	return ret;
> >  }
> >  
> > -- 
> > 2.30.0
> 
