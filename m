From: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: memcg: net: do not associate sock with
 unrelated cgroup
Date: Fri, 14 Feb 2020 16:11:24 -0800
Message-ID: <CANn89iKq5r7aCDdpTXzfvDbhHYgnTGhgyTG5_rLbcSeeF8uJJQ@mail.gmail.com>
References: <20200214222415.181467-1-shakeelb@google.com> <CANn89iLe7KVjaechEhtV4=QRy4s8qBQDiX9e8LX_xq8tunrQNA@mail.gmail.com>
 <CALvZod5RoE3V7HteKqqDEfCgY8pDok6PWHrpu8trB1vyuK2UHA@mail.gmail.com>
 <CANn89i+-GJgD4-YnF9yKhDvG48OK8XtM7oB9gw6njeb_ZbdpDw@mail.gmail.com> <CALvZod4kU=tWcWbu4pWBrHUcxgTnKj_2fEEdnBeU+F0kox0Hig@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qj2zBbkIxBGfCERuHV86VP5E7OnuA4mxy13S+8Juj1A=;
        b=mQXv020xrGiFQVRcG+t3iVDyjz5L4TGdw0U6fbXeCwxrDC4hDSpg0HBUuUifRpC35r
         IAr+R+LZdTurVkQIlblgBmObc9b8hX5L2QMJXSgw+ykNNQcG5LVdhpwoKmSquITh5FDc
         me1wYFI8+0AcXmPj9ameun83h8tbAFaCzlBQVnK9wL0CfDhdWHFsRLu+6RaIUliQg3mx
         FEvcu8Ar1zcLaMHBuLvh3rsYsOfl0C2RlyfjNt65BG+ROrPNebXJjL0UYf9LxR0gYO5q
         4Entvu6OAzKq+H8KYWL1LRp/fdJbWViG6JTmq3xbcl9LNkt596K8wSd8/aHFGmc4lO1e
         VG0A==
In-Reply-To: <CALvZod4kU=tWcWbu4pWBrHUcxgTnKj_2fEEdnBeU+F0kox0Hig-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Feb 14, 2020 at 4:04 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Fri, Feb 14, 2020 at 3:12 PM Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On Fri, Feb 14, 2020 at 2:48 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > >
> > > I think in the current code if the association is skipped at
> > > allocation time then the sock will remain unassociated for its
> > > lifetime.
> > >
> > > Maybe we can add the association in the later stages but it seems like
> > > it is not a simple task i.e. edbe69ef2c90f ("Revert "defer call to
> > > mem_cgroup_sk_alloc()"").
> >
> > Half TCP sockets are passive, so this means that 50% of TCP sockets
> > won't be charged.
> > (the socket cloning always happens from BH context)
> >
> > I think this deserves a comment in the changelog or documentation,
> > otherwise some people might think
> > using memcg will make them safe.
>
> Thanks I will update the changelog. Also is inet_csk_accept() the
> right place for delayed cgroup/memcg binding (if we decide to do
> that). I am wondering if we can force charge the memcg during late
> binding to cater the issue fixed in edbe69ef2c90f.
>

Yes, this is exactly why accept() would be the natural choice.

You  do not want to test/change the binding at sendmsg()/recvmsg() time, right ?
