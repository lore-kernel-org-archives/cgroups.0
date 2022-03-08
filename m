From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/3] mm: use vmalloc_array and vcalloc for array
 allocations
Date: Tue, 8 Mar 2022 14:49:01 +0100
Message-ID: <YidezSPVZBCQcGJ4@dhcp22.suse.cz>
References: <20220308105918.615575-1-pbonzini@redhat.com>
 <20220308105918.615575-3-pbonzini@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646747341; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SyTgM5F6+9CT4oBrYUK4bC/XMWpEt2BZNDE3I1Sk7Ys=;
        b=SOLJf8KzF3lpV2Z1nK2RtJ/mCHih8E/LOT3+NtV9WjuFZrbvkvNGfz9md9KsmuMAmYb4xl
        mrgfppZj4eTymdy2LnRjU7ToP7z5QKvHD+Fb5G9Y3hGjHgDOXnP7/F9d/3dhoWrdQoV6gE
        PQ9kK/Trd67H0yxar7509l2hpkGD6SA=
Content-Disposition: inline
In-Reply-To: <20220308105918.615575-3-pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 08-03-22 05:59:17, Paolo Bonzini wrote:
> Instead of using array_size or just a multiply, use a function that
> takes care of both the multiplication and the overflow checks.
> 
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Signed-off-by: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

The resulting code is easier to read indeed.

> ---
>  mm/percpu-stats.c | 2 +-
>  mm/swap_cgroup.c  | 4 +---
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/percpu-stats.c b/mm/percpu-stats.c
> index c6bd092ff7a3..e71651cda2de 100644
> --- a/mm/percpu-stats.c
> +++ b/mm/percpu-stats.c
> @@ -144,7 +144,7 @@ static int percpu_stats_show(struct seq_file *m, void *v)
>  	spin_unlock_irq(&pcpu_lock);
>  
>  	/* there can be at most this many free and allocated fragments */
> -	buffer = vmalloc(array_size(sizeof(int), (2 * max_nr_alloc + 1)));
> +	buffer = vmalloc_array(2 * max_nr_alloc + 1, sizeof(int));
>  	if (!buffer)
>  		return -ENOMEM;
>  
> diff --git a/mm/swap_cgroup.c b/mm/swap_cgroup.c
> index 7f34343c075a..5a9442979a18 100644
> --- a/mm/swap_cgroup.c
> +++ b/mm/swap_cgroup.c
> @@ -167,14 +167,12 @@ unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
>  int swap_cgroup_swapon(int type, unsigned long max_pages)
>  {
>  	void *array;
> -	unsigned long array_size;
>  	unsigned long length;
>  	struct swap_cgroup_ctrl *ctrl;
>  
>  	length = DIV_ROUND_UP(max_pages, SC_PER_PAGE);
> -	array_size = length * sizeof(void *);
>  
> -	array = vzalloc(array_size);
> +	array = vcalloc(length, sizeof(void *));
>  	if (!array)
>  		goto nomem;
>  
> -- 
> 2.31.1
> 
> 

-- 
Michal Hocko
SUSE Labs
