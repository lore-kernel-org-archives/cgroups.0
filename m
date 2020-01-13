From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [PATCH v7 03/10] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Mon, 13 Jan 2020 10:41:16 -0500
Message-ID: <20200113154116.mwly5hl5yfvjkzl2@ca-dmjordan1.us.oracle.com>
References: <1577264666-246071-1-git-send-email-alex.shi@linux.alibaba.com>
 <1577264666-246071-4-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=DaiMzq10P7q2znpRBBajknZMYi+ZtWubzic8NGU8mfo=;
 b=sE8GHT2SDtHhjkzDOynzxChoJhv6zkVeBzHBdfCaY7p+DOvJXh69L7uo8fa07mQ/fMVr
 /miOInt1cI3EVZvZEziLjpafJrDa2xOrvUs5t+gLqTsIJ/PZVC+wb8Ip7ZV/BSb+Pzkv
 Uoihwv3ROB3y2pgzcZVXOkFpfMHJ+RfiWkfHV09AMKe45a4Wj26LQBsMJ3lY/WposRWF
 c16UC4OfUtsOIFzL4tJTnx3qBOzbirK88CUCIS6IPj2eZyUIxcuqcliUl0pg/cw8z703
 7dCQsJ9IzjpzUWP04nR9rty4p7SVtX3wqO7FXMuHQiF8WrJKW2vIgmBjte4zpRaZdNzJ 9A== 
Content-Disposition: inline
In-Reply-To: <1577264666-246071-4-git-send-email-alex.shi@linux.alibaba.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com, hannes@cmpxchg.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Rientjes <rientjes@google.com>, Aneesh

Hi Alex,

On Wed, Dec 25, 2019 at 05:04:19PM +0800, Alex Shi wrote:
> @@ -900,6 +904,29 @@ static inline struct lruvec *mem_cgroup_page_lruvec(struct page *page,
>  {
>  	return &pgdat->__lruvec;
>  }
> +#define lock_page_lruvec_irq(page)			\
> +({							\
> +	struct pglist_data *pgdat = page_pgdat(page);	\
> +	spin_lock_irq(&pgdat->__lruvec.lru_lock);	\
> +	&pgdat->__lruvec;				\
> +})
> +
> +#define lock_page_lruvec_irqsave(page, flagsp)			\
> +({								\
> +	struct pglist_data *pgdat = page_pgdat(page);		\
> +	spin_lock_irqsave(&pgdat->__lruvec.lru_lock, *flagsp);	\
> +	&pgdat->__lruvec;					\
> +})
> +
> +#define unlock_page_lruvec_irq(lruvec)			\
> +({							\
> +	spin_unlock_irq(&lruvec->lru_lock);		\
> +})
> +
> +#define unlock_page_lruvec_irqrestore(lruvec, flags)		\
> +({								\
> +	spin_unlock_irqrestore(&lruvec->lru_lock, flags);	\
> +})

Noticed this while testing your series.  These are safe as inline functions, so
I think you may have gotten the wrong impression when Johannes made this point:

https://lore.kernel.org/linux-mm/20191119164448.GA396644@cmpxchg.org/

