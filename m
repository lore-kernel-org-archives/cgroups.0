From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v15 05/21] mm/thp: move lru_add_page_tail func to
 huge_memory.c
Date: Tue, 7 Jul 2020 20:00:11 +0800
Message-ID: <9fa2cf92-c4a0-02ca-1f02-7ef71952de18@linux.alibaba.com>
References: <1594122412-28057-1-git-send-email-alex.shi@linux.alibaba.com>
 <1594122412-28057-6-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1594122412-28057-6-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, "Kirill A. Shutemov" <kirill@shutemov.name>



=D4=DA 2020/7/7 =CF=C2=CE=E77:46, Alex Shi =D0=B4=B5=C0:
> =20
> +static void lru_add_page_tail(struct page *page, struct page *page_tail,
> +				struct lruvec *lruvec, struct list_head *list)
> +{
> +	VM_BUG_ON_PAGE(!PageHead(page), page);
> +	VM_BUG_ON_PAGE(PageCompound(page_tail), page);
> +	VM_BUG_ON_PAGE(PageLRU(page_tail), page);
> +	lockdep_assert_held(&lruvec_pgdat(lruvec)->lru_lock);
> +
> +	if (!list)
> +		SetPageLRU(page_tail);
> +
> +	if (likely(PageLRU(page)))
> +		list_add_tail(&page_tail->lru, &page->lru);
> +	else if (list) {
> +		/* page reclaim is reclaiming a huge page */
> +		get_page(page_tail);
> +		list_add_tail(&page_tail->lru, list);
> +	} else {
> +		/*
> +		 * Head page has not yet been counted, as an hpage,
> +		 * so we must account for each subpage individually.
> +		 *
> +		 * Put page_tail on the list at the correct position
> +		 * so they all end up in order.
> +		 */
> +		add_page_to_lru_list_tail(page_tail, lruvec,
> +					  page_lru(page_tail));


I missed some points for this function, since in the call chain:
split_huge_page() to lru_add_page_tail, the head page's lru won't be
set when !PageLRU(head). But the other page_tail are add to lru list here
Is it ok for this situation?

Thanks!
Alex

> +	}
> +}
