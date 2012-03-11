From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 13/13] memcg: Document kernel memory accounting.
Date: Sun, 11 Mar 2012 14:42:00 +0400
Message-ID: <4F5C8178.7000601@parallels.com>
References: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org> <1331325556-16447-14-git-send-email-ssouhlal@FreeBSD.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331325556-16447-14-git-send-email-ssouhlal-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Suleiman Souhlal <ssouhlal-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dan.magenheimer-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 03/10/2012 12:39 AM, Suleiman Souhlal wrote:
> Signed-off-by: Suleiman Souhlal<suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>   Documentation/cgroups/memory.txt |   44 ++++++++++++++++++++++++++++++++++---
>   1 files changed, 40 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> index 4c95c00..73f2e38 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
> @@ -74,6 +74,11 @@ Brief summary of control files.
>
>    memory.kmem.tcp.limit_in_bytes  # set/show hard limit for tcp buf memory
>    memory.kmem.tcp.usage_in_bytes  # show current tcp buf memory allocation
> + memory.kmem.usage_in_bytes	 # show current kernel memory usage
> + memory.kmem.limit_in_bytes	 # show/set limit of kernel memory usage
> + memory.kmem.independent_kmem_limit # show/set control of kernel memory limit
> + 				    (See 2.7 for details)
> + memory.kmem.slabinfo		 # show cgroup's slabinfo
>
>   1. History
>
> @@ -265,11 +270,19 @@ the amount of kernel memory used by the system. Kernel memory is fundamentally
>   different than user memory, since it can't be swapped out, which makes it
>   possible to DoS the system by consuming too much of this precious resource.
>
> -Kernel memory limits are not imposed for the root cgroup. Usage for the root
> -cgroup may or may not be accounted.
> +Kernel memory limits are not imposed for the root cgroup.
>
> -Currently no soft limit is implemented for kernel memory. It is future work
> -to trigger slab reclaim when those limits are reached.
> +A cgroup's kernel memory is counted into its memory.kmem.usage_in_bytes.
> +
> +memory.kmem.independent_kmem_limit controls whether or not kernel memory
> +should also be counted into the cgroup's memory.usage_in_bytes.
> +If it is set, it is possible to specify a limit for kernel memory with
> +memory.kmem.limit_in_bytes.
> +
> +Upon cgroup deletion, all the remaining kernel memory becomes unaccounted.
> +
> +An accounted kernel memory allocation may trigger reclaim in that cgroup,
> +and may also OOM.
Why delete the softlimit bit? Since we're not shrinking, at least for 
the independent kmem case, we effectively don't do softlimits here. The 
file for it does not even exist...

>
>   2.7.1 Current Kernel Memory resources accounted
>
> @@ -279,6 +292,29 @@ per cgroup, instead of globally.
>
>   * tcp memory pressure: sockets memory pressure for the tcp protocol.
>
> +* slab memory.
> +
> +2.7.1.1 Slab memory accounting
> +
> +Any slab type created with the SLAB_MEMCG_ACCT kmem_cache_create() flag
> +is accounted.
> +
> +Slab gets accounted on a per-page basis, which is done by using per-cgroup
> +kmem_caches. These per-cgroup kmem_caches get created on-demand, the first
> +time a specific kmem_cache gets used by a cgroup.
> +
> +Only slab memory that can be attributed to a cgroup gets accounted in this
> +fashion.
> +
> +A per-cgroup kmem_cache is named like the original, with the cgroup's name
> +in parentheses.
> +
> +When a cgroup is destroyed, all its kmem_caches get migrated to the root
> +cgroup, and "dead" is appended to their name, to indicate that they are not
> +going to be used for new allocations.
> +These dead caches automatically get removed once there are no more active
> +slab objects in them.
> +
>   3. User Interface
>
>   0. Configuration
