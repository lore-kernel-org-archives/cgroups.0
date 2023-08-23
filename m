From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH 3/3] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Wed, 23 Aug 2023 07:55:40 -0700
Message-ID: <CAJD7tka34WjtwBWfkTu8ZCEUkLm7h-AyCXpw=h34n4RZ5qBVwA@mail.gmail.com>
References: <20230821205458.1764662-1-yosryahmed@google.com>
 <20230821205458.1764662-4-yosryahmed@google.com> <ZOR6eyYfJYlxdMet@dhcp22.suse.cz>
 <CAJD7tka13M-zVZTyQJYL1iUAYvuQ1fcHbCjcOBZcz6POYTV-4g@mail.gmail.com> <ZOW2PZN8Sgqq6uR2@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692802577; x=1693407377;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PSVoIOZqrLzgTIYTqSKj0XgeIg86+0IH5XubqeiWf/A=;
        b=Mi/Mvi2fWR1+DchpFlIQ3KB1SwAMcdVb/97gHN9qIPrhg0gM3fbbPNqn7SdEETJnnR
         aRVvXtg7RwWm+BIilNjTNh33g7Nd+pFDl6xGvbYsd85QBTDnEPuLOyl8j0VwtD3wFnMN
         +P1+mk8vFOU38YVY+CnxgZ2MPY73RUTdSk1B+L7GY2DQsGn/XrbAhXbie+GrOsIfNFvD
         R898eDcFng2eThS1Y7Dt5IGVTTHmbPh1Cq+FjhP3181VxhcdT5WNqIkha4ouNEetRm5t
         YEZ1DX0+u3IImvaWYsQgKErOpesSlzAFCLaKaZgfqA/C6qS5gNoGeTQ7rQDSEErqPwZd
         esSA==
In-Reply-To: <ZOW2PZN8Sgqq6uR2@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Aug 23, 2023 at 12:33=E2=80=AFAM Michal Hocko <mhocko@suse.com> wro=
te:
>
> On Tue 22-08-23 08:30:05, Yosry Ahmed wrote:
> > On Tue, Aug 22, 2023 at 2:06=E2=80=AFAM Michal Hocko <mhocko@suse.com> =
wrote:
> > >
> > > On Mon 21-08-23 20:54:58, Yosry Ahmed wrote:
> [...]
> > So to answer your question, I don't think a random user can really
> > affect the system in a significant way by constantly flushing. In
> > fact, in the test script (which I am now attaching, in case you're
> > interested), there are hundreds of threads that are reading stats of
> > different cgroups every 1s, and I don't see any negative effects on
> > in-kernel flushers in this case (reclaimers).
>
> I suspect you have missed my point.

I suspect you are right :)


> Maybe I am just misunderstanding
> the code but it seems to me that the lock dropping inside
> cgroup_rstat_flush_locked effectivelly allows unbounded number of
> contenders which is really dangerous when it is triggerable from the
> userspace. The number of spinners at a moment is always bound by the
> number CPUs but depending on timing many potential spinners might be
> cond_rescheded and the worst time latency to complete can be really
> high. Makes more sense?

I think I understand better now. So basically because we might drop
the lock and resched, there can be nr_cpus spinners + other spinners
that are currently scheduled away, so these will need to wait to be
scheduled and then start spinning on the lock. This may happen for one
reader multiple times during its read, which is what can cause a high
worst case latency.

I hope I understood you correctly this time. Did I?

So the logic to give up the lock and sleep was introduced by commit
0fa294fb1985 ("cgroup: Replace cgroup_rstat_mutex with a spinlock") in
4.18. It has been possible for userspace to trigger this scenario by
reading cpu.stat, which has been using rstat since then. On the memcg
side, it was also possible to trigger this behavior between commit
2d146aa3aa84 ("mm: memcontrol: switch to rstat") and commit
fd25a9e0e23b ("memcg: unify memcg stat flushing") (i.e between 5.13
and 5.16).

I am not sure there has been any problems from this, but perhaps Tejun
can answer this better than I can.

The way I think about it is that random userspace reads will mostly be
reading their subtrees, which is generally not very large (and can be
limited), so every individual read should be cheap enough. Also,
consequent flushes on overlapping subtrees will have very little to do
as there won't be many pending updates, they should also be very
cheap. So unless multiple jobs on the same machine are collectively
trying to act maliciously (purposefully or not) and concurrently spawn
multiple readers of different parts of the hierarchy (and maintain
enough activity to generate stat updates to flush), I don't think it's
a concern.

I also imagine (but haven't checked) that there is some locking at
some level that will throttle a malicious job that spawns multiple
readers to the same memory.stat file.

I hope this answers your question.


> --
> Michal Hocko
> SUSE Labs
