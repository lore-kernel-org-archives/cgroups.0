From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH][RFC] mm: memcontrol: fix a unbalance uncharged count
Date: Tue, 31 May 2016 11:50:04 +0200
Message-ID: <20160531094952.GI26128@dhcp22.suse.cz>
References: <1464687512-10695-1-git-send-email-roy.qing.li@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1464687512-10695-1-git-send-email-roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org

On Tue 31-05-16 17:38:32, roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> I see the number of page of hpage_nr_pages(page) is charged if page is
> transparent huge or hugetlbfs pages; but when uncharge a huge page,

hugetlb pages do not get charged to the memcg. They have their own
hugetlbfscg controller.

> (1<<compound_order) page is uncharged, and maybe hpage_nr_pages(page) is
> not same as 1<<compound_order.

This should never happen. So this is not a fix. I guess it would a clean
up though.

> And remove VM_BUG_ON_PAGE(!PageTransHuge(page), page); since
> PageTransHuge(page) always is true, when this VM_BUG_ON_PAGE is called.

I guess we can drop this BUG_ON because nobody should be be seeing the
page at this stage so we cannot race with a THP split up. But I would
really have to look closer. This would be a patch on its own with the
full explanation though, IMHO.

> Signed-off-by: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  mm/memcontrol.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 12aaadd..28c0137 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5453,8 +5453,7 @@ static void uncharge_list(struct list_head *page_list)
>  		}
>  
>  		if (PageTransHuge(page)) {
> -			nr_pages <<= compound_order(page);
> -			VM_BUG_ON_PAGE(!PageTransHuge(page), page);
> +			nr_pages = hpage_nr_pages(page);
>  			nr_huge += nr_pages;
>  		}
>  
> -- 
> 2.1.4

-- 
Michal Hocko
SUSE Labs
