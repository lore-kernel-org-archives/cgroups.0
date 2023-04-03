From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v2 4/9] cgroup: rstat: add WARN_ON_ONCE() if flushing
 outside task context
Date: Mon, 3 Apr 2023 13:39:29 -0700
Message-ID: <CAJD7tkZF+rCNW4pctjOfAetoAQRq7-exV-j-nRc_xYMkMBGY_A@mail.gmail.com>
References: <ZCU1Bp+5bKNJzWIu@dhcp22.suse.cz> <CAJD7tka0CmRvcvB0k8DZuid1vC9OK_mFriHHbXNTUkVE7OjaTA@mail.gmail.com>
 <ZCU+8lSi+e4WgT3F@dhcp22.suse.cz> <CAJD7tkaKd9Bcb2-e83Q-kzF7G+crr1U+7uqUPBARXWq-LpyKvw@mail.gmail.com>
 <ZCVFA78lDj2/Uy0C@dhcp22.suse.cz> <CAJD7tkbjmBaXghQ+14Hy28r2LoWSim+LEjOPxaamYeA_kr2uVw@mail.gmail.com>
 <ZCVKqN2nDkkQFvO0@dhcp22.suse.cz> <CAJD7tkYEOVRcXs-Ag3mWn69EwE4rjFt9j5MAcTGCNE8BuhTd+A@mail.gmail.com>
 <ZCa9sixp3GJcjf8Y@dhcp22.suse.cz> <CAJD7tka-2vNn25=NdrKQoMf4ntdbWtojY0k4eAa-c9D+v7J=HQ@mail.gmail.com>
 <ZCqQfuprGreGYwFA@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680554406;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=98lpmjVP03rasH0aUw5Or4NqpKX/eDyfmYvak2z+XQY=;
        b=aOrySHi+L5aBtQhD9CMl2wIUewhWyIyQQXGmhw67rG4aYB/0VxtLJJdx4JKcjr4/Su
         CKHv3ZrfEko2du/9DiJPnmJgfyM9NzFrN9wGLJLRnVWtCv6yd58ea0gAc1LIGcNps8aF
         iQTbr3AocnQwqVN0vRpZPBqysYDShbz/ZYTddqaS5BtXq0sVascssl+jkJwncPNANTjk
         LRdvan3ZAUekClGuJ3S02i2YGWuAiDNHkJMii0Y/083m5jLXpgQg8MobYoyssOoaX1B9
         uxV+Z9IvmlmsJ8Y4QsY7pkdlMNW7ukQiPmVap2uSl7WIEp0ptj20puF/FpeYyuTT9zI9
         0ZgQ==
In-Reply-To: <ZCqQfuprGreGYwFA@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Mon, Apr 3, 2023 at 1:38=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrote=
:
>
> On Fri 31-03-23 12:03:47, Yosry Ahmed wrote:
> > On Fri, Mar 31, 2023 at 4:02=E2=80=AFAM Michal Hocko <mhocko@suse.com> =
wrote:
> > >
> > > On Thu 30-03-23 01:53:38, Yosry Ahmed wrote:
> > > [...]
> > > > Maybe we can add a primitive like might_sleep() for this, just food=
 for thought.
> > >
> > > I do not think it is the correct to abuse might_sleep if the function
> > > itself doesn't sleep. If it does might_sleep is already involved.
> >
> > Oh, sorry if I wasn't clear, I did not mean to reuse might_sleep() --
> > I meant introducing a new similar debug primitive that shouts if irqs
> > are disabled.
>
> This is circling back to original concerns about arbitrary decision to
> care about IRQs. Is this really any different from spin locks or preempt
> disabled critical sections preventing any scheduling and potentially
> triggereing soft lockups?

Not really, I am sure there are other code paths that may cause
similar problems. At least we can start annotating them so that we
don't regress them (e.g. by introducing a caller that disables irqs --
converting them into hard lockups).

> --
> Michal Hocko
> SUSE Labs
