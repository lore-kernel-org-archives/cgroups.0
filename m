From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: put controller Kconfig options in meaningful
 order
Date: Fri, 18 Dec 2015 10:26:05 +0800
Message-ID: <56736EBD.8060302@huawei.com>
References: <1450390797-4748-1-git-send-email-hannes@cmpxchg.org>
 <1450390797-4748-3-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450390797-4748-3-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On 2015/12/18 6:19, Johannes Weiner wrote:
> To make it easier to quickly find what's needed list the basic
> resource controllers of cgroup2 first - io, memory, cpu - while
> pushing the more exotic and/or legacy controllers to the bottom.
>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

> ---
>   init/Kconfig | 214 +++++++++++++++++++++++++++++------------------------------
>   1 file changed, 107 insertions(+), 107 deletions(-)
>
> diff --git a/init/Kconfig b/init/Kconfig
> index ed324f5..fdb5ecb 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -957,64 +957,6 @@ menuconfig CGROUPS
>
...
> +config CGROUP_PERF
> +	bool "Perf controller"
> +	depends on PERF_EVENTS && CGROUPS

While you are at it, remove "&& CGROUPS" ?

> +	help
> +	  This option extends the perf per-cpu mode to restrict monitoring
> +	  to threads which belong to the cgroup specified and run on the
> +	  designated cpu.
> +
> +	  Say N if unsure.
> +
> +config CGROUP_DEBUG
> +	bool "Example controller"
>   	default n
> -	---help---
> -	Enable some debugging help. Currently it exports additional stat
> -	files in a cgroup which can be useful for debugging.
> +	help
> +	  This option enables a simple controller that exports
> +	  debugging information about the cgroups framework.
>
> -config CGROUP_WRITEBACK
> -	bool
> -	depends on MEMCG && BLK_CGROUP
> -	default y
> +	  Say N.
>
>   endif # CGROUPS
>
>
