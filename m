From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 6/9] memcg: sleep during flushing stats in safe contexts
Date: Tue, 28 Mar 2023 11:45:19 -0700
Message-ID: <CAJD7tkZxEEcVZ9G7NSM56q_uOyL7e353NT06kD0mY5DyNmKTpw@mail.gmail.com>
References: <20230328061638.203420-1-yosryahmed@google.com>
 <20230328061638.203420-7-yosryahmed@google.com> <ZCMzfQuo9IhWVzRA@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680029155;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WDPpGTUcAigUdKyxJFj5FSviALfqo1wtwcjHPt+uS1s=;
        b=hybc48zyKPXEpWZviFjaAJ9WSBFVr1MfoVcaRbhXnniFqrgKcZURpL2D66EDfe2Tom
         2enWNHJvfeVMeYKAokqAFAXfZky705CgievqgDkFCxw4bPSTAK2Jp0CTqI7/9FVShpJy
         vR3o+VqgifbVaYRySVqKDxmaMMNXgAKvJzO0kZxGOm+jjAPdvnHtk7pGDo7cExEnhjW/
         0fQi9SbN5MXhL+Y1R6QN/IJLbl9GreFFGWUTl+AvpY5hoTt68q4RTl/M0g27vj36Yw30
         3H/+tfUlSanDAmXpy+sxacjiLYAoaymmPVTxzgAnJ/Lsg5sj0Yw2/MQpjUuiaHO+/Ydn
         R6gw==
In-Reply-To: <ZCMzfQuo9IhWVzRA-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Mar 28, 2023 at 11:35=E2=80=AFAM Johannes Weiner <hannes-druUgvl0LCPF2uMehF1BdA@public.gmane.org=
g> wrote:
>
> On Tue, Mar 28, 2023 at 06:16:35AM +0000, Yosry Ahmed wrote:
> > @@ -642,24 +642,57 @@ static void __mem_cgroup_flush_stats(void)
> >        * from memcg flushers (e.g. reclaim, refault, etc).
> >        */
> >       if (atomic_xchg(&stats_flush_ongoing, 1))
> > -             return;
> > +             return false;
> >
> >       WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
> > -     cgroup_rstat_flush_atomic(root_mem_cgroup->css.cgroup);
> > +     return true;
> > +}
> > +
> > +static void mem_cgroup_post_stats_flush(void)
> > +{
> >       atomic_set(&stats_flush_threshold, 0);
> >       atomic_set(&stats_flush_ongoing, 0);
> >  }
> >
> > -void mem_cgroup_flush_stats(void)
> > +static bool mem_cgroup_should_flush_stats(void)
> >  {
> > -     if (atomic_read(&stats_flush_threshold) > num_online_cpus())
> > -             __mem_cgroup_flush_stats();
> > +     return atomic_read(&stats_flush_threshold) > num_online_cpus();
> > +}
> > +
> > +/* atomic functions, safe to call from any context */
> > +static void __mem_cgroup_flush_stats_atomic(void)
> > +{
> > +     if (mem_cgroup_pre_stats_flush()) {
> > +             cgroup_rstat_flush_atomic(root_mem_cgroup->css.cgroup);
> > +             mem_cgroup_post_stats_flush();
> > +     }
> > +}
>
> I'm afraid I wasn't very nuanced with my complaint about the bool
> parameter in the previous version. In this case, when you can do a
> common helper for a couple of API functions defined right below it,
> and the callers don't spread throughout the codebase, using bools
> makes things simpler while still being easily understandable:

Looking at your suggestion now, it seems fairly obvious that this is
what I should have gone for. Will do that for v2. Thanks!

>
> static void do_flush_stats(bool may_sleep)
> {
>         if (atomic_xchg(&stats_flush_ongoing, 1))
>                 return;
>
>         WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
>         atomic_set(&stats_flush_threshold, 0);
>
>         if (!may_sleep)
>                 cgroup_rstat_flush_atomic(root_mem_cgroup->css.cgroup);
>         else
>                 cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
>
>         atomic_set(&stats_flush_ongoing, 0);
> }
>
> void mem_cgroup_flush_stats(void)
> {
>         if (atomic_read(&stats_flush_threshold) > num_online_cpus())
>                 do_flush_stats(true);
> }
>
> void mem_cgroup_flush_stats_atomic(void)
> {
>         if (atomic_read(&stats_flush_threshold) > num_online_cpus())
>                 do_flush_stats(false);
> }
>
> >  void mem_cgroup_flush_stats_ratelimited(void)
> >  {
> >       if (time_after64(jiffies_64, READ_ONCE(flush_next_time)))
> > -             mem_cgroup_flush_stats();
> > +             mem_cgroup_flush_stats_atomic();
> > +}
>
> This should probably be mem_cgroup_flush_stats_atomic_ratelimited().
>
> (Whee, kinda long, but that's alright. Very specialized caller...)

It should, but the following patch makes it non-atomic anyway, so I
thought I wouldn't clutter the diff by renaming it here and then
reverting it back in the next patch.

There is an argument for maintaining a clean history tho in case the
next patch is reverted separately (which is the reason I put it in a
separate patch to begin with) -- so perhaps I should rename it here to
mem_cgroup_flush_stats_atomic_ratelimited () and back to
mem_cgroup_flush_stats_ratelimited() in the next patch, just for
consistency?

>
> Btw, can you guys think of a reason against moving the threshold check
> into the common function? It would then apply to the time-limited
> flushes as well, but that shouldn't hurt anything. This would make the
> code even simpler:

I think the point of having the threshold check outside the common
function is that the periodic flusher always flushes, regardless of
the threshold, to keep rstat flushing from critical contexts as cheap
as possible.

If you think it's not worth it, I can make that change. It is a
separate functional change tho, so maybe in a separate patch.

>
> static void do_flush_stats(bool may_sleep)
> {
>         if (atomic_read(&stats_flush_threshold) <=3D num_online_cpus())
>                 return;
>
>         if (atomic_xchg(&stats_flush_ongoing, 1))
>                 return;
>
>         WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
>         atomic_set(&stats_flush_threshold, 0);
>
>         if (!may_sleep)
>                 cgroup_rstat_flush_atomic(root_mem_cgroup->css.cgroup);
>         else
>                 cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
>
>         atomic_set(&stats_flush_ongoing, 0);
> }
>
> void mem_cgroup_flush_stats(void)
> {
>         do_flush_stats(true);
> }
>
> void mem_cgroup_flush_stats_atomic(void)
> {
>         do_flush_stats(false);
> }
>
> void mem_cgroup_flush_stats_atomic_ratelimited(void)
> {
>         if (time_after64(jiffies_64, READ_ONCE(flush_next_time)))
>                 do_flush_stats(false);
> }
>
> > @@ -2845,7 +2845,7 @@ static void prepare_scan_count(pg_data_t *pgdat, =
struct scan_control *sc)
> >        * Flush the memory cgroup stats, so that we read accurate per-me=
mcg
> >        * lruvec stats for heuristics.
> >        */
> > -     mem_cgroup_flush_stats();
> > +     mem_cgroup_flush_stats_atomic();
>
> I'm thinking this one could be non-atomic as well. It's called fairly
> high up in reclaim without any locks held.

A later patch does exactly that. I put making the reclaim and refault
paths non-atomic in separate patches to easily revert them if we see a
regression. Let me know if this is too defensive and if you'd rather
have them squashed.

Thanks!
