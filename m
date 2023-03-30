From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 4/9] cgroup: rstat: add WARN_ON_ONCE() if flushing
 outside task context
Date: Thu, 30 Mar 2023 01:06:26 -0700
Message-ID: <CAJD7tkaKd9Bcb2-e83Q-kzF7G+crr1U+7uqUPBARXWq-LpyKvw@mail.gmail.com>
References: <20230328221644.803272-1-yosryahmed@google.com>
 <20230328221644.803272-5-yosryahmed@google.com> <ZCQfZJFufkJ10o01@dhcp22.suse.cz>
 <CAJD7tkb-UpKm2QbjYzB=B=oGk6Hyj9cbUviZUPC+7VsvBecH7g@mail.gmail.com>
 <20230329192059.2nlme5ubshzdbpg6@google.com> <ZCU1Bp+5bKNJzWIu@dhcp22.suse.cz>
 <CAJD7tka0CmRvcvB0k8DZuid1vC9OK_mFriHHbXNTUkVE7OjaTA@mail.gmail.com> <ZCU+8lSi+e4WgT3F@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680163623;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I9/OZbBvN+GYY+k6VNhkbPsCuwIDJGgvOD15HQAmaC4=;
        b=Dsrmlf6SQ7dieSEewhGmRqcjAnISmY3AXD9YHFTWUr8d+rNOpPZJaTLj6dySdAJBmS
         2QtMKaqtURSXtYTkG0ZC4UmNj6SQdXGiCRKn4ol9GUN33Z9cvEGcATJXOWKZqMvTfIwf
         QhPCIRe1EuHaGXZkRDNRZSBsvvOSCKbdsMoAnDpHTvNBHEdWh2VFjjbS2q3CAxFG3btu
         9+MI5lzCPRk1D1xVAU7NB+C21NNfqBlxd2VKiRIhMGqXWDHEF52eu7YEHYU0MDOcj+bg
         5qY4+RVkbmlN5SerigkhW3HND52Iysgu6N4mDyqx0XKW8vxxRsMx5p6SzsEYAB9yGwzi
         J4rQ==
In-Reply-To: <ZCU+8lSi+e4WgT3F-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 30, 2023 at 12:49=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wro=
te:
>
> On Thu 30-03-23 00:13:16, Yosry Ahmed wrote:
> > On Thu, Mar 30, 2023 at 12:06=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>=
 wrote:
> [...]
> > > So the real question is. Do we really care so deeply? After all someb=
ody
> > > might be calling this from within a spin lock or irq disabled section
> > > resulting in a similar situation without noticing.
> >
> > There are discussions in [1] about making atomic rstat flush not
> > disable irqs throughout the process, so in that case it would only
> > result in a similar situation if the caller has irq disabled. The only
> > caller that might have irq disabled is the same caller that might be
> > in irq context before this series: mem_cgroup_usage().
> >
> > On that note, and while I have your attention, I was wondering if we
> > can eliminate the flush call completely from mem_cgroup_usage(), and
> > read the global stats counters for root memcg instead of the root
> > counters. There might be subtle differences, but the root memcg usage
> > isn't super accurate now anyway (e.g. it doesn't include kernel
> > memory).
>
> root memcg stats are imprecise indeed and I have to admit I do not
> really know why we are adding more work for that case. I have tried to
> dig into git history for that yesterday but couldn't find a satisfying
> answer. It goes all the way down to 2d146aa3aa842 which has done the
> switch to rstat. Maybe Johannes remembers.

I think it goes back even before that. Even before rstat, we used to
get the root usage by iterating over the hierarchy. Maybe we didn't
have the global counters at some point or they weren't in line with
the root memcg (e.g. use_hierarchy =3D 0). It would be great if we can
just use the global counters here. Hopefully Johannes can confirm or
deny this.

>
> Anyway, back to this particular patch. I still do not see strong reasons
> to be verbose about !in_task case so I would just drop this patch.

I will drop this patch in the next iteration. If I implement a patch
that makes rstat flushing not disable irqs all throughout (like [1]),
whether part of this series or not, and we remove flushing from
mem_cgroup_usage(), then at this point:
- No existing flushers will be disabling irqs.
- rstat flushing itself will not be disabling irqs throughout the entire fl=
ush.

If we achieve that, do you think it makes sense to add
WARN_ON_ONCE(irqs_disabled()) instead to prevent future users from
flushing while disabling irqs or in irq context?

All I am trying to achieve here is make sure we don't regress. I don't
want to minimize the current atomic flushers now only to have them
increase later.

[1] https://lore.kernel.org/lkml/CAJD7tkZrp=3D4zWvjE9_010TAG1T_crCbf9P64UzJ=
ABspgcrGPKg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/

> --
> Michal Hocko
> SUSE Labs
