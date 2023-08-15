From: Ivan Babrou <ivan@cloudflare.com>
Subject: Re: Expensive memory.stat + cpu.stat reads
Date: Mon, 14 Aug 2023 17:30:11 -0700
Message-ID: <CABWYdi3z7Y4qdjPv4wiHyM6Wvwy_VwSLGA92=_PdYyVZgQDSYQ@mail.gmail.com>
References: <CABWYdi0c6__rh-K7dcM_pkf9BJdTRtAU08M43KO9ME4-dsgfoQ@mail.gmail.com>
 <20230706062045.xwmwns7cm4fxd7iu@google.com> <CABWYdi2pBaCrdKcM37oBomc+5W8MdRp1HwPpOExBGYfZitxyWA@mail.gmail.com>
 <d3f3a7bc-b181-a408-af1d-dd401c172cbf@redhat.com> <CABWYdi2iWYT0sHpK74W6=Oz6HA_3bAqKQd4h+amK0n3T3nge6g@mail.gmail.com>
 <CABWYdi3YNwtPDwwJWmCO-ER50iP7CfbXkCep5TKb-9QzY-a40A@mail.gmail.com>
 <CABWYdi0+0gxr7PB4R8rh6hXO=H7ZaCzfk8bmOSeQMuZR7s7Pjg@mail.gmail.com>
 <CAJD7tkaf5GNbyhCbWyyLtxpqmZ4+iByQgmS1QEFf+bnEMCdmFA@mail.gmail.com>
 <CAJD7tkb=dUfc=L+61noQYHymHPUHswm_XUyFvRdaZemo80qUdQ@mail.gmail.com> <ZNrEV1qEcQMUgztn@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1692059423; x=1692664223;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dLuShFOThvoDFyPjtjqSrXce/+NsjfeL6FKbvb91ep0=;
        b=CxLgfRZTYE2O+lvzzG0vY5ne298WWrrJYUWkVxMZpLYYaHsHujbTYL5pjKgETSom8D
         vzAAqqBkpXkWiv0++Uxv0ACgo3g3wnwX2egyTis+N6wLSzvjoT/n1He6wzKIsNcmOJPd
         u2v+6Q1C4+SciYbUN3OI8YjqnJpbMRUzxEYaE=
In-Reply-To: <ZNrEV1qEcQMUgztn@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tejun Heo <tj@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>, Waiman Long <longman@redhat.com>, Shakeel Butt <shakeelb@google.com>, cgroups@vger.kernel.org, Linux MM <linux-mm@kvack.org>, kernel-team <kernel-team@cloudflare.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, Aug 14, 2023 at 5:18=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Fri, Aug 11, 2023 at 05:01:08PM -0700, Yosry Ahmed wrote:
> > There have been a lot of problems coming from this global rstat lock:
> > hard lockups (when we used to flush atomically), unified flushing
> > being expensive, skipping flushing being inaccurate, etc.
> >
> > I wonder if it's time to rethink this lock and break it down into
> > granular locks. Perhaps a per-cgroup lock, and develop a locking
> > scheme where you always lock a parent then a child, then flush the
> > child and unlock it and move to the next child, etc. This will allow
> > concurrent flushing of non-root cgroups. Even when flushing the root,
> > if we flush all its children first without locking the root, then only
> > lock the root when flushing the top-level children, then some level of
> > concurrency can be achieved.
> >
> > Maybe this is too complicated, I never tried to implement it, but I
> > have been bouncing around this idea in my head for a while now.
> >
> > We can also split the update tree per controller. As far as I can tell
> > there is no reason to flush cpu stats for example when someone wants
> > to read memory stats.
>
> There's another thread. Let's continue there but I'm a bit skeptical whet=
her
> splitting the lock is a good solution here. Regardless of locking, we don=
't
> want to run in an atomic context for that long anwyay.

Could you link to the other thread?
