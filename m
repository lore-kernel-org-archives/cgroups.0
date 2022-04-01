From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Fri, 1 Apr 2022 02:23:33 -0700
Message-ID: <CAJD7tka1UstKYBVrie-_1CgvtaLtVD1uwgzfk5SifxW4FQbOVw@mail.gmail.com>
References: <20220331084151.2600229-1-yosryahmed@google.com> <874k3d6vuq.fsf@vajain21.in.ibm.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eqHcENevlipVpLwJzXjFe9d3oZf1LHDk3dciHpBysEs=;
        b=SE0wj13yNQUKOLM7y5D13X3QyLAcWrPwhqQndeixZUJj6q9pgA456c8KR80+WD0J4T
         0B29QRq5HhGLr5tyU1zOJD/4zhyujrn1COBvQHyQG0IkF+B7lhHruTepHwDZ6y0Dyqdf
         udoZQegWVZWcu+U+gY66/nsmhnOOOqWbZ3bsB0CLnxC+FTaiugBCHOBpEr/IvU87nfid
         ng87Quwf+lM88JUvep0VBVmphTmD6/NdezPovc4WuobQb42jRkZ7P9qMVe+O9TuFF3RL
         geu+SYCVcB0i0i/mVYgCqw80holeY6GYkG2zo8XI2CVyJ8+ZRn2wD0Aa1RbFQmuCT/gO
         npFA==
In-Reply-To: <874k3d6vuq.fsf@vajain21.in.ibm.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Roman Gushchin <roman.gushchin@linux.dev>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, Jonathan Corbet <corbet@lwn.net>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>

On Fri, Apr 1, 2022 at 1:39 AM Vaibhav Jain <vaibhav@linux.ibm.com> wrote:
>
>
> Yosry Ahmed <yosryahmed@google.com> writes:
> > From: Shakeel Butt <shakeelb@google.com>
> >
> > Introduce an memcg interface to trigger memory reclaim on a memory cgroup.
> <snip>
>
> > +
> > +     while (nr_reclaimed < nr_to_reclaim) {
> > +             unsigned long reclaimed;
> > +
> > +             if (signal_pending(current))
> > +                     break;
> > +
> > +             reclaimed = try_to_free_mem_cgroup_pages(memcg,
> > +                                             nr_to_reclaim - nr_reclaimed,
> > +                                             GFP_KERNEL, true);
> > +
> > +             if (!reclaimed && !nr_retries--)
> > +                     break;
> > +
> > +             nr_reclaimed += reclaimed;
>
> I think there should be a cond_resched() in this loop before
> try_to_free_mem_cgroup_pages() to have better chances of reclaim
> succeding early.
>
Thanks for taking the time to look at this!

I believe this loop is modeled after the loop in memory_high_write()
for the memory.high interface. Is there a reason why it should be
needed here but not there?

> <snip>
>
> --
> Cheers
> ~ Vaibhav
