From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v2 2/5] cgroup: Account for memory_recursiveprot in
 test_memcg_low()
Date: Thu, 28 Apr 2022 18:03:33 -0700
Message-ID: <20220429010333.5rt2jwpiumnbuapf@dev0025.ash9.facebook.com>
References: <20220423155619.3669555-1-void@manifault.com>
 <20220423155619.3669555-3-void@manifault.com>
 <20220427140928.GD9823@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220427140928.GD9823-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Richard Palethorpe <rpalethorpe-IBi9RG/b67k@public.gmane.org>

Hi Michal,

On Wed, Apr 27, 2022 at 04:09:28PM +0200, Michal Koutn=FD wrote:
> Hello David.
>=20
> On Sat, Apr 23, 2022 at 08:56:19AM -0700, David Vernet <void-gq6j2QGBifHb=
y3iVrkZq2A@public.gmane.org> wrote:
> > This unfortunately broke the memcg tests, which asserts that a sibling
> > that experienced reclaim but had a memory.low value of 0, would not
> > observe any memory.low events. This patch updates test_memcg_low() to
> > account for the new behavior introduced by memory_recursiveprot.
>=20
> I think the test is correct, there should be no (not even recursive)
> protection in this particular case (when the remaining siblings consume
> all of parental protection).
>=20
> This should be fixed in the kernel (see also [1], no updates from me yet
> :-/)
>=20
> Michal
>=20
> [1] https://lore.kernel.org/lkml/20220322182248.29121-1-mkoutny-IBi9RG/b6=
7k@public.gmane.org/
>=20

I see, thanks for sharing that context. I think I see your point about the
implementation of the reclaim mechanism potentially overcounting, but my
interpretation of the rest of that discussion with Roman is that we haven't
yet decided whether we don't want to propagate memory.low events from
children cgroups with memory.low =3D=3D 0. Or at the very least, some more
justification was requested on why not counting such events was prudent.

Would you be ok with merging this patch so that the cgroup selftests can
pass again based on the current behavior of the kernel, and we can then
revert the changes to test_memcg_low() later on if and when we decide that
we don't want to propagate memory.low events for memory.low =3D=3D 0 childr=
en?

Thanks,
David
