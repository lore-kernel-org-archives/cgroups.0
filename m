From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm: memcontrol: recursive memory.low protection
Date: Wed, 26 Feb 2020 10:05:48 -0500
Message-ID: <20200226150548.GD10257@cmpxchg.org>
References: <20191219200718.15696-1-hannes@cmpxchg.org>
 <20191219200718.15696-4-hannes@cmpxchg.org>
 <20200221171256.GB23476@blackbody.suse.cz>
 <20200221185839.GB70967@cmpxchg.org>
 <20200225133720.GA6709@blackbody.suse.cz>
 <20200225150304.GA10257@cmpxchg.org>
 <20200226132237.GA16746@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=xLGXbcfU4g3S4aLzErptFSe/rB4zsTw8GDyEXXa4IsQ=;
        b=l500m4Ia0VPmZO/B9pKznYu4o7SEwfOC1uaoGPv4NoceNO/0Wqgj4P9gxxqmfoxXXr
         2kWTq/5FqbgQz2jgyDyys21kd9PhcFQ0CMswAF+XsUuqHGQag3nmjwk5EFvMdah/eeNM
         Yu2fkEZ9R1WUX5qAnNaC4KmmhmOhlZZc3WzgzPqyvUnbpsNTvGA4/XSTAsc7vQwRhHoJ
         blXSIq28K7tHP1/3MlKvHb5V1eja+wNHFXtgjN4xCvqwvVqPd/3Osm3k9WmVyExLTcJU
         PbkJbzTsToxgU4U8jnz/CbiiMEPy8HFz7tuf698Nx3/WAsMfLQGPXmSA7naPYfYjI+NH
         fpeg==
Content-Disposition: inline
In-Reply-To: <20200226132237.GA16746-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

On Wed, Feb 26, 2020 at 02:22:37PM +0100, Michal Koutn=FD wrote:
> On Tue, Feb 25, 2020 at 10:03:04AM -0500, Johannes Weiner <hannes-druUgvl=
0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > Can you explain why you think protection is different from a weight?
> - weights are dimension-less, they represent no real resource

They still ultimately translate to real resources. The concrete value
depends on what the parent's weight translates to, and it depends on
sibling configurations and their current consumption. (All of this is
already true for memory protection as well, btw). But eventually, a
weight specification translates to actual time on a CPU, bandwidth on
an IO device etc.

> - sum of sibling weights is meaningless (and independent from parent
>   weight)

Technically true for overcommitted memory.low values as well.

> - to me this protection is closer to limits (actually I like your simile
>   that they're very lazily enforced limits)

But weights are also lazily enforced limits. Without competition, you
can get 100% regardless of your weight; under contention, you get
throttled/limited back to an assigned share, however that's specified.

Once you peel away the superficial layer of how resources, or shares
of resources, are being referred to (time, bytes, relative shares)
weights/guarantees/protections are all the same thing: they are lazily
enforced* partitioning rules of a resource under contention.

I don't see a fundamental difference between them. And that in turn
makes it hard for me to accept that hierarchical inheritance rules
should be different.

* We also refer to this as work-conserving

> > Now you apply memory pressure, what happens?. D isn't reclaimed, C is
> > somewhat reclaimed, E is reclaimed hard. D will not page, C will page
> > a little bit, E will page hard *with the higher IO priority of B*.
> >=20
> > Now C is stuck behind E. This is a priority inversion.
> This is how I understand the weights to work.
>=20
>     A			=09
>     `- B		io.weight=3D200
>        `- D		io.weight=3D100 (e.g.)
>        `- E		io.weight=3D100 (e.g.)
>     `- C		io.weight=3D50
>=20
> Whatever weights I assign to D and E, when only E and C compete, E will
> have higher weight (200 to 50, work-conservacy of weights).

Yes, exactly. I'm saying the same should be true for memory.

> I don't think this inversion is wrong because E's work is still on
> behalf of B.

"Wrong" isn't the right term. Is it what you wanted to express in your
configuration?

What's the point of designating E a memory donor group that needs to
relinquish memory to C under pressure, but when it actually gives up
that memory it beats C in competition over a different resource?

You are talking about a mathematical truth on a per-controller
basis. What I'm saying is that I don't see how this is useful for real
workloads, their relative priorities, and the performance expectations
users have from these priorities.

With a priority inversion like this, there is no actual performance
isolation or containerization going on here - which is the whole point
of cgroups and resource control.

> Or did you mean that if protections were transformed (via effective
> calculation) to have ratios only in the same range as io.weights
> (1e-4..1e4 instead of 0..inf), then it'd prevent the inversion? (By
> setting D,E weights in same ratios as D,E protections.)

No, the inversion would be prevented if E could consume all resources
assigned to B that aren't consumed by D.

This is true for IO and CPU, but before my patch not for memory.

> > 1. Can you please make a practical use case for having scape goats or
> >    donor groups to justify retaining what I consider to be an
> >    unimportant artifact in the memory.low semantics?
>     A.low=3D10G
>     `- B.low=3DX   u=3D6G
>     `- C.low=3DX   u=3D4G
>     `- D.low=3D0G  u=3D5G
>=20
> B,C   run the workload which should be protected
> D     runs job that doesn't need any protection=20
> u     denotes usage
> (I made the example with more than one important sibling to illustrate
> usefulness of some implicit distribution X.)
>=20
> When outer reclaim comes, reclaiming from B,C would be detrimental to
> their performance, while impact on D is unimportant. (And induced IO
> load on the rest (out of A) too.)

Okay, but this is a different usecase than we were talking about.

My objection is to opting out of protection against cousins (thus
overriding parental resource assignment), not against siblings.

Expressing priorities between siblings like this is fine. And I
absolutely see practical value in your specific example.

> It's not possible to move D to the A's level, since only A is all what a
> given user can control.

Correct, but you can change the tree to this:

     A.low=3D10G
     `- A1.low=3D10G
        `- B.low=3D0G
        `- C.low=3D0G
     `- D.low=3D0G

to express

A1 > D
 B =3D C

That priority order can be matched by CPU and IO controls as well:

     A.weight=3D100
     `- A1.weight=3D100
        `- B.weight=3D100
        `- C.weight=3D100
     `- D.weight=3D1

My objection is purely about opting out of resources relative to (and
assuming a lower memory priority than) an outside cousin that may have
a lower priority on other resources.

That is, I would like to see an argument for this setup:

     A			=09
     `- B		io.weight=3D200          memory.low=3D10G
        `- D		io.weight=3D100 (e.g.)   memory.low=3D10G
        `- E		io.weight=3D100 (e.g.)   memory.low=3D0
     `- C		io.weight=3D50           memory.low=3D5G

Where E has no memory protection against C, but E has IO priority over
C. That's the configuration that cannot be expressed with a recursive
memory.low, but since it involves priority inversions it's not useful
to actually isolate and containerize workloads.

That's why I'm saying it's an artifact, not an actual feature.

> > 2. If you think opting out of hierarchically assigned resources is a
> >    fundamentally important usecase, can you please either make an
> >    argument why it should also apply to CPU and IO, or alternatively
> >    explain in detail why they are meaningfully different?
> I'd say that protected memory is a disposable resource in contrast with
> CPU/IO. If you don't have latter, you don't progress; if you lack the
> former, you are refaulting but can make progress. Even more, you should
> be able to give up memory.min.

Eh, I'm not buying that. You cannot run without memory either. If
somebody reclaims a page between you faulting it in and you resuming
to userspace, there is no forward progress.
