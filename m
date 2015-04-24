From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v10 3/4] cgroups: allow a cgroup subsystem to reject a
 fork
Date: Fri, 24 Apr 2015 11:48:30 -0400
Message-ID: <20150424154830.GD24029@htj.duckdns.org>
References: <1429446154-10660-1-git-send-email-cyphar@cyphar.com>
 <1429446154-10660-4-git-send-email-cyphar@cyphar.com>
 <20150422155445.GD10738@htj.duckdns.org>
 <CAOviyajrizKYCbSZZU0BzYeH_8A62_vq1zyzJ-z7=qBV+owWSg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=6w613qdg58JJ9l21GNSwfVtNEcMeeqq9wogF5S8R7mg=;
        b=udGfDdcvMso0+y/F+0KXaZ8y6CLEAm1tiWpKGV5mrhYtbNDJStz2MKsxb68aFqv/0/
         yBOZaBrdVpVp412SszmClpBvZhDh3mDe50vbjnpcc47aPolbmthKcdIHpbODSforiAVV
         OCS8846qG4hQzUnmu4IICOAo6xzrBBPsYYLao0tT42dBMgQUqktvjiQAHrXcQsQqE0vm
         KCfdElrPXx1LgyIweOKPTgVK/r6HRTGLyHgdwIX1dw0CuwHqqJ5FtpWdLxnl+jkAwN2P
         rznlcQOd7y3lnF6p/OF8Q2LL8eebVF448MI5qOWQ7+S7PctaHsQ2CMupIU/gc0ib2rD4
         LT2g==
Content-Disposition: inline
In-Reply-To: <CAOviyajrizKYCbSZZU0BzYeH_8A62_vq1zyzJ-z7=qBV+owWSg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org, richard@nod.at, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Fri, Apr 24, 2015 at 11:59:31PM +1000, Aleksa Sarai wrote:
> Hey,
> 
> >> +#define CGROUP_PREFORK_COUNT 0
> >> +
> >>  static inline int cgroup_init_early(void) { return 0; }
> >>  static inline int cgroup_init(void) { return 0; }
> >>  static inline void cgroup_fork(struct task_struct *p) {}
> >> -static inline void cgroup_post_fork(struct task_struct *p) {}
> >> +static inline int cgroup_can_fork(struct task_struct *p,
> >> +                               void *s[CGROUP_PREFORK_COUNT])
> >> +{
> >> +     return 0;
> >> +}
> >
> > Style consistency?
> 
> It's because it wraps. I can move it to be something like:
> 
> static inline int cgroup_can_fork(struct task_struct *p,
>                                void *s[CGROUP_PREFORK_COUNT])
>                                { return 0; }

static inline int cgroup_can_fork(struct task_struct *p,
				  void *s[CGROUP_PREFORK_COUNT])
{ return 0; }

> >> @@ -2078,6 +2084,18 @@ static void cgroup_task_migrate(struct cgroup *old_cgrp,
> >>       list_move_tail(&tsk->cg_list, &new_cset->mg_tasks);
> >>
> >>       /*
> >> +      * We detach from the old_cset subsystems here. We must do this
> >> +      * before we drop the refcount for old_cset, in order to make sure
> >> +      * that nobody frees it underneath us.
> >> +      */
> >> +     for_each_e_css(css, i, old_cgrp) {
> >> +             struct cgroup_subsys_state *old_css = old_cset->subsys[i];
> >> +
> >> +             if (old_css->ss->detach)
> >> +                     old_css->ss->detach(old_css, tsk);
> >> +     }
> >
> > I don't get this.  What can ->detach do that ->can_attach cannot?
> 
> ->detach signifies that a task is being migrated away from a cgroup.
> On second thought, we could just use task_css() on each task in the
> tset to figure out what the cgroup the task is being migrated away
> from is and just uncharge that inside ->can_attach.

Yeah, that's how it's supposed to be used.  You have access to both
pre and post csses before migration and only to the new ones once by
the time ->attach() is running.

> On the same point, are all the tasks in a tset passed to ->can_attach
> guaranteed to have the same css? Or do I have to uncharge each one
> individually?

They're the same.

Thanks.

-- 
tejun
