Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFDC428472;
	Fri, 29 May 2026 21:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780088917; cv=none; b=eVB8B4q3q0La6pJa4FTUp1ZdSOAR1HaT+942a1FC3Qcxy6g2TtbMvKKMbBTSgGiqnds+v2xbX9jARWqfuRuGJGvu/+O3ACFeHRGLXibb77EteVvKWwOc3H2MszfWJnODhohxz1bk8E54DbFbYzQRl98Ueo3HCTLhczGhfumRpAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780088917; c=relaxed/simple;
	bh=J87q3rQeI0jr5y0o0srKBS8JvgOztJeG40jCLPOqkUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bNS+SWxOsqWZ1p2bWdWXTJiwwNbOdlVIumpT2CTC8rY2ad2aUxWMZ5qvJbIL4kqD7Vh1Ph7Jw4AoQJvIPb1gE7QGxJss3vakUdouSdV0Y0+PmHvff/5I5JYyoSyehgogvr0KObRtdRPMxATKGryw/qBcJEbaWWvm5LftiNjX6uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KWTQgkW7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KWTQgkW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF501F00893;
	Fri, 29 May 2026 21:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780088916;
	bh=oXRQFhMUdUjDktCpMqtDUPR43iyuZzvdvzSf4NQyNLI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KWTQgkW7NOj5UOxnT/VdzhaMufdawoVZMxKxjwJRQX26SnqF7mAUulryrT1nvihDz
	 +RO7ovvYDb7VjK0Ukd232Tl0xzMQ+jZ0d8/XvirvAJ2LOa50KbwcElFIW92P9gU9E0
	 i8jZLat6D0aGUsHJXLT/34Rfnnd3qZWvLhaUnxifXs0f3ABpm0WanxTU57IE4IoxnR
	 4rD1lcRcAxqtDELaJxMFNx1XzU3ohqjYGpk3Fd/tLkUXWppyRXEdWJib9mBMenClIt
	 GkJf+p7eB+m1CJIEM6C3NJtvgSgVgb1MY1Hj9FxED4L4d62UyCL5SVKIODvQ7fdgLh
	 T/fWFyF0UnJUg==
Date: Fri, 29 May 2026 22:08:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Petr Malat <oss@malat.biz>, Bert Karwatzki <spasswolf@web.de>,
	kernel test robot <oliver.sang@intel.com>,
	Martin Pitt <martin@piware.de>, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, Aishwarya.TCV@arm.com
Subject: Re: [PATCH 5/5] cgroup: Defer kill_css_finish() in
 cgroup_apply_control_disable()
Message-ID: <fd72aa26-4fed-4fcb-b4b1-d7ce9d891fe4@sirena.org.uk>
References: <20260505005121.1230198-1-tj@kernel.org>
 <20260505005121.1230198-6-tj@kernel.org>
 <41cd159c-54e5-45e0-81df-eaf36a6c028e@sirena.org.uk>
 <ahnMCQuw2K6zA3Hs@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UIuDOOq5as0cju9d"
Content-Disposition: inline
In-Reply-To: <ahnMCQuw2K6zA3Hs@slm.duckdns.org>
X-Cookie: Equal bytes for women.


--UIuDOOq5as0cju9d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 29, 2026 at 07:25:29AM -1000, Tejun Heo wrote:
> On Wed, May 27, 2026 at 11:45:54AM +0100, Mark Brown wrote:
> > On Mon, May 04, 2026 at 02:51:21PM -1000, Tejun Heo wrote:

> > with no further output and given that this is a cgroup locking change
> > this does seem like a plausible commmit, though I didn't look into it in
> > detail.  Bisect log and the list of LTP tests we're running in our test
> > job below.  We are running multuple tests in parallel.

> Unfortunately, I can't reproduce this in my environment. Any chance you can
> try testing on x86 tooa nd see whether it produces there?

Not readily sadly, I'll see if I can figure something out.  Our rootfs
images are based on Debian Trixie if that's relevant?

--UIuDOOq5as0cju9d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoaAE4ACgkQJNaLcl1U
h9Amlwf+J+MqoEoCvHT2GaEK4Pv45h2WTkU8lCea4P0U8LloM+a0TmHj70ToYuFH
fW7TOYWGQr0NiRLc90j0uEGyGZrH59YayXXDlBUiC5FzmHWUrTq70EF+aUzmmSgS
w2EvyKJNwyEnlivalNEvYouo7hzGOa+NztPy8BwRDesJ/FloEA4QYmupQp3zBMmy
vRGqF9tUG4+SLFhXM0FzEIinE7RknUUQ++TmXvDXa38Ci5m9vf9C76zpAErHxP1u
0sbLUfvnP7c2hyVzs2h6R++A/t93/uTJ3kk7Z3g7c+/ikHZ0fWH6UOnDCzk4+QY1
gYpBoxTuv0U6eXGi5CBGLrCA34Kl3w==
=M71S
-----END PGP SIGNATURE-----

--UIuDOOq5as0cju9d--
