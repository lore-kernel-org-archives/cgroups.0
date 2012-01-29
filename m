From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove extra calls to find_existing_css_set
Date: Sun, 29 Jan 2012 12:37:49 -0800
Message-ID: <20120129203749.GE17211@htj.dyndns.org>
References: <1327429591-8507-1-git-send-email-msb@chromium.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=0K9oTIzKXN6nS8b0FdJLLmBGOm1sJ4NApH/7ZKeljQM=;
        b=F41985KGhoHEBp+bytZlK/irw5qkyZOsAXggMidKqCzIQS5I/ZcyViN+0cNXskxLvi
         VwiKhkxQmfmOddyM67ZR7ldCpzofFKc9uNtmbxcTcvtSDeOpW7K0lDF+jmQVIoDUDqsP
         JXML7cYKfoJ4yfmyDDdhamjMdiPabgpYIVeZ8=
Content-Disposition: inline
In-Reply-To: <1327429591-8507-1-git-send-email-msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>

Hello, Manddep.

On Tue, Jan 24, 2012 at 10:26:31AM -0800, Mandeep Singh Baines wrote:
> In cgroup_attach_proc, we indirectly call find_existing_css_set 3
> times. It is an expensive call so we want to call it a minimum
> of times. This patch only calls it once and stores the result so
> that it can be used later on when we call cgroup_task_migrate.
> 
> This required modifying cgroup_task_migrate to take the new css_set
> (which we obtained from find_css_set) as a parameter. The nice side
> effect of this is that cgroup_task_migrate is now identical for
> cgroup_attach_task and cgroup_attach_proc. It also now returns a
> void since it can never fail.
> 
> Changes in V5:
> * https://lkml.org/lkml/2012/1/20/344 (Tejun Heo)
>   * Remove css_set_refs
             ^^^^^^^^^^^^
>  static int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
>  {
> -	int retval, i, group_size;
> +	int retval, i, group_size, css_set_refs = 0;
				   ^^^^^^^^^^^^
Wrong patch?

Thanks.

-- 
tejun
