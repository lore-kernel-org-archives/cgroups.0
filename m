Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B7B1D514E
	for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 14:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784299756; cv=none; b=rl1HfIjIHpck4N0zDaN58uDMRbmvEMFwI7NHtNQBDP4RllOWwfxMXOMI1d396QZeSuFaySIxyckq5DtPhZtkJC/m/zMXmFa0PSbJLvUgG1scwLmMTvAXBFYPzeFLSrEGFghdWn0XoS2BDhZv7q90wmd8Xrsk3ejUBLAdRNOLFqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784299756; c=relaxed/simple;
	bh=n7KNhhouRJfPPKsSowjR4uhZpTB4DvWvjk1/uN1YmGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KPs3s1mysUluEgtVJ2DeRca4yhfa33cBiEvqAdmdHBj6Go2wxDyeq1EdeucJps8LbQWJlMxwEDzyKQaTBGNnutMp1UoIVKhU9uqRel0M+siGaUQdURm1mm/B2AEhL906z9Prr2CMmwl5XnEIkesVhFyASR1BFdCTWw7EPXT0+34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UXi5CGXv; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UXi5CGXv"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-493f6de72faso12160785e9.0
        for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 07:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784299753; x=1784904553; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DQVZwUL5Yj/HZgLc5usvXd7dYSZnepBO0DvOQ94q45E=;
        b=UXi5CGXvBNbX4mxWmW/mq/8rQH7+cFHhYGTgLyWliXV0Kkj32wxB1TS++lx+Nil3kn
         QiFT6Ier1tQyrPMX0IpjjF8Y3tWbwW0uytm5HAXgoL/A1IJFmE0NzthSG6QCk81RKYwu
         Cu8pOByXCn7pmBWPNrDGE4DqMc2G8KOImPAgPks+ga/IzF3Bf7O1RFlt1JA6rixwFx8U
         Na2Y5GlrW5VRqn+YEdadZ+lzcSL1Az2wmiH6n+/qzvj2VxxfXQnhcSvx9wT/Sj7j6fmG
         Ol+GsojYPL0DeUxAv9EJCoXXvjh5ORsJr3d7XECVwWw7kzJvu9XDOo3pND4irqpKjNRt
         5JxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784299753; x=1784904553;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DQVZwUL5Yj/HZgLc5usvXd7dYSZnepBO0DvOQ94q45E=;
        b=GfXW19tUyhj8GXJv+hVNm6ElV2y9g8Vi20+gZoyKORipHA5YfXZvYqFz7WKRVTkcMZ
         oeOOoZNtJM27OneFlGgYjLQJ0j4g9rucmDopyoTu9aKiKeXtwLX6JdgK0xYIxFX6S42E
         mbKVf32IvCJDdXitBDsBcQKbxW10uoGGc+pLln2LBhRILNDD2ZX03jXXVLOVNyZ31P+1
         4O6ReTi3uB6stn7sX1pKlRFNu4A09gOOa4ohSZ5Rjl1SlMle/Gw4kik5ltzM4EznJTw6
         1OH5kJL7IYBlG49oqPPCzGgi0fSrrLLQ3tqr1sN9gECD9bVv5btY2UEqx2GpcGqwy8gu
         1O2g==
X-Forwarded-Encrypted: i=1; AHgh+Rr/1iGUw8cPPUEIe3/SzeKYP70cBlKbSpz1QpsrQT6gnIwsj1OLgGeMVzFf+VPZ/SDjbvaI8/QK@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9gmLVWxCcgULBB8ZWKER2Yud6NZsnytpU+zCvtJ8wl4l2FCvt
	K5FRMpmmsN8iJTaGAwGHHajhBBR+VqE06dF04c0O2bVML1UJcV3PqWBmC8gnt018o80=
X-Gm-Gg: AfdE7clop+2UPSBXdGqxxG4B0T9PbBrT2qiAIkg80XdY1BtXnlR4fMBBon3Zrvlb/5y
	bVLtU31t+vbXGyDtSVJRf1/ZqFbesfagoc9ovjocy5TozfX9nXJcdq+nNBgq4CxVzNrYfp2ssra
	WM8M05zIhgxMVzvlKtkkLDLwj5xSFrCfxuQcPd5pnyaUzjSRF+VCnupO+pt1GnSCsmEEZbCG0FO
	B+3LpBGpwbElZ8B4+7TYpqu389wP6I+LEc+bSIcQKpIOVFi9cmZJ3QlR7G6b3dCje68w97f7XFX
	Q/DOllTs9J6tFMYvojgsDOtD205G7sRWCJElMRMPwZVs1vxKr4ev1rEquPmyIkzfA/qwx2tuKRD
	S/swST8R7rjDf2BDwsCeIF8/PhFKie/hZZWAWV+/Ihaiu+qGSsGHQc246Z2nUsYYoIbCvwgENZY
	0tszgSTA==
X-Received: by 2002:a05:600c:35d1:b0:495:3a52:71b1 with SMTP id 5b1f17b1804b1-4954aa1a34fmr30304385e9.5.1784299753303;
        Fri, 17 Jul 2026 07:49:13 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49549a3f07esm54400465e9.6.2026.07.17.07.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 07:49:12 -0700 (PDT)
Date: Fri, 17 Jul 2026 16:49:11 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Tao Cui <cui.tao@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, cuitao@kylinos.cn
Subject: Re: [PATCH v2 2/2] Docs/admin-guide/cgroup-v2: fix delay_nsec unit
 in io.latency doc
Message-ID: <alpA0tsH2cm4029Z@localhost.localdomain>
References: <20260717060225.2019764-1-cui.tao@linux.dev>
 <20260717060225.2019764-3-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pye5sop4w5d2exnu"
Content-Disposition: inline
In-Reply-To: <20260717060225.2019764-3-cui.tao@linux.dev>


--pye5sop4w5d2exnu
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 2/2] Docs/admin-guide/cgroup-v2: fix delay_nsec unit
 in io.latency doc
MIME-Version: 1.0

On Fri, Jul 17, 2026 at 02:02:25PM +0800, Tao Cui <cui.tao@linux.dev> wrote:
> From: Tao Cui <cuitao@kylinos.cn>
>=20
> The io.latency doc says the io.stat delay field counts microseconds.  The
> field is delay_nsec and is reported in nanoseconds.  Refer to it by its
> real name and correct the unit.
>=20
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Acked-by: Michal Koutn=FD <mkoutny@suse.com>

--pye5sop4w5d2exnu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCalpA4xsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AixjAEA9/n0vXB3k2HvRBb083Jj
tjUEjDc1NkoJGkZKUybqmTYBAPfbVswDStpRGY75PBl6pVDE9MVPM2cN0AaEGMWW
+9IE
=K1f0
-----END PGP SIGNATURE-----

--pye5sop4w5d2exnu--
