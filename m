From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 4/9] cgroup: rstat: add WARN_ON_ONCE() if flushing
 outside task context
Date: Thu, 30 Mar 2023 01:53:38 -0700
Message-ID: <CAJD7tkYEOVRcXs-Ag3mWn69EwE4rjFt9j5MAcTGCNE8BuhTd+A@mail.gmail.com>
References: <20230328221644.803272-5-yosryahmed@google.com>
 <ZCQfZJFufkJ10o01@dhcp22.suse.cz> <CAJD7tkb-UpKm2QbjYzB=B=oGk6Hyj9cbUviZUPC+7VsvBecH7g@mail.gmail.com>
 <20230329192059.2nlme5ubshzdbpg6@google.com> <ZCU1Bp+5bKNJzWIu@dhcp22.suse.cz>
 <CAJD7tka0CmRvcvB0k8DZuid1vC9OK_mFriHHbXNTUkVE7OjaTA@mail.gmail.com>
 <ZCU+8lSi+e4WgT3F@dhcp22.suse.cz> <CAJD7tkaKd9Bcb2-e83Q-kzF7G+crr1U+7uqUPBARXWq-LpyKvw@mail.gmail.com>
 <ZCVFA78lDj2/Uy0C@dhcp22.suse.cz> <CAJD7tkbjmBaXghQ+14Hy28r2LoWSim+LEjOPxaamYeA_kr2uVw@mail.gmail.com>
 <ZCVKqN2nDkkQFvO0@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680166455;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oX0gvaOyZOPHIQS/lmv/Ti0/aOErAsGb3zG7Z5OZO2o=;
        b=WXf5DP/SnSUFzsV29yQgNbT+UqQSF6+RPsReWZbLSzwsLGnGrCZ7mGJ+Kg/l3LT/Sa
         YlwaRxHHQ4V8lQ2ngT1wVPQMpGUNmakTZ5x8ceTg9l7uyxQYfBn3BhwcdUe8BUgFVqDb
         bVOJOTc+pwvM4OZmgIb2vZRKpL47bO6euuKgv9L3ClENMySR3LjJxL78id+QyVP+9Fvz
         FdJKYDAKkbtWpALArnt1W7TxIvNZmYl4ltnlCbMCIDvEu2F6DuajYEYUnNpe7RwlEMuh
         u94GrNUK8lYFRnnkcYCsxCIMmfShfaZNaHwS6ESlMLL2PYDi7KIj59BTIU269tYBDwan
         IPnA==
In-Reply-To: <ZCVKqN2nDkkQFvO0-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 30, 2023 at 1:39=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrot=
e:
>
> On Thu 30-03-23 01:19:29, Yosry Ahmed wrote:
> > On Thu, Mar 30, 2023 at 1:15=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> =
wrote:
> > >
> > > On Thu 30-03-23 01:06:26, Yosry Ahmed wrote:
> > > [...]
> > > > If we achieve that, do you think it makes sense to add
> > > > WARN_ON_ONCE(irqs_disabled()) instead to prevent future users from
> > > > flushing while disabling irqs or in irq context?
> > >
> > > WARN_ON (similar to BUG_ON) will not prevent anybody from doing bad
> > > things. We already have means to shout about sleepable code being
> > > invoked from an atomic context and there is no reason to duplicate th=
at.
> > > As I've said earlier WARN_ON might panic the system in some
> > > configurations (and yes they are used also in production systems - do
> > > not ask me why...). So please be careful about that and use that only
> > > when something really bad (yet recoverable) is going on.
> >
> > Thanks for the information (I was about to ask why about production
> > systems, but okay..). I will avoid WARN_ON completely. For the
> > purposes of this series I will drop this patch anyway.
>
> Thanks! People do strange things sometimes...
>
> > Any idea how to shout about "hey this may take too long, why are you
> > doing it with irqs disabled?!"?
>
> Well we have a hard lockup detector. It hits at a much higher stall by
> default but if you care about IRQ latencies in general then you likely
> want to lower. Another thing would be IRQ tracing. In any case this code
> path shouldn't be any special. Sure it can take long on large systems
> but I bet there are more of those.

We did see hard lockups in extreme cases, and we do have setups with
"nmi_watchdog=3Dpanic" that will panic when this happens, so we would
rather catch the code paths that can lead to that before it actually
happens.

Maybe we can add a primitive like might_sleep() for this, just food for tho=
ught.

> --
> Michal Hocko
> SUSE Labs
