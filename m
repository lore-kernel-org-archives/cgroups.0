From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix potential null pointer risk
Date: Tue, 17 May 2022 07:07:37 -1000
Message-ID: <YoPWWfoZ+6PrHuJl@slm.duckdns.org>
References: <20220517073106.1704628-1-zhangshida@kylinos.cn>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fCK6k5MFQxA5ofqm3sgSZqcQRtroxcs0pcd/twtbxgs=;
        b=BXxc1xeYwvdZuKq+L1ImlO+eEzBSBJ/fuHX1PvyDFx/UsMhB8eldZQyePIueHxk1ka
         x0le8JCihnmd+lLB7lUun6Ik3LDS4/HKxDUiuAcMZCeXOuxH0+3S3IE+r/d/9SaMXfKQ
         EMsw2iFrg7ptTTeORMukmKhFNWRDNT0RPWhL764/LTok3qS+VphpXFzecwxLPFB2LyF+
         3JiroJGsKWPBB034qarLfZgooLAbbFMYXN/D6i3JUHj98KZcGRgaD1QEBO4npkIbGwjj
         W+U0CD3+H7Q7jFxZuIN8VRKxuFnf1dCjqf+G8HPTWDJQfweDmxHBW6sykhvjwf6DtWZF
         6x/A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220517073106.1704628-1-zhangshida-UOlijcLmZ/InDS1+zs4M5A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shida Zhang <starzhangzsd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, zhangshida-UOlijcLmZ/InDS1+zs4M5A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, May 17, 2022 at 03:31:06PM +0800, Shida Zhang wrote:
> We previously assumed 'parent' could be null,
> so null pointer judgment should be added.
> 
> Signed-off-by: Shida Zhang <zhangshida-UOlijcLmZ/InDS1+zs4M5A@public.gmane.org>
> ---
>  kernel/cgroup/cgroup.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index adb820e98f24..7f230b0ab644 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -5701,7 +5701,8 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
>  	}
>  	spin_unlock_irq(&css_set_lock);
>  
> -	cgroup1_check_for_release(parent);
> +	if (parent)
> +		cgroup1_check_for_release(parent);

The function is never called for a root cgroup. The parent check up above in
the same function is superflous. So, maybe remove that?

Thanks.

-- 
tejun
