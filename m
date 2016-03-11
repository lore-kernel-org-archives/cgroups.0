From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: clarify the uncharge_list() loop
Date: Fri, 11 Mar 2016 09:19:52 +0100
Message-ID: <20160311081951.GD27701@dhcp22.suse.cz>
References: <1457643015-8828-3-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457643015-8828-3-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu 10-03-16 15:50:15, Johannes Weiner wrote:
> uncharge_list() does an unusual list walk because the function can
> take regular lists with dedicated list_heads as well as singleton
> lists where a single page is passed via the page->lru list node.
> 
> This can sometimes lead to confusion as well as suggestions to replace
> the loop with a list_for_each_entry(), which wouldn't work.

Yes this confused at least me 2 times AFAIR.

> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

> ---
>  mm/memcontrol.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8614e0d750e5..fa7bf354ae32 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5420,6 +5420,10 @@ static void uncharge_list(struct list_head *page_list)
>  	struct list_head *next;
>  	struct page *page;
>  
> +	/*
> +	 * Note that the list can be a single page->lru; hence the
> +	 * do-while loop instead of a simple list_for_each_entry().
> +	 */
>  	next = page_list->next;
>  	do {
>  		unsigned int nr_pages = 1;
> -- 
> 2.7.2

-- 
Michal Hocko
SUSE Labs
