From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: move comments for get_mctgt_type to
 proper position
Date: Thu, 19 May 2016 10:21:23 +0200
Message-ID: <20160519082122.GG26110@dhcp22.suse.cz>
References: <1463644638-7446-1-git-send-email-roy.qing.li@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1463644638-7446-1-git-send-email-roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org

On Thu 19-05-16 15:57:18, roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> move the comments for get_mctgt_type before the get_mctgt_type function

heh, it used to be much closer back then when introduced but we have
grown quite some code since then...

> Signed-off-by: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  mm/memcontrol.c | 37 +++++++++++++++++++------------------
>  1 file changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index fe787f5..00981d2 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4290,24 +4290,6 @@ static int mem_cgroup_do_precharge(unsigned long count)
>  	return 0;
>  }
>  
> -/**
> - * get_mctgt_type - get target type of moving charge
> - * @vma: the vma the pte to be checked belongs
> - * @addr: the address corresponding to the pte to be checked
> - * @ptent: the pte to be checked
> - * @target: the pointer the target page or swap ent will be stored(can be NULL)
> - *
> - * Returns
> - *   0(MC_TARGET_NONE): if the pte is not a target for move charge.
> - *   1(MC_TARGET_PAGE): if the page corresponding to this pte is a target for
> - *     move charge. if @target is not NULL, the page is stored in target->page
> - *     with extra refcnt got(Callers should handle it).
> - *   2(MC_TARGET_SWAP): if the swap entry corresponding to this pte is a
> - *     target for charge migration. if @target is not NULL, the entry is stored
> - *     in target->ent.
> - *
> - * Called with pte lock held.
> - */
>  union mc_target {
>  	struct page	*page;
>  	swp_entry_t	ent;
> @@ -4496,6 +4478,25 @@ out:
>  	return ret;
>  }
>  
> +/**
> + * get_mctgt_type - get target type of moving charge
> + * @vma: the vma the pte to be checked belongs
> + * @addr: the address corresponding to the pte to be checked
> + * @ptent: the pte to be checked
> + * @target: the pointer the target page or swap ent will be stored(can be NULL)
> + *
> + * Returns
> + *   0(MC_TARGET_NONE): if the pte is not a target for move charge.
> + *   1(MC_TARGET_PAGE): if the page corresponding to this pte is a target for
> + *     move charge. if @target is not NULL, the page is stored in target->page
> + *     with extra refcnt got(Callers should handle it).
> + *   2(MC_TARGET_SWAP): if the swap entry corresponding to this pte is a
> + *     target for charge migration. if @target is not NULL, the entry is stored
> + *     in target->ent.
> + *
> + * Called with pte lock held.
> + */
> +
>  static enum mc_target_type get_mctgt_type(struct vm_area_struct *vma,
>  		unsigned long addr, pte_t ptent, union mc_target *target)
>  {
> -- 
> 2.1.4

-- 
Michal Hocko
SUSE Labs
