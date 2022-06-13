From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v11 7/8] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Mon, 13 Jun 2022 19:55:49 +0200
Message-ID: <20220613175548.GB21665@blackbody.suse.cz>
References: <20220510153413.400020-1-longman@redhat.com>
 <20220510153413.400020-8-longman@redhat.com>
 <YqYnQ4U4t6j/3UaL@slm.duckdns.org>
 <404171dc-0da3-21f2-5003-9718f875e967@redhat.com>
 <YqarMyNo9oHxhZFh@slm.duckdns.org>
 <20220613142452.GB6910@blackbody.suse.cz>
 <YqdzuSQuAeiPXQvy@slm.duckdns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1655142950; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AzS01aA3Xyy9CDel2JXDJs9iyrs3QpwSpqahshjzX74=;
        b=cqnjztUqJrCHTfw9V8Ca5DYeE4hhSffVbVP2M7yHzGtkufmdle7iK/rqZUXXVJWwvILc+6
        EdHXTnZWsO2XWqTSSZiB36tUtLKfOeQZOLoNGPczPNYP4F54eWRp6cXpT5TwvRwJNGCBjJ
        lkBJEdxZ0YrWvHlqX3P3gIIFXIfUN6Q=
Content-Disposition: inline
In-Reply-To: <YqdzuSQuAeiPXQvy@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 13, 2022 at 07:28:25AM -1000, Tejun Heo <tj@kernel.org> wrote:
> I see. Is this part even necessary? All the .cpus files of the siblings a=
re
> owned by the parent who's responsible for configuring both the mode that =
the
> cgroup subtree is gonna be in and their cpumasks.=20

Do you mean such an example:

    parent	cpuset.cpus=3DSET (root)	cpuset.cpus.partition=3Disolated=20
    `- child_1	cpuset.cpus=3Dpartition_of(SET) (root)	cpuset.cpus.partition=
=3Disolated
    `- ...
    `- child_n	cpuset.cpus=3Dpartition_of(SET) (root)	cpuset.cpus.partition=
=3Disolated
?

I don't think child_*/cpuset.cpus must be owned by root.
Actually, the root would only configure the parent, i.e.
parent/cpuset.cpus (whose changes would be disallowed to the
unprivileged tasks) and the distribution among siblings would up to the
whatever runs below.

> Given that all the other errors it can make are notified through
> "invalid (REASON)" in the mode file, wouldn't it fit better to notify
> cpus configuration error the same way too?

Do you suggest that a write into child_*/cpuset.cpus that'd not be
exclusive wrt a sibling would result in an error string in
parent/cpuset.cpus.partition?

Thanks,
Michal

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCYqd6IgAKCRAkDQmsBEOq
uTj0AQCj12EX4WPcqDcmcwMKbJzlpJ02i8IqULaAkdHb+ptGcwEA8e1nvXYC0yDJ
hezmngAtFbdLR+r20pDT8tTEBO6BKAs=
=xTZE
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
