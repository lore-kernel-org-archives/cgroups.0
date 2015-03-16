From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 1/3] cgroups: use bitmask to filter for_each_subsys
Date: Mon, 16 Mar 2015 12:42:14 -0400
Message-ID: <20150316164214.GB8353@htj.duckdns.org>
References: <1426307835-5893-1-git-send-email-cyphar@cyphar.com>
 <1426307835-5893-2-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=JRKWOZCnNJjtw/wVsqzrnMNlkAckam3Cs61eYKGaduY=;
        b=CUTSe9oWJaTtvaZvnyXl4t3Lrm9EGCSiXNWl2s9z4OVt7NEU/3dbdv28IObhnLf4kb
         v5yVOkYZtWLZ+/3dIYI0kwjDRx6aVj+oCksL34wQrlWtMw7hm9F9GErJFXpNEIR0xdMQ
         +ccMRGRqAk3c8/bbT0d12A3RPNwaqYiZ3GM5GURhVFTA1wFf0+LKP+kEVtgR05vGrdxp
         ALoDCKJEzacDpyqSnd1IM/M1odzX5CL9FFG4uw0BEWmitIVL3I3L5lkYoiZ7Mwyl9SFK
         vo1sv6pvdFZw3osl0ox+ZM38pHPlxY3XRHRXn+grzhm5nIdURyptAbSb31q339C67EZA
         9iRw==
Content-Disposition: inline
In-Reply-To: <1426307835-5893-2-git-send-email-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org, richard@nod.at, fweisbec@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hello,

On Sat, Mar 14, 2015 at 03:37:13PM +1100, Aleksa Sarai wrote:
> -/* This flag indicates whether tasks in the fork and exit paths should
> +/*
> + * This bitmask flag indicates whether tasks in the fork and exit paths should

Please reflow the comment.  It's going over 80col.  Also, wouldn't it
be clearer if the comment actually stated that the bitmask is
subsystem bitmask?

> @@ -4932,7 +4946,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
>  	 * init_css_set is in the subsystem's root cgroup. */
>  	init_css_set.subsys[ss->id] = css;
>  
> -	need_forkexit_callback |= ss->fork || ss->exit;
> +	need_forkexit_callback |= !!(ss->fork || ss->exit) << ss->id;

I generally prefer (bool) casts to !!'s these days but this doesn't
really matter.  More importantly, shouldn't we be splitting fork and
exit masks so that we don't have to test the callback existence later?

> @@ -5239,11 +5253,9 @@ void cgroup_post_fork(struct task_struct *child)
>  	 * css_set; otherwise, @child might change state between ->fork()
>  	 * and addition to css_set.
>  	 */
> -	if (need_forkexit_callback) {
> -		for_each_subsys(ss, i)
> -			if (ss->fork)
> -				ss->fork(child);
> -	}
> +	for_each_subsys_which(need_forkexit_callback, ss, i)
> +		if (ss->fork)
> +			ss->fork(child);
>  }

IOW, we should be able to do

	for_each_subsys_which(subsys_has_fork, ss, i)
		ss->fork(child);

And ditto for exit.

Thanks.

-- 
tejun
