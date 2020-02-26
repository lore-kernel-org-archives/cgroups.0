From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 2/3] mm: memcontrol: clean up and document effective
 low/min calculations
Date: Wed, 26 Feb 2020 14:40:25 -0500
Message-ID: <20200226194025.GA30206@cmpxchg.org>
References: <20191219200718.15696-1-hannes@cmpxchg.org>
 <20191219200718.15696-3-hannes@cmpxchg.org>
 <20200221171024.GA23476@blackbody.suse.cz>
 <20200225184014.GC10257@cmpxchg.org>
 <20200226164632.GL27066@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=82BmcmIVU/khlxiiYLp8kss4jd0AD0u0A2zzeUS4+kw=;
        b=WEj7yOV9SDW39LsGpGcXtu4EXCsXQZqx+4Ofd8PWITH80J16ytU6qapFwuTqcwcLNb
         vCXFym+WS7inLUTrgz7QI0EaJuLjT7HQRP/QAblVFLjMClW5mLBLmnxaZ4m0pQ80OcOk
         vXFZ3mHk9v47818QjdvLM4zepljBKzCNfMrzZMI3CUlVfYAm3HRd6XY6n+2NaDTGI26g
         +k01NPC4NLEbl7ruddjxdoJgnGvsgArEemcZ6TUGlSGiYw/dpd6q5FRUqa/mo/NvZ/C6
         Uo/XN+iJPNnoCUwrPzn1xeDTsGfyWm2O2BGwNWyYaBVmjZp96ZEN4nEUFu2hg85iCWVS
         kSbA==
Content-Disposition: inline
In-Reply-To: <20200226164632.GL27066-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Feb 26, 2020 at 05:46:32PM +0100, Michal Koutn=FD wrote:
> On Tue, Feb 25, 2020 at 01:40:14PM -0500, Johannes Weiner <hannes-druUgvl=
0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > Hm, this example doesn't change with my patch because there is no
> > "floating" protection that gets distributed among the siblings.
> Maybe it had changed even earlier and the example obsoleted.
>=20
> > In my testing with the above parameters, the equilibrium still comes
> > out to roughly this distribution.
> I'm attaching my test (10-times smaller) and I'm getting these results:
>=20
> > /sys/fs/cgroup/test.slice/memory.current:838750208
> > /sys/fs/cgroup/test.slice/pressure.service/memory.current:616972288
> > /sys/fs/cgroup/test.slice/test-A.slice/memory.current:221782016
> > /sys/fs/cgroup/test.slice/test-A.slice/B.service/memory.current:1234288=
64
> > /sys/fs/cgroup/test.slice/test-A.slice/C.service/memory.current:93495296
> > /sys/fs/cgroup/test.slice/test-A.slice/D.service/memory.current:4702208
> > /sys/fs/cgroup/test.slice/test-A.slice/E.service/memory.current:155648
>=20
> (I'm running that on 5.6.0-rc2 + first two patches of your series.)
>=20
> That's IMO closer to the my simulation (1.16:0.84)
> than the example prediction (1.3:0.6)

I think you're correct about the moving points of equilibrium. I'm
going to experiment more with your script. I had written it off as
noise from LRU rotations, reclaim concurrency etc. but your script
shows that these points do shift around as the input parameters
change. This is useful, thanks.

But AFAICS, my patches here do not change or introduce this behavior
so it's a longer-standing issue.

> > It's just to illustrate the pressure weight, not to reflect each
> > factor that can influence the equilibrium.
> But it's good to have some idea about the equilibrium when configuring
> the values.=20

Agreed.

> > > > @@ -6272,12 +6262,63 @@ struct cgroup_subsys memory_cgrp_subsys =3D=
 {
> > > >   * for next usage. This part is intentionally racy, but it's ok,
> > > >   * as memory.low is a best-effort mechanism.
> > > Although it's a different issue but since this updates the docs I'm
> > > mentioning it -- we treat memory.min the same, i.e. it's subject to t=
he
> > > same race, however, it's not meant to be best effort. I didn't look i=
nto
> > > outcomes of potential misaccounting but the comment seems to miss imp=
act
> > > on memory.min protection.
> >=20
> > Yeah I think we can delete that bit.
> Erm, which part?
> Make the racy behavior undocumented or that it applies both memory.low
> and memory.min?

I'm honestly not sure what it's trying to say. Reclaim and charging
can happen concurrently, so the protection enforcement, whether it's
min or low, has always been racy. Even OOM itself is racy.

Caching the parental value while iterating over a group of siblings
shouldn't fundamentally alter that outcome. We do enough priority
iterations and reclaim loops from the allocator that we shouldn't see
premature OOMs or apply totally incorrect balances because of that.

So IMO the statement that "this is racy, but low is best-effort
anyway, so it's okay" is misleading. I think more accurate would be to
say that reclaim is fundamentally racy, so a bit of additional noise
here doesn't matter.

Either way, I don't find this paragraph all that useful. If you think
it's informative, could you please let me know which important aspect
it communicates? Otherwise, I'm inclined to delete it.
