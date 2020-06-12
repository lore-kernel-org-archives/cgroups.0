From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH 3/6] mm, memcg: Prevent memory.low load/store tearing
Date: Fri, 12 Jun 2020 18:13:35 +0100
Message-ID: <20200612171335.GA341094@chrisdown.name>
References: <cover.1584034301.git.chris@chrisdown.name>
 <448206f44b0fa7be9dad2ca2601d2bcb2c0b7844.1584034301.git.chris@chrisdown.name>
 <20200612170352.GA40768@blackbook>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6/WKj2RP2D9n4+fw5DYObbawXZCZEXk2atts5/6vXZA=;
        b=TI6S+MwlPkt8KC/tPABYYKsT1TobgOSEYvn7gfp61hj7IWbDiaISOUSExWX249s6fi
         EIYHO6hkn1K1f6HNJlpcgTM7TC6HcJ9Bz/i/U+52KQ4SDr9GmgcRXdjV7av4HWETWXxM
         fxu5PbxWzUePUak1TSIszwbrfNsSF2Mef0XA8=
Content-Disposition: inline
In-Reply-To: <20200612170352.GA40768@blackbook>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

Good catch! Andrew and I must have missed these when massaging the commits =
with=20
other stuff in -mm, which is totally understandable considering the amount =
of=20
places being touched by this and other patch series at the same time. Just =
goes=20
to show how complex it can be sometimes, since I even double checked these =
and=20
didn't see that missed hunk :-)

The good news is that these are belt-and-suspenders: this avoids a rare=20
theoretical case, not something likely to be practically dangerous. But yes=
, we=20
should fix it up. Since the commit is already out, I'll just submit a new o=
ne.

Thanks for the report!

Chris

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQKTBAEBCgB9FiEECEkprPvCOwsaJqhB340hthYRgHAFAl7jt79fFIAAAAAALgAo
aXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5maWZ0aGhvcnNlbWFuLm5ldDA4
NDkyOUFDRkJDMjNCMEIxQTI2QTg0MURGOEQyMUI2MTYxMTgwNzAACgkQ340hthYR
gHAerQ//Zf+6DzdEaZvfnvPNq5+6NbmAAs+Pw1AZn2s81dipkRY38MGPNTqY8oBL
qd46ZDJ24zSUPAcHvu6E3UGwpjO8VSynvP+CfEoFlS+R5k15oEqTe36C7l9eA+IY
zTDyLj9LrFhy5qD2V2GKH9Dp9ZQC9BrIls1Gc0J+XaB7h9umEc2g1Ybadj1d3ouk
xAX/6iV19fAW4uFgXVOq70BhYGXGXvWCX0NYQ3Yz18Kkr5bSnjzTz2irIxCbaWZ+
q2Gj+Q1JFN/yhkRUt+m+8qtJZAb/i4cXqDJp9kqJ6t9cLjIhybFNRnXMueGr1Puc
byWoWK7i9+vEjnY6VbjToicAWQPeId063wxJzzhp/uqQ+zoCMDX+P7Iz4s1u+6l6
R3nXQSRcrw9VNc3ZOfJjXy1R/hIwGBbeGt/ndPnyNrznWu8yYJJr7qZirk8Uy4lp
wTmv/5QTkal+TiVXOMW6VwXMLLvu50Q+E3/7dIz4waKt98kfM8hd8zjB676rwcGD
olHRJHD956i7HOAU3uzFrijiMOgOnXAiJIDj1+MxLXdTL0ZidJizBh6eeSbxUrcg
egr+KPJSKcxuZ+K8c+yZD8MoCLJX84xTU1LdtTwQC9x10M1HnT1OMFLrfso4yWTK
SYtQxYe6sGiKMLvN3tYD5Ql63m8D2CIK5NDiK/hxG9hZtiYOH9k=
=2HeI
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
