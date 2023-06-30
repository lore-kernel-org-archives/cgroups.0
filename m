From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v2 1/1] sched/psi: use kernfs polling functions for PSI
 trigger polling
Date: Thu, 29 Jun 2023 18:04:15 -0700
Message-ID: <CAJuCfpH1eoB4cb-huqoMOP9M-zzm40pEJPZgSO_9Z8ZP6bRGPQ@mail.gmail.com>
References: <20230630005612.1014540-1-surenb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688087066; x=1690679066;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K627+SpIchKsrJFUhyxYZc0jOMiYoONX+cQtoMUBTFo=;
        b=xKW9xFUeuKWUZbFlbAhPoefihcZSYRbJBqJFNwWeExauq3xbjwbJX7qp+TuAOuAy7d
         N1w2lEpI3w/VGayOQrcrzIU7dpgNITLacPhctX/qARSEuuo5umGoObTBrskumhzTQJbj
         mIVK4A/6r9RDOwOqIvWNhUmZGOdPRJnXyd/p+NbFmnFj2F28pHDKyPCWH+V5GHrKpNKL
         OAe5dYUPluSvC+Axp/aB39eCVqgFf9VWmdWux2lXqyREXswlaLz+fBYBkWiYheuQVYYz
         jSkA5KTAIj6WS8bR8kK8rAyShesRJB5MYOh183pa61JmV4+Yf7AgVSfzoePK99JnQ1gP
         vn3A==
In-Reply-To: <20230630005612.1014540-1-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: peterz@infradead.org
Cc: gregkh@linuxfoundation.org, tj@kernel.org, lujialin4@huawei.com, lizefan.x@bytedance.com, hannes@cmpxchg.org, mingo@redhat.com, ebiggers@kernel.org, oleg@redhat.com, akpm@linux-foundation.org, viro@zeniv.linux.org.uk, brauner@kernel.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, bristot@redhat.com, vschneid@redhat.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-team@android.com

