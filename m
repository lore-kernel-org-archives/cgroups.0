From: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] net: memcg: late association of sock to memcg
Date: Wed, 4 Mar 2020 17:36:14 -0800
Message-ID: <CANn89i+TiiLKsE7k4TyRqr03uNPW=UpkvpXL1LVWvTmhE_AUpA@mail.gmail.com>
References: <20200304233856.257891-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=elDmLeR3tSgLpvdXEISH+Yu3WidaDgNW2ZcPOQFDsvs=;
        b=qpBkUIA0/1+0YcJbMBGaG8rOed8G3LMa8MzpE1iD4ZC8ek6Q4lrDBzOybqocgiC8ob
         pD6WeVVKh2BrPywSmiLG7dpp8JIQYNNi+jxLH18jArlOXzg5VGKDJMXdGwTHBHDQ8hIv
         Up/QUizz6DzXVj8LhxLpAan2Qu1FG6cek6scVfjIvAoiAqaKvmPxhv+XDvSORpOjfuBi
         ZoiH8XmqL5hXI6+JaSLfPGCiAcZv7R6R3aCCTJReb8W8iX+QYTFS7EO/pUg9UwaqHC1N
         2Q4c+pmU8wSNqQbt09St9MSEFR0ydlw40nbYRgMGnxJ51Bpjv/hshzy0f6psUhQeXXAF
         AFnA==
In-Reply-To: <20200304233856.257891-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Alexey Kuznetsov <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Mar 4, 2020 at 3:39 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> If a TCP socket is allocated in IRQ context or cloned from unassociated
> (i.e. not associated to a memcg) in IRQ context then it will remain
> unassociated for its whole life. Almost half of the TCPs created on the
> system are created in IRQ context, so, memory used by such sockets will
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
> Changes since v1:
> - added sk->sk_rmem_alloc to initial charging.
> - added synchronization to get memory usage and set sk_memcg race-free.
>
>  net/ipv4/inet_connection_sock.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index a4db79b1b643..7bcd657cd45e 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -482,6 +482,25 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
>                 }
>                 spin_unlock_bh(&queue->fastopenq.lock);
>         }
> +
> +       if (mem_cgroup_sockets_enabled && !newsk->sk_memcg) {
> +               int amt;
> +
> +               /* atomically get the memory usage and set sk->sk_memcg. */
> +               lock_sock(newsk);
> +
> +               /* The sk has not been accepted yet, no need to look at
> +                * sk->sk_wmem_queued.
> +                */
> +               amt = sk_mem_pages(newsk->sk_forward_alloc +
> +                                  atomic_read(&sk->sk_rmem_alloc));
> +               mem_cgroup_sk_alloc(newsk);
> +
> +               release_sock(newsk);
> +
> +               if (newsk->sk_memcg)

Most sockets in accept queue should have amt == 0, so maybe avoid
calling this thing only when amt == 0 ?

Also  I would release_sock(newsk) after this, otherwise incoming
packets could mess with newsk->sk_forward_alloc

if (amt && newsk->sk_memcg)
      mem_cgroup_charge_skmem(newsk->sk_memcg, amt);
release_sock(newsk);

Also, I wonder if     mem_cgroup_charge_skmem() has been used at all
these last four years
on arches with PAGE_SIZE != 4096

( SK_MEM_QUANTUM is not anymore PAGE_SIZE, but 4096)



> +                       mem_cgroup_charge_skmem(newsk->sk_memcg, amt);
> +       }
>  out:
>         release_sock(sk);
>         if (req)
> --
> 2.25.0.265.gbab2e86ba0-goog
>
