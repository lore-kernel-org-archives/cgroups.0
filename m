From: Willem de Bruijn <willemdebruijn.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH net-next v5 2/3] sock: Always take memcg pressure into consideration
Date: Sun, 4 Jun 2023 12:36:25 +0200
Message-ID: <CAF=yD-LFQRreWq1RMkvLw9Nj3NQpJwbDSCfECUhh-aVchR-jsg@mail.gmail.com>
References: <20230602081135.75424-1-wuyun.abel@bytedance.com>
 <20230602081135.75424-3-wuyun.abel@bytedance.com> <20230602204159.vo7fmuvh3y2pdfi5@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685875025; x=1688467025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J+cW+W+2ToTmL5Y4D5MrCTf7iqNWcTE2j9X0ITTZBzs=;
        b=JExgNb84ODfc1n2XYy4S5jPF5F4lLgn7e28BYdaq3YfVbJndWp2rO96Rdh2dExcsHU
         o6OARLsIs0cAT76nDYzVxjtwNmLABQakff6/4TpMI/yozfxXxqm6sFLyqf/w5LZIXBbJ
         zC+DbBMB32zQiqJxDneHHS2/E0CYotb8OIUKI+V5VTIv2lWE148GMOVcB3Sz6inUchTf
         5S7GFwgSCoO5P0QRbPejsO+0c74YvVvfAxGr0+h5lK3heEBzYzXCSo+dzGKndszXGaVs
         IA/ycRfW5pKCmGcjO/I0uEXZ0x0f1bvZpRvY9SSAGseCrXor94SjXYofHsJViBEkHaHA
         FT0A==
In-Reply-To: <20230602204159.vo7fmuvh3y2pdfi5-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Simon Horman <simon.horman-JqlR5BE4aJhWk0Htik3J/w@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jun 2, 2023 at 10:42=E2=80=AFPM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> =
wrote:
>
> On Fri, Jun 02, 2023 at 04:11:34PM +0800, Abel Wu wrote:
> > The sk_under_memory_pressure() is called to check whether there is
> > memory pressure related to this socket. But now it ignores the net-
> > memcg's pressure if the proto of the socket doesn't care about the
> > global pressure, which may put burden on its memcg compaction or
> > reclaim path (also remember that socket memory is un-reclaimable).
> >
> > So always check the memcg's vm status to alleviate memstalls when
> > it's in pressure.
> >
>
> This is interesting. UDP is the only protocol which supports memory
> accounting (i.e. udp_memory_allocated) but it does not define
> memory_pressure. In addition, it does have sysctl_udp_mem. So
> effectively UDP supports a hard limit and ignores memcg pressure at the
> moment. This patch will change its behavior to consider memcg pressure
> as well. I don't have any objection but let's get opinion of UDP
> maintainer.

Others have more experience with memory pressure on UDP, for the
record. Paolo worked on UDP memory pressure in
https://lore.kernel.org/netdev/cover.1579281705.git.pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/

It does seem odd to me to modify sk_under_memory_pressure only. See
for instance its use in __sk_mem_raise_allocated:

        if (sk_has_memory_pressure(sk)) {
                u64 alloc;

                if (!sk_under_memory_pressure(sk))
                        return 1;

This is not even reached as sk_has_memory_pressure is false for UDP.
So this commit only affects the only other protocol-independent
caller, __sk_mem_reduce_allocated, to possibly call
sk_leave_memory_pressure if now under the global limit.

What is the expected behavioral change in practice of this commit?


> > Signed-off-by: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> > ---
> >  include/net/sock.h | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index 3f63253ee092..ad1895ffbc4a 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -1411,13 +1411,11 @@ static inline bool sk_has_memory_pressure(const=
 struct sock *sk)
> >
> >  static inline bool sk_under_memory_pressure(const struct sock *sk)
> >  {
> > -     if (!sk->sk_prot->memory_pressure)
> > -             return false;
> > -
> >       if (mem_cgroup_under_socket_pressure(sk->sk_memcg))
> >               return true;
> >
> > -     return !!*sk->sk_prot->memory_pressure;
> > +     return sk->sk_prot->memory_pressure &&
> > +             *sk->sk_prot->memory_pressure;
> >  }
> >
> >  static inline long
> > --
> > 2.37.3
> >
