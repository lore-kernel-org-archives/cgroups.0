From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v3] net: memcg: late association of sock to memcg
Date: Thu, 5 Mar 2020 14:45:44 -0800
Message-ID: <20200305224544.GA1092120@carbon.dhcp.thefacebook.com>
References: <20200305205525.245058-1-shakeelb@google.com>
 <9505d35b-f9fc-149b-6df5-e65ad95acabb@gmail.com>
 <CALvZod68Raqfa2ZJOfF_OOQdb-hxkOs54G5KK3VQnUdxiZ=KTQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Mp/1lQJtzXVINzsbfr8kALKtjQcBVu5sDXErI8SIq2U=;
 b=avREyIi2vpTR0GskRVXXOpJiKWxwyKa5+UfKrR1JMovcvlevrU7uy7OcHYGqM1KQxRer
 zwrY88V12Veu+RVgZ7x0ha0xMwxTxmqSIlDqBsYxbgQfO8Ut+3WNoQQW6uXRX1uLEl8u
 0ruZNjC1KJoXGwcLiu1r2u5benyYWiOInEE= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mp/1lQJtzXVINzsbfr8kALKtjQcBVu5sDXErI8SIq2U=;
 b=DvqdHXaDP1jCaE9I3yAMp9KSL9ccvoHhRmr4evrHQD6mheSjU5OCVcRZBonsHbFpZ4bCsuP57z3HGWitmv+L8kslPEaBiFsBfSo/QOQ1KGLKbaGgCSU2VsaSGSTc3iRCCcAPaYiLnQloMR5AGtevHnAS/tTieLUwfE5vw7maMqk=
Content-Disposition: inline
In-Reply-To: <CALvZod68Raqfa2ZJOfF_OOQdb-hxkOs54G5KK3VQnUdxiZ=KTQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Eric Dumazet <edumazet@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "David S . Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev <netdev@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Thu, Mar 05, 2020 at 01:59:37PM -0800, Shakeel Butt wrote:
> On Thu, Mar 5, 2020 at 1:17 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> >
> >
> > On 3/5/20 12:55 PM, Shakeel Butt wrote:
> > > If a TCP socket is allocated in IRQ context or cloned from unassociated
> > > (i.e. not associated to a memcg) in IRQ context then it will remain
> > > unassociated for its whole life. Almost half of the TCPs created on the
> > > system are created in IRQ context, so, memory used by such sockets will
> > > not be accounted by the memcg.
> > >
> > > This issue is more widespread in cgroup v1 where network memory
> > > accounting is opt-in but it can happen in cgroup v2 if the source socket
> > > for the cloning was created in root memcg.
> > >
> > > To fix the issue, just do the late association of the unassociated
> > > sockets at accept() time in the process context and then force charge
> > > the memory buffer already reserved by the socket.
> > >
> > > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > > ---
> > > Changes since v2:
> > > - Additional check for charging.
> > > - Release the sock after charging.
> > >
> > > Changes since v1:
> > > - added sk->sk_rmem_alloc to initial charging.
> > > - added synchronization to get memory usage and set sk_memcg race-free.
> > >
> > >  net/ipv4/inet_connection_sock.c | 20 ++++++++++++++++++++
> > >  1 file changed, 20 insertions(+)
> > >
> > > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > > index a4db79b1b643..5face55cf818 100644
> > > --- a/net/ipv4/inet_connection_sock.c
> > > +++ b/net/ipv4/inet_connection_sock.c
> > > @@ -482,6 +482,26 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
> > >               }
> > >               spin_unlock_bh(&queue->fastopenq.lock);
> > >       }
> > > +
> > > +     if (mem_cgroup_sockets_enabled && !newsk->sk_memcg) {
> > > +             int amt;
> > > +
> > > +             /* atomically get the memory usage, set and charge the
> > > +              * sk->sk_memcg.
> > > +              */
> > > +             lock_sock(newsk);
> > > +
> > > +             /* The sk has not been accepted yet, no need to look at
> > > +              * sk->sk_wmem_queued.
> > > +              */
> > > +             amt = sk_mem_pages(newsk->sk_forward_alloc +
> > > +                                atomic_read(&sk->sk_rmem_alloc));
> > > +             mem_cgroup_sk_alloc(newsk);
> > > +             if (newsk->sk_memcg && amt)
> > > +                     mem_cgroup_charge_skmem(newsk->sk_memcg, amt);
> > > +
> > > +             release_sock(newsk);
> > > +     }
> > >  out:
> > >       release_sock(sk);
> > >       if (req)
> > >
> >
> > This patch looks fine, but why keeping the mem_cgroup_sk_alloc(newsk);
> > in sk_clone_lock() ?
> >
> > Note that all TCP sk_clone_lock() calls happen in softirq context.
> 
> So, basically re-doing something like 9f1c2674b328 ("net: memcontrol:
> defer call to mem_cgroup_sk_alloc()") in this patch. I am fine with
> that.
> 
> Roman, any concerns?

Nothing at the moment, I'll try to give some testing to the final patch.
I hope this time it will work better...

Thank you!
