From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
Date: Tue, 9 May 2023 10:58:01 -0700
Message-ID: <CALvZod6JK1Ts90uGYSDRWXX3-D=gyN3q+Bpy-oW+dqJsjjBm2w@mail.gmail.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com> <20230508020801.10702-2-cathy.zhang@intel.com>
 <3887b08ac0e55e27a24d2f66afcfff1961ed9b13.camel@redhat.com>
 <CH3PR11MB73459006FCE3887E1EA3B82FFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CH3PR11MB73456D792EC6E7614E2EF14DFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iL6Ckuu9vOEvc7A9CBLGuh-EpbwFRxRAchV-6VFyhTUpg@mail.gmail.com> <CH3PR11MB73458BB403D537CFA96FD8DDFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683655093; x=1686247093;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vhZkJ8mwG4mA4GCg1/8ebcBN7nEL6s99qLu8EGL+6aM=;
        b=KgfWhPK3zHiclIOgn2Kt/8GHAUxSexMKKgnsWOlc7aVOEV4EKytoa+H0EqUWWLumnT
         1dRSubDaBeFdDFq5mk6LysSPbERN+lyQPD6IuvnSJnePeVD1mQLJ88Za+dm8IVENdkjb
         WQRDUXrSe8O8ohUX6luTRGj+g5E9a9OHHVag8TjgszPmoF94rDtT+dNxqBrAns28z89w
         V5qmy+0WHT/mBZruiHDgKsBO1vYTxuKtWFMvj3ulbgcdd/+mfQsRI7sweMdZHiLG7Cab
         FDLGqCHgc/hpMLWaXSeZ00gzyUNtkn9ZNZnNo5zXiUsxk7Epss7emB+77WZKRnXVFIUf
         UZ8A==
In-Reply-To: <CH3PR11MB73458BB403D537CFA96FD8DDFC769-WQKEFoXy4NEXvLLfv6NhPJPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "Zhang, Cathy" <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Brandeburg, Jesse" <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Srinivas, Suresh" <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "You, Lizhen" <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, May 9, 2023 at 8:07=E2=80=AFAM Zhang, Cathy <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>=
 wrote:
>
[...]
> >
> > Something must be wrong in your setup, because the only small issue tha=
t
> > was noticed was the memcg one that Shakeel solved last year.
>
> As mentioned in commit log, the test is to create 8 memcached-memtier pai=
rs
> on the same host, when server and client of the same pair connect to the =
same
> CPU socket and share the same CPU set (28 CPUs), the memcg overhead is
> obviously high as shown in commit log. If they are set with different CPU=
 set from
> separate CPU socket, the overhead is not so high but still observed.  Her=
e is the
> server/client command in our test:
> server:
> memcached -p ${port_i} -t ${threads_i} -c 10240
> client:
> memtier_benchmark --server=3D${memcached_id} --port=3D${port_i} \
> --protocol=3Dmemcache_text --test-time=3D20 --threads=3D${threads_i} \
> -c 1 --pipeline=3D16 --ratio=3D1:100 --run-count=3D5
>
> So, is there anything wrong you see?
>

What is the memcg hierarchy of this workload? Is each server and
client processes running in their own memcg? How many levels of
memcgs? Are you setting memory.max and memory.high to some value? Also
how are you limiting the processes to CPUs? cpusets?
