From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 3/7] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Fri, 15 Nov 2019 20:38:06 -0800
Message-ID: <20191116043806.GD20752@bombadil.infradead.org>
References: <1573874106-23802-1-git-send-email-alex.shi@linux.alibaba.com>
 <1573874106-23802-4-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NcGo6y3a7xQQOSK5TngZP8uR7CqYMj91tUhuMqf+9Ns=; b=KJtGujYNRdJwEveOIs3XLtio4
        XHcsmagpcP1yaA2N+7UrIE8V88n7OW4Do7IfTCYeR+d4q8v+G3r8Zir+Cp+wqGKc7HcyXxooyXm1i
        jUE+uYz62ZT+621BjFs/KBU3haXSa51WqN5sxZOr6xU5RH76Y/Sz5sUAwn8r5wYzwdM5mfHtQUUs2
        ZrfmLVkLLS3h61l7VCJuzpkz68DUwA0bDfpS9kSDMtYs2EMRC5HTkOW19cMl/t9SIEyiGCRFhHR5D
        Twd3LrtrHICHuFYKljsa+iVV+hFFYEI2DXYCf/BJPck0X727I4xYwpczptlMf5e6Dk3CiwXvaYxO3
Content-Disposition: inline
In-Reply-To: <1573874106-23802-4-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Rientjes <>

On Sat, Nov 16, 2019 at 11:15:02AM +0800, Alex Shi wrote:
> This is the main patch to replace per node lru_lock with per memcg
> lruvec lock. It also fold the irqsave flags into lruvec.

I have to say, I don't love the part where we fold the irqsave flags
into the lruvec.  I know it saves us an argument, but it opens up the
possibility of mismatched expectations.  eg we currently have:

static void __split_huge_page(struct page *page, struct list_head *list,
			struct lruvec *lruvec, pgoff_t end)
{
...
	spin_unlock_irqrestore(&lruvec->lru_lock, lruvec->irqflags);

so if we introduce a new caller, we have to be certain that this caller
is also using lock_page_lruvec_irqsave() and not lock_page_lruvec_irq().
I can't think of a way to make the compiler enforce that, and if we don't,
then we can get some odd crashes with interrupts being unexpectedly
enabled or disabled, depending on how ->irqflags was used last.

So it makes the code more subtle.  And that's not a good thing.

> +static inline struct lruvec *lock_page_lruvec_irq(struct page *page,
> +						struct pglist_data *pgdat)
> +{
> +	struct lruvec *lruvec = mem_cgroup_page_lruvec(page, pgdat);
> +
> +	spin_lock_irq(&lruvec->lru_lock);
> +
> +	return lruvec;
> +}

...

> +static struct lruvec *lock_page_lru(struct page *page, int *isolated)
>  {
>  	pg_data_t *pgdat = page_pgdat(page);
> +	struct lruvec *lruvec = lock_page_lruvec_irq(page, pgdat);
>  
> -	spin_lock_irq(&pgdat->lru_lock);
>  	if (PageLRU(page)) {
> -		struct lruvec *lruvec;
>  
> -		lruvec = mem_cgroup_page_lruvec(page, pgdat);
>  		ClearPageLRU(page);
>  		del_page_from_lru_list(page, lruvec, page_lru(page));
>  		*isolated = 1;
>  	} else
>  		*isolated = 0;
> +
> +	return lruvec;
>  }

But what if the page is !PageLRU?  What lruvec did we just lock?
According to the comments on mem_cgroup_page_lruvec(),

 * This function is only safe when following the LRU page isolation
 * and putback protocol: the LRU lock must be held, and the page must
 * either be PageLRU() or the caller must have isolated/allocated it.

and now it's being called in order to find out which LRU lock to take.
So this comment needs to be updated, if it's wrong, or this patch has
a race.

