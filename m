Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D77319852
	for <cgroups@vger.kernel.org>; Mon, 29 Jun 2026 13:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782741498; cv=none; b=UNYPe3OMP7pa0bUdvL1FHWEPvxC865TcKqXIm8PKtVOKo2UJdw60OUoM/zD1s4Gqb2iW67mx/NsRm/ALccfMENIsQ2iylVamJuJJk30Ek3djE9lqFF25L/Nxt6tbr6oNyQxhcotW8eTHnLo/NAWP7c+dG1o5OCVu6O/LlTr265M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782741498; c=relaxed/simple;
	bh=DRlmXZWlqten3MVGfQOjEdiIvKTFdBlls6hAAo2eRQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ho9MSwFvxPc2cnJEFPvvQfjh/HH0OH543U+l0V4dyg6lykibFVK+hRpKlCklaZEXEWWh8ocAlqfdfj+WrAIJeFWpJbO/vgXpfE1EnIC2Au+mN+AdAa+rdaw3M+G6iONnZZzwGqnpEM+L6Tza46OLdnmpiTGwFWXqKZnFpnIMpak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SOrBkV5R; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SOrBkV5R"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-493b779003fso521965e9.3
        for <cgroups@vger.kernel.org>; Mon, 29 Jun 2026 06:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782741496; x=1783346296; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ckhr+A9zr+J32IrfHMZuetYzQ2uESKh3SuZ//glpMWc=;
        b=SOrBkV5RO7dY46sIQOMdJrjS2TpGNIsgmpzuuS66MU3wV6sA35T28IiB7l9kQo9O6A
         aKVFI1s1L+E1cXJlaNbkxBo2oQwc14SBECLPYfBPS/mdSsSiaLQFijSUzEq3Z9ByIC2C
         9NzfT8CEVicXMj0p3Pyo148YnaGD8kgxX4vFxmZ6Cpjhlr4rAS+BiN0ahFbB2dtpDo/3
         vlvTRfHsLcFSAO3YKnUMSEAm6wC1738SF5zNZbJAEnWPYNDmfMnvOpgvXVsylX74p2OP
         GqMpN5Faa0jgVUC4k7I616TlCfhGFqMjoWBMjc+KSlDx7nhnGmq7Grdbj95qzQLixqJj
         5tIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782741496; x=1783346296;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ckhr+A9zr+J32IrfHMZuetYzQ2uESKh3SuZ//glpMWc=;
        b=sVr1VXV9yryLFgl6hRb+w4w9wIRUneyFiqFkBz7hEjIgZv3kZ79Sn2Ov+GoZgfgPZT
         Ul1arJLTZtOeMfpfWmi4TLgGG578tUYkWbh6kLnHPXKF6XQ+hkwxEMpzTgouHgEvI8JJ
         L18YGhSBURX+00S+rVRF5Svany3kuWYX2hxjzgE0Uf7ueCYGUnVQinKO9/SCBsMmMe7K
         6UFI0UB17kce/F10Z3WQyeI+HhDJBMtlX6nS9TDigSUbSOCpxP3+1nCd07VSQ2fkrdMZ
         SfIfR5flaGWiB4P3W2zbl8BLTiGAxrENV2wHgX8FHTmZKUCrWcLysyia2f3c5YT36ZmF
         KeYQ==
X-Forwarded-Encrypted: i=1; AFNElJ92oEb61cXvmCeRxT+3cdrX+CGmXgrp4CTJrimy+mCxYrPgAJpFpJAvLuTC/SzWG66xIdYiz27p@vger.kernel.org
X-Gm-Message-State: AOJu0YzmR3oG15sN/zA1anI96LTeJ1hthUQiFNQ60JAg8b4ICNdG7wT3
	+DZqn2/eAU42ZvLCB+kYfuVq3p3z6eeqGAijOHxVW1aUvXuN8bt3cau+a0uPvfvf7wY=
X-Gm-Gg: AfdE7cm2T0UqK+gUg58hEUIM4nJ4A63hO9leVtnIutA5s5be2Rn47bgCaoXdztGzSbF
	vBT9vCRjOdE2osmeo0JuZ/O4EgcMt8uhF6foIANpDJHU7wIdA49GbS72y62DJESmxCw4GBxLFPP
	ldWM5Ik0FjMPx7EJVchoi33yrZq/nJwzVbcKGCj7wjcGcz+ApDCqELZk8JY6rrI9B/li4DfxrBM
	0SKHSSeE/rssqdtN3HBJI9ioqABQYILF48UKMWxx9GSUSvzaA+KfZmX0MyCS8C4r3KdRjqQIDXK
	oLx3+ejeb5Sr572Iv8mJ2OF8pS/0uB+oR11a0jSz0MrwRrOZMCV4DRZrmOt3YxzX1CsUfj+YJ8N
	CL2zG2JP2yauPs3x30rz3XRKWymGVEp+aHYJe1nC7NqVc2N902neWHE06SxqysVxz4cdzBbJVYj
	204SY0/nEuxl74ZEjhsg==
X-Received: by 2002:a05:600c:c045:b0:493:b6e2:1b10 with SMTP id 5b1f17b1804b1-493b71cfff5mr11334205e9.31.1782741495906;
        Mon, 29 Jun 2026 06:58:15 -0700 (PDT)
Received: from localhost.localdomain ([62.77.90.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46efd7ee1c7sm41210744f8f.14.2026.06.29.06.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 06:58:15 -0700 (PDT)
Date: Mon, 29 Jun 2026 15:58:13 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Joe Simmons-Talbott <joest@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shuah Khan <shuah@kernel.org>, cui.tao@linux.dev, Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Waiman Long <longman@redhat.com>, Li Wang <li.wang@linux.dev>, 
	Sebastian Chlad <sebastianchlad@gmail.com>, Guopeng Zhang <zhangguopeng@kylinos.cn>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] selftests/cgroup: Adjust cpu test duration based on HZ
Message-ID: <akJ50VywgMXHvOqI@localhost.localdomain>
References: <20260626202925.1527524-1-joest@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wt466z5oxdyad3x6"
Content-Disposition: inline
In-Reply-To: <20260626202925.1527524-1-joest@redhat.com>


--wt466z5oxdyad3x6
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v5] selftests/cgroup: Adjust cpu test duration based on HZ
MIME-Version: 1.0

On Fri, Jun 26, 2026 at 04:29:22PM -0400, Joe Simmons-Talbott <joest@redhat=
=2Ecom> wrote:
>  .../cgroup/lib/include/cgroup_util.h          |  1 +
>  tools/testing/selftests/cgroup/test_cpu.c     | 43 ++++++++++++++++---
>  2 files changed, 38 insertions(+), 6 deletions(-)

Acked-by: Michal Koutn=FD <mkoutny@suse.com>

--wt466z5oxdyad3x6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCakJ58RsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Aj56AEAm/33THJwKq5HqIo/Mzwa
CFW+wEvcdsgjuF738rboa9AA/RVyfUbxEbsIOftbmrLOKpSy+Qoe4nC5z6afmoWu
a60J
=9Dss
-----END PGP SIGNATURE-----

--wt466z5oxdyad3x6--
