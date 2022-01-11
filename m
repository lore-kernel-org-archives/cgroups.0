From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Date: Mon, 10 Jan 2022 19:55:54 -0800
Message-ID: <CAJuCfpGtnzLJNpUhq2dG97Vm-NDue3v747Fr77RVSKxC_Sfx8Q@mail.gmail.com>
References: <20220111025138.1071848-1-surenb@google.com> <Ydz1jAp6RW3t0owj@sol.localdomain>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HVGAaZCv1PtP8nOdf8xI+Otrs0pFsPi16+2M9IA8PMA=;
        b=PMIR9AavQUxk2P1t/gnE4Ha0f/Wgo4AGsu7oSS5EfdhLWF8hH2BmwauKecM1SCvCc8
         ZPNsxv3Pv6UF/oAzDxrHn5CnM183oJ6eGMdLuw5ubV3lsrrymJRvS+0lo6Js59b/ogs+
         789aymY4wOEYcHOnccO148G4FXL1zTw4TU7yDu4Hw07B0aDffLc178WULiA1vQUOa9m/
         Y+eNn1w8PU3VtZ9kIbZQ/R2GUczSOgbu3mPHfzjh/RXIMfYApAz7eSHYCxD89Fg10h4t
         2kC7d6BkUZO+EdnOqnOAan9LvAm2tSQFtoDhLD/1VWO2MI73ddmTFQ7CFE26E9k/BI6q
         E8+A==
In-Reply-To: <Ydz1jAp6RW3t0owj@sol.localdomain>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Biggers <ebiggers@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Benjamin Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, cgroups mailinglist <cgroups@vger.kernel.org>, kernel-team <kernel-team@android.com>, syzbot <syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com>

On Mon, Jan 10, 2022 at 7:12 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Mon, Jan 10, 2022 at 06:51:38PM -0800, Suren Baghdasaryan wrote:
> > With write operation on psi files replacing old trigger with a new one,
> > the lifetime of its waitqueue is totally arbitrary. Overwriting an
> > existing trigger causes its waitqueue to be freed and pending poll()
> > will stumble on trigger->event_wait which was destroyed.
> > Fix this by disallowing to redefine an existing psi trigger. If a write
> > operation is used on a file descriptor with an already existing psi
> > trigger, the operation will fail with EBUSY error.
> > Also bypass a check for psi_disabled in the psi_trigger_destroy as the
> > flag can be flipped after the trigger is created, leading to a memory
> > leak.
> >
> > Reported-by: syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com
> > Analyzed-by: Eric Biggers <ebiggers@kernel.org>
> > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> Please include Fixes and Cc stable tags.

Ack.

>
> > diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> > index cafb8c114a21..e6878238fb19 100644
> > --- a/kernel/cgroup/cgroup.c
> > +++ b/kernel/cgroup/cgroup.c
> > @@ -3642,6 +3642,12 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
> >       cgroup_get(cgrp);
> >       cgroup_kn_unlock(of->kn);
> >
> > +     /* Allow only one trigger per file descriptor */
> > +     if (READ_ONCE(ctx->psi.trigger)) {
> > +             cgroup_put(cgrp);
> > +             return -EBUSY;
> > +     }
> > +
>
> Doesn't the task have exclusive access to the file at this point?  READ_ONCE()
> is only needed instead of a plain load when the field can be concurrently
> changed by another thread.

Yeah, you are right. Concurrent writes are serialized by of->mutex and
kernfs_release_file documents "@of is guaranteed to have no other file
operations in flight", so ->release() can't race with ->write(). Will
fix.

>
> > diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
> > index 1652f2bb54b7..882bf62cc247 100644
> > --- a/kernel/sched/psi.c
> > +++ b/kernel/sched/psi.c
> > @@ -1151,7 +1151,6 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
> >       t->event = 0;
> >       t->last_event_time = 0;
> >       init_waitqueue_head(&t->event_wait);
> > -     kref_init(&t->refcount);
> >
> >       mutex_lock(&group->trigger_lock);
> >
> > @@ -1180,15 +1179,21 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
> >       return t;
> >  }
> >
> > -static void psi_trigger_destroy(struct kref *ref)
> > +void psi_trigger_destroy(void **trigger_ptr)
> >  {
> > -     struct psi_trigger *t = container_of(ref, struct psi_trigger, refcount);
> > -     struct psi_group *group = t->group;
> > +     struct psi_trigger *t;
> > +     struct psi_group *group;
> >       struct task_struct *task_to_destroy = NULL;
> >
> > -     if (static_branch_likely(&psi_disabled))
> > +     /*
> > +      * We do not check psi_disabled since it might have been disabled after
> > +      * the trigger got created.
> > +      */
> > +     t = xchg(trigger_ptr, NULL);
> > +     if (!t)
> >               return;
>
> Likewise, doesn't the task have exclusive access to the file at this point?
> This is only called during ->release().

Yes, will fix.

>
> And why does this take a pointer to a pointer instead of just the pointer?

That was done to do atomic xchg, but as you mentioned, it's not needed
here. Will change.

>
> > @@ -1305,14 +1289,24 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
> >
> >       buf[buf_size - 1] = '\0';
> >
> > -     new = psi_trigger_create(&psi_system, buf, nbytes, res);
> > -     if (IS_ERR(new))
> > -             return PTR_ERR(new);
> > -
> >       seq = file->private_data;
> > +
> >       /* Take seq->lock to protect seq->private from concurrent writes */
> >       mutex_lock(&seq->lock);
> > -     psi_trigger_replace(&seq->private, new);
> > +
> > +     /* Allow only one trigger per file descriptor */
> > +     if (READ_ONCE(seq->private)) {
> > +             mutex_unlock(&seq->lock);
> > +             return -EBUSY;
> > +     }
>
> Likewise, what does this race against that would require the use of READ_ONCE()?

Will fix.
Thanks!

>
> - Eric
