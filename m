From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] net: memcg: late association of sock to memcg
Date: Thu, 5 Mar 2020 13:59:37 -0800
Message-ID: <CALvZod68Raqfa2ZJOfF_OOQdb-hxkOs54G5KK3VQnUdxiZ=KTQ@mail.gmail.com>
References: <20200305205525.245058-1-shakeelb@google.com> <9505d35b-f9fc-149b-6df5-e65ad95acabb@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GZ9X7pBOQ32PghBEC4+dP85I/S+wu1As9RhQFRnXXto=;
        b=lSsXtoDIO0iLHjqPicvvXtqjyT7OR/kBmY+VLmgBRevQBgKkkDTBQRGLxzsgcELH6t
         gqiGETJBzstXBAnv9oYvbcIBIz89GpuahxVSYeZiGIBZ4JvWLqjwVYKVD1bfwB074NTL
         9MZik/rr8kw3M1VyRiiRn60Ts6yKRUKNcOSsYWGch+SBvf7epfYp8rNztCtiP/kPuX9K
         10Bcd7ggd2vSizpgzvw3rq7TbbT5qAgso27hxp1LZMY9bXozbQWsZzRKL1BXWCK66cCq
         FzIrI80C7cvzbZRPcHeBZj4Pxdrxrivy0+6UjMRhYPpEW17iy/T0kUB0lmxycqhI6IJV
         wl0w==
In-Reply-To: <9505d35b-f9fc-149b-6df5-e65ad95acabb-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Alexey Kuznetsov <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Mar 5, 2020 at 1:17 PM Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>
>
> On 3/5/20 12:55 PM, Shakeel Butt wrote:
> > If a TCP socket is allocated in IRQ context or cloned from unassociated
> > (i.e. not associated to a memcg) in IRQ context then it will remain
> > unassociated for its whole life. Almost half of the TCPs created on the
> > system are created in IRQ context, so, memory used by such sockets will
> > not be accounted by the memcg.
> >
> > This issue is more widespread in cgroup v1 where network memory
> > accounting is opt-in but it can happen in cgroup v2 if the source socket
> > for the cloning was created in root memcg.
> >
> > To fix the issue, just do the late association of the unassociated
> > sockets at accept() time in the process context and then force charge
> > the memory buffer already reserved by the socket.
> >
> > Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
> > Changes since v2:
> > - Additional check for charging.
> > - Release the sock after charging.
> >
> > Changes since v1:
> > - added sk->sk_rmem_alloc to initial charging.
> > - added synchronization to get memory usage and set sk_memcg race-free.
> >
> >  net/ipv4/inet_connection_sock.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >
> > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > index a4db79b1b643..5face55cf818 100644
> > --- a/net/ipv4/inet_connection_sock.c
> > +++ b/net/ipv4/inet_connection_sock.c
> > @@ -482,6 +482,26 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
> >               }
> >               spin_unlock_bh(&queue->fastopenq.lock);
> >       }
> > +
> > +     if (mem_cgroup_sockets_enabled && !newsk->sk_memcg) {
> > +             int amt;
> > +
> > +             /* atomically get the memory usage, set and charge the
> > +              * sk->sk_memcg.
> > +              */
> > +             lock_sock(newsk);
> > +
> > +             /* The sk has not been accepted yet, no need to look at
> > +              * sk->sk_wmem_queued.
> > +              */
> > +             amt = sk_mem_pages(newsk->sk_forward_alloc +
> > +                                atomic_read(&sk->sk_rmem_alloc));
> > +             mem_cgroup_sk_alloc(newsk);
> > +             if (newsk->sk_memcg && amt)
> > +                     mem_cgroup_charge_skmem(newsk->sk_memcg, amt);
> > +
> > +             release_sock(newsk);
> > +     }
> >  out:
> >       release_sock(sk);
> >       if (req)
> >
>
> This patch looks fine, but why keeping the mem_cgroup_sk_alloc(newsk);
> in sk_clone_lock() ?
>
> Note that all TCP sk_clone_lock() calls happen in softirq context.

So, basically re-doing something like 9f1c2674b328 ("net: memcontrol:
defer call to mem_cgroup_sk_alloc()") in this patch. I am fine with
that.

Roman, any concerns?
