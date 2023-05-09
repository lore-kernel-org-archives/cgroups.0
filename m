From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
Date: Tue, 9 May 2023 11:17:42 -0700
Message-ID: <CALvZod7njXsc0JDHxxi_+0c=owNwC6m1g_FieRfY4XkfuTmo1A@mail.gmail.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com> <20230508020801.10702-2-cathy.zhang@intel.com>
 <20230509171910.yka3hucbwfnnq5fq@google.com> <DM6PR11MB41078CDC3B97ED88AF71DEBFDC769@DM6PR11MB4107.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683656273; x=1686248273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S2UHCATH3G4CuSJf4Vt2XimiowlnQCvyva4J0Y6pMkg=;
        b=Mli6sJjznQpwgkxl03KMv9Ha9Q0uVZi6usPfIE7bV5rhYWG3rMpH/tXFlJYEQAtrPe
         C8cQFSATIeyaRKBBearzQRWEPXqK4RTh2/pbm/3KotJawrCfoQAMmqG6KHFGv0+LInVD
         xe2zW+twGzSmkzZHHYOFM1isS8rlNC90pLpUbUTUQeMewuWnwYvdzuDokXbe4dHMx/Ft
         QRR4TS0bsiIz2PJzZtMS0BqZJuILhC++3fY+TwB5CHWXhg6KMfPMzKGe55CFAOY+VZT9
         L1AHCrAVtuGUJ+NyEGBiFau844G7zH2uAbHNSHYGDfSFROX3VTT1dBqC6uhn3hbpyNxi
         ZDbw==
In-Reply-To: <DM6PR11MB41078CDC3B97ED88AF71DEBFDC769-10zMTfzfexdb1STU19CZ9pPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Zhang, Cathy" <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Brandeburg, Jesse" <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Srinivas, Suresh" <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "You, Lizhen" <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, May 9, 2023 at 11:04=E2=80=AFAM Chen, Tim C <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> =
wrote:
>
> >>
> >> Run memcached with memtier_benchamrk to verify the optimization fix. 8
> >> server-client pairs are created with bridge network on localhost,
> >> server and client of the same pair share 28 logical CPUs.
> >>
> > >Results (Average for 5 run)
> > >RPS (with/without patch)     +2.07x
> > >
>
> >Do you have regression data from any production workload? Please keep in=
 mind that many times we (MM subsystem) accepts the regressions of microben=
chmarks over complicated optimizations. So, if there is a real production r=
egression, please be very explicit about it.
>
> Though memcached is actually used by people in production. So this isn't =
an unrealistic scenario.
>

Yes, memcached is used in production but I am not sure anyone runs 8
pairs of server and client on the same machine for production
workload. Anyways, we can discuss, if needed, about the practicality
of the benchmark after we have some impactful memcg optimizations.

> Tim
