From: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] net: memcg: late association of sock to memcg
Date: Sun, 23 Feb 2020 23:29:04 -0800
Message-ID: <CANn89iJ2CWSeLp-+mfBLWKNdS2vw=r1iLFtWhyzav_SYcjFrAg@mail.gmail.com>
References: <20200222010456.40635-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pu7YZUk9S4E/pNGkKq9v6WlWWKovjGT+ogGtMRUpTlY=;
        b=cT1aVW9aEmNffyJsbSnpD1pePBSTJmnbrzeS1G1xYMa+f/EI6Ix7TCrDA2k7COPesT
         nCNnqeSTzMOzj9Dop4WbLhHHv4N6u/cpIlGFjewYNHHviMvEopaL5JfcJWNiNYOy828a
         5q0KS5TdQWwz9hJAk7r952F3mLit5GROR1edHOg1LGu+yE8oWQ3LB3TLurElJ+N/IUhS
         yJOqnGyl9XxLMZrwR8wmW/j6Hkht8FySi7RJe6fJtKM5dYhMdn9bTuo8r9THb3skjq7K
         /3mYHGC5MFfzeDS085t/m1H8wI9bVvbmxd3lRfq7AH9PkcpWJXQWmBQKz0NmH5Zm2SVy
         CC+g==
In-Reply-To: <20200222010456.40635-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Alexey Kuznetsov <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Feb 21, 2020 at 5:05 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> If a TCP socket is allocated in IRQ context or cloned from unassociated
> (i.e. not associated to a memcg) in IRQ context then it will remain
> unassociated for its whole life. Almost half of the TCPs created on the
> system are created in IRQ context, so, memory used by suck sockets will
> not be accounted by the memcg.
>
> This issue is more widespread in cgroup v1 where network memory
> accounting is opt-in but it can happen in cgroup v2 if the source socket
> for the cloning was created in root memcg.
>
> To fix the issue, just do the late association of the unassociated
> sockets at accept() time in the process context and then force charge
> the memory buffer already reserved by the socket.
>
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  net/ipv4/inet_connection_sock.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index a4db79b1b643..df9c8ef024a2 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -482,6 +482,13 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
>                 }
>                 spin_unlock_bh(&queue->fastopenq.lock);
>         }
> +
> +       if (mem_cgroup_sockets_enabled && !newsk->sk_memcg) {
> +               mem_cgroup_sk_alloc(newsk);
> +               if (newsk->sk_memcg)
> +                       mem_cgroup_charge_skmem(newsk->sk_memcg,
> +                                       sk_mem_pages(newsk->sk_forward_alloc));

I am not sure what you  are trying to do here.

sk->sk_forward_alloc is not the total amount of memory used by a TCP socket.
It is only some part that has been reserved, but not yet consumed.

For example, every skb that has been stored in TCP receive queue or
out-of-order queue might have
used memory.

I guess that if we assume that  a not yet accepted socket can not have
any outstanding data in its transmit queue,
you need to use sk->sk_rmem_alloc as well.

To test this patch, make sure to add a delay before accept(), so that
2MB worth of data can be queued before accept() happens.

Thanks.
