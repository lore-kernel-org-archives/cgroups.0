From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 3/7] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Mon, 18 Nov 2019 04:14:51 -0800
Message-ID: <20191118121451.GG20752@bombadil.infradead.org>
References: <1573874106-23802-1-git-send-email-alex.shi@linux.alibaba.com>
 <1573874106-23802-4-git-send-email-alex.shi@linux.alibaba.com>
 <20191116043806.GD20752@bombadil.infradead.org>
 <0bfa9a03-b095-df83-9cfd-146da9aab89a@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GhE7qMvIwwf/aYu9her0sBn1vDdPh7s1IE5BSkrLez4=; b=fR9iKXTXT4+XD+NhJdh5EwWQ5l
        ASFMW7HjICEpN4ugb9W379oArY6sdOuc5ijoipM0viY1tQs2o7BSudAaG2wbsNBla7gxYICZ1Jvdo
        TS3mbVdewoayXAVYyQ4/1tO3QuaU1VoUy4NV1nKzvLAUkcvQo3jtp0lJg5JsjfJmlPBiA2hArgz9k
        YKImF07gPYx+3ZOcONkLa1blhaXcisTK7+aRTTGkeUoZ4vPMrtvlKVgffH0SWuHKYlSm/S1SWtjli
        FFy6w7B8A1tbTW97fCdNHvYxj7PQuqrnTrzV9gmrXhwrTOdbySmOG40qHxW6dd5vJ+/y/xqIiwlTD
Content-Disposition: inline
In-Reply-To: <0bfa9a03-b095-df83-9cfd-146da9aab89a@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Rientjes <>

On Mon, Nov 18, 2019 at 07:55:43PM +0800, Alex Shi wrote:
> 在 2019/11/16 下午12:38, Matthew Wilcox 写道:
> > On Sat, Nov 16, 2019 at 11:15:02AM +0800, Alex Shi wrote:
> >> This is the main patch to replace per node lru_lock with per memcg
> >> lruvec lock. It also fold the irqsave flags into lruvec.
> > 
> > I have to say, I don't love the part where we fold the irqsave flags
> > into the lruvec.  I know it saves us an argument, but it opens up the
> > possibility of mismatched expectations.  eg we currently have:
> > 
> > static void __split_huge_page(struct page *page, struct list_head *list,
> > 			struct lruvec *lruvec, pgoff_t end)
> > {
> > ...
> > 	spin_unlock_irqrestore(&lruvec->lru_lock, lruvec->irqflags);
> > 
> > so if we introduce a new caller, we have to be certain that this caller
> > is also using lock_page_lruvec_irqsave() and not lock_page_lruvec_irq().
> > I can't think of a way to make the compiler enforce that, and if we don't,
> > then we can get some odd crashes with interrupts being unexpectedly
> > enabled or disabled, depending on how ->irqflags was used last.
> > 
> > So it makes the code more subtle.  And that's not a good thing.
> 
> Hi Matthew,
> 
> Thanks for comments!
> 
> Here, the irqflags is bound, and belong to lruvec, merging them into together helps us to take them as whole, and thus reduce a unnecessary code clues.

It's not bound to the lruvec, though.  Call chain A uses it and call chain
B doesn't.  If it was always used by every call chain, I'd see your point,
but we have call chains which don't use it, and so it adds complexity.

> As your concern for a 'new' caller, since __split_huge_page is a static helper here, no distub for anyothers.

Even though it's static, there may be other callers within the same file.
Or somebody may decide to make it non-static in the future.  I think it's
actually clearer to keep the irqflags as a separate parameter.

> >> +static inline struct lruvec *lock_page_lruvec_irq(struct page *page,
> >> +						struct pglist_data *pgdat)
> >> +{
> >> +	struct lruvec *lruvec = mem_cgroup_page_lruvec(page, pgdat);
> >> +
> >> +	spin_lock_irq(&lruvec->lru_lock);
> >> +
> >> +	return lruvec;
> >> +}
> > 
> > ...
> > 
> >> +static struct lruvec *lock_page_lru(struct page *page, int *isolated)
> >>  {
> >>  	pg_data_t *pgdat = page_pgdat(page);
> >> +	struct lruvec *lruvec = lock_page_lruvec_irq(page, pgdat);
> >>  
> >> -	spin_lock_irq(&pgdat->lru_lock);
> >>  	if (PageLRU(page)) {
> >> -		struct lruvec *lruvec;
> >>  
> >> -		lruvec = mem_cgroup_page_lruvec(page, pgdat);
> >>  		ClearPageLRU(page);
> >>  		del_page_from_lru_list(page, lruvec, page_lru(page));
> >>  		*isolated = 1;
> >>  	} else
> >>  		*isolated = 0;
> >> +
> >> +	return lruvec;
> >>  }
> > 
> > But what if the page is !PageLRU?  What lruvec did we just lock?
> 
> like original pgdat->lru_lock, we need the lock from PageLRU racing. And it the lruvec which the page should be.
> 
> 
> > According to the comments on mem_cgroup_page_lruvec(),
> > 
> >  * This function is only safe when following the LRU page isolation
> >  * and putback protocol: the LRU lock must be held, and the page must
> >  * either be PageLRU() or the caller must have isolated/allocated it.
> > 
> > and now it's being called in order to find out which LRU lock to take.
> > So this comment needs to be updated, if it's wrong, or this patch has
> > a race.
> 
> 
> Yes, the function reminder is a bit misunderstanding with new patch, How about the following changes:
> 
> - * This function is only safe when following the LRU page isolation
> - * and putback protocol: the LRU lock must be held, and the page must
> - * either be PageLRU() or the caller must have isolated/allocated it.
> + * The caller needs to grantee the page's mem_cgroup is undisturbed during
> + * using. That could be done by lock_page_memcg or lock_page_lruvec.

I don't understand how lock_page_lruvec makes this guarantee.  I'll look
at the code again and see if I can understand that.
