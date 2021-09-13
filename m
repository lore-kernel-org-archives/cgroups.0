From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: Fix incorrect warning from
 cgroup_apply_control_disable()
Date: Mon, 13 Sep 2021 08:05:55 -1000
Message-ID: <YT+TA6ItnF9xM3cR@slm.duckdns.org>
References: <20210910024256.7615-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lTZVobgM/3IcweDVBRrPU9HP9E4rGk6Uc/SK3CeJgbs=;
        b=hz+MNqFoGnCqooN4pC0ZNqbr8/ZDMZ29FkRELhIRuC5hKGL9L9J9cPYqbJJJ9EeVlD
         uieVwHvuZtCzWv2i9+5nUuSYWc6YHpCTvW/uCVKVWanM3bGO9clHLlZDJTRQdh+vStXT
         JebR147UMte2xKNSG766+KWPqjmormL7wvrfV4Oo6q7tYf9OBdp3Q9Sgyp+cXVXKPhd2
         LZbVzW+nhGFJ8DywljsBashi5kxWlbVV3SrTxrThfU+pfx9HknFRDPUv/2nBqsbfr0kF
         mIB2JcID3JCKEdZYv1v67prapGM5itGUbWpzNfCUP+Gqx5xyBuRbv2pPH1Nx8ieaI2kr
         VBnQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210910024256.7615-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, Sep 09, 2021 at 10:42:55PM -0400, Waiman Long wrote:
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 881ce1470beb..e31bca9fcd46 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -3140,7 +3140,16 @@ static void cgroup_apply_control_disable(struct cgroup *cgrp)
>  			if (!css)
>  				continue;
>  
> -			WARN_ON_ONCE(percpu_ref_is_dying(&css->refcnt));
> +			/*
> +			 * A kill_css() might have been called previously, but
> +			 * the css may still linger for a while before being
> +			 * removed. Skip it in this case.
> +			 */
> +			if (percpu_ref_is_dying(&css->refcnt)) {
> +				WARN_ON_ONCE(css->parent &&
> +					cgroup_ss_mask(dsct) & (1 << ss->id));
> +				continue;
> +			}

This warning did help me catch some gnarly bugs. Any chance we can keep it
for normal cases and elide it just for remounting?

Thanks.

-- 
tejun
