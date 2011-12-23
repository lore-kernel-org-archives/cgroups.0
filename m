From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: Remove task_lock() from cgroup_post_fork()
Date: Fri, 23 Dec 2011 15:00:13 -0800
Message-ID: <20111223230013.GV17084@google.com>
References: <1324610723-30080-1-git-send-email-fweisbec@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=09zBcSkd4K9ouU8ySekwIXJo+0p8fNpGfGAfTr464S4=;
        b=c/PSo4RMHpUkovQ1XV/wsJP7ndU86hGxxgO7FgVvAR9341rhleWdM48+kmIeyevGT8
         LghritekFWScHC960aI92BtJdpPzrmQi2hhZnwmECg4oGWcTJ0BwpMgOq08Kv+nEEuX+
         zzEx3Giu4BlNmjpY1kogSW9tSxLG0uVBXpVpo=
Content-Disposition: inline
In-Reply-To: <1324610723-30080-1-git-send-email-fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>, Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

On Fri, Dec 23, 2011 at 04:25:23AM +0100, Frederic Weisbecker wrote:
> cgroup_post_fork() is protected between threadgroup_change_begin()
> and threadgroup_change_end() against concurrent changes of the
> child's css_set in cgroup_task_migrate(). Also the child can't
> exit and call cgroup_exit() at this stage, this means it's css_set
> can't be changed with init_css_set concurrently.
> 
> For these reasons, we don't need to hold task_lock() on the child
> because it's css_set can only remain stable in this place.
> 
> Let's remove the lock there.
> 
> v2: Update comment to explain that we are safe against
> cgroup_exit()
> 
> Signed-off-by: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
> Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>
> Cc: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

Li, does this look good to you?

Thanks.

-- 
tejun
