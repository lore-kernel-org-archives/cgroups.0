From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH] cpuset: Replace all instances of time_t with time64_t
Date: Wed, 25 Nov 2015 18:35:42 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1511251834550.12555@nanos>
References: <2798266.9VZu01a7d1@wuerfel>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2798266.9VZu01a7d1@wuerfel>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Heena Sirwani <heenasirwani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>


On Wed, 25 Nov 2015, Arnd Bergmann wrote:

> The following patch replaces all instances of time_t with time64_t i.e.
> change the type used for representing time from 32-bit to 64-bit. All
> 32-bit kernels to date use a signed 32-bit time_t type, which can only
> represent time until January 2038. Since embedded systems running 32-bit
> Linux are going to survive beyond that date, we have to change all
> current uses, in a backwards compatible way.
> 
> The patch also changes the function get_seconds() that returns a 32-bit
> integer to ktime_get_seconds() that returns seconds as 64-bit integer.
> 
> The patch changes the type of ticks from time_t to u32. We keep ticks as
> 32-bits as the function uses 32-bit arithmetic which would prove less
> expensive than 64-bit arithmetic and the function is expected to be
> called atleast once every 32 seconds.
> 
> Signed-off-by: Heena Sirwani <heenasirwani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> ---
> This is an older patch I still had in my queue. Who should pick it up?

Tejun, Cc'ed
 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 10ae73611d80..c9ea63ff70a7 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -51,6 +51,7 @@
>  #include <linux/stat.h>
>  #include <linux/string.h>
>  #include <linux/time.h>
> +#include <linux/time64.h>
>  #include <linux/backing-dev.h>
>  #include <linux/sort.h>
>  
> @@ -68,7 +69,7 @@ struct static_key cpusets_enabled_key __read_mostly = STATIC_KEY_INIT_FALSE;
>  struct fmeter {
>  	int cnt;		/* unprocessed events count */
>  	int val;		/* most recent output value */
> -	time_t time;		/* clock (secs) when val computed */
> +	time64_t time;		/* clock (secs) when val computed */
>  	spinlock_t lock;	/* guards read or write of above */
>  };
>  
> @@ -1374,7 +1375,7 @@ out:
>   */
>  
>  #define FM_COEF 933		/* coefficient for half-life of 10 secs */
> -#define FM_MAXTICKS ((time_t)99) /* useless computing more ticks than this */
> +#define FM_MAXTICKS ((u32)99)   /* useless computing more ticks than this */
>  #define FM_MAXCNT 1000000	/* limit cnt to avoid overflow */
>  #define FM_SCALE 1000		/* faux fixed point scale */
>  
> @@ -1390,8 +1391,11 @@ static void fmeter_init(struct fmeter *fmp)
>  /* Internal meter update - process cnt events and update value */
>  static void fmeter_update(struct fmeter *fmp)
>  {
> -	time_t now = get_seconds();
> -	time_t ticks = now - fmp->time;
> +	time64_t now;
> +	u32 ticks;
> +
> +	now = ktime_get_seconds();
> +	ticks = now - fmp->time;
>  
>  	if (ticks == 0)
>  		return;
> 
> 
