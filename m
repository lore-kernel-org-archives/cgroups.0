From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v6 02/10] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Mon, 16 Dec 2019 18:16:13 -0800
Message-ID: <20191217021613.GB32169@bombadil.infradead.org>
References: <1576488386-32544-1-git-send-email-alex.shi@linux.alibaba.com>
 <1576488386-32544-3-git-send-email-alex.shi@linux.alibaba.com>
 <20191216121427.GZ32169@bombadil.infradead.org>
 <286c11c2-480f-37d6-e9fe-91822f862cd6@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=siGlAtwbpMtn2+e/O7hKM+nw0EWpzij1iF2dGkh6S28=; b=fMahm2K5a4Q9AU7WAk02csbb8w
        kPQUQkYGI1oxLG13qBOQYj40/hcOw6UrbIKgqlWAymUgbivUWBlJBr0EBJQYEtGKsLM8iyozgPkhR
        FPjoylR+LfIYOO09S4gFDvvCUKRYE/fh7bNn6HwUfg9TmcvJAjXXkTRfLfGT0whTBbTyUtZUxfZag
        +0zeiBvJK7mPFXM2IspiWLrfiiZq7641o5OVTZLszsOX8JG98YfVlKnY82iYtBwOt/maBbZGdzFdP
        e1qJxVzjYr8raPVoeo/pMmCTp9aG32t41zTdk8q0B6hkXf3iUmfVdwvYGFDRVoEXOHUOfvmsgjjNm
Content-Disposition: inline
In-Reply-To: <286c11c2-480f-37d6-e9fe-91822f862cd6@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, shakeelb@google.com, hannes@cmpxchg.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Rientjes <rientjes@google.com>, Aneesh Kum

On Tue, Dec 17, 2019 at 09:30:13AM +0800, Alex Shi wrote:
> 在 2019/12/16 下午8:14, Matthew Wilcox 写道:
> > On Mon, Dec 16, 2019 at 05:26:18PM +0800, Alex Shi wrote:
> >> -static void lock_page_lru(struct page *page, int *isolated)
> >> +static struct lruvec *lock_page_lru(struct page *page, int *isolated)
> >>  {
> >> -	pg_data_t *pgdat = page_pgdat(page);
> >> +	struct lruvec *lruvec = lock_page_lruvec_irq(page);
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
> > You still didn't fix this function.  Go back and look at my comment from
> > the last time you sent this patch set.
> > 
> 
> Sorry for the misunderstanding. I guess what your want is fold the patch 9th into this, is that right?
> Any comments for the 9th patch?

I didn't get as far as looking at the ninth patch because I saw this
one was wrong and stopped looking.  This is not the first time *with
this patch set* that you've been told to *fix the patch*, not submit
something that's broken and fix it in a later patch.

I'll look at patch 9 later.
