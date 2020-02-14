From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: memcg: net: do not associate sock with
 unrelated cgroup
Date: Fri, 14 Feb 2020 14:48:46 -0800
Message-ID: <CALvZod5RoE3V7HteKqqDEfCgY8pDok6PWHrpu8trB1vyuK2UHA@mail.gmail.com>
References: <20200214222415.181467-1-shakeelb@google.com> <CANn89iLe7KVjaechEhtV4=QRy4s8qBQDiX9e8LX_xq8tunrQNA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TgoIP7Jshrn2duDl/cLkfq4CVlTeMc4BWp5pc4aKy4o=;
        b=MhgOWYPob9S6aZV6qa2b7vLLaVDvt275tODnygTV/CKd8wZi8f724KWNlUCRxs5mjH
         DCM690tw83yBr2LORN0E+j9ll5bD4HHOlWoWsl86QrhEuZIsmxOjBealBDm00d5vtezR
         vUaYfoe/EyPW0Yufblun637lPw3LqF5RI0rMvLWN47ZAf9ujyHXOjVyP4Qfo2c271JS9
         7rUY48zxABcoVUIkQPtg+0T4o5KmUJuvDUzJxKTBOgxeCBg2ZxJDuziggGbCQ9scH07Z
         1lMwyvU0Aa05SCjGeSZN7Mw6D5wbI4rvxo452JwFeUFIe8Ry6FtSz9LrvBReh5+rLGI4
         jBsA==
In-Reply-To: <CANn89iLe7KVjaechEhtV4=QRy4s8qBQDiX9e8LX_xq8tunrQNA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Feb 14, 2020 at 2:38 PM Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Fri, Feb 14, 2020 at 2:24 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > We are testing network memory accounting in our setup and noticed
> > inconsistent network memory usage and often unrelated cgroups network
> > usage correlates with testing workload. On further inspection, it
> > seems like mem_cgroup_sk_alloc() and cgroup_sk_alloc() are broken in
> > irq context specially for cgroup v1.
> >
> > mem_cgroup_sk_alloc() and cgroup_sk_alloc() can be called in irq context
> > and kind of assumes that this can only happen from sk_clone_lock()
> > and the source sock object has already associated cgroup. However in
> > cgroup v1, where network memory accounting is opt-in, the source sock
> > can be unassociated with any cgroup and the new cloned sock can get
> > associated with unrelated interrupted cgroup.
> >
> > Cgroup v2 can also suffer if the source sock object was created by
> > process in the root cgroup or if sk_alloc() is called in irq context.
> > The fix is to just do nothing in interrupt.
>
> So, when will the association be done ?
> At accept() time ?
> Is it done already ?
>

I think in the current code if the association is skipped at
allocation time then the sock will remain unassociated for its
lifetime.

Maybe we can add the association in the later stages but it seems like
it is not a simple task i.e. edbe69ef2c90f ("Revert "defer call to
mem_cgroup_sk_alloc()"").

Shakeel
