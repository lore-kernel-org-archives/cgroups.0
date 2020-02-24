From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] net: memcg: late association of sock to memcg
Date: Mon, 24 Feb 2020 08:38:35 -0800
Message-ID: <CALvZod5Hns1pcPLOHrpnrmxEtU2vT2uVBWpKmU7u5EMYPJwrzQ@mail.gmail.com>
References: <20200222010456.40635-1-shakeelb@google.com> <CANn89iJ2CWSeLp-+mfBLWKNdS2vw=r1iLFtWhyzav_SYcjFrAg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5gO1Y0WzjkHxYIBlGhH4yAQ+tmF9LMDtnMgPaRxoyaM=;
        b=cj0x+qTlOH8bogprsI1KxF0PwXK+DJOMYjbq8x5Xr0Peoeo3LPolVoXCH2d+1bFHyn
         cJGd+9woHFNvbMXIOehX7Uzt631Xj8BTQdWcqeMXoFhgFbKjRr7mJfKxZJ9B9dypEoi+
         0a/c7ukYfIWAmmQ2dGInzkXyM3vzdfJmtfUzx21/4NbAICg5fQ5csiFBDWljYeEiu/Kc
         ks5XUrla6niH4fjrg/j57lJHfVnvBdGq1Hccd9QyueUwpBWZdCtJgXSm2A8RnugrhcWq
         A//qAoh7mL2CDYzh7DZXY86nzBSrghF1gLfSmibRpfRYSp4ADTbJUFptp8GZpd6JsWt5
         clyA==
In-Reply-To: <CANn89iJ2CWSeLp-+mfBLWKNdS2vw=r1iLFtWhyzav_SYcjFrAg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Dumazet <edumazet@google.com>
Cc: Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "David S . Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, netdev <netdev@vger.kernel.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, linux-mm <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Sun, Feb 23, 2020 at 11:29 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Feb 21, 2020 at 5:05 PM Shakeel Butt <shakeelb@google.com> wrote:
> >
> > If a TCP socket is allocated in IRQ context or cloned from unassociated
> > (i.e. not associated to a memcg) in IRQ context then it will remain
> > unassociated for its whole life. Almost half of the TCPs created on the
> > system are created in IRQ context, so, memory used by suck sockets will
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
> > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > ---
> >  net/ipv4/inet_connection_sock.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > index a4db79b1b643..df9c8ef024a2 100644
> > --- a/net/ipv4/inet_connection_sock.c
> > +++ b/net/ipv4/inet_connection_sock.c
> > @@ -482,6 +482,13 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
> >                 }
> >                 spin_unlock_bh(&queue->fastopenq.lock);
> >         }
> > +
> > +       if (mem_cgroup_sockets_enabled && !newsk->sk_memcg) {
> > +               mem_cgroup_sk_alloc(newsk);
> > +               if (newsk->sk_memcg)
> > +                       mem_cgroup_charge_skmem(newsk->sk_memcg,
> > +                                       sk_mem_pages(newsk->sk_forward_alloc));
>
> I am not sure what you  are trying to do here.
>
> sk->sk_forward_alloc is not the total amount of memory used by a TCP socket.
> It is only some part that has been reserved, but not yet consumed.
>
> For example, every skb that has been stored in TCP receive queue or
> out-of-order queue might have
> used memory.
>
> I guess that if we assume that  a not yet accepted socket can not have
> any outstanding data in its transmit queue,
> you need to use sk->sk_rmem_alloc as well.

Thanks a lot. I will add that with a comment. BTW for my knowledge
which field represents the transmit queue size?

>
> To test this patch, make sure to add a delay before accept(), so that
> 2MB worth of data can be queued before accept() happens.

Yes, I will test this with a delay.

thanks,
Shakeel
