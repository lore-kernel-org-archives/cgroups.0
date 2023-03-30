From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v2 4/9] cgroup: rstat: add WARN_ON_ONCE() if flushing
 outside task context
Date: Thu, 30 Mar 2023 01:19:29 -0700
Message-ID: <CAJD7tkbjmBaXghQ+14Hy28r2LoWSim+LEjOPxaamYeA_kr2uVw@mail.gmail.com>
References: <20230328221644.803272-1-yosryahmed@google.com>
 <20230328221644.803272-5-yosryahmed@google.com> <ZCQfZJFufkJ10o01@dhcp22.suse.cz>
 <CAJD7tkb-UpKm2QbjYzB=B=oGk6Hyj9cbUviZUPC+7VsvBecH7g@mail.gmail.com>
 <20230329192059.2nlme5ubshzdbpg6@google.com> <ZCU1Bp+5bKNJzWIu@dhcp22.suse.cz>
 <CAJD7tka0CmRvcvB0k8DZuid1vC9OK_mFriHHbXNTUkVE7OjaTA@mail.gmail.com>
 <ZCU+8lSi+e4WgT3F@dhcp22.suse.cz> <CAJD7tkaKd9Bcb2-e83Q-kzF7G+crr1U+7uqUPBARXWq-LpyKvw@mail.gmail.com>
 <ZCVFA78lDj2/Uy0C@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680164406;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rE+Nd7UYDrEpMLZdSjUiKej18eXol1/TN8rz8IxWo74=;
        b=GyiWHmVq+FRfL2cjm01ZTknwA6vfgE0p1ya77Ct3yJ2fB3E9yTJDYO2DG1GztDRNr1
         mgqcDehwuGMzQozTkhWOck0f+hbdMLCW22Oz0H2Hw6ub0AxgTKvO7NZZd8kar0iXPa0I
         w1fR0oirsZVe2itG6Xr3UFIcRF4dGKzDyt2lNU2VwbqP6oVlYOxkUSoEnJivS8rNs64x
         VZVdjxryxpTbjqXXWbrRaMthVoEUjQbg6RENFAeilc95gCV/uc5zz8ndmctFE1QXVkv2
         tyHZExil1HMZFY3eIbGsSr2E+zht6bWEo8TR5K8rxCHL18BXfX+/+YVs+jZNksasf9f2
         oklg==
In-Reply-To: <ZCVFA78lDj2/Uy0C@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Thu, Mar 30, 2023 at 1:15=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Thu 30-03-23 01:06:26, Yosry Ahmed wrote:
> [...]
> > If we achieve that, do you think it makes sense to add
> > WARN_ON_ONCE(irqs_disabled()) instead to prevent future users from
> > flushing while disabling irqs or in irq context?
>
> WARN_ON (similar to BUG_ON) will not prevent anybody from doing bad
> things. We already have means to shout about sleepable code being
> invoked from an atomic context and there is no reason to duplicate that.
> As I've said earlier WARN_ON might panic the system in some
> configurations (and yes they are used also in production systems - do
> not ask me why...). So please be careful about that and use that only
> when something really bad (yet recoverable) is going on.

Thanks for the information (I was about to ask why about production
systems, but okay..). I will avoid WARN_ON completely. For the
purposes of this series I will drop this patch anyway.

Any idea how to shout about "hey this may take too long, why are you
doing it with irqs disabled?!"?

>
> --
> Michal Hocko
> SUSE Labs
