From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH mm v2 3/3] mm: automatically penalize tasks with high
 swap use
Date: Wed, 13 May 2020 10:38:14 +0200
Message-ID: <20200513083814.GT29153@dhcp22.suse.cz>
References: <20200511225516.2431921-1-kuba@kernel.org>
 <20200511225516.2431921-4-kuba@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200511225516.2431921-4-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Mon 11-05-20 15:55:16, Jakub Kicinski wrote:
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 5f12f203822e..c60226daa193 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1374,6 +1374,22 @@ PAGE_SIZE multiple when read back.
>  	The total amount of swap currently being used by the cgroup
>  	and its descendants.
>  
> +  memory.swap.high
> +	A read-write single value file which exists on non-root
> +	cgroups.  The default is "max".
> +
> +	Swap usage throttle limit.  If a cgroup's swap usage exceeds
> +	this limit, all its further allocations will be throttled to
> +	allow userspace to implement custom out-of-memory procedures.
> +
> +	This limit marks a point of no return for the cgroup. It is NOT
> +	designed to manage the amount of swapping a workload does
> +	during regular operation. Compare to memory.swap.max, which
> +	prohibits swapping past a set amount, but lets the cgroup
> +	continue unimpeded as long as other memory can be reclaimed.
> +
> +	Healthy workloads are not expected to reach this limit.
> +

Btw. I forgot to mention that before but you should also add a
documentation for the swap high event to this file.
-- 
Michal Hocko
SUSE Labs