On Thu, Jun 29, 2023 at 5:56=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> Destroying psi trigger in cgroup_file_release causes UAF issues when
> a cgroup is removed from under a polling process. This is happening
> because cgroup removal causes a call to cgroup_file_release while the
> actual file is still alive. Destroying the trigger at this point would
> also destroy its waitqueue head and if there is still a polling process
> on that file accessing the waitqueue, it will step on the freed pointer:
>
> do_select
>   vfs_poll
>                            do_rmdir
>                              cgroup_rmdir
>                                kernfs_drain_open_files
>                                  cgroup_file_release
>                                    cgroup_pressure_release
>                                      psi_trigger_destroy
>                                        wake_up_pollfree(&t->event_wait)
> // vfs_poll is unblocked
>                                        synchronize_rcu
>                                        kfree(t)
>   poll_freewait -> UAF access to the trigger's waitqueue head
>
> Patch [1] fixed this issue for epoll() case using wake_up_pollfree(),
> however the same issue exists for synchronous poll() case.
> The root cause of this issue is that the lifecycles of the psi trigger's
> waitqueue and of the file associated with the trigger are different. Fix
> this by using kernfs_generic_poll function when polling on cgroup-specifi=
c
> psi triggers. It internally uses kernfs_open_node->poll waitqueue head
> with its lifecycle tied to the file's lifecycle. This also renders the
> fix in [1] obsolete, so revert it.
>
> [1] commit c2dbe32d5db5 ("sched/psi: Fix use-after-free in ep_remove_wait=
_queue()")
>
> Fixes: 0e94682b73bf ("psi: introduce psi monitor")
> Reported-by: Lu Jialin <lujialin4@huawei.com>
> Closes: https://lore.kernel.org/all/20230613062306.101831-1-lujialin4@hua=
wei.com/
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

This patch is a replacement for the patchset posted at
https://lore.kernel.org/all/20230626201713.1204982-1-surenb@google.com/
The original patchset was more appropriate for Tejun's tree but this
one is mostly touching PSI-related code, so I changed the recipient to
PeterZ. That said, I would still greatly appreciate inputs from Tejun
and Greg, and anyone else of course.
Thanks,
Suren.

> ---
>  include/linux/psi.h       |  5 +++--
>  include/linux/psi_types.h |  3 +++
>  kernel/cgroup/cgroup.c    |  2 +-
>  kernel/sched/psi.c        | 29 +++++++++++++++++++++--------
>  4 files changed, 28 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/psi.h b/include/linux/psi.h
> index ab26200c2803..e0745873e3f2 100644
> --- a/include/linux/psi.h
> +++ b/include/linux/psi.h
> @@ -23,8 +23,9 @@ void psi_memstall_enter(unsigned long *flags);
>  void psi_memstall_leave(unsigned long *flags);
>
>  int psi_show(struct seq_file *s, struct psi_group *group, enum psi_res r=
es);
> -struct psi_trigger *psi_trigger_create(struct psi_group *group,
> -                       char *buf, enum psi_res res, struct file *file);
> +struct psi_trigger *psi_trigger_create(struct psi_group *group, char *bu=
f,
> +                                      enum psi_res res, struct file *fil=
e,
> +                                      struct kernfs_open_file *of);
>  void psi_trigger_destroy(struct psi_trigger *t);
>
>  __poll_t psi_trigger_poll(void **trigger_ptr, struct file *file,
> diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
> index 040c089581c6..f1fd3a8044e0 100644
> --- a/include/linux/psi_types.h
> +++ b/include/linux/psi_types.h
> @@ -137,6 +137,9 @@ struct psi_trigger {
>         /* Wait queue for polling */
>         wait_queue_head_t event_wait;
>
> +       /* Kernfs file for cgroup triggers */
> +       struct kernfs_open_file *of;
> +
>         /* Pending event flag */
>         int event;
>
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index bfe3cd8ccf36..f55a40db065f 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -3730,7 +3730,7 @@ static ssize_t pressure_write(struct kernfs_open_fi=
le *of, char *buf,
>         }
>
>         psi =3D cgroup_psi(cgrp);
> -       new =3D psi_trigger_create(psi, buf, res, of->file);
> +       new =3D psi_trigger_create(psi, buf, res, of->file, of);
>         if (IS_ERR(new)) {
>                 cgroup_put(cgrp);
>                 return PTR_ERR(new);
> diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
> index 81fca77397f6..9bb3f2b3ccfc 100644
> --- a/kernel/sched/psi.c
> +++ b/kernel/sched/psi.c
> @@ -493,8 +493,12 @@ static u64 update_triggers(struct psi_group *group, =
u64 now, bool *update_total,
>                         continue;
>
>                 /* Generate an event */
> -               if (cmpxchg(&t->event, 0, 1) =3D=3D 0)
> -                       wake_up_interruptible(&t->event_wait);
> +               if (cmpxchg(&t->event, 0, 1) =3D=3D 0) {
> +                       if (t->of)
> +                               kernfs_notify(t->of->kn);
> +                       else
> +                               wake_up_interruptible(&t->event_wait);
> +               }
>                 t->last_event_time =3D now;
>                 /* Reset threshold breach flag once event got generated *=
/
>                 t->pending_event =3D false;
> @@ -1271,8 +1275,9 @@ int psi_show(struct seq_file *m, struct psi_group *=
group, enum psi_res res)
>         return 0;
>  }
>
> -struct psi_trigger *psi_trigger_create(struct psi_group *group,
> -                       char *buf, enum psi_res res, struct file *file)
> +struct psi_trigger *psi_trigger_create(struct psi_group *group, char *bu=
f,
> +                                      enum psi_res res, struct file *fil=
e,
> +                                      struct kernfs_open_file *of)
>  {
>         struct psi_trigger *t;
>         enum psi_states state;
> @@ -1331,7 +1336,9 @@ struct psi_trigger *psi_trigger_create(struct psi_g=
roup *group,
>
>         t->event =3D 0;
>         t->last_event_time =3D 0;
> -       init_waitqueue_head(&t->event_wait);
> +       t->of =3D of;
> +       if (!of)
> +               init_waitqueue_head(&t->event_wait);
>         t->pending_event =3D false;
>         t->aggregator =3D privileged ? PSI_POLL : PSI_AVGS;
>
> @@ -1388,7 +1395,10 @@ void psi_trigger_destroy(struct psi_trigger *t)
>          * being accessed later. Can happen if cgroup is deleted from und=
er a
>          * polling process.
>          */
> -       wake_up_pollfree(&t->event_wait);
> +       if (t->of)
> +               kernfs_notify(t->of->kn);
> +       else
> +               wake_up_interruptible(&t->event_wait);
>
>         if (t->aggregator =3D=3D PSI_AVGS) {
>                 mutex_lock(&group->avgs_lock);
> @@ -1465,7 +1475,10 @@ __poll_t psi_trigger_poll(void **trigger_ptr,
>         if (!t)
>                 return DEFAULT_POLLMASK | EPOLLERR | EPOLLPRI;
>
> -       poll_wait(file, &t->event_wait, wait);
> +       if (t->of)
> +               kernfs_generic_poll(t->of, wait);
> +       else
> +               poll_wait(file, &t->event_wait, wait);
>
>         if (cmpxchg(&t->event, 1, 0) =3D=3D 1)
>                 ret |=3D EPOLLPRI;
> @@ -1535,7 +1548,7 @@ static ssize_t psi_write(struct file *file, const c=
har __user *user_buf,
>                 return -EBUSY;
>         }
>
> -       new =3D psi_trigger_create(&psi_system, buf, res, file);
> +       new =3D psi_trigger_create(&psi_system, buf, res, file, NULL);
>         if (IS_ERR(new)) {
>                 mutex_unlock(&seq->lock);
>                 return PTR_ERR(new);
> --
> 2.41.0.255.g8b1d071c50-goog
>
