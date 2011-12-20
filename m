From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/5] cgroup: separate out cgroup_attach_proc error
 handling code
Date: Tue, 20 Dec 2011 15:35:02 -0800
Message-ID: <20111220233502.GN10752@google.com>
References: <1324422873-31001-1-git-send-email-msb@chromium.org>
 <1324422873-31001-6-git-send-email-msb@chromium.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=JaE8DCHbG077fK150hKRTlO2wam7eKcD0GIw5038ZeQ=;
        b=KE+iS9DyZes4mH5ba6GdU+65MUz95B1gFV8EcMs0m7+FijH402dp6LGuG7iVrZaoTV
         CH/l4+X3uU66zWNFKN6LxC0nfWr9m3qeomy30gVZruTfBM6GhzlQvr/krDWoSSfin346
         y8WnnDwlmBTwUR/1ZW7Yt5kpxDNmWVrBuqFxs=
Content-Disposition: inline
In-Reply-To: <1324422873-31001-6-git-send-email-msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>

Hello,

On Tue, Dec 20, 2011 at 03:14:33PM -0800, Mandeep Singh Baines wrote:
> @@ -2067,9 +2067,10 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
>  	read_unlock(&tasklist_lock);
>  
>  	/* methods shouldn't be called if no task is actually migrating */
> -	retval = 0;
> -	if (!group_size)
> +	if (!group_size) {
> +		retval = 0;
>  		goto out_free_group_list;
> +	}

Eh... I don't think this is an improvement.  It's just different.

> @@ -2126,20 +2127,20 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
>  	 */
>  	synchronize_rcu();
>  	cgroup_wakeup_rmdir_waiter(cgrp);
> -	retval = 0;
> +	flex_array_free(group);
> +	return 0;

Hmm... maybe goto out_free_group_list?  Duplicating cleanup on success
and failure paths can lead future updaters forget one of them.  The
exit path in this function isn't pretty but I don't think the proposed
patch improves it either.

Thanks.

-- 
tejun
