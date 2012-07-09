From: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/7] memcg: remove MEMCG_NR_FILE_MAPPED
Date: Mon, 09 Jul 2012 14:01:21 -0700
Message-ID: <xr93ehok1wf2.fsf@gthelen.mtv.corp.google.com>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com>
	<1340881111-5576-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:references:date:message-id:user-agent
         :mime-version:content-type;
        bh=BFlyZiPIjdfXtBUwxw+xYKpSx57CbFTngLgZ1nF1T4k=;
        b=ZnU9cDIBdqVmvN2y/mWSWpj11rbu88aRBPxaCyZCtQT1s2zcrb9jPay68dbI+IodqE
         iR0mgdwAWutTNtax9oWl9LSBDoPiqRD+OxJZgTaEU2+NKjlM7qUhua3gI4ayGbJ2yVbd
         GUGV0tMdxfntudYQisJ1KGjlXeteeXahRkpcqlDuu9atYws1rYFY+VtU1YjGhyEh5XEv
         MCKrObX1oRS55F7dbjRejRtFvRf0fJxbMZJ/k4nJ8eApxDLfS2GvigTCg5fycdwUSy7c
         JagqbNewNzQC6oSTAABTHz2q8I3C77LYM/8Lbp6Ac/TqJeNFo8GLImDXW3ohf6tOVnKr
         SK2w==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Thu, Jun 28 2012, Sha Zhengju wrote:

> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>
> While accounting memcg page stat, it's not worth to use MEMCG_NR_FILE_MAPPED
> as an extra layer of indirection because of the complexity and presumed
> performance overhead. We can use MEM_CGROUP_STAT_FILE_MAPPED directly.
>
> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/memcontrol.h |   25 +++++++++++++++++--------
>  mm/memcontrol.c            |   24 +-----------------------
>  mm/rmap.c                  |    4 ++--
>  3 files changed, 20 insertions(+), 33 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 83e7ba9..20b0f2d 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -27,9 +27,18 @@ struct page_cgroup;
>  struct page;
>  struct mm_struct;
>  
> -/* Stats that can be updated by kernel. */
> -enum mem_cgroup_page_stat_item {
> -	MEMCG_NR_FILE_MAPPED, /* # of pages charged as file rss */
> +/*
> + * Statistics for memory cgroup.
> + */
> +enum mem_cgroup_stat_index {
> +	/*
> +	 * For MEM_CONTAINER_TYPE_ALL, usage = pagecache + rss.
> +	 */
> +	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
> +	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as anon rss */
> +	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
> +	MEM_CGROUP_STAT_SWAP, /* # of pages, swapped out */
> +	MEM_CGROUP_STAT_NSTATS,
>  };

Nit.  Moving mem_cgroup_stat_index from memcontrol.c to memcontrol.h is
fine with me.  But this does increase the distance between related
defintions of definition mem_cgroup_stat_index and
mem_cgroup_stat_names.  These two lists have to be kept in sync.  So it
might help to add a comment to both indicating their relationship so we
don't accidentally modify the enum without updating the dependent string
table.

Otherwise, looks good.

Reviewed-by: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
