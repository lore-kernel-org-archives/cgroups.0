From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: fixed the cset refcnt leak when fork() failed
Date: Mon, 5 Jun 2023 10:12:25 -0400
Message-ID: <e0d1998f-c081-30e6-7646-cf6460c2d67c@redhat.com>
References: <20230605130444.1421-1-zoucao@kuaishou.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685974552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DACW0kCzVuT5IFaBn71kjqbpg34q1clPenVlI/hF2Iw=;
        b=arwOE3VzPy/DCFrU3713YNNwmY7pWySInwqgX6vVm6PNgDFGHSJqFDlKgkzU3JLq6+x3jr
        kfb+t7KLs4SSkkgHKGy4fojTvmxZqGVKsVJM7h4V41ZJdYBbR7VYNAbGYDB2eoIe/dwwOn
        o8reWw+jJLkQy2TvddeMNhTZeX4nI1Y=
Content-Language: en-US
In-Reply-To: <20230605130444.1421-1-zoucao-e2CXd7i0PsxWk0Htik3J/w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Zou Cao <zoucaox-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Zou Cao <zoucao-e2CXd7i0PsxWk0Htik3J/w@public.gmane.org>

On 6/5/23 09:04, Zou Cao wrote:
> TeamID: B1486294
What is this?
>
> when fork, cset will be increased by commit "ef2c41cf38a7", the refcnt will
> be decrease by child exit, but when failed in fork(), this refcnt will
> be lost decrease in cgroup_cancel_fork as follow:
>
> copy_process
>       |
> cgroup_can_fork    //  increase the css refcount
>    ......
>    spin_lock_irq(&css_set_lock);
>    cset = task_css_setcurrent);
>    get_css_set(cset);
>    spin_unlock_irq&css_set_lock);
>    ......

The code quoted above is actually in cgroup_css_set_fork(). You may want 
to list it as well.

I believe the problem is in

         if (!(kargs->flags & CLONE_INTO_CGROUP)) {
                 kargs->cset = cset;
                 return 0;
         }

When CLONE_INTO_CGROUP isn't set, a reference to the current cset is taken.

>       |
> goto cgroup_cancel_fork    // if failed in  copy_process
>       |
> cgroup_cancel_fork  // lost the decrease refcount if flag not CLONE_INTO_CGROUP
>
> Fixes: ef2c41cf38a7 ("clone3: allow spawning processes into cgroups")
> Signed-off-by: Zou Cao <zoucao-e2CXd7i0PsxWk0Htik3J/w@public.gmane.org>
> ---
>   kernel/cgroup/cgroup.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index d18c2ef..5ecd706 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -6284,6 +6284,11 @@ void cgroup_cancel_fork(struct task_struct *child,
>   		if (ss->cancel_fork)
>   			ss->cancel_fork(child, kargs->cset);
>   
> +	if (!(kargs->flags & CLONE_INTO_CGROUP) &&
> +			kargs->cset) {
> +		put_css_set(kargs->cset);
> +	}
> +
I believe the out_revert error path of cgroup_can_fork() has a similar 
issue. Perhaps you may want to put the put_css_set() call in 
cgroup_css_set_put_fork().
>   	cgroup_css_set_put_fork(kargs);
>   }
>   
Cheers,
Longman

