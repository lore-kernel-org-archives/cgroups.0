From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: remove tasklist_lock from
 cgroup_attach_proc
Date: Thu, 22 Dec 2011 14:51:02 -0800
Message-ID: <20111222225102.GM17084@google.com>
References: <1324592816-13792-1-git-send-email-msb@chromium.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=bbK7L/8f76esS7aYW+5z+N/09Ms78+K9VKfjiFXsc/s=;
        b=okr88tp279RFcjJ/2ZTDY0FsirWd+h8kw5bjBJT5ndngc5lPS0qF2k19+aAlggv2s0
         ao7TO59rNiA75GdihAOuQqRG+ZkkGBgg5M5S9srglwnnFHUYZWMQmasoEvxGnnqG7sWo
         n0BOQWzqG4RbUz7xR/76eo8+mfINSOZdIXm18=
Content-Disposition: inline
In-Reply-To: <1324592816-13792-1-git-send-email-msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>

Hello,

On Thu, Dec 22, 2011 at 02:26:55PM -0800, Mandeep Singh Baines wrote:
> @@ -2283,14 +2261,26 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
>  
>  	threadgroup_lock(tsk);
>  
> -	if (threadgroup)
> +	if (threadgroup) {
> +		if (!thread_group_leader(tsk)) {
> +			/*
> +			 * a race with de_thread from another thread's exec()
> +			 * may strip us of our leadership, if this happens,
> +			 * there is no choice but to throw this task away and
> +			 * try again (from cgroup_procs_write); this is
> +			 * "double-double-toil-and-trouble-check locking".
> +			 */
> +			ret = -EAGAIN;
> +			goto out_unlock_threadgroup;
> +		}
>  		ret = cgroup_attach_proc(cgrp, tsk);

Ummm... can't we just do tsk = tsk->leader after locking threadgroup?
Why do we need to retry from the beginning?

Thanks.

-- 
tejun
