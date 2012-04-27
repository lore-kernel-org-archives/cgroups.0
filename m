From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH 3/7 v2] res_counter: add
 res_counter_uncharge_until()
Date: Fri, 27 Apr 2012 11:18:40 -0700
Message-ID: <20120427181840.GH26595@google.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
 <4F9A343F.7020409@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=/Fps8Nj7v0z4wf2V3FDym+alLECRWMZk21NPZE5nvWw=;
        b=JpVrk9epctLNF3jnfsVo/1jp5VidJyiErmV/JW1ZY58+DugRUJPKt04KdJozooKrvH
         fnKVFudp91K01VgUzFQbc5zebh3PDicAW487mswLr2VKB8r9eQo84GPNr92qBIMJ+XkF
         RhU6jNOwq4E2uQwE6/jancR7+0OknEDNafor6nerlo+tRj5mzqIDEKot7Spw98INcT/i
         d9v6t/9sqMgIH8sxs0WZtJMvMvh19g4bPpBTmW7ANKSWV1LNn/4//aQ7ysm9tktThegv
         S+gvs+1TIPolNgkmvrZ96EsMd2Jexc1V8tIjrFWOnkCbI18gPfR/t7ruDYY5evx7tuDF
         0zqQ==
Content-Disposition: inline
In-Reply-To: <4F9A343F.7020409-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Fri, Apr 27, 2012 at 02:53:03PM +0900, KAMEZAWA Hiroyuki wrote:
> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
> index d508363..f4ec411 100644
> --- a/kernel/res_counter.c
> +++ b/kernel/res_counter.c
> @@ -66,6 +66,8 @@ done:
>  	return ret;
>  }
>  
> +
> +

Contamination?

-- 
tejun
