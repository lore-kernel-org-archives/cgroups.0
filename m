From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [PATCH v3 3/7] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Mon, 18 Nov 2019 21:10:58 -0500
Message-ID: <20191119021058.auxc6g7vmgf7d5gg@ca-dmjordan1.us.oracle.com>
References: <1573874106-23802-1-git-send-email-alex.shi@linux.alibaba.com>
 <1573874106-23802-4-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=0HzX/gxMttS4J+L6PBkjiqoj8SSAB9SSaypPZSiCkzg=;
 b=D9joND5QO8S0RfNgqFdUhAAiwvaLvkWQx8NA14Soj4ETkg9FcnCwlVFZoVYb0oNDzxfj
 e6xJ8dl6KGgiLyKLxboS5iS8+D3IK57Jbdd27Yi7AfaZskW+fbnvRJtvdTcmtJbNfhKr
 QGG5Lh1c/gg2PFM7SGV68PypYf6afXGsyCqTubkd7KoV5b4ba/D7GvECWKV53hAQpMEE
 yQPFNyn1voCxZ+OpwT2ImC6E77fNFQOItE/CQz8DbMWkD/aDPzxIDJANWgacRtvs6PyU
 dCO9yHc16O1R2RItBSZe4NUpy/j9AyvJBFZ/ExZ3xx1P2RIyAa+gdzDsrEp/f0neprxD fw== 
Content-Disposition: inline
In-Reply-To: <1573874106-23802-4-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.co>

On Sat, Nov 16, 2019 at 11:15:02AM +0800, Alex Shi wrote:
> @@ -192,26 +190,17 @@ static void pagevec_lru_move_fn(struct pagevec *pvec,
>  	void *arg)
>  {
>  	int i;
> -	struct pglist_data *pgdat = NULL;
> -	struct lruvec *lruvec;
> -	unsigned long flags = 0;
> +	struct lruvec *lruvec = NULL;
>  
>  	for (i = 0; i < pagevec_count(pvec); i++) {
>  		struct page *page = pvec->pages[i];
> -		struct pglist_data *pagepgdat = page_pgdat(page);
>  
> -		if (pagepgdat != pgdat) {
> -			if (pgdat)
> -				spin_unlock_irqrestore(&pgdat->lru_lock, flags);
> -			pgdat = pagepgdat;
> -			spin_lock_irqsave(&pgdat->lru_lock, flags);
> -		}
> +		lruvec = lock_page_lruvec_irqsave(page, page_pgdat(page));
>  
> -		lruvec = mem_cgroup_page_lruvec(page, pgdat);
>  		(*move_fn)(page, lruvec, arg);
> +		spin_unlock_irqrestore(&lruvec->lru_lock, lruvec->irqflags);
>  	}
> -	if (pgdat)
> -		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
> +
>  	release_pages(pvec->pages, pvec->nr);
>  	pagevec_reinit(pvec);
>  }

Why can't you keep the locking pattern where we only drop and reacquire if the
lruvec changes?  It'd save a lot of locks and unlocks if most pages were from
the same memcg and node, or the memory controller were unused.


Thanks for running the -readtwice benchmark, by the way.
