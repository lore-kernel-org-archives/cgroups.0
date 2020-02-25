From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 2/3] mm: memcontrol: clean up and document effective
 low/min calculations
Date: Tue, 25 Feb 2020 13:40:14 -0500
Message-ID: <20200225184014.GC10257@cmpxchg.org>
References: <20191219200718.15696-1-hannes@cmpxchg.org>
 <20191219200718.15696-3-hannes@cmpxchg.org>
 <20200221171024.GA23476@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=i2CV/HrBlB038Ie8Qimmh82koD0NdKzml2lxz77LIw8=;
        b=ERjzs/tXZewLwer9YDYr/IYsZ/pnkPxN3//YU6bP7CHHDRMWHkIbtg/nZJaTXwNmK7
         4Qs4eXYUyB3Ezg+amypKAA20yzqDlEMeDIBpWdXMJnLR0PY7mXMKbXfnv97c2RPJisPX
         mm5VxvL+kqkeqFK9E7EdHKna0JtlAdztQzV/q7yA8TjapZ/6iFqjVEf2XjpalFBXfJY5
         qX3jcf2q9XJ5LFRVJQgHZWN8TzNR4va/XA3U7FJ79+PGCItxdnPc4CUAhu+up/bX+Tfn
         Vfdfg2Pcea2m37AoNJ0Xto0D2JDL0rkW2eLIM8KMNVqsT+PYB2rqxqoqatC4WbAuFM49
         3yDg==
Content-Disposition: inline
In-Reply-To: <20200221171024.GA23476-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello Michal,

On Fri, Feb 21, 2020 at 06:10:24PM +0100, Michal Koutn=FD wrote:
> On Thu, Dec 19, 2019 at 03:07:17PM -0500, Johannes Weiner <hannes-druUgvl=
0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > + *    Consider the following example tree:
> >   *
> > + *        A      A/memory.low =3D 2G, A/memory.current =3D 6G
> > + *       //\\
> > + *      BC  DE   B/memory.low =3D 3G  B/memory.current =3D 2G
> > + *               C/memory.low =3D 1G  C/memory.current =3D 2G
> > + *               D/memory.low =3D 0   D/memory.current =3D 2G
> > + *               E/memory.low =3D 10G E/memory.current =3D 0
> >   *
> > + *    and memory pressure is applied, the following memory
> > + *    distribution is expected (approximately*):
> >   *
> > + *      A/memory.current =3D 2G
> > + *      B/memory.current =3D 1.3G
> > + *      C/memory.current =3D 0.6G
> > + *      D/memory.current =3D 0
> > + *      E/memory.current =3D 0
> >   *
> > + *    *assuming equal allocation rate and reclaimability
> I think the assumptions for this example don't hold (anymore).
> Because reclaim rate depends on the usage above protection, the siblings
> won't be reclaimed equally and so the low_usage proportionality will
> change over time and the equilibrium distribution is IMO different (I'm
> attaching an Octave script to calculate it).

Hm, this example doesn't change with my patch because there is no
"floating" protection that gets distributed among the siblings.

In my testing with the above parameters, the equilibrium still comes
out to roughly this distribution.

> As it depends on the initial usage, I don't think there can be given
> such a general example (for overcommit).

It's just to illustrate the pressure weight, not to reflect each
factor that can influence the equilibrium.

I think it still has value to gain understanding of how it works, no?

> > @@ -6272,12 +6262,63 @@ struct cgroup_subsys memory_cgrp_subsys =3D {
> >   * for next usage. This part is intentionally racy, but it's ok,
> >   * as memory.low is a best-effort mechanism.
> Although it's a different issue but since this updates the docs I'm
> mentioning it -- we treat memory.min the same, i.e. it's subject to the
> same race, however, it's not meant to be best effort. I didn't look into
> outcomes of potential misaccounting but the comment seems to miss impact
> on memory.min protection.

Yeah I think we can delete that bit.

> > @@ -6292,52 +6333,29 @@ enum mem_cgroup_protection mem_cgroup_protected=
(struct mem_cgroup *root,
> > [...]
> > +	if (parent =3D=3D root) {
> > +		memcg->memory.emin =3D memcg->memory.min;
> > +		memcg->memory.elow =3D memcg->memory.low;
> > +		goto out;
> >  	}
> Shouldn't this condition be 'if (parent =3D=3D root_mem_cgroup)'? (I.e. 1=
st
> level takes direct input, but 2nd and further levels redistribute only
> what they really got from parent.)

I believe we cleared this up in the parallel thread, but just in case:
reclaim can happen due to a memory.max set lower in the
tree. memory.low propagation is always relative from the reclaim
scope, not the system-wide root cgroup.
