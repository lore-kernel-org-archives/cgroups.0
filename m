From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.7-fixes 1/2] Revert "cgroup: Remove
 task_lock() from cgroup_post_fork()"
Date: Fri, 19 Oct 2012 09:35:26 -0400
Message-ID: <CAFTL4hz82==b3ioSMhbKzh0CN1ivR7RQMKKMFFWu5PHPjg=Bfg@mail.gmail.com>
References: <20121008020000.GB2575@localhost>
	<20121019005922.GG13370@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=bRuC5SbbbLZEIvhPGbE7bVDsM/gfKSh/JtKma6v8Oos=;
        b=P4CwUj2P6vsxpPzcTu2CCpzVHCWFhVhQdnZvK6LaT/parmmzs/1BaVawpS+KNQLhYm
         HqnftFwAkhU8fUrq8G4N/kbs3nudNX0TGBjuUaONHoTEGouJY1t71a+hhk3BufjArg6m
         5Sjz3qtBAoafZEfY8gfWvPN0yrtHIE/uhWXSD+LJ6q6nD0yIsd8de1Al541jamvrP/UU
         v81Z7qsM2OGFhx+KaaeMASjlYSszQ2pTUxhSX0zKe2olbSL4o6F4T/k3nTk2RZUF5mkp
         /MsDQX1Ltw++PhXU5zii3TL0/qr11BHQHYRc2h66qZ0RA8ccY5HjX808F2BQMyKcT6d+
         jGlg==
In-Reply-To: <20121019005922.GG13370-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

2012/10/18 Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> From d935a5d6832a264ce52f4257e176f4f96cbaf048 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Thu, 18 Oct 2012 17:40:30 -0700
>
> This reverts commit 7e3aa30ac8c904a706518b725c451bb486daaae9.
>
> The commit incorrectly assumed that fork path always performed
> threadgroup_change_begin/end() and depended on that for
> synchronization against task exit and cgroup migration paths instead
> of explicitly grabbing task_lock().
>
> threadgroup_change is not locked when forking a new process (as
> opposed to a new thread in the same process) and even if it were it
> wouldn't be effective as different processes use different threadgroup
> locks.
>
> Revert the incorrect optimization.

Ok but there is still no good reason to task_lock() there. But the
comment is indeed wrong,  how about fixing it instead? I can send you
a patch for that.

>
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> LKML-Reference: <20121008020000.GB2575@localhost>
> Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  kernel/cgroup.c |   15 +++------------
>  1 files changed, 3 insertions(+), 12 deletions(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index d1739fc..2990dc7 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -4894,19 +4894,10 @@ void cgroup_post_fork(struct task_struct *child)
>          */
>         if (use_task_css_set_links) {
>                 write_lock(&css_set_lock);
> -               if (list_empty(&child->cg_list)) {
> -                       /*
> -                        * It's safe to use child->cgroups without task_lock()
> -                        * here because we are protected through
> -                        * threadgroup_change_begin() against concurrent
> -                        * css_set change in cgroup_task_migrate(). Also
> -                        * the task can't exit at that point until
> -                        * wake_up_new_task() is called, so we are protected
> -                        * against cgroup_exit() setting child->cgroup to
> -                        * init_css_set.
> -                        */
> +               task_lock(child);
> +               if (list_empty(&child->cg_list))
>                         list_add(&child->cg_list, &child->cgroups->tasks);
> -               }
> +               task_unlock(child);
>                 write_unlock(&css_set_lock);
>         }
>  }
> --
> 1.7.7.3
>
