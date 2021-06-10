From: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4] sched/fair: Correctly insert cfs_rq's to list on unthrottle
Date: Thu, 10 Jun 2021 08:49:39 +0200
Message-ID: <CAKfTPtBEZZo9fHDxe7viLyZmCe=4NTLLtBFyWM_UuJ1nmqxGvA@mail.gmail.com>
References: <20210604102314.697749-1-odin@uged.al> <YL+dTtsCtZjMeZWn@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=67pgjCx8vmxJvqmbawagxHeBDG9F0WOXi380k50exuo=;
        b=po0rea81p6koLdoj90+BpTqr297m34vqZiDHl35MFKN5HmBo/cINMskvg8Rj1AiXCD
         P/mX6NsU8ilK5hyP7AW2r0V1bwvN2iVAetVFInJHL3ulhputAR1fbbnR8g/j+kgSLQRN
         iXciNRcfQNWXmevrvU/V5C2Ds7I+9bLqYeVGkHSoUKiLnS7CZ/zFob00D4OF3VknComV
         +qQqQK4kXsp5qjvVU5KnImu/nnQ+tNK8McFDo2o+UIVNatGM0GWVemlGxwcDZQAGmctV
         Yi8SxUDNO9ks7NLikMTm/51IqsXk6A361yvzd5VwX3BuQ5o0Bb4YtgNKJRMi3H4g+gpU
         x25A==
In-Reply-To: <YL+dTtsCtZjMeZWn@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Giovanni Gherdovich <ggherdovich-AlSwsSmVLrQ@public.gmane.org>

On Tue, 8 Jun 2021 at 18:39, Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wrote:
>
> Hello.
>
> On Fri, Jun 04, 2021 at 12:23:14PM +0200, Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org> wrot=
e:
>
> > @@ -4719,8 +4738,8 @@ static int tg_unthrottle_up(struct task_group *tg=
, void *data)
> >               cfs_rq->throttled_clock_task_time +=3D rq_clock_task(rq) =
-
> >                                            cfs_rq->throttled_clock_task=
;
> >
> > -             /* Add cfs_rq with already running entity in the list */
> > -             if (cfs_rq->nr_running >=3D 1)
> > +             /* Add cfs_rq with load or one or more already running en=
tities to the list */
> > +             if (!cfs_rq_is_decayed(cfs_rq) || cfs_rq->nr_running)
> >                       list_add_leaf_cfs_rq(cfs_rq);
> >       }
>
> Can there be a decayed cfs_rq with positive nr_running?
> I.e. can the condition be simplified to just the decayed check?

Yes, nothing prevent a task with a null load to be enqueued on a
throttle cfs as an example

>
> (I'm looking at account_entity_enqueue() but I don't know if an entity's
> weight can be zero in some singular cases.)
>
> Thanks,
> Michal
