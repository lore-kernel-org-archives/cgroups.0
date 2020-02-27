From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm: memcontrol: recursive memory.low protection
Date: Thu, 27 Feb 2020 10:06:19 -0500
Message-ID: <20200227150619.GD39625@cmpxchg.org>
References: <20191219200718.15696-1-hannes@cmpxchg.org>
 <20191219200718.15696-4-hannes@cmpxchg.org>
 <20200221171256.GB23476@blackbody.suse.cz>
 <20200221185839.GB70967@cmpxchg.org>
 <20200225133720.GA6709@blackbody.suse.cz>
 <20200225150304.GA10257@cmpxchg.org>
 <20200226132237.GA16746@blackbody.suse.cz>
 <20200226150548.GD10257@cmpxchg.org>
 <20200227133544.GA20690@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=WksUni8+9tZQpyBBuW8X+gQa0Tzb8KbHzuJ7Pnkh/HQ=;
        b=ft/OwHMQDXoySzRqQhM3Euo4A8IQtSI4XRc6MrV9HF/5UZVkMmhLm3EdhFy/hV2Hpc
         klL0cyKlgdB6phi95cveN+byBtSBglXzhMEGp1eiB7TRhsTx8n1KXNLSRPpMyjbfHIBy
         Tmqw9y6EzckW1TmrvhJrxR/pKLrHTLwF/1YoEdAfxhHQh75FxQKtVeOvMX+8l9EvL0Ds
         htDpu+IKmiWP9dlRUBMPtkxDF79ciUtFrcIMoN+RVVsmz4xShEm5FaKzgfw2ihNc9iOB
         n3trkJsrqwxJqjgh3aokOJ1N5DxKbNiAHOH0kP2mwLqIW7Ge410QDJDU/mCSdvt4SaXa
         qJXA==
Content-Disposition: inline
In-Reply-To: <20200227133544.GA20690-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Feb 27, 2020 at 02:35:44PM +0100, Michal Koutn=FD wrote:
> On Wed, Feb 26, 2020 at 10:05:48AM -0500, Johannes Weiner <hannes-druUgvl=
0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > I don't see a fundamental difference between them. And that in turn
> > makes it hard for me to accept that hierarchical inheritance rules
> > should be different.
> I'll try coming up with some better examples for the difference that I
> perceive.
>=20
> > "Wrong" isn't the right term. Is it what you wanted to express in your
> > configuration?
> I want to express absolute amount of memory (ideally representing
> workingset size) under protection.
>=20
> IIUC, you want to express general relative priorities of B vs C when
> some outer metric has to be maintained given you reach both limits of
> memory and IO.

It's been our experience that it's basically impossible to control for
memory without having it result in IO contention.

You acknowledge below that this effect may be noticable in some
situations. It's been our experience, however, that this effect is so
pronounced over a wide variety of workloads and host configurations
that exclusive memory control is not a practical application for
anything but niche cases - if they exist at all.

> > You are talking about a mathematical truth on a per-controller
> > basis. What I'm saying is that I don't see how this is useful for real
> > workloads, their relative priorities, and the performance expectations
> > users have from these priorities.
> =20
> > With a priority inversion like this, there is no actual performance
> > isolation or containerization going on here - which is the whole point
> > of cgroups and resource control.
> I acknowledge that by pressing too much along one dimension (memory) you
> induce expansion in other dimension (IO) and that may become noticable in
> siblings (expansion over saturation [1]). But that's expected when only
> weights are in use. If you wanted to hide the effect of workload B to C,
> B would need real limit.
>
> [I beg to disagree that containerization is whole point of cgroups, it's
> large part of it, hence the isolation needn't be necessarily
> bi-directional.]

I said "isolation or containerization", and it really isn't a stretch
to see how the the intended isolation can break down in this example.

You could set an IO limit on the scape goat to keep it from inheriting
the higher IO priority from its parent.

But you could also just set a memory limit on the scape goat to keep
it from inheriting the higher memory allowance from the parent.

