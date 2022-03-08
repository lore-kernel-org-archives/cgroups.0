From: Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] mm: use vmalloc_array and vcalloc for array
 allocations
Date: Tue, 8 Mar 2022 11:13:44 -0500
Message-ID: <YieAuCGMRrJjEHMR@fedora>
References: <20220308105918.615575-1-pbonzini@redhat.com>
 <20220308105918.615575-3-pbonzini@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220308105918.615575-3-pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Mar 08, 2022 at 05:59:17AM -0500, Paolo Bonzini wrote:
> Instead of using array_size or just a multiply, use a function that
> takes care of both the multiplication and the overflow checks.
> 
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Signed-off-by: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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

Acked-by: Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks,
Dennis
