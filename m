From: "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Date: Tue, 9 May 2023 18:04:47 +0000
Message-ID: <DM6PR11MB41078CDC3B97ED88AF71DEBFDC769@DM6PR11MB4107.namprd11.prod.outlook.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
 <20230508020801.10702-2-cathy.zhang@intel.com>
 <20230509171910.yka3hucbwfnnq5fq@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683655491; x=1715191491;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TR5WHHRCzGdsPh8bo8hMlJBkOQ0jfHateJxOqUeVeTM=;
  b=EhBeXjKiXQTQyRuWUbYzBrHyvK1KWUrVdrGY9CecIuRyS0wmAzQFPn44
   dxVHvLOq/aWReP5mMiu6D6qXZPhBNSxNIb3LrwbMEx74c30U+mwGnyYrl
   Wl4Q1s3nnYVxUAxBbT/aNpKE6e/21FXIhGucQipqRIkK/dvCH1ciPoATM
   5/J96Qx8PBVhocnVmtaS72BdFCYjLooTHbotzb7u+a7VOVs/mKPbDszri
   /eM0ZOc1Wr8sSgMd4TY9E0+b4b0jSW03R9nGUffZdrDuk46vXNLpw0lDf
   nqVAoiP5SLh/gjJX30D6mm04SmVdGnYvsWxTAurCJ0yJipRQxSE6+uf9X
   w==;
In-Reply-To: <20230509171910.yka3hucbwfnnq5fq-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Zhang, Cathy" <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Brandeburg, Jesse" <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Srinivas, Suresh" <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "You, Lizhen" <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

>>=20
>> Run memcached with memtier_benchamrk to verify the optimization fix. 8=20
>> server-client pairs are created with bridge network on localhost,=20
>> server and client of the same pair share 28 logical CPUs.
>>=20
> >Results (Average for 5 run)
> >RPS (with/without patch)	+2.07x
> >

>Do you have regression data from any production workload? Please keep in m=
ind that many times we (MM subsystem) accepts the regressions of microbench=
marks over complicated optimizations. So, if there is a real production reg=
ression, please be very explicit about it.

Though memcached is actually used by people in production. So this isn't an=
 unrealistic scenario.

Tim
