From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: memcontrol: replace the loop with a
 list_for_each_entry()
Date: Thu, 4 Feb 2021 10:14:09 -0500
Message-ID: <YBwPQUwLQ6hAbdSV@cmpxchg.org>
References: <20210204105320.46072-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rSIFYGhhFddePwX4nFIG//fqjMTXGZtm1TOG4qBhrCg=;
        b=pUezDEZQ4njLOWPSWqusqTJWSM+RIcwjXnsGMScZPcUpPTHTLLB1LC6j3HQ+NUylpm
         ce8EnFUHaNH7LO9bmQ6KqtQgQgDiECYrr+oucQSZcgmN/7gQ4qzoiKP7fxpHvrGZDA7X
         pwpDgvyVTB0QbFuQOArsSuWeibbvA6gJ90GxJyQQ/4a57SykMlMsFMxHY9huq1qYDGHY
         1cNeyEnMtrXDJZeswRiBim85+PxB64GJmwA+kZeTJHPsT2NUaIyj7CgvoKXGrF9o6PKn
         8iSr36F2vrztBPbao/2Uf1mmJyichJKkZbHjKsxzZD6BJ1+YAWSes7bfeG++EbAgWUtX
         GbYQ==
Content-Disposition: inline
In-Reply-To: <20210204105320.46072-1-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Thu, Feb 04, 2021 at 06:53:20PM +0800, Muchun Song wrote:
> The rule of list walk has gone since:
> 
>  commit a9d5adeeb4b2 ("mm/memcontrol: allow to uncharge page without using page->lru field")
> 
> So remove the strange comment and replace the loop with a
> list_for_each_entry().
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  mm/memcontrol.c | 17 ++---------------
>  1 file changed, 2 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6c7f1ea3955e..43341bd7ea1c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6891,24 +6891,11 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
>  static void uncharge_list(struct list_head *page_list)
>  {
>  	struct uncharge_gather ug;
> -	struct list_head *next;
> +	struct page *page;
>  
>  	uncharge_gather_clear(&ug);
> -
> -	/*
> -	 * Note that the list can be a single page->lru; hence the
> -	 * do-while loop instead of a simple list_for_each_entry().
> -	 */
> -	next = page_list->next;
> -	do {
> -		struct page *page;
> -
> -		page = list_entry(next, struct page, lru);
> -		next = page->lru.next;
> -
> +	list_for_each_entry(page, page_list, lru)
>  		uncharge_page(page, &ug);
> -	} while (next != page_list);
> -
>  	uncharge_batch(&ug);

Good catch, this makes things much simpler.

Looking at the surrounding code, there also seems to be no reason
anymore to have uncharge_list() as a separate function: there is only
one caller after the mentioned commit, and it's trivial after your
change. Would you mind folding it into mem_cgroup_uncharge_list()?

The list_empty() check in that one is also unnecessary now: the
do-while loop required at least one page to be on the list or it would
crash, but list_for_each() will be just fine on an empty list.

Thanks
