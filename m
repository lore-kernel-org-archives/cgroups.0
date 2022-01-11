From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Date: Mon, 10 Jan 2022 23:16:14 -0800
Message-ID: <CAJuCfpHtMLDgz=zU3zhWXjBwehZdEMqcy_F2NffKYPZyT6nR6w@mail.gmail.com>
References: <20220111025138.1071848-1-surenb@google.com> <Ydz1jAp6RW3t0owj@sol.localdomain>
 <CAJuCfpGtnzLJNpUhq2dG97Vm-NDue3v747Fr77RVSKxC_Sfx8Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mQovg6SglNQvBWc+EuM/TfAfk7u0q5Jg74wSPErxv4c=;
        b=tG03wDMmOJRXSRBc8wp4E4wA7I9VEb7bpZPJ80vCNMhwe10GsZAfhc0JSH6IiBzA4j
         mOO4X3qFcV5NKvkgIAvnIDXn8ry5EMrYTpkpQL87pJYmmnYLJMA0p6QHoR3EhO2YN4JF
         YNOoG+7MwKMaG26DtygwAXHMO4v7TC+x9Mi27XrdLR0CSBeCEjcTfMAB2JGo4n3NLaej
         boBHX13vs/0SfeX2LuuR+TSR5E98SJYuPbD8XQpThhPleVk3/0e7zwbSWIHb9F7hvZCj
         pAHRp7hXPzsb/Qir/7A78qAi2UzvLz74Ll/ZvyI1X1FjyIeXxshQvDw2BdOwbM9UZtvT
         ZQxg==
In-Reply-To: <CAJuCfpGtnzLJNpUhq2dG97Vm-NDue3v747Fr77RVSKxC_Sfx8Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Biggers <ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Benjamin Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, syzbot <syzbot+cdb5dd11c97cc532efad-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>

On Mon, Jan 10, 2022 at 7:55 PM Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Mon, Jan 10, 2022 at 7:12 PM Eric Biggers <ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Mon, Jan 10, 2022 at 06:51:38PM -0800, Suren Baghdasaryan wrote:
> > > With write operation on psi files replacing old trigger with a new one,
> > > the lifetime of its waitqueue is totally arbitrary. Overwriting an
> > > existing trigger causes its waitqueue to be freed and pending poll()
> > > will stumble on trigger->event_wait which was destroyed.
> > > Fix this by disallowing to redefine an existing psi trigger. If a write
> > > operation is used on a file descriptor with an already existing psi
> > > trigger, the operation will fail with EBUSY error.
> > > Also bypass a check for psi_disabled in the psi_trigger_destroy as the
> > > flag can be flipped after the trigger is created, leading to a memory
> > > leak.
> > >
> > > Reported-by: syzbot+cdb5dd11c97cc532efad-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
> > > Analyzed-by: Eric Biggers <ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > Suggested-by: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> > > Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >
> > Please include Fixes and Cc stable tags.
>
> Ack.
>
> >
> > > diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> > > index cafb8c114a21..e6878238fb19 100644
> > > --- a/kernel/cgroup/cgroup.c
> > > +++ b/kernel/cgroup/cgroup.c
> > > @@ -3642,6 +3642,12 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
> > >       cgroup_get(cgrp);
> > >       cgroup_kn_unlock(of->kn);
> > >
> > > +     /* Allow only one trigger per file descriptor */
> > > +     if (READ_ONCE(ctx->psi.trigger)) {
> > > +             cgroup_put(cgrp);
> > > +             return -EBUSY;
> > > +     }
> > > +
> >
> > Doesn't the task have exclusive access to the file at this point?  READ_ONCE()
> > is only needed instead of a plain load when the field can be concurrently
> > changed by another thread.
>
> Yeah, you are right. Concurrent writes are serialized by of->mutex and
> kernfs_release_file documents "@of is guaranteed to have no other file
> operations in flight", so ->release() can't race with ->write(). Will
> fix.
>
> >
> > > diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
> > > index 1652f2bb54b7..882bf62cc247 100644
> > > --- a/kernel/sched/psi.c
> > > +++ b/kernel/sched/psi.c
> > > @@ -1151,7 +1151,6 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
> > >       t->event = 0;
> > >       t->last_event_time = 0;
> > >       init_waitqueue_head(&t->event_wait);
> > > -     kref_init(&t->refcount);
> > >
> > >       mutex_lock(&group->trigger_lock);
> > >
> > > @@ -1180,15 +1179,21 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
> > >       return t;
> > >  }
> > >
> > > -static void psi_trigger_destroy(struct kref *ref)
> > > +void psi_trigger_destroy(void **trigger_ptr)
> > >  {
> > > -     struct psi_trigger *t = container_of(ref, struct psi_trigger, refcount);
> > > -     struct psi_group *group = t->group;
> > > +     struct psi_trigger *t;
> > > +     struct psi_group *group;
> > >       struct task_struct *task_to_destroy = NULL;
> > >
> > > -     if (static_branch_likely(&psi_disabled))
> > > +     /*
> > > +      * We do not check psi_disabled since it might have been disabled after
> > > +      * the trigger got created.
> > > +      */
> > > +     t = xchg(trigger_ptr, NULL);
> > > +     if (!t)
> > >               return;
> >
> > Likewise, doesn't the task have exclusive access to the file at this point?
> > This is only called during ->release().
>
> Yes, will fix.
>
> >
> > And why does this take a pointer to a pointer instead of just the pointer?
>
> That was done to do atomic xchg, but as you mentioned, it's not needed
> here. Will change.
>
> >
> > > @@ -1305,14 +1289,24 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
> > >
> > >       buf[buf_size - 1] = '\0';
> > >
> > > -     new = psi_trigger_create(&psi_system, buf, nbytes, res);
> > > -     if (IS_ERR(new))
> > > -             return PTR_ERR(new);
> > > -
> > >       seq = file->private_data;
> > > +
> > >       /* Take seq->lock to protect seq->private from concurrent writes */
> > >       mutex_lock(&seq->lock);
> > > -     psi_trigger_replace(&seq->private, new);
> > > +
> > > +     /* Allow only one trigger per file descriptor */
> > > +     if (READ_ONCE(seq->private)) {
> > > +             mutex_unlock(&seq->lock);
> > > +             return -EBUSY;
> > > +     }
> >
> > Likewise, what does this race against that would require the use of READ_ONCE()?
>
> Will fix.
> Thanks!

Posted v2 at https://lore.kernel.org/all/20220111071212.1210124-1-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

>
> >
> > - Eric
