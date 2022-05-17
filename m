From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: Remove unnecessary rcu_read_lock/unlock()
Date: Tue, 17 May 2022 12:11:08 +0800
Message-ID: <CAMZfGtU8GYN6aLepHr3z=AvJ4XivmWpPdnvUBgaJUnmf37-28Q@mail.gmail.com>
References: <20220516173930.159535-1-bh1scw@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NO/qVr25gl9DWObhrjxNHN1PGGWIrTbPudg44b/JLeI=;
        b=6KEbpLl+WAWuaT8l95JqbSOJgxSfJpLNEobjxxcKridU4U1e87XUTvnUWU6odxyltG
         sXCcYvAJY+6YB1DpztmiFEnawZUnjEhrpZdrVqDMMN1cGgA1leE+uGdC2eL9FIQFSPdB
         xEO8+E2C/VI8ufjhzynb2Z+cjaYGHRHv3EiZaE0UgmgXsHBuI952bSfrr9GwiudXZovw
         CVqHc0o16YBvjIQ9aiw2/bi+cIfUuynJXbTcERUtjLZy+1Zd8Een7qt0NcebDbVycA6i
         4xth0GFVrEk/CoU07cQjxYG1M9u2NZERL1P5PXhcCQ6ywkbKUWXRQHnHLustaralGwoS
         2tXg==
In-Reply-To: <20220516173930.159535-1-bh1scw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bh1scw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:BLOCK LAYER" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, May 17, 2022 at 1:39 AM <bh1scw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> From: Fanjun Kong <bh1scw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> spin_lock_irq/spin_unlock_irq contains preempt_disable/enable().
> Which can serve as RCU read-side critical region, so remove
> rcu_read_lock/unlock().
>
> Signed-off-by: Fanjun Kong <bh1scw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Thanks.
