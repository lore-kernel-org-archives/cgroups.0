Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7BC449B2E
	for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 12:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791808658; cv=none; b=YAG0Ok7iWlFNX2sTmNrr34NEW//WpodgciaiQeocgWdZ4EMBfwoZs1HOmvfHw5Dg3fz9XfMv2RwakaFdHQ7GS0FasomlIMA0WoS069j6D6XlKaImuEQgEO+CGVVildGO4Q77GbXNzXCT7aJU7hB0Fi0FwH1OXhLr9YndU0RnJx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791808658; c=relaxed/simple;
	bh=v4IziCkASKkVCaFhJHDZf4Plx12XI9gG6H0aDX4vqzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XVcLB9Yb7O/Ivy2Jk6XvRsKd7pPMXdylzjOkFFoEMo5SL33rwFlyMG8ux01pHvH5blV/q6oQhDD5k4FwEOBtf7phPcWBLeEnoeRYiNRW+hKPjdCV2mn+OPbTPWbSKmzdrMFv94kCebQCfmtNqVeR/1b/oV6twHNP6Uz9G3ocDe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Yt3VqNu0; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Yt3VqNu0"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48bbb06e746so1062430f8f.3
        for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 05:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791808655; x=1792413455; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=v4IziCkASKkVCaFhJHDZf4Plx12XI9gG6H0aDX4vqzk=;
        b=Yt3VqNu0iX0rAqky5OpmtTo0CIQz6WykVKszJENVDF5Z4pwLXDQ7uaJpPinLT9kq7Q
         zQhUe1HiyyJ2YlESIPUQge03zEiewVyfbvp4Cz/MBFvK/qx+aFrpGK1zH9u8GB++wDIL
         MpyK7E/DKJD+HWaXnG8elL4UkvUE3Rb4eGoy3Q0z9DVQQVOIXHGsU0Xf6qCtNMBs0IGi
         h269aT1zERckzma0Vwm5l42cef8K12Ab7uthOadAY3gtwVAP7zLEysneyh8nUbcNLn8t
         KMHQQn2tPIbJoOfazGWjfhida4f8iMAO5AmRWH4LqKlsPqr2H0tZReJ89nLVSFQRgbcn
         WM5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791808655; x=1792413455;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v4IziCkASKkVCaFhJHDZf4Plx12XI9gG6H0aDX4vqzk=;
        b=YL6wCQnCF//RePwqxYzW9JuhI2/cQp6hK+x0TL36kOSmMhL0fQmg9Ol5kmzbscc+/L
         PX2bMtL4kRfgodpCIp8BEfcK1pr6MBmhCtAZDDF8DDGAQbbw34OxOZzLw8ApV1H7XEri
         9agWSea//7zgjjlU1qG1MnJGtKN8h455u/8MU4Iuu3ehz2YrVT6aDTJFgUijWEA69Dop
         EaZbK3QNs8BDoNZHlBnQetmFwT18Y9Pr/Me2w37z6Ccsy+79Jm6n7I5GANdmCfAA0yn5
         fRBZ2gHQ7skrLeg72Myjv8L9w6TNY4rzSgrBhkfMVR/6PA6HyZ60LLYMaWDo8vC12HkY
         PN2g==
X-Forwarded-Encrypted: i=1; AKwUvBzLOMD7Bl/AudfgnEJQgnk7tdilcjhdP2jtARGYpyFozYHhnu2x2cLsETSLXliUUzKN36jDyk/X@vger.kernel.org
X-Gm-Message-State: AFq9FYKrEaYjX7iLD/mb1DzNfaWVx/KfzdOpJGLbY7S76lg6/Xe7Pf6E
	X2rW4JkGTBxW86cxmdgxWjLU6bPa2HmOeO+Rz+Rtm/DWPZymosttZB07feHIp/fsE8g=
X-Gm-Gg: AYBFou06ptVuSxrbM565GTcX3xtL/5Lc5p25q+TRUDYt45vtAjDiJt5fKohMFVNahnm
	jQhsYJ3qjUa7tpmIvXQz/GxSwLZAdcCVLwO83duRPCk1F3Aw3ecq4JZIBxbEu/mKBq9DUygD4w1
	hMK/L+Snn16ypQ3vL0a8DygU0wan251Q/W1OnKeqbY8+cF3ciXKw8oXP4umnV33VqPj5i07QjAr
	l6MHVFFsscfhn2P+KdAfiQFGFwIQleS5XNExSXfoeoREQXSSgyygdWdokBOV6p5itnMxU1PMjPP
	gyq1MNsNsW8pBy7vcBULcrUR9CpzkrVJvVSgW2Yjs+1hqOZ3izOjLiVbnMxeqYO6yEqF2euePaB
	215RcL5gjqg/2A8NDxWaB6LelRbgJ9VffFzEGNBWGw2zjP81KJKxVwcDg6B/G2CckpNBNnzieT9
	GQrRH4epOu7LARvUKjXYimi03KCBnP7voWMa9mitiic1Q17S4vvnvpJm9xfWafJY1RetASZ5SBj
	S3HG2GUPhIc
X-Received: by 2002:a05:6000:298d:10b0:487:b50:101c with SMTP id ffacd0b85a97d-48dba77cf06mr13120307f8f.5.1791808654891;
        Mon, 12 Oct 2026 05:37:34 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48db9ada3edsm19095411f8f.53.2026.10.12.05.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 05:37:34 -0700 (PDT)
Date: Mon, 12 Oct 2026 14:37:32 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: Avoid warning when procfs is disabled
Message-ID: <20261012-robin-handclasp-417c1263d268@there>
References: <20261012054219.13365-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="sxhfuelmz2jajvtk"
Content-Disposition: inline
In-Reply-To: <20261012054219.13365-1-kmehltretter@gmail.com>


--sxhfuelmz2jajvtk
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] cgroup: Avoid warning when procfs is disabled
MIME-Version: 1.0

On Mon, Oct 12, 2026 at 07:42:19AM +0200, Karl Mehltretter <kmehltretter@gm=
ail.com> wrote:
> With CGROUPS=3Dy and PROC_FS=3Dn,

What is practical about this config? Is it real life usage?

> proc_create_single() returns NULL and
> cgroup initialization warns during every boot.
>=20
> Only check creation of /proc/cgroups when procfs is enabled.

The dependency on CONFIG_PROC_FS is encoded in the
proc_create_single already, it's unfortunate that it returns a value
that signifies an error.
I'd prefer more generic fix that doesn't target cgroup_init()
specifically.

Thanks,
Michal

--sxhfuelmz2jajvtk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaszUiBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AgyPQD+JF1ALjKHhvCZgZTHWKpt
px7gEmaDUfg16vcP3hhQmeYBANL7rIcu2f2MPAKqn5Rlx5g0zUpusN84McLyxckt
nFMK
=qrjq
-----END PGP SIGNATURE-----

--sxhfuelmz2jajvtk--
