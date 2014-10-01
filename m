From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] mm: memcontrol Use #include <linux/uaccess.h>
Date: Wed, 1 Oct 2014 17:56:34 +0200
Message-ID: <20141001155634.GB4405@dhcp22.suse.cz>
References: <1412178296-2972-1-git-send-email-paulmcquad@gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5ypUp9ZU8nTzBrSrl8n07HMoQuNH7i0bWrGPJPgH6ts=;
        b=YEDcojFp9aiDnETXMg2dJ2HKJn+OF9XX/4wQHfFwDsx7EYIWZpjONLLyQ8sJUi6I5m
         L6nFUC4Q4ICCIwtOtluMbXEefx1UrIohmuYKcdEK8I2GZyhyHUn5qbDbG79R4Gmhz7gm
         j+tL2Dcu9qsVUEipXCUrEKELLThoIp91WZk44vBQNj6wiIPkxKJpL7qBlOynz1lKGOVX
         a3/y7gJ9M5c769p4NLZ2bug1VWaOd2DU8dJWX2xxFOeOZ7F2F7hsjEv33AaUMY9btRNe
         79U0dhNZ3Ey8TZntE0IeD5Ca9v59+cWdZqKuFwXy6Jy4P3rV0+dhkjDqSdENmFgmi3yD
         Llkg==
Content-Disposition: inline
In-Reply-To: <1412178296-2972-1-git-send-email-paulmcquad@gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul McQuade <paulmcquad@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org

On Wed 01-10-14 16:44:56, Paul McQuade wrote:
> Remove asm headers for linux headers

I think we do not need this header at all these days. There are no
direct operations on user memory in memcontrol.c.

> Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
> ---
>  mm/memcontrol.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 085dc6d..51dbe80 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -56,14 +56,14 @@
>  #include <linux/oom.h>
>  #include <linux/lockdep.h>
>  #include <linux/file.h>
> +#include <linux/uaccess.h>
> +
>  #include "internal.h"
>  #include <net/sock.h>
>  #include <net/ip.h>
>  #include <net/tcp_memcontrol.h>
>  #include "slab.h"
>  
> -#include <asm/uaccess.h>
> -
>  #include <trace/events/vmscan.h>
>  
>  struct cgroup_subsys memory_cgrp_subsys __read_mostly;
> -- 
> 1.9.1
> 

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
