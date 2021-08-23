From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix occasional OOMs due to proportional
 memory.low reclaim
Date: Mon, 23 Aug 2021 13:48:43 -0400
Message-ID: <YSPfe4yf2fRdzijh@cmpxchg.org>
References: <20210817180506.220056-1-hannes@cmpxchg.org>
 <YSPIOZOVG2qplLIW@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=gbkRpn8OvHDvVhkug5/SCecw4iR6zEDgQeKV01fnIoo=;
        b=upkSxN2nnvY2Wv/MwUo3Qk+bN9RsxVHHPTcUHGhtMHImyRfryeKTsloFifEFrqdlt0
         UxVtQai+tAQNcsIJ818me8Yhi3/bMHiaU7UglvqElSdxuOBTPg8BCOnN3T1AJfORwqcH
         NYTKsEACcfB06lkK8E4ps1ukwzCLeG8yfT85LndESHBE7pMmxUCgd78URSV2DpFKMKNs
         5j1L94LSJYWhTz1Yyq8X6ZJU0F/PJxu6jlgN3V1E7rR727XeyxqXOvVGAY1aVcOmGrAW
         7SpfwdKSRYCa67kYAD3SULGslNCC8EhJZcPuSsdvmwK1YPuq5Us1QyWndADVs8b5Lf83
         KDZQ==
Content-Disposition: inline
In-Reply-To: <YSPIOZOVG2qplLIW@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Leon Yang <lnyng-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hi Michal,

On Mon, Aug 23, 2021 at 06:09:29PM +0200, Michal Koutn=FD wrote:
> Hello
>=20
> (and sorry for a belated reply).

It's never too late, thanks for taking a look.

> On Tue, Aug 17, 2021 at 02:05:06PM -0400, Johannes Weiner <hannes-druUgvl=
0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > @@ -2576,6 +2578,15 @@ static void get_scan_count(struct lruvec *lruvec=
, struct scan_control *sc,
> > [...]
> > +			/* memory.low scaling, make sure we retry before OOM */
> > +			if (!sc->memcg_low_reclaim && low > min) {
> > +				protection =3D low;
> > +				sc->memcg_low_skipped =3D 1;
>=20
> IIUC, this won't result in memory.events:low increment although the
> effect is similar (breaching (partial) memory.low protection) and signal
> to the user is comparable (overcommited memory.low).

Good observation. I think you're right, we should probably count such
partial breaches as LOW events as well.

Note that this isn't new behavior. My patch merely moved this part
from mem_cgroup_protection():

-       if (in_low_reclaim)
-               return READ_ONCE(memcg->memory.emin);

Even before, if we retried due to just one (possibly insignificant)
cgroup below low, we'd ignore proportional reclaim and partially
breach ALL protected cgroups, while only counting a low event for the
one group that is usage < low.

> Admittedly, this patch's behavior adheres to the current documentation
> (Documentation/admin-guide/cgroup-v2.rst):
>=20
> > The number of times the cgroup is reclaimed due to high memory
> > pressure even though its usage is under the low boundary,
>=20
> however, that definition might not be what the useful indicator would
> be now.
> Is it worth including these partial breaches into memory.events:low?

I think it is. How about:

"The number of times the cgroup's memory.low-protected memory was
reclaimed in order to avoid OOM during high memory pressure."

And adding a MEMCG_LOW event to partial breaches. BTW, the comment
block above this code is also out-of-date, because it says we're
honoring memory.low on the retries, but that's not the case.

I'll prepare a follow-up patch for these 3 things as well as the more
verbose comment that Michal Hocko asked for on the retry logic.