Between all this, I really don't see an argument here to make the
memory hierarchy semantics different from the other controllers.

> > My objection is to opting out of protection against cousins (thus
> > overriding parental resource assignment), not against siblings.
> Just to sync up the terminology - I'm calling this protection against
> uncles (the composition/structure under them is irrelevant).
> And the limitation comes from grandparent or higher (or global).

Yes, either way works.

> ...and the overriden parental resource assignment is the expansion on
> non-memory dimension (IO/CPU).
>=20
> > Correct, but you can change the tree to this:
> >=20
> >      A.low=3D10G
> >      `- A1.low=3D10G
> >         `- B.low=3D0G
> >         `- C.low=3D0G
> >      `- D.low=3D0G
> >=20
> > to express
> >=20
> > A1 > D
> >  B =3D C
> That sort of works (if I give up the scapegoat). Although I have trouble
> that I have to copy the value from A to A1, I could have done that with
> previous hierarchy and simply set B.low=3DC.low=3D10G.

D is still the scape goat for B and C..?

> > That is, I would like to see an argument for this setup:
> >=20
> >      A			=09
> >      `- B		io.weight=3D200          memory.low=3D10G
> >         `- D		io.weight=3D100 (e.g.)   memory.low=3D10G
> >         `- E		io.weight=3D100 (e.g.)   memory.low=3D0
> >      `- C		io.weight=3D50           memory.low=3D5G
> >=20
> > Where E has no memory protection against C, but E has IO priority over
> > C. That's the configuration that cannot be expressed with a recursive
> > memory.low, but since it involves priority inversions it's not useful
> > to actually isolate and containerize workloads.
> But there can be no cousin (uncle) or more precisely it's the global
> rest that we don't mind to affect.

Okay, hold on.

You wouldn't care about starving the rest of the system of IO and
CPU. But the objection to my patch is that you want to give memory
back to avoid undue burden on the rest of the system?

Can we please stop talking about such contrived hypotheticals and
discuss real computer systems that real people actually care about?

> > > I'd say that protected memory is a disposable resource in contrast wi=
th
> > > CPU/IO. If you don't have latter, you don't progress; if you lack the
> > > former, you are refaulting but can make progress. Even more, you shou=
ld
> > > be able to give up memory.min.
> >=20
> > Eh, I'm not buying that. You cannot run without memory either. If
> > somebody reclaims a page between you faulting it in and you resuming
> > to userspace, there is no forward progress.
> I made a hasty argument (misinterpretting the constant outer reclaim
> pressure). So that wasn't the fundamental difference.
>=20
> The second part -- memory.min is subject to equal calculation as
> memory.low. Do you find the scape goat preventing OOM in grand-parent
> (or higher) subtree also a misfeature/artifact?

What about CPU and IO?

If you knew exactly that the scape goat doesn't need the memory, you
could set a memory limit on it - just like you could set a limit on
CPU and IO cycles to "give back" resources from inside a tree.

If you don't know exactly how much of the scape goat's memory is and
isn't needed, the additional paging risk from getting it wrong would
be to the detriment of both your workload and the rest of the system -
your attempt to be good to the rest of the system suddenly turns into
a negative-sum game.

I fundamentally do not understand the practical application of the
configuration you are arguing tooth and nail needs to be supported.

If this is a dealbreaker, surely in a month of discussion and 30+
emails, it should have been possible to come up with *one* example of
a real workload and host configuration for which the ability to
dissent from the hierarchical memory allocation (but oddly, not other
resources) is the *only* way to express working resource isolation.

As it stands, I have provided examples of real workloads and host
configs that can't be expressed with the current semantics. As such, I
would like to move ahead with my changes. They are gated behind a
mount option, so pose no risk to the elusive setups you envision. We
can always implement the inheritance scheme you propose once we have
concrete examples of real life scenarios that aren't otherwise doable,
but there is certainly not enough evidence to make me implement it now
as a condition for merging my patches.
