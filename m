From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [RFC PATCH 0/8] memory recharging for offline memcgs
Date: Fri, 21 Jul 2023 11:47:49 -0700
Message-ID: <CAJD7tkatz1JhKVj_iP9J0H7fPJnUSurZkCT1iJTJ=+qRen_nLQ@mail.gmail.com>
References: <20230720070825.992023-1-yosryahmed@google.com>
 <20230720153515.GA1003248@cmpxchg.org> <ZLmRlTej8Tm82kXG@slm.duckdns.org>
 <CAJD7tkYhu3g9u7HkUTFBtT3Q4edVZ2g1TWV1FDcyM9srrYCBLg@mail.gmail.com>
 <ZLmxLUNdxMi5s2Kq@slm.duckdns.org> <CAJD7tkZKo_oSZ-mQc-knMELP8kiY1N7taQhdV6tPsqN0tg=gog@mail.gmail.com>
 <ZLm1ptOYH6F8fGHT@slm.duckdns.org> <CAJD7tkbDxw-hqG8i85NhnjxmXFMbR5OaSW5dHDVYfdA=ZnPAEw@mail.gmail.com>
 <ZLrN1BE42Tsybm6j@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689965306; x=1690570106;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tdq/W+QGmbFYjBwzec6GU8stgr9jLA3Mk5O05X2GOvY=;
        b=muASEYnZmQZKBYoEZ0S4+U/aJoPH1HHib/qcQHHw3GxE+05UEBQofzyZMM6Atdd0Yg
         iVLuraXsAfHkF8ldSyV7GfVUX31oAUm34s0teCQepYf7rLqtpiA01nCnVOn2tnrj5CMm
         DUDokWhrZG8N240U4zghZjjxw/sQCIjjLknPmfGDFbpXzSUo2nvgHzuSyz/ChM3q8GBV
         wN+s0L2B2DYK5k8ZNnOaM244w71qa8p2Y2ok7OcD0cAHzY4tiZj8X4C/GvGWN+udQars
         ksS0fIcBPzTY8ecxgk9/+GpHK3lU5nZ1X/ZDddKSqb0cEmI0D8W+SPo2QIKCxHMQwhot
         bxWg==
In-Reply-To: <ZLrN1BE42Tsybm6j@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Zefan Li <lizefan.x@bytedance.com>, Yu Zhao <yuzhao@google.com>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Iurii Zaikin <yzaikin@google.com>, "T.J. Mercier" <tjmercier@google.com>, Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Fri, Jul 21, 2023 at 11:26=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Fri, Jul 21, 2023 at 11:15:21AM -0700, Yosry Ahmed wrote:
> > On Thu, Jul 20, 2023 at 3:31=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote=
:
> > > memory at least in our case. The sharing across them comes down to th=
ings
> > > like some common library pages which don't really account for much th=
ese
> > > days.
> >
> > Keep in mind that even a single page charged to a memcg and used by
> > another memcg is sufficient to result in a zombie memcg.
>
> I mean, yeah, that's a separate issue or rather a subset which isn't all
> that controversial. That can be deterministically solved by reparenting t=
o
> the parent like how slab is handled. I think the "deterministic" part is
> important here. As you said, even a single page can pin a dying cgroup.

There are serious flaws with reparenting that I mentioned above. We do
it for kernel memory, but that's because we really have no other
choice. Oftentimes the memory is not reclaimable and we cannot find an
owner for it. This doesn't mean it's the right answer for user memory.

The semantics are new compared to normal charging (as opposed to
recharging, as I explain below). There is an extra layer of
indirection that we did not (as far as I know) measure the impact of.
Parents end up with pages that they never used and we have no
observability into where it came from. Most importantly, over time
user memory will keep accumulating at the root, reducing the accuracy
and usefulness of accounting, effectively an accounting leak and
reduction of capacity. Memory that is not attributed to any user, aka
system overhead.

>
> > > > Keep in mind that the environment is dynamic, workloads are constan=
tly
> > > > coming and going. Even if find the perfect nesting to appropriately
> > > > scope resources, some rescheduling may render the hierarchy obsolet=
e
> > > > and require us to start over.
> > >
> > > Can you please go into more details on how much memory is shared for =
what
> > > across unrelated dynamic workloads? That sounds different from other =
use
> > > cases.
> >
> > I am trying to collect more information from our fleet, but the
> > application restarting in a different cgroup is not what is happening
> > in our case. It is not easy to find out exactly what is going on on
>
> This is the point that Johannes raised but I don't think the current
> proposal would make things more deterministic. From what I can see, it
> actually pushes it towards even less predictability. Currently, yeah, som=
e
> pages may end up in cgroups which aren't the majority user but it at leas=
t
> is clear how that would happen. The proposed change adds layers of
> indeterministic behaviors on top. I don't think that's the direction we w=
ant
> to go.

I believe recharging is being mis-framed here :)

Recharging semantics are not new, it is a shortcut to a process that
is already happening that is focused on offline memcgs. Let's take a
step back.

It is common practice (at least in my knowledge) to try to reclaim
memory from a cgroup before deleting it (by lowering the limit or
using memory.reclaim). Reclaim heuristics are biased towards
reclaiming memory from offline cgroups. After the memory is reclaimed,
if it is used again by a different process, it will be refaulted and
charged again (aka recharged) to the new

What recharging is doing is *not* anything new. It is effectively
doing what reclaim + refault would do above, with an efficient
shortcut. It avoids the unnecessary fault, avoids disrupting the
workload that will access the memory after it is reclaimed, and cleans
up zombie memcgs memory faster than reclaim would. Moreover, it works
for memory that may not be reclaimable (e.g. because of lack of swap).

All the indeterministic behaviors in recharging are exactly the
indeterministic behaviors in reclaim. It is very similar. We iterate
the lrus, try to isolate and lock folios, etc. This is what reclaim
does. Recharging is basically lightweight reclaim + charging again (as
opposed to fully reclaiming the memory then refaulting it).

We are not introducing new indeterminism or charging semantics.
Recharging does exactly what would happen when we reclaim zombie
memory. It is just more efficient and accelerated.

>
> > machines and where the memory is coming from due to the
> > indeterministic nature of charging. The goal of this proposal is to
> > let the kernel handle leftover memory in zombie memcgs because it is
> > not always obvious to userspace what's going on (like it's not obvious
> > to me now where exactly is the sharing happening :) ).
> >
> > One thing to note is that in some cases, maybe a userspace bug or
> > failed cleanup is a reason for the zombie memcgs. Ideally, this
> > wouldn't happen, but it would be nice to have a fallback mechanism in
> > the kernel if it does.
>
> I'm not disagreeing on that. Our handling of pages owned by dying cgroups
> isn't great but I don't think the proposed change is an acceptable soluti=
on.

 I hope the above arguments change your mind :)

>
> Thanks.
>
> --
> tejun
