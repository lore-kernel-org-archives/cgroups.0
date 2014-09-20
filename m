From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: Racy manipulation of task_struct->flags in cgroups code causes
 hard to reproduce kernel panics
Date: Sat, 20 Sep 2014 20:04:18 +0200
Message-ID: <20140920180418.GR2832@worktop.localdomain>
References: <201409192053.IHJ35462.JLOMOSOFFVtQFH@I-love.SAKURA.ne.jp>
 <541D16EA.70407@huawei.com>
 <20140920143012.GL2832@worktop.localdomain>
 <CAGXu5j+P_kcgZuqYsemgL0KU_zRhz5HGJ6seh2oLyyst=cZP6g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5j+P_kcgZuqYsemgL0KU_zRhz5HGJ6seh2oLyyst=cZP6g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, fernando_b1-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

On Sat, Sep 20, 2014 at 10:15:50AM -0700, Kees Cook wrote:
> On Sat, Sep 20, 2014 at 7:30 AM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> > On Sat, Sep 20, 2014 at 01:55:54PM +0800, Zefan Li wrote:
> >> We should make the updating of this flag atomic.
> >
> >>  /* Per-process atomic flags. */
> >>  #define PFA_NO_NEW_PRIVS 0x00000001  /* May not gain new privileges. */
> >> +#define PFA_SPREAD_PAGE  0x00000002  /* Spread page cache over cpuset */
> >> +#define PFA_SPREAD_SLAB  0x00000004  /* Spread some slab caches over cpuset */
> >
> > Ooh, I was not ware we had those.. /me checks where that came from. Hmm
> > weird, while I did get that patch it had a seccomp prefix when landing
> > in my inbox so I ignored it. However the commit has a sched prefix
> > (which I would not have ignored). Dubious things happened here.
> 
> The series went through a lot of revisions, so it probably gained the
> sched prefix later in its life. Is there anything that needs changing
> about how this has been implemented?

No, don't think so, just got surprised.
