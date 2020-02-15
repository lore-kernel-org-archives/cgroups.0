From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: memcg: net: do not associate sock with
 unrelated cgroup
Date: Fri, 14 Feb 2020 16:04:20 -0800
Message-ID: <CALvZod4kU=tWcWbu4pWBrHUcxgTnKj_2fEEdnBeU+F0kox0Hig@mail.gmail.com>
References: <20200214222415.181467-1-shakeelb@google.com> <CANn89iLe7KVjaechEhtV4=QRy4s8qBQDiX9e8LX_xq8tunrQNA@mail.gmail.com>
 <CALvZod5RoE3V7HteKqqDEfCgY8pDok6PWHrpu8trB1vyuK2UHA@mail.gmail.com> <CANn89i+-GJgD4-YnF9yKhDvG48OK8XtM7oB9gw6njeb_ZbdpDw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sc3eN5qofsLsz0odXUjAXrrQtgiKgF8fh8BjuXC2JWY=;
        b=OpzcXXfkrp7UFH3ZK85YabQ88elz5XA6OO/FPNgHZkCMW/kxBKWveumbeQjL/Xav1P
         ty+v6E4VESghdBWneJyGKa+igJclsO2a1+3vswIplonbl5S+KcdbSPQ9MRbF18yIlU2I
         dgnwRWUtwnZt3zXEGFDhMWGJh9u+i42Mcn1kCybLYVgeQiyhHacQ7TUUdM+4+U56jaqy
         d9tdMOE3jWZIvcihxvFqfE8ew7Nux205pr5nJLrYaZCkhW/yXfL3YjxoECuwcIckYZHm
         qFG5VsR/2Ok/XAzuGw700He0YIDDQ1KHzWkBVK+S3C0h01QsVZVUYaSQ4MPyi0ROMS+g
         hsaA==
In-Reply-To: <CANn89i+-GJgD4-YnF9yKhDvG48OK8XtM7oB9gw6njeb_ZbdpDw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Feb 14, 2020 at 3:12 PM Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Fri, Feb 14, 2020 at 2:48 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> >
> > I think in the current code if the association is skipped at
> > allocation time then the sock will remain unassociated for its
> > lifetime.
> >
> > Maybe we can add the association in the later stages but it seems like
> > it is not a simple task i.e. edbe69ef2c90f ("Revert "defer call to
> > mem_cgroup_sk_alloc()"").
>
> Half TCP sockets are passive, so this means that 50% of TCP sockets
> won't be charged.
> (the socket cloning always happens from BH context)
>
> I think this deserves a comment in the changelog or documentation,
> otherwise some people might think
> using memcg will make them safe.

Thanks I will update the changelog. Also is inet_csk_accept() the
right place for delayed cgroup/memcg binding (if we decide to do
that). I am wondering if we can force charge the memcg during late
binding to cater the issue fixed in edbe69ef2c90f.

Shakeel
