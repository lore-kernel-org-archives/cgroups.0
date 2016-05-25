From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: remove the useless parameter for
 mc_handle_swap_pte
Date: Wed, 25 May 2016 17:18:31 +0200
Message-ID: <20160525151831.GJ20132@dhcp22.suse.cz>
References: <1464145026-26693-1-git-send-email-roy.qing.li@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1464145026-26693-1-git-send-email-roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org

On Wed 25-05-16 10:57:06, roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

It is really trivial but I would add:
"
It reall seems like this parameter has never been used since introduced
by 90254a65833b ("memcg: clean up move charge"). Not a big deal
because I assume the function would get inlined into the caller anyway
but why not to get rid of it.
"
 
> Signed-off-by: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks
> ---
>  mm/memcontrol.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 36b7ecf..c628c90 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4386,7 +4386,7 @@ static struct page *mc_handle_present_pte(struct vm_area_struct *vma,
>  
>  #ifdef CONFIG_SWAP
>  static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
> -			unsigned long addr, pte_t ptent, swp_entry_t *entry)
> +			pte_t ptent, swp_entry_t *entry)
>  {
>  	struct page *page = NULL;
>  	swp_entry_t ent = pte_to_swp_entry(ptent);
> @@ -4405,7 +4405,7 @@ static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
>  }
>  #else
>  static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
> -			unsigned long addr, pte_t ptent, swp_entry_t *entry)
> +			pte_t ptent, swp_entry_t *entry)
>  {
>  	return NULL;
>  }
> @@ -4570,7 +4570,7 @@ static enum mc_target_type get_mctgt_type(struct vm_area_struct *vma,
>  	if (pte_present(ptent))
>  		page = mc_handle_present_pte(vma, addr, ptent);
>  	else if (is_swap_pte(ptent))
> -		page = mc_handle_swap_pte(vma, addr, ptent, &ent);
> +		page = mc_handle_swap_pte(vma, ptent, &ent);
>  	else if (pte_none(ptent))
>  		page = mc_handle_file_pte(vma, addr, ptent, &ent);
>  
> -- 
> 2.1.4

-- 
Michal Hocko
SUSE Labs
