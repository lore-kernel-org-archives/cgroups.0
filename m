From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v4 3/9] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Fri, 22 Nov 2019 11:16:52 -0500
Message-ID: <20191122161652.GA489821@cmpxchg.org>
References: <1574166203-151975-1-git-send-email-alex.shi@linux.alibaba.com>
 <1574166203-151975-4-git-send-email-alex.shi@linux.alibaba.com>
 <20191119160456.GD382712@cmpxchg.org>
 <bcf6a952-5b92-50ad-cfc1-f4d9f8f63172@linux.alibaba.com>
 <20191121220613.GB487872@cmpxchg.org>
 <d3bbbbf5-52c5-374c-0897-899e787cecb4@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=wfrcrjX2H8D8RSvVc5LOIPsNb3WQnwmD64TJNBPNLUA=;
        b=2CxFAF9vQ8BbOhqPOkf+HBDvDUxib+UWq9hNW0Tg4l/6YvGcIgULwb7zDfm9mbuP/9
         3/EKpUXrSdv8B03hy14QpNLhWat83HNQyn1GgIfaBTMQMmmanUe+btbssVaH8haWbOpr
         QqRPK10O9tUUfndkbGrdfQe1z6ITlCczduG7UJhZ6JNU7ZoQRSrIbazx85Z8h4rz26Xb
         6EJVTX6A/tEz9L4CMMWPjveLs+QHDUyDxvybrIHm+D9wpJ2bnJSnESNPWmTfEoXJTO6d
         RHERX6f1D2fDaO/gYzRlAdEHF6PJxDPr/jbgCMQMh3Z2Fj6YG7Q5lbEYKwW7Ol6/bl7e
         sgEw==
Content-Disposition: inline
In-Reply-To: <d3bbbbf5-52c5-374c-0897-899e787cecb4@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Rientjes <rientjes@google.com>, Aneesh Ku

On Fri, Nov 22, 2019 at 10:36:32AM +0800, Alex Shi wrote:
> 在 2019/11/22 上午6:06, Johannes Weiner 写道:
> > If we could restrict lock_page_lruvec() to working only on PageLRU
> > pages, we could fix the problem with memory barriers. But this won't
> > work for split_huge_page(), which is AFAICT the only user that needs
> > to freeze the lru state of a page that could be isolated elsewhere.
> > 
> > So AFAICS the only option is to lock out mem_cgroup_move_account()
> > entirely when the lru_lock is held. Which I guess should be fine.
> 
> I guess we can try from lock_page_memcg, is that a good start?

Yes.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 7e6387ad01f0..f4bbbf72c5b8 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1224,7 +1224,7 @@ struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgd
>                 goto out;
>         }
> 
> -       memcg = page->mem_cgroup;
> +       memcg = lock_page_memcg(page);
>         /*
>          * Swapcache readahead pages are added to the LRU - and
>          * possibly migrated - before they are charged.

test_clear_page_writeback() calls this function with that lock already
held so that would deadlock. Let's keep locking in lock_page_lruvec().

lock_page_lruvec():

	memcg = lock_page_memcg(page);
	lruvec = mem_cgroup_lruvec(page_pgdat(page), memcg);

	spin_lock_irqsave(&lruvec->lru_lock, *flags);
	return lruvec;

unlock_lruvec();

	spin_unlock_irqrestore(&lruvec->lru_lock);
	__unlock_page_memcg(lruvec_memcg(lruvec));

The lock ordering should be fine as well. But it might be a good idea
to stick a might_lock(&memcg->move_lock) in lock_page_memcg() before
that atomic_read() and test with lockdep enabled.


But that leaves me with one more worry: compaction. We locked out
charge moving now, so between that and knowing that the page is alive,
we have page->mem_cgroup stable. But compaction doesn't know whether
the page is alive - it comes from a pfn and finds out using PageLRU.

In the current code, pgdat->lru_lock remains the same before and after
the page is charged to a cgroup, so once compaction has that locked
and it observes PageLRU, it can go ahead and isolate the page.

But lruvec->lru_lock changes during charging, and then compaction may
hold the wrong lock during isolation:

compaction:				generic_file_buffered_read:

					page_cache_alloc()

!PageBuddy()

lock_page_lruvec(page)
  lruvec = mem_cgroup_page_lruvec()
  spin_lock(&lruvec->lru_lock)
  if lruvec != mem_cgroup_page_lruvec()
    goto again

					add_to_page_cache_lru()
					  mem_cgroup_commit_charge()
					    page->mem_cgroup = foo
					  lru_cache_add()
					    __pagevec_lru_add()
					      SetPageLRU()

if PageLRU(page):
  __isolate_lru_page()

I don't see what prevents the lruvec from changing under compaction,
neither in your patches nor in Hugh's. Maybe I'm missing something?
