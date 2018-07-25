From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] memcg: reduce memcg tree traversals for stats collection
Date: Wed, 25 Jul 2018 07:27:50 -0700
Message-ID: <CALvZod7Fqj_pJ2sn+XiDsoDX4jBLM22iGUrB9PeJXg+8S5xExQ@mail.gmail.com>
References: <20180724224635.143944-1-shakeelb@google.com> <CAOm-9arFu63A9YJ6yVtm6_LdtbRKZg1Q3dz8WugdkBBQfoOWYw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CPxlBjp9IJJj6SZNOZXY2s4FyyZaG0r+B7Dvp6lfg5w=;
        b=GxxB33XOBqTnuMHkXS2VMnZIVvqhHS59wcU0IGCzL+qX5Lunl7M/2tU2hXvjEXRiwr
         sGOjyDI7zzC9UZbDROD3/XITzgZEIboIqNuhCIJpquF4MbkSUjgsE6tM6m6syPs2id7y
         bMYPURH4VCvltpX0VKyM4mqx/Gc/Nd3JMGXGgrYJEP8OhRyEn6aqdnxZcWweyCPw8Jug
         KS2LB1eQAlI48kr3Y7dzZ+fZVBUPgrjcUWuD4gt15FoEEpx89I/R81HHmBSdDVm4kQ5k
         +Nv+iuWsxfFD3Hfs6Xb3nSo/poHQOmuep5Df8zvw7KZG9sI8yQBhLHETdrFVD8fleJRn
         nMjA==
In-Reply-To: <CAOm-9arFu63A9YJ6yVtm6_LdtbRKZg1Q3dz8WugdkBBQfoOWYw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bmerry@ska.ac.za
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>

On Wed, Jul 25, 2018 at 4:26 AM Bruce Merry <bmerry@ska.ac.za> wrote:
>
> On 25 July 2018 at 00:46, Shakeel Butt <shakeelb@google.com> wrote:
> > I ran a simple benchmark which reads the root_mem_cgroup's stat file
> > 1000 times in the presense of 2500 memcgs on cgroup-v1. The results are:
> >
> > Without the patch:
> > $ time ./read-root-stat-1000-times
> >
> > real    0m1.663s
> > user    0m0.000s
> > sys     0m1.660s
> >
> > With the patch:
> > $ time ./read-root-stat-1000-times
> >
> > real    0m0.468s
> > user    0m0.000s
> > sys     0m0.467s
>
> Thanks for cc'ing me. I've tried this patch using my test case and the
> results are interesting. With the patch applied, running my script
> only generates about 8000 new cgroups, compared to 40,000 before -
> presumably because the optimisation has altered the timing.
>
> On the other hand, if I run the script 5 times to generate 40000
> zombie cgroups, the time to get stats for the root cgroup (cgroup-v1)
> is almost unchanged at around 18ms (was 20ms, but there were slightly
> more cgroups as well), compared to the almost 4x speedup you're seeing
> in your test.
>

Hi Bruce, I think your script is trying to create zombies, so, the
experiments after that script will be non-deterministic. Why not just
create 40k cgroups ,no need for zombies, and the see how much this
patch affects reading stats.

Shakeel
