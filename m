From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH 3/3] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Mon, 28 Aug 2023 11:35:41 -0700
Message-ID: <CAJD7tkZkDDKa28nVciOv6o+4=Eh433sJ34R_bC2XURX2QMP=og@mail.gmail.com>
References: <20230821205458.1764662-4-yosryahmed@google.com>
 <ZOR6eyYfJYlxdMet@dhcp22.suse.cz> <CAJD7tka13M-zVZTyQJYL1iUAYvuQ1fcHbCjcOBZcz6POYTV-4g@mail.gmail.com>
 <ZOW2PZN8Sgqq6uR2@dhcp22.suse.cz> <CAJD7tka34WjtwBWfkTu8ZCEUkLm7h-AyCXpw=h34n4RZ5qBVwA@mail.gmail.com>
 <ZOcDLD/1WaOwWis9@dhcp22.suse.cz> <CAJD7tkZby2enWa8_Js8joHqFx_tHB=aRqHOizaSiXMUjvEei4g@mail.gmail.com>
 <CAJD7tkadEtjK_NFwRe8yhUh_Mdx9LCLmCuj5Ty-pqp1rHTb-DA@mail.gmail.com>
 <ZOhSyvDxAyYUJ45i@dhcp22.suse.cz> <CAJD7tkYPyb+2zOKqctQw-vhuwYRg85e6v2Y44xWJofHZ+F+YQw@mail.gmail.com>
 <ZOzBgfzlGdrPD4gk@dhcp22.suse.cz> <CAJD7tkakMcaR_6NygEXCt6GF8TOuzYAUQe1im+vu2F3G4jtz=w@mail.gmail.com>
 <CALvZod7uxDd3Lrd3VwTTC-SDvqhdj2Ly-dYVswO=TBM=XTnkcg@mail.gmail.com>
 <CAJD7tkbnvMCNfQwY_dmVe2SWR5NeN+3RzFhsVyimM1ATaX0D5A@mail.gmail.com>
 <599b167c-deaf-4b92-aa8b-5767b8608483@redhat.com> <CAJD7tkZsGfYXkWM5aa67v3JytTO04LS7_x+ooMDK82cBZ-C8eQ@mail.gmail.com>
 <307cbcf6-dca2-0b5d-93e8-11368a931d2f@redhat.com> <820843a5-d7a5-91a9-b861-99e7132ddb98@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693247778; x=1693852578;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ky9ruWT4vMi1n23k32PoOKd6l441oU0lu6dvfmODcBE=;
        b=EcIUqfkgmCxoArH+hvfanA9vD9wZJyYnIYgZ6iL2g3vZPGwgFPCQCOAgIcl8o9FleE
         Oz4x81gdB9NDZBw7x9QXZh64JZQa3MHyRutba8p2xFGAp7vpvy40xtiavYfdEh/Xu/9Y
         YrxQuvbFVJ8FheigRKtd6haVQyRbZuEn4j4jQDwc0UohDDlpo6OkPgsIhoLMeLtv1Ack
         X7GQrz+nuTXPiBZ+7KOvrlB2Oby3wWne7ppYNsM3H1J11qRE3dSbC8MrF4kYA6f7iFZX
         2FUH8fA8AmzSYyW1QZccq0we7ZFJCAvf9NJgtUmttoPnyskfuN74ZUuucdoHKNXnjh4M
         c28g==
In-Reply-To: <820843a5-d7a5-91a9-b861-99e7132ddb98@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Aug 28, 2023 at 10:43=E2=80=AFAM Waiman Long <longman@redhat.com> w=
rote:
>
>
> On 8/28/23 13:35, Waiman Long wrote:
> > On 8/28/23 13:28, Yosry Ahmed wrote:
> >> On Mon, Aug 28, 2023 at 10:27=E2=80=AFAM Waiman Long <longman@redhat.c=
om> wrote:
> >>>
> >>> On 8/28/23 13:07, Yosry Ahmed wrote:
> >>>>> Here I agree with you. Let's go with the approach which is easy to
> >>>>> undo for now. Though I prefer the new explicit interface for
> >>>>> flushing,
> >>>>> that step would be very hard to undo. Let's reevaluate if the
> >>>>> proposed
> >>>>> approach shows negative impact on production traffic and I think
> >>>>> Cloudflare folks can give us the results soon.
> >>>> Do you prefer we also switch to using a mutex (with preemption
> >>>> disabled) to avoid the scenario Michal described where flushers give
> >>>> up the lock and sleep resulting in an unbounded wait time in the wor=
st
> >>>> case?
> >>> Locking with mutex with preemption disabled is an oxymoron. Use
> >>> spinlock
> >>> if you want to have preemption disabled. The purpose of usiing mutex =
is
> >>> to allow the lock owner to sleep, but you can't sleep with preemption
> >>> disabled. You need to enable preemption first. You can disable
> >>> preemption for a short time in a non-sleeping section of the lock
> >>> critical section, but I would not recommend disabling preemption for
> >>> the
> >>> whole critical section.
> >> I thought using a mutex with preemption disabled would at least allow
> >> waiters to sleep rather than spin, is this not correct (or doesn't
> >> matter) ?
> >
> > Because of optimistic spinning, a mutex lock waiter will only sleep if
> > the lock holder sleep or when its time slice run out. So the waiters
> > are likely to spin for quite a while before they go to sleep.

I see. Thanks for the explanation.

>
> Perhaps you can add a mutex at the read side so that only 1 reader can
> contend with the global rstat spinlock at any time if this is a concern.

I guess we can keep it simple for now and add that later if needed.
For unified flushers we already can only have one. If we see a problem
from the stat reading side we can add a mutex there.

Thanks!
