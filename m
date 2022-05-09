From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 2/5] cgroup: Account for memory_recursiveprot in
 test_memcg_low()
Date: Mon, 9 May 2022 11:09:15 -0400
Message-ID: <Ynkum8DeJIAtGi9y@cmpxchg.org>
References: <20220423155619.3669555-1-void@manifault.com>
 <20220423155619.3669555-3-void@manifault.com>
 <20220427140928.GD9823@blackbody.suse.cz>
 <20220429010333.5rt2jwpiumnbuapf@dev0025.ash9.facebook.com>
 <20220429092620.GA23621@blackbody.suse.cz>
 <20220506164015.fsdsuv226nhllos5@dev0025.ash9.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=4MK5Z5duMa87oHfTgQRev3JJqnSTwXWH5fVcV34L7dM=;
        b=l+MeEY8PFGfskD3FsCOlvSab9XgG1oPg/iynQwlXTFrp/alh8KkZYehnFpakdk+2y6
         jKiO9k7kOkYPU29eqCecdB6DUs7C1PNR2Ev/yXH8aw2fNbvvy9l/YtVVbQahxBmKHV76
         m/29e1REy8tS9WU0KLk8b+3BVI/mNjWrTP6+evBbdVEgKqv6XW/bg6XuZXwtDZOlT/Hf
         fQDDLvknV+r9yrtTnJrM1LaVNhutiu1tHOYhsUCqSsvBfrOsnuazqm6H4R9vbMlZoy6J
         3FHixuJyOBVhZ7sr+23dJSEwCWrY0/paq2Z0MtQCeTzBTz5qsjpX6Mro80MNDaSvgMJT
         nGGA==
Content-Disposition: inline
In-Reply-To: <20220506164015.fsdsuv226nhllos5-2sxDN0k4oOr/D8ZFBB3Vemm1Eemhq0z/AL8bYrjMMd8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Richard Palethorpe <rpalethorpe-IBi9RG/b67k@public.gmane.org>

On Fri, May 06, 2022 at 09:40:15AM -0700, David Vernet wrote:
> Sorry for the delayed reply, Michal. I've been at LSFMM this week.
>=20
> On Fri, Apr 29, 2022 at 11:26:20AM +0200, Michal Koutn=FD wrote:
> > I still think that the behavior when there's no protection left for the
> > memory.low =3D=3D 0 child, there should be no memory.low events (not ju=
st
> > uncounted but not happening) and test should not accept this (even
> > though it's the current behavior).
>
> That's fair. I think part of the problem here is that in general, the
> memcontroller itself is quite heuristic, so it's tough to write tests that
> provide useful coverage while also being sufficiently flexible to avoid
> flakiness and over-prescribing expected behavior. In this case I think it=
's
> probably correct that the memory.low =3D=3D 0 child shouldn't inherit
> protection from its parent under any circumstances due to its siblings
> overcommitting the parent's protection, but I also wonder if it's really
> necessary to enforce that. If you look at how much memory A/B/E gets at t=
he
> end of the reclaim, it's still far less than 1MB (though should it be 0?).
> I'd be curious to hear what Johannes thinks.

We need to distinguish between what the siblings declare and what they
consume.

My understanding of the issue you're raising, Michal, is that
protected siblings start with current > low, then get reclaimed
slightly too much and end up with current < low. This results in a
tiny bit of float that then gets assigned to the low=3D0 sibling; when
that sibling gets reclaimed regardless, it sees a low event. Correct
me if I missed a detail or nuance here.

But unused float going to siblings is intentional. This is documented
in point 3 in the comment above effective_protection(): if you use
less than you're legitimately claiming, the float goes to your
siblings. So the problem doesn't seem to be with low accounting and
event generation, but rather it's simply overreclaim.

It's conceivable to make reclaim more precise and then tighten up the
test. But right now, David's patch looks correct to me.
