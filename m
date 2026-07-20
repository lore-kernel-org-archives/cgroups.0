Received: from mail-wr2-f0.google.com (mail-wr2-f0.google.com [74.125.225.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A641829BDBF
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 15:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784560063; cv=none; b=TCPk2tw1Iv+QMgReutnbrUvRvOWei/cgm4yFCqU9CS78TJ1f34QKXKDQGR4XZLgGX5dH9vOoANoYe0FedIT6leKdW88PiVh5rozA3wn0g7fXo+PfDG28fHJNGjr7WexDUOBVah1HPEZcQ7wS9iVAi91WQ8cZFc/mIeEkr7tfZ3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784560063; c=relaxed/simple;
	bh=kZekYJjdgA9jTrzaGEtUfryy0E1YgJzlFnQXBMIRaKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LRowWqeTanw0In+unTL5axChElmdN5Orn7frSrAnE03yNRWqTuksK5Wr//YagN0ZWhZwtz//zbHJgsHs0SGlaFulyFjBaOcxVscvd4yEt5C70XoeLG3qCLrEai8GYonYGY5zTkK9dRSf3IWIGwfR7FyZLhVrvVmaS6x87E/f+N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GI+Jsj3V; arc=none smtp.client-ip=74.125.225.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GI+Jsj3V"
Received: by mail-wr2-f0.google.com with SMTP id ffacd0b85a97d-47825ef4012so2794558f8f.1
        for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 08:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784560060; x=1785164860; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kZekYJjdgA9jTrzaGEtUfryy0E1YgJzlFnQXBMIRaKc=;
        b=GI+Jsj3Vrt1zFsjKUQ+rJPeGe1jTm/A3DWgpt005AWGJ3yn9IkJ/gPmSDUiQWRuf3U
         GxcjhRpuegMMFaHk4CCm9rHRwLJm6i2H0Eonp/XVA13/feMLqSJdKuLUlGLgY6coZpuV
         ps5jX+oOrpJTLMmv4OQYwbfxg/hMrImBW8dLgkhWyWziLDRmQhnZNcqCHRbU+xEk/oLr
         8r84MMQ4shy8RbaG6n3qHBDI6eLetTZvMOfjBcsMNHehvL1W4e8c4za71OG/F2Jm06m1
         DLMX+j1TuH0f7Do+vzGq5A7eM0w0xjhO8bsHIykxVl1HTb5o2OntPwC8nODvZZMURg20
         dc1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784560060; x=1785164860;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kZekYJjdgA9jTrzaGEtUfryy0E1YgJzlFnQXBMIRaKc=;
        b=FcnyEEcOv45WM146SF3lGz7Lc8/4IE80E5CO0sgUnar9iMwH+gkMFNtg9YX+FY1pk5
         O0p7ypymiqXEwaJFos/jJabOVd6KdGvC+DMTJmNhzOJRVLGbXsmen03kEMJP/6cBs5BT
         9VD2h8xIaZe6kOaw2+hySP7At3dYJTUD3lS6z8YQFydMN90PCXfx9UhYLTdupqetZurZ
         biCsEeoE7s3jbRvh2IR69GUYNKwbvP4bwf6R0LhNNsEVDurfoPHkp8hwtekAmWkutpVD
         wJKxV0KsoMHp6W1lNdFNKnFbAqtDpmNImfC5bgt5UrWknZJeJtTZ17aDk38G4dnoLDY1
         ceTw==
X-Forwarded-Encrypted: i=1; AHgh+RqmdFKW9wHVfM+A4UXFYJvjy88wISJ1seF80W9UTPv4i5H9pqfEXyHxoC5lWoWA0YorWdtiP+Tk@vger.kernel.org
X-Gm-Message-State: AOJu0YzcHhPQrZ6uLTbe7J1cUYTiCFuVpRjAWk1hw380gv/48NIlKcpe
	gMh43aUAFwrlanIK+vuvdxVzlInpi1/RuQUpQ+87+bY+d6O+whgs3tXP0sl/PfCa47A=
X-Gm-Gg: AfdE7cl7WTQXYJSlnpiEw/qkUB/nH3cHpacuTcW9WzG9nbL5oxTniVyBnMNEN3qZ3gN
	Jw7A8Z9nahkcMVX30J2qZz8RW+6KbMukOWitZJprRV80Bp1TTap1aRGP1iFxltBd+VpKN28CkzR
	HgJpBESlreMlIE2skJIPILzTiDU26Qt/QR5sEfWyj/WlGrNunZjZUob/aUjMSm+i3rFky/6NkJg
	AvO6yX+nzgOOBUM4zej+Sh9LcEDJloTDcEECQ+wvvFhiRuugF1iQ8Wzub7FxlQDjYKRwA9hGnYj
	yooG/Y04xlHG+Sf6YUJIokyAw7bLBSmybTWYQAew3x6Cgi+UgX5M23wHTmCgJV8ALpVXd0cy7cJ
	uVH4Vg09kn6SQQ4D2O1aUj9T3cmwMvnAC+N0Um6Aloy//bV2U651zKI9NDWGZZ43FbkTjgXbWxY
	L2iQqp3w==
X-Received: by 2002:a05:600c:1986:b0:495:64a8:c35c with SMTP id 5b1f17b1804b1-49564a8c364mr5779205e9.24.1784560059737;
        Mon, 20 Jul 2026 08:07:39 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2aa698sm264192565e9.4.2026.07.20.08.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 08:07:39 -0700 (PDT)
Date: Mon, 20 Jul 2026 17:07:37 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Tao Cui <cui.tao@linux.dev>, cgroups@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cuitao@kylinos.cn
Subject: Re: [PATCH] cgroup/cpu: document cpu.stat nice_usec and
 core_sched.force_idle_usec
Message-ID: <al45RUAYKgGt5IYS@localhost.localdomain>
References: <20260718080100.2334415-1-cui.tao@linux.dev>
 <20260720150226.926730-1-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6epftcfwmdm62r3v"
Content-Disposition: inline
In-Reply-To: <20260720150226.926730-1-joshua.hahnjy@gmail.com>


--6epftcfwmdm62r3v
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] cgroup/cpu: document cpu.stat nice_usec and
 core_sched.force_idle_usec
MIME-Version: 1.0

On Mon, Jul 20, 2026 at 08:02:26AM -0700, Joshua Hahn <joshua.hahnjy@gmail.=
com> wrote:
> I have to ask, which tree is this based on? I can't seem to find a single
> tree that contains the "(including those in descendant cgroups)" section
> anywhere.=20

It is most likely linux-next which contains a nearby modification from
[1] (or it was based on that regardless).

HTH,
Michal

[1] https://lore.kernel.org/lkml/20260629060636.200118-1-sunshaojie@kylinos=
=2Ecn/

--6epftcfwmdm62r3v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCal45tRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AjM6gD9Fm0pi8Et/bcFqnkqiw4H
49e+XSsvzEjwawApGizXmPIBAJkcQKWuepD6r2fr/W5aFr5Y6UcGdVKXnZjLgnh+
XH0N
=qiy3
-----END PGP SIGNATURE-----

--6epftcfwmdm62r3v--
