From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH 2/2] sched/psi: iterate through cgroups directly
Date: Wed, 15 Feb 2023 19:25:48 +0100
Message-ID: <20230215182547.GA17571@blackbody.suse.cz>
References: <20230208161654.99556-1-ryncsn@gmail.com>
 <20230208161654.99556-3-ryncsn@gmail.com>
 <20230208172956.GF24523@blackbody.suse.cz>
 <Y+P17OVZZWVpYIb0@cmpxchg.org>
 <CAMgjq7Bem+8g8A_OR26PHhYYx-A7LHHO3tyQNR_tMnaaKNxkug@mail.gmail.com>
 <CAMgjq7CKG_pNxm5ofciK-aBKwGuRCiyWPm1BXhjmcg=N0bfFcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1676485549; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P42oJWVw8QVuwSC+c50ruu3wOmb36a3Nrnfl7WXxgLs=;
        b=nIw20IgL2GT8wQHlWmqHCqEmwhG/Pq1EZmuhoFV1Eq83obXVTTxm6QMGgetdPgY5pyg+Mg
        sRhZf3gkQmfDS7Qk2HLmV4mMHvHMER3OnoK44UCuxI0d3Du7zug6DQDsigpDegbn3bs/Ow
        ZFOSDYvp5GwPsWz11xW3WnDUG/+0L/Q=
Content-Disposition: inline
In-Reply-To: <CAMgjq7CKG_pNxm5ofciK-aBKwGuRCiyWPm1BXhjmcg=N0bfFcg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Suren Baghdasaryan <surenb@google.com>, Chengming Zhou <zhouchengming@bytedance.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 16, 2023 at 01:49:22AM +0800, Kairui Song <ryncsn@gmail.com> wr=
ote:
> With rootcg:
> 55718.9 op/s (unpatched) compared to 55862.2 (patched)
> With 5 levels:
> 49975.5 op/s (unpatched) compared to 50778.5 op/s (patched)
>=20
> Previous tests are a bit biased since I only run the test for 100 * 3
> times, or maybe it is sensitive to some random kernel structure
> changes.
>=20
> But I ignored one important thing in my previous test, that the
> performance actually drops heavily with deeper levers of cgroups:
> With 8 levels:
> 48902.4 op/s (unpatched) compared to 47476.6 op/s (patched)
> With 50 levels of cgroup:
> 25605.7375 op/s (unpatched) compared to 20417.275 op/s (patched)

IIUC, one could also interpret this as the parent caching within
psi_group is effective especially with deep hierarchies.

I'd say practical hierarchies are below 10 levels deep. But yeah, the
averaged results aren't so impressive.

Thanks for sharing your insights,
Michal

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY+0jqAAKCRAkDQmsBEOq
uUXvAP4+saOtuGucCO0aCQxHAbvhTyM5VvwDko7ulIHrCJqItwD/Ygb9MEG1fYtK
kuirW9/kbrOKIwB1g5aix6+CxtrydQw=
=eG0E
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
