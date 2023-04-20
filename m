From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH mm-unstable RFC 1/5] writeback: move wb_over_bg_thresh()
 call outside lock section
Date: Thu, 20 Apr 2023 13:22:52 -0700
Message-ID: <CAJD7tkbd=CJjRWbPev-8aZm=mufE5Sp7u5AzPUUJTK9xL_yOgQ@mail.gmail.com>
References: <20230403220337.443510-1-yosryahmed@google.com>
 <20230403220337.443510-2-yosryahmed@google.com> <CALvZod5h5G9YNu8d9fAOL5eXie5iM3urw9QgD=vucBdCMAQnxA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682022209; x=1684614209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RDPS2kJGA9qHFAhB01dB7yBOdSjj/en4thGsxxtxQ0Y=;
        b=EGJMPcsyHoAX/3gJSN5xuzkkXvuy7iPOrcCdkFFe5y4qoCmbLuUudZ5/py08XvZhAD
         dTESHFeDumQ2LmNnLOMS8aDauca5eoCn+hdL6UEhIyzkE1wwZHtB7EaW0ttXr/UB1/yo
         30CiV9bU0Ied0qmn7FdLPavRsZfDwtu9FTDG/cSmGQASCWDb3iAhYHICJ3KKwcZYnQUf
         LAFiq4XGTjTI7PcCQVTQHP286d/cKqQucx0gkmMRuQVaGQGuuLHbr6IW14F9/+HPpVwj
         hPkuaDIbBkTtFGVKEB4DEGjLzorQM0fNJEw/yASZ3odr6htflmHhSoLYzmq/4N7BOWd7
         dALg==
In-Reply-To: <CALvZod5h5G9YNu8d9fAOL5eXie5iM3urw9QgD=vucBdCMAQnxA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, Apr 20, 2023 at 11:53=E2=80=AFAM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>=
 wrote:
>
> +Jens & Jan
>
> The patch looks good but it would be nice to pass this patch through
> the eyes of experts of this area.

Thanks for taking a look and CC'ing folks. I will make sure to include
them in the next rounds as well. FWIW, Jens & Jan did not show up when
I ran scripts/get_maintainers.ph if I remember correctly.

>
> On Mon, Apr 3, 2023 at 3:03=E2=80=AFPM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org=
> wrote:
> >
> > wb_over_bg_thresh() calls mem_cgroup_wb_stats() which invokes an rstat
> > flush, which can be expensive on large systems. Currently,
> > wb_writeback() calls wb_over_bg_thresh() within a lock section, so we
> > have to make the rstat flush atomically. On systems with a lot of
> > cpus/cgroups, this can cause us to disable irqs for a long time,
> > potentially causing problems.
> >
> > Move the call to wb_over_bg_thresh() outside the lock section in
> > preparation to make the rstat flush in mem_cgroup_wb_stats() non-atomic=
.
> > The list_empty(&wb->work_list) should be okay outside the lock section
> > of wb->list_lock as it is protected by a separate lock (wb->work_lock),
> > and wb_over_bg_thresh() doesn't seem like it is modifying any of the b_=
*
> > lists the wb->list_lock is protecting. Also, the loop seems to be
> > already releasing and reacquring the lock, so this refactoring looks
> > safe.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/fs-writeback.c | 16 +++++++++++-----
> >  1 file changed, 11 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index 195dc23e0d831..012357bc8daa3 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -2021,7 +2021,6 @@ static long wb_writeback(struct bdi_writeback *wb=
,
> >         struct blk_plug plug;
> >
> >         blk_start_plug(&plug);
> > -       spin_lock(&wb->list_lock);
> >         for (;;) {
> >                 /*
> >                  * Stop writeback when nr_pages has been consumed
> > @@ -2046,6 +2045,9 @@ static long wb_writeback(struct bdi_writeback *wb=
,
> >                 if (work->for_background && !wb_over_bg_thresh(wb))
> >                         break;
> >
> > +
> > +               spin_lock(&wb->list_lock);
> > +
> >                 /*
> >                  * Kupdate and background works are special and we want=
 to
> >                  * include all inodes that need writing. Livelock avoid=
ance is
> > @@ -2075,13 +2077,19 @@ static long wb_writeback(struct bdi_writeback *=
wb,
> >                  * mean the overall work is done. So we keep looping as=
 long
> >                  * as made some progress on cleaning pages or inodes.
> >                  */
> > -               if (progress)
> > +               if (progress) {
> > +                       spin_unlock(&wb->list_lock);
> >                         continue;
> > +               }
> > +
> >                 /*
> >                  * No more inodes for IO, bail
> >                  */
> > -               if (list_empty(&wb->b_more_io))
> > +               if (list_empty(&wb->b_more_io)) {
> > +                       spin_unlock(&wb->list_lock);
> >                         break;
> > +               }
> > +
> >                 /*
> >                  * Nothing written. Wait for some inode to
> >                  * become available for writeback. Otherwise
> > @@ -2093,9 +2101,7 @@ static long wb_writeback(struct bdi_writeback *wb=
,
> >                 spin_unlock(&wb->list_lock);
> >                 /* This function drops i_lock... */
> >                 inode_sleep_on_writeback(inode);
> > -               spin_lock(&wb->list_lock);
> >         }
> > -       spin_unlock(&wb->list_lock);
> >         blk_finish_plug(&plug);
> >
> >         return nr_pages - work->nr_pages;
> > --
> > 2.40.0.348.gf938b09366-goog
> >
