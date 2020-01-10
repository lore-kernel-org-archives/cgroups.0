From: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: Re: [PATCH v7 02/10] mm/memcg: fold lru_lock in lock_page_lru
Date: Fri, 10 Jan 2020 11:49:08 +0300
Message-ID: <36d7e390-a3d1-908c-d181-4a9e9c8d3d98@yandex-team.ru>
References: <1577264666-246071-1-git-send-email-alex.shi@linux.alibaba.com>
 <1577264666-246071-3-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1578646150; bh=qNR3NRByyHlpXQ4p8X/hlo3hrAKhN7Qz3lDeB34a2SE=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=Fyx7qH8P/x1bFQnJzbtV/n/oKwipgrSOqyHGMcwJ8hs8laBFTQJQCrEKnzAvegvLj
         7DmxhCtvD5dSvHww2xkvK8WCrFCn8nLyOIVAc8fp2ddXKmixviBV9JqSrBpVvJZ0O9
         vop6n5umIXK5jlres1B9ZHfNtHWTnSNRpRfoE+fw=
In-Reply-To: <1577264666-246071-3-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Content-Language: en-CA
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 25/12/2019 12.04, Alex Shi wrote:
>  From the commit_charge's explanations and mem_cgroup_commit_charge
> comments, as well as call path when lrucare is ture, The lru_lock is
> just to guard the task migration(which would be lead to move_account)
> So it isn't needed when !PageLRU, and better be fold into PageLRU to
> reduce lock contentions.
> 
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>   mm/memcontrol.c | 9 ++++-----
>   1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c5b5f74cfd4d..0ad10caabc3d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2572,12 +2572,11 @@ static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
>   
>   static void lock_page_lru(struct page *page, int *isolated)
>   {
> -	pg_data_t *pgdat = page_pgdat(page);
> -
> -	spin_lock_irq(&pgdat->lru_lock);
>   	if (PageLRU(page)) {
> +		pg_data_t *pgdat = page_pgdat(page);
>   		struct lruvec *lruvec;
>   
> +		spin_lock_irq(&pgdat->lru_lock);

That's wrong. Here PageLRU must be checked again under lru_lock.


Also I don't like these functions:
- called lock/unlock but actually also isolates
- used just once
- pgdat evaluated twice

>   		lruvec = mem_cgroup_page_lruvec(page, pgdat);
>   		ClearPageLRU(page);
>   		del_page_from_lru_list(page, lruvec, page_lru(page));
> @@ -2588,17 +2587,17 @@ static void lock_page_lru(struct page *page, int *isolated)
>   
>   static void unlock_page_lru(struct page *page, int isolated)
>   {
> -	pg_data_t *pgdat = page_pgdat(page);
>   
>   	if (isolated) {
> +		pg_data_t *pgdat = page_pgdat(page);
>   		struct lruvec *lruvec;
>   
>   		lruvec = mem_cgroup_page_lruvec(page, pgdat);
>   		VM_BUG_ON_PAGE(PageLRU(page), page);
>   		SetPageLRU(page);
>   		add_page_to_lru_list(page, lruvec, page_lru(page));
> +		spin_unlock_irq(&pgdat->lru_lock);
>   	}
> -	spin_unlock_irq(&pgdat->lru_lock);
>   }
>   
>   static void commit_charge(struct page *page, struct mem_cgroup *memcg,
> 
