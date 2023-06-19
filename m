From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] memcg: remove unneeded header files
Date: Mon, 19 Jun 2023 09:19:45 +0200
Message-ID: <ZJABkaSdZP+K6dOh@dhcp22.suse.cz>
References: <20230617072658.1826560-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1687159186; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GDE22N6RhZJ008soRf2pb0Es9I9DW+ry9z9nMBOE6Qs=;
        b=GIP9IjQevaWuqsO9XKJc0QPPQQxbsj457qjoQ/Jq9JjZyaVqo02HuYv28wkIPbskWuRoj6
        rPPkhzIkTk1xQYcqXuYrg/bazd3S40oCZ04mFdwzlKWloaOe1i3PHk0Doy1lv207fqbPbU
        HXlv+iPFOCBtv1Ul82ato2iLLjC99OI=
Content-Disposition: inline
In-Reply-To: <20230617072658.1826560-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat 17-06-23 15:26:58, Miaohe Lin wrote:
> Remove some unneeded header files. No functional change intended.

Header inclusion cleanups are certainly welcome but it would be much
more preferred to explain why those are not needed. As build test follow
ups show this is much more subtle than it seems.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  mm/memcontrol.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d42742edfeac..a2c82a18745d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -30,14 +30,10 @@
>  #include <linux/cgroup.h>
>  #include <linux/pagewalk.h>
>  #include <linux/sched/mm.h>
> -#include <linux/shmem_fs.h>
> -#include <linux/hugetlb.h>
>  #include <linux/pagemap.h>
>  #include <linux/vm_event_item.h>
>  #include <linux/smp.h>
>  #include <linux/page-flags.h>
> -#include <linux/backing-dev.h>
> -#include <linux/bit_spinlock.h>
>  #include <linux/rcupdate.h>
>  #include <linux/limits.h>
>  #include <linux/export.h>
> @@ -66,7 +62,6 @@
>  #include <linux/sched/isolation.h>
>  #include "internal.h"
>  #include <net/sock.h>
> -#include <net/ip.h>
>  #include "slab.h"
>  #include "swap.h"
>  
> -- 
> 2.27.0

-- 
Michal Hocko
SUSE Labs
