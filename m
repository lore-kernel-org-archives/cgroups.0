From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v3 6/9] cgroup/cpuset: Add a new isolated cpus.partition
 type
Date: Wed, 28 Jul 2021 18:09:00 +0200
Message-ID: <20210728160900.GA8905@blackbody.suse.cz>
References: <20210720141834.10624-1-longman@redhat.com>
 <20210720141834.10624-7-longman@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1627488542; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V8WnBgopJa2lvYyrEcrAnfZx6ZFCWG157aEnC0Y6NwA=;
        b=XGstFWI8zd51oMVV0Rhav655K/8yZmB7A4B4T+F5pJlClVmdjDnW5BP0Fqrw/uWBQbPqO8
        CSumfaEsmAzaM0iivIaFbkPbHEBF9CTHxwORQ4FXKdf3yDtydPCCFBJgGx26BuLMPczxQu
        /zhArJcocOT3a64BzFiasgfYE/BEtsA=
Content-Disposition: inline
In-Reply-To: <20210720141834.10624-7-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Waiman.

On Tue, Jul 20, 2021 at 10:18:31AM -0400, Waiman Long <longman@redhat.com> wrote:
> @@ -2026,6 +2036,22 @@ static int update_prstate(struct cpuset *cs, int new_prs)
> [...]
> +	} else if (old_prs && new_prs) {

If an isolated root partition becomes invalid (new_prs == PRS_ERROR)...

> +		/*
> +		 * A change in load balance state only, no change in cpumasks.
> +		 */
> +		update_flag(CS_SCHED_LOAD_BALANCE, cs, (new_prs != PRS_ISOLATED));

...this seems to erase information about CS_SCHED_LOAD_BALANCE zeroness.

IOW, if there's an isolated partition that becomes invalid and later
valid again (a cpu is (re)added), it will be a normal root partition
without the requested isolation, which is IMO undesired.

I may have overlooked something in broader context but it seems to me
the invalidity should be saved independently of the root/isolated type.

Regards,
Michal


--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmEBgRgACgkQia1+riC5
qSgO0Q//QBaFMt0GNk3zGOjGT2DTaib+z3zKvfq4mFSgCEx1VORHT4EnrEH7NOES
zoqFY30U5Cgi/9JO655nCgAJKeG/hwdxvbOcztKOAkzQFi3ts0KxGRQufwf+ajkt
n0Xi5Eb8XOzHA+q2QQFiTttopulxIVe2qt6FXtVsl2MVr3W0rZq5mJ0BQbTdfN8r
I3QPoCIpgy1+4JLgBIWr4nFAn16TpfxBFzAkTpidXLarNhp7vzbqUuEsuBXIhJ2w
dQtFunPBdOsdAVMC4WnCwxDt2XFiRpteY8j0ZOK6R1eGEdMbNagqTwN+ShlWYsT4
ymBZLfS1z3B9wXIJvzVFwimjMIQI6z7JrDfCnm6qGdCkxnLq6RSqpmqobF+liQU0
44HaXSoEM+rNI+Ss9tbF9URJEKDKwACtGozM257YAB4Vo/zteIKRVsL8WBWfRuB9
qELxjaR3uAGQ4i3UgpXxxph98pNBxxOM39iEU+3L6e0d/VO+/Yt0cnscLPJwIxbt
JybmN1c9a7bn3asILIX2hAxPcn3csQV3enWsVx8ARZcV3kMne7eRGTTQshZ1W56o
XektiwwjgzDtwQdO5Fv7wQGp352ikUorXU35JP+f8gqb8f4HPtgIf2AUBxisT/oa
zqBTCXZGwBWOSDleRR4/UvafoT4HVD8DaDw740LYDpdffOT3HyI=
=ZMPH
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
