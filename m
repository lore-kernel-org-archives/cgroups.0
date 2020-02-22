From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] net: memcg: late association of sock to memcg
Date: Fri, 21 Feb 2020 17:54:43 -0800
Message-ID: <CALvZod6njD5Km=qqaQNOwHdPjx+dt=LJRkzosBYUJLEWyYtHMQ@mail.gmail.com>
References: <20200222010456.40635-1-shakeelb@google.com> <20200222014850.GC459391@carbon.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sw7GUZ8pSeTtd2D2gBjMqfVeJ6NiOruxqtzQHUcbXAE=;
        b=RHl51ojseo7iryCem5GSsxvnC3ShVs3uMsdYTB/dvjcL2ajlQMa+5vHX1oFp//4BRD
         Ox4SCW1s6tUDg0ECSWE5b0dWoY1XLsw0p8h1op0TLp55JMD2lXWxT8s5730OatksAgcy
         kGuyRceUWy+zrrBkZFmTnQU9VsI2cBUGSo491ie/es5JJ9C+RhHbnj0brJJZtSxjmWH9
         ZxPPrwBlCDDgvYW3KdYjZc94tAWvw2JNynNaMJkAaUnvOGCl/gaO6jBJb1xyDogSQ/Uv
         PUGCmp/AFfqBM5w52zSxo3gpfAtTDMeu8P/Hj63dqUcORBbMWXcd2yvixbNsHPh91+lh
         Gt2A==
In-Reply-To: <20200222014850.GC459391@carbon.DHCP.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Eric Dumazet <edumazet@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "David S . Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, netdev@vger.kernel.org, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Fri, Feb 21, 2020 at 5:49 PM Roman Gushchin <guro@fb.com> wrote:
>
> On Fri, Feb 21, 2020 at 05:04:56PM -0800, Shakeel Butt wrote:
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
>
> Hello, Shakeel!
>
> > ---
> >  net/ipv4/inet_connection_sock.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > index a4db79b1b643..df9c8ef024a2 100644
> > --- a/net/ipv4/inet_connection_sock.c
> > +++ b/net/ipv4/inet_connection_sock.c
> > @@ -482,6 +482,13 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
> >               }
> >               spin_unlock_bh(&queue->fastopenq.lock);
> >       }
> > +
> > +     if (mem_cgroup_sockets_enabled && !newsk->sk_memcg) {
> > +             mem_cgroup_sk_alloc(newsk);
> > +             if (newsk->sk_memcg)
> > +                     mem_cgroup_charge_skmem(newsk->sk_memcg,
> > +                                     sk_mem_pages(newsk->sk_forward_alloc));
> > +     }
>
> Looks good for me from the memcg side. Let's see what networking people will say...
>
> Btw, do you plan to make a separate patch for associating the socket with the default
> cgroup on the unified hierarchy? I mean cgroup_sk_alloc().
>

Yes. I tried to do that here but was not able to do without adding the
(newsk->sk_cgrp_data.val) check which I can not do in this file as
sk_cgrp_data might not be compiled. I will send a separate patch.

Shakeel
