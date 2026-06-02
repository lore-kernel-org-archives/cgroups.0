Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1DE368D68;
	Tue,  2 Jun 2026 16:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780417742; cv=none; b=Hk0hO/PpTx9mCkB6Hsc8AcHDYAjXbt5n/9Fd3XY/N7ERSGxZxS1IRlnW0WUigTNLxOVPZiaUJueMrRbnToJwDRwqG3K/tRjYJOdMo/Dzk22mFyDbNwB+NpKjS+qx0DcBtWiOxDaZkZdS5L+AcpGgKZlOFaUfnCdCtNH5o8l/OaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780417742; c=relaxed/simple;
	bh=wk6f1RNMZGFpHBLLaT2U9WXGrUJsj1HYdvrLHTC9yhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lzZAorv6JAxnKXPtqEbtpcgvvwdbIYnZ7GGbyADEQBq2d6560ccufClJra0i34PVhJzESdylKS1Sustu8Vo9Xb4PoT6VNMIGHdjf//9cUbgWy5DDnOdUIND27XGIW/Zhp6LHTLLKEvRzLFwW3ThXy17Z59acFWt6AaQ/c0xIXB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UnGIjF+2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UnGIjF+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671521F00898;
	Tue,  2 Jun 2026 16:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780417741;
	bh=wk6f1RNMZGFpHBLLaT2U9WXGrUJsj1HYdvrLHTC9yhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UnGIjF+2HxMgNMO34Ds47v+8hld+Ae35d7Z2UfDW2LlNEyewsrxPaQXB8TYTSyEzp
	 Ulx9/AUNvDiy9ZzL5Y9TKDnyNJLLEpCnYrnh9RyYuZeHk4lvlooeFNpGsighQrj4cj
	 6uynfDPfn1lADcYmw+idm0ICXIfMywl/ZS+9hhmrTTjF+2ph/DBxzz0n/FOEw42jZw
	 Y1CurnBqhRKOpgUkAkGHmCgYSm2UeRhi3NR1Z1TJEuVyU6Qesi364wJUerSyQP/Y5F
	 Xfk9xuK0oPQNsxTiPey2+fWHXIwn0ertVqXpqIhOse56Xho7Ui0rYTOE3W1iGvTKek
	 NfWOn0ZndTQuA==
Date: Tue, 2 Jun 2026 17:28:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bert Karwatzki <spasswolf@web.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Petr Malat <oss@malat.biz>,
	kernel test robot <oliver.sang@intel.com>,
	Martin Pitt <martin@piware.de>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH] cgroup: Migrate tasks to the root css when a controller
 is rebound
Message-ID: <67814774-0047-4800-bf83-dacd1aabbf48@sirena.org.uk>
References: <a9f6c0bcd262e764453b95eb7397871825e11559.camel@web.de>
 <20260601190256.1815778-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="QJuGK6nEyPZOqIrU"
Content-Disposition: inline
In-Reply-To: <20260601190256.1815778-1-tj@kernel.org>
X-Cookie: The wages of sin are unreported.


--QJuGK6nEyPZOqIrU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 01, 2026 at 09:02:56AM -1000, Tejun Heo wrote:
> cgroup_apply_control_disable() defers kill_css_finish() while a css is
> still populated, relying on css_update_populated() to fire the deferred
> kill once the populated count reaches zero.

This seems to fix things for me, thanks both!

Tested-by: Mark Brown <broonie@kernel.org>

--QJuGK6nEyPZOqIrU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmofBMgACgkQJNaLcl1U
h9C/3Qf/U6vSoBdg/oBAW6QotbrNc+mcWoUPG5cF8zUT9gwATTLVB+/HxWz7fv8h
6njeOaxQcuaEhOu18G14Je1Z40fYv7xdAYhP5tqKnvzpNLIF3BQ+VobRJfkaFY6l
C/rsIBCZ6Sgqo8GGj3JWzAyDNNfBj08naASnFgWYmdjiYfWgwM/yyz4Y8RfArAcp
d9t3MJbxMJA7JwDNp/E7fD0Z7tt2cdT7RN2cL4PDvGykXNKQKg+dmJLgDXmwmBgw
OLjxcFwINUyM2hP5g/vH/FpcPszb7Lhhhyt0V8N2W5ibBtGLlivL6+B3s2C/33Ph
ciOWix3bmvo0cicv9zreQdPC0pD9Iw==
=9TCH
-----END PGP SIGNATURE-----

--QJuGK6nEyPZOqIrU--
