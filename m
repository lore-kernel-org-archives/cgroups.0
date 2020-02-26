From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v3] cgroup: memcg: net: do not associate sock with
 unrelated cgroup
Date: Wed, 26 Feb 2020 12:02:31 -0800
Message-ID: <CALvZod5TsauERhaCqa1OZp4FaX4nq_UBL84=siESEG=Uk4LYuQ@mail.gmail.com>
References: <20200221014604.126118-1-shakeelb@google.com> <20200226.110749.77396284962321904.davem@davemloft.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oYPZLk9fblhfI7X9fM3xbDPsnJvljmxVNytskCU+vlA=;
        b=UyP5fnk2tcq/pPIf8UiuwxkR5072gZy0q/BJ2uagssjQU8qPl2XlFZef/INcAqm/G/
         AIzv7Fc+eTguGy7/felWPoIFpMQfSwUovQC59vXMK3nK9Vld9VdxSJVDicbvgWOoN9Hc
         lp6Ttr3B2PC+IVX+BU48YAaEoSpQUtEPZEVOyu252uIIjzfQutowIm9kF5gwglA+Mga6
         WWmBOfvwOmDJ4tDldTih3mXrVaeidJaV15tBRGEoVRZ4mnxtChsEM3sWHWTcRg38Tv9P
         1liVai5ZMM8MDyDZbBiD/OsEkAEtf+9uLwxyaxcV1jCFl7V2wMCKotF0lyMmLkNbF9cb
         35sQ==
In-Reply-To: <20200226.110749.77396284962321904.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>, Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Greg Thelen <gthelen@google.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>

On Wed, Feb 26, 2020 at 11:07 AM David Miller <davem@davemloft.net> wrote:
>
> From: Shakeel Butt <shakeelb@google.com>
> Date: Thu, 20 Feb 2020 17:46:04 -0800
>
> > We are testing network memory accounting in our setup and noticed
> > inconsistent network memory usage and often unrelated cgroups network
> > usage correlates with testing workload. On further inspection, it
> > seems like mem_cgroup_sk_alloc() and cgroup_sk_alloc() are broken in
> > IRQ context specially for cgroup v1.
> >
> > mem_cgroup_sk_alloc() and cgroup_sk_alloc() can be called in IRQ context
> > and kind of assumes that this can only happen from sk_clone_lock()
> > and the source sock object has already associated cgroup. However in
> > cgroup v1, where network memory accounting is opt-in, the source sock
> > can be unassociated with any cgroup and the new cloned sock can get
> > associated with unrelated interrupted cgroup.
> >
> > Cgroup v2 can also suffer if the source sock object was created by
> > process in the root cgroup or if sk_alloc() is called in IRQ context.
> > The fix is to just do nothing in interrupt.
> >
> > WARNING: Please note that about half of the TCP sockets are allocated
> > from the IRQ context, so, memory used by such sockets will not be
> > accouted by the memcg.
>
> Then if we do this then we have to have some kind of subsequent change
> to attach these sockets to the correct cgroup, right?

Currently we can potentially charge wrong cgroup. With this patch that
will be fixed but potentially half of sockets remain unaccounted. I
have a followup (incomplete) patch [1] to fix that. I will send the
next version soon.

[1] https://lore.kernel.org/linux-mm/20200222010456.40635-1-shakeelb@google.com/
