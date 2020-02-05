From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/3] cgroup: Iterate tasks that did not finish do_exit()
Date: Wed, 5 Feb 2020 09:27:45 -0800
Message-ID: <CAJuCfpEq9c6cdEdqZOq6KDmxSHLNzby=46psRYpGxYhDT31yew@mail.gmail.com>
References: <20200120145635.GA30904@blackbody.suse.cz> <20200124114017.8363-1-mkoutny@suse.com>
 <20200124114017.8363-2-mkoutny@suse.com> <CAJuCfpGjC=YwY=oNnYFNDp2nCuR9YhSU95=xbbeoDEheemte+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/J7K6eoBY50PYm0N/u4X3+dlKUZnt64LaOlAE9qk+tY=;
        b=lJaz2HSL0GodXUnBdAWn5vXGicOnSOjlEzL6WRhsXUYvoCwf2EksV/H80DsSr0HvVU
         jf5gZF9txDXrM3yAMqWtQrJa6rF6ZxYg2ABlbXin3ylMvhed2NeSefp4yc29oR7AO7Kq
         SForPuVGtkLxc0SWSZpIfaM7l+JRe3quj6YnZtk6CLCdH6Ya1+FowX4QH8PE8atAmrxL
         2mwslJZqu1/pZH8QJ9X3mo5JZXE2zX0ovIXlKc9ZS9JoWrcs0qZi3ZNp1BsgCSehUGC7
         pVPo2EESWoXfB1s0YdZHI7GfTR2svAMgYjRNn51zpIpuaTZN19/bg1o9tYC2NLTZCylr
         L8ig==
In-Reply-To: <CAJuCfpGjC=YwY=oNnYFNDp2nCuR9YhSU95=xbbeoDEheemte+Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kernel-team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, JeiFeng Lee <linger.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tom Cherry <tomcherry-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, Jan 24, 2020 at 2:56 PM Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrot=
e:
>
> On Fri, Jan 24, 2020 at 3:40 AM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wro=
te:
> >
> > PF_EXITING is set earlier than actual removal from css_set when a task
> > is exitting. This can confuse cgroup.procs readers who see no PF_EXITIN=
G
> > tasks, however, rmdir is checking against css_set membership so it can
> > transitionally fail with EBUSY.
> >
> > Fix this by listing tasks that weren't unlinked from css_set active
> > lists.
> > It may happen that other users of the task iterator (without
> > CSS_TASK_ITER_PROCS) spot a PF_EXITING task before cgroup_exit(). This
> > is equal to the state before commit c03cd7738a83 ("cgroup: Include dyin=
g
> > leaders with live threads in PROCS iterations") but it may be reviewed
> > later.
> >
> > Reported-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Fixes: c03cd7738a83 ("cgroup: Include dying leaders with live threads i=
n PROCS iterations")
> > Signed-off-by: Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org>
> > ---
> >  include/linux/cgroup.h |  1 +
> >  kernel/cgroup/cgroup.c | 23 ++++++++++++++++-------
> >  2 files changed, 17 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> > index d7ddebd0cdec..e75d2191226b 100644
> > --- a/include/linux/cgroup.h
> > +++ b/include/linux/cgroup.h
> > @@ -62,6 +62,7 @@ struct css_task_iter {
> >         struct list_head                *mg_tasks_head;
> >         struct list_head                *dying_tasks_head;
> >
> > +       struct list_head                *cur_tasks_head;
> >         struct css_set                  *cur_cset;
> >         struct css_set                  *cur_dcset;
> >         struct task_struct              *cur_task;
> > diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> > index 735af8f15f95..a6e3619e013b 100644
> > --- a/kernel/cgroup/cgroup.c
> > +++ b/kernel/cgroup/cgroup.c
> > @@ -4404,12 +4404,16 @@ static void css_task_iter_advance_css_set(struc=
t css_task_iter *it)
> >                 }
> >         } while (!css_set_populated(cset) && list_empty(&cset->dying_ta=
sks));
> >
> > -       if (!list_empty(&cset->tasks))
> > +       if (!list_empty(&cset->tasks)) {
> >                 it->task_pos =3D cset->tasks.next;
> > -       else if (!list_empty(&cset->mg_tasks))
> > +               it->cur_tasks_head =3D &cset->tasks;
> > +       } else if (!list_empty(&cset->mg_tasks)) {
> >                 it->task_pos =3D cset->mg_tasks.next;
> > -       else
> > +               it->cur_tasks_head =3D &cset->mg_tasks;
> > +       } else {
> >                 it->task_pos =3D cset->dying_tasks.next;
> > +               it->cur_tasks_head =3D &cset->dying_tasks;
> > +       }
> >
> >         it->tasks_head =3D &cset->tasks;
> >         it->mg_tasks_head =3D &cset->mg_tasks;
> > @@ -4467,10 +4471,14 @@ static void css_task_iter_advance(struct css_ta=
sk_iter *it)
> >                 else
> >                         it->task_pos =3D it->task_pos->next;
> >
> > -               if (it->task_pos =3D=3D it->tasks_head)
> > +               if (it->task_pos =3D=3D it->tasks_head) {
> >                         it->task_pos =3D it->mg_tasks_head->next;
> > -               if (it->task_pos =3D=3D it->mg_tasks_head)
> > +                       it->cur_tasks_head =3D it->mg_tasks_head;
> > +               }
> > +               if (it->task_pos =3D=3D it->mg_tasks_head) {
> >                         it->task_pos =3D it->dying_tasks_head->next;
> > +                       it->cur_tasks_head =3D it->dying_tasks_head;
> > +               }
> >                 if (it->task_pos =3D=3D it->dying_tasks_head)
> >                         css_task_iter_advance_css_set(it);
> >         } else {
> > @@ -4489,11 +4497,12 @@ static void css_task_iter_advance(struct css_ta=
sk_iter *it)
> >                         goto repeat;
> >
> >                 /* and dying leaders w/o live member threads */
> > -               if (!atomic_read(&task->signal->live))
> > +               if (it->cur_tasks_head =3D=3D it->dying_tasks_head &&
> > +                   !atomic_read(&task->signal->live))
> >                         goto repeat;
> >         } else {
> >                 /* skip all dying ones */
> > -               if (task->flags & PF_EXITING)
> > +               if (it->cur_tasks_head =3D=3D it->dying_tasks_head)
> >                         goto repeat;
> >         }
> >  }
> > --
> > 2.24.1
> >
>
> Tested-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> Thanks!

Hi Folks,
If this new version looks good could we get an Ack please? I need to
start backporting this fix to Android and would like a confirmation
before doing so.
Thanks!
