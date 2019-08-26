From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH 03/14] lru/memcg: using per lruvec lock in
 un/lock_page_lru
Date: Mon, 26 Aug 2019 11:30:28 +0300
Message-ID: <936eb865-d8da-8e53-3e2b-6858c586aa49@yandex-team.ru>
References: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com>
 <1566294517-86418-4-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1566808229; bh=LOCYjiT8FfunGZukLIK5K5NXyHYjruIoyJuaVRXWFmw=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=PzP7Xz+0fbmSFKmOl6qSc25qnWjMayfAIpLSoml9FZ8ZarWGHebheC5fEvxFDfPCt
         dOCHjV3FaJj7JujDdJ1LFCKmF+JXBAuyH3WuQlZ4uoazgTMqz+hrN1fnRtPXmZs5HU
         Cu9026sTL8hgP5UBrNPW6Lv6uBn23Bic/Z3aRXAM=
In-Reply-To: <1566294517-86418-4-git-send-email-alex.shi@linux.alibaba.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Alex Shi <alex.shi@linux.alibaba.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>

On 20/08/2019 12.48, Alex Shi wrote:
> Now we repeatly assign the lruvec->pgdat in memcg. Will remove the
> assignment in lruvec getting function after very points are protected.
> 
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   mm/memcontrol.c | 12 +++++-------
>   1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e8a1b0d95ba8..19fd911e8098 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2550,12 +2550,12 @@ static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
>   static void lock_page_lru(struct page *page, int *isolated)
>   {
>   	pg_data_t *pgdat = page_pgdat(page);
> +	struct lruvec *lruvec = mem_cgroup_page_lruvec(page, pgdat);
>   

What protects lruvec from freeing at this point?
After reading resolving lruvec page could be moved and cgroup deleted.

In this old patches I've used RCU for that: https://lkml.org/lkml/2012/2/20/276
Pointer to lruvec should be resolved under disabled irq.
Not sure this works these days.

> -	spin_lock_irq(&pgdat->lruvec.lru_lock);
> +	spin_lock_irq(&lruvec->lru_lock);
> +	sync_lruvec_pgdat(lruvec, pgdat);
>   	if (PageLRU(page)) {
> -		struct lruvec *lruvec;
>   
> -		lruvec = mem_cgroup_page_lruvec(page, pgdat);
>   		ClearPageLRU(page);
>   		del_page_from_lru_list(page, lruvec, page_lru(page));
>   		*isolated = 1;
> @@ -2566,16 +2566,14 @@ static void lock_page_lru(struct page *page, int *isolated)
>   static void unlock_page_lru(struct page *page, int isolated)
>   {
>   	pg_data_t *pgdat = page_pgdat(page);
> +	struct lruvec *lruvec = mem_cgroup_page_lruvec(page, pgdat);
>   
>   	if (isolated) {
> -		struct lruvec *lruvec;
> -
> -		lruvec = mem_cgroup_page_lruvec(page, pgdat);
>   		VM_BUG_ON_PAGE(PageLRU(page), page);
>   		SetPageLRU(page);
>   		add_page_to_lru_list(page, lruvec, page_lru(page));
>   	}
> -	spin_unlock_irq(&pgdat->lruvec.lru_lock);
> +	spin_unlock_irq(&lruvec->lru_lock);
>   }
>   
>   static void commit_charge(struct page *page, struct mem_cgroup *memcg,
> 
