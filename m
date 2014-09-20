From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: Racy manipulation of task_struct->flags in cgroups code causes
 hard to reproduce kernel panics
Date: Sat, 20 Sep 2014 16:30:12 +0200
Message-ID: <20140920143012.GL2832@worktop.localdomain>
References: <201409192053.IHJ35462.JLOMOSOFFVtQFH@I-love.SAKURA.ne.jp>
 <541D16EA.70407@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <541D16EA.70407-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fernando_b1-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org

On Sat, Sep 20, 2014 at 01:55:54PM +0800, Zefan Li wrote:
> We should make the updating of this flag atomic.

>  /* Per-process atomic flags. */
>  #define PFA_NO_NEW_PRIVS 0x00000001	/* May not gain new privileges. */
> +#define PFA_SPREAD_PAGE  0x00000002	/* Spread page cache over cpuset */
> +#define PFA_SPREAD_SLAB  0x00000004	/* Spread some slab caches over cpuset */

Ooh, I was not ware we had those.. /me checks where that came from. Hmm
weird, while I did get that patch it had a seccomp prefix when landing
in my inbox so I ignored it. However the commit has a sched prefix
(which I would not have ignored). Dubious things happened here.

