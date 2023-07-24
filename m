From: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] misc_cgroup: Fix the obsolete comment around 'struct
 misc_res'
Date: Mon, 24 Jul 2023 19:14:05 +0530
Message-ID: <7690e7b2-6e7f-6ff1-5249-72f497f82f7e@oracle.com>
References: <20230724115425.1452383-1-kai.huang@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=/f4rAVigOcdaQGMxLbatsMRm6FWYKHMEfV7JzyxVa0w=;
 b=uyWi7UgT2/S4O3yOaQWzeEMStSqcUKqd3KnBZN0kyWj5TKzYsgNAZnLqsVgf3GJo9ATw
 kb8WhrbtLbqgmMSDK0/uPNi+1fBaH5l5sWnJpXOIPeSbVWd8BXHAyrkzkIbBYHJ/j0yw
 5vxRV5a2WMEVSvLYevqmOIOajsltnkFLCydYOtbph7+oSqFRByDV/QWrs4XSpfZZ5f38
 djMNLS8Ie04OMlsSreT5HzCMqCcbCRsNJq9fpSEhCBY2rzr8DSR4HTCtckhhFkaprHCj
 VZw41Exd+8jHbkYZvV5Z1jfRPYWDwWbaTCrlz4mm4icB/RvxrnELAuNHbkT5iThb8q/e Kg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/f4rAVigOcdaQGMxLbatsMRm6FWYKHMEfV7JzyxVa0w=;
 b=e5tvg9UKNUKjKLynULS+1ER+pA0f3N7wbIdLY4yikl+T0KloM2RkJGG+pqIqLYU2NmhGQwP58jsYjNcb1UJhdv2pqZw8tpbkEblmLchddpn1J285guxF8pnuicT+aNHlCeLDd1axsRLN8XsDqOYa2hdD/rSLGOyJBQIQdPvaFPw=
Content-Language: en-US
In-Reply-To: <20230724115425.1452383-1-kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kai Huang <kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 7/24/23 17:24, Kai Huang wrote:
> The comment of the 'failed' member of 'struct misc_res' is obsolete
> since commit b03357528fd9 ("misc_cgroup: remove error log to avoid log
> flood"), which removed the 'failed' member from the structure.  Remove
> the obsolete comment.
> 
> Also add the missing comment for the 'events' field, which should come
> with commit f279294b3293 ("misc_cgroup: introduce misc.events to count
> failures") where the 'events' member was added.

This has been fixed by:
https://lore.kernel.org/lkml/20230718090834.1829191-1-kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org/

> 
> Signed-off-by: Kai Huang <kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  include/linux/misc_cgroup.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
> index c238207d1615..41aa213a1125 100644
> --- a/include/linux/misc_cgroup.h
> +++ b/include/linux/misc_cgroup.h
> @@ -31,7 +31,7 @@ struct misc_cg;
>   * struct misc_res: Per cgroup per misc type resource
>   * @max: Maximum limit on the resource.
>   * @usage: Current usage of the resource.
> - * @failed: True if charged failed for the resource in a cgroup.
> + * @events: Charge failure event counter of the resource.
>   */
>  struct misc_res {
>  	unsigned long max;
> 
> base-commit: 3f01e9fed8454dcd89727016c3e5b2fbb8f8e50c

-- 
Thanks,
Kamalesh
