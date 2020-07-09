From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCH v15 05/21] mm/thp: move lru_add_page_tail func to
 huge_memory.c
Date: Thu, 9 Jul 2020 18:55:38 +0300
Message-ID: <20200709155538.mf3gxutgckz7p67i@box>
References: <1594122412-28057-1-git-send-email-alex.shi@linux.alibaba.com>
 <1594122412-28057-6-git-send-email-alex.shi@linux.alibaba.com>
 <9fa2cf92-c4a0-02ca-1f02-7ef71952de18@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ko2toLCZVcB1lleYvRhScChtwEJOK0oSQV22Yurja2Q=;
        b=Uc4CCtMLCs3lO9xhdmBONzGWRiRwT9i1ZMePGIYt4l0xaGLYpohw0IerOblGgyhLoW
         AT5UmJkwwuxoQRcctui1mXrBp211sfFdtr7d5kPb5DLJKl327ienkkdxSaj8OuYdeb0V
         gD1sYjx5U1/q4X6Lx2NbhLKuVFaBneMzUK5o+BllCwhWYGnXAbgfroWFhQSbqErEmWDK
         +AP91wv6In/CR0I+dXAnClibT5z9pp3YulfddtucRksexscSOh1ki4NY5LEcEYtJB1y0
         5GdX3YRnyOvUjqVkLqhHFf5V1TWpqXAIYide9TRITdEoQ58rlC8+trgvboocTbHdQGcQ
         dI4A==
Content-Disposition: inline
In-Reply-To: <9fa2cf92-c4a0-02ca-1f02-7ef71952de18-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Tue, Jul 07, 2020 at 08:00:11PM +0800, Alex Shi wrote:
> 
> 
> 在 2020/7/7 下午7:46, Alex Shi 写道:
> >  
> > +static void lru_add_page_tail(struct page *page, struct page *page_tail,
> > +				struct lruvec *lruvec, struct list_head *list)
> > +{
> > +	VM_BUG_ON_PAGE(!PageHead(page), page);
> > +	VM_BUG_ON_PAGE(PageCompound(page_tail), page);
> > +	VM_BUG_ON_PAGE(PageLRU(page_tail), page);
> > +	lockdep_assert_held(&lruvec_pgdat(lruvec)->lru_lock);
> > +
> > +	if (!list)
> > +		SetPageLRU(page_tail);
> > +
> > +	if (likely(PageLRU(page)))
> > +		list_add_tail(&page_tail->lru, &page->lru);
> > +	else if (list) {
> > +		/* page reclaim is reclaiming a huge page */
> > +		get_page(page_tail);
> > +		list_add_tail(&page_tail->lru, list);
> > +	} else {
> > +		/*
> > +		 * Head page has not yet been counted, as an hpage,
> > +		 * so we must account for each subpage individually.
> > +		 *
> > +		 * Put page_tail on the list at the correct position
> > +		 * so they all end up in order.
> > +		 */
> > +		add_page_to_lru_list_tail(page_tail, lruvec,
> > +					  page_lru(page_tail));
> 
> 
> I missed some points for this function, since in the call chain:
> split_huge_page() to lru_add_page_tail, the head page's lru won't be
> set when !PageLRU(head). But the other page_tail are add to lru list here
> Is it ok for this situation?

It doesn't differ from the situation when some pages are isolated from
LRU. Tail page has become completely on its own after
__split_huge_page_tail() has completed, it's not tied to the head page.

-- 
 Kirill A. Shutemov
