Received: from mail-wr2-f2.google.com (mail-wr2-f2.google.com [74.125.225.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74606395243
	for <cgroups@vger.kernel.org>; Fri, 24 Jul 2026 12:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897545; cv=none; b=rEA+WXq3v2XoCYb0PlCMndxwpnvCpKgnS24P7BtZeb8B4doYhBfd8XB0Zof4YPWw0hBEtI9V0v+JY/AsmVSlTSSCr5PElhxXsh9injoy+3WzDCPiXWhLht5qW4C7Zava4MMKuwEyDMSxaiaJ7pcPi32GmAJSoerrLSmvPeTdmYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897545; c=relaxed/simple;
	bh=mk1BQnZGtudR7XDj42PbREbR3Ki5M0tr3oqDAtI6TZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sMkK7xsyjLlRa8zJzNrkykxctFS+y5Wq/rpbGQq5R+BWEjS/CxIF9NjQnVppwonQGsdcbzleJn6paiBl9B7MoBXz1crSjvilb/G0n8vYxxDNvM01wELck9vH6xq/5IiJwbx7RABP5GEjUyv0uBLSYDD5Y7OPqP36P4uhg3TlTfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=b/NgON33; arc=none smtp.client-ip=74.125.225.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="b/NgON33"
Received: by mail-wr2-f2.google.com with SMTP id ffacd0b85a97d-4730b8edae6so134282f8f.0
        for <cgroups@vger.kernel.org>; Fri, 24 Jul 2026 05:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784897542; x=1785502342; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Mv5tWqGLGkHnf04eMqxVT5ugoOpACtQyu5RJWX4G6Hs=;
        b=b/NgON33ojALkqd+RvRGUC8ybuq8FxJ9pcBWde0o3YNprY0w8v8IOCXiMLE8hOXvz+
         I1S5Ex4xQl7ZbpHfJHl0LOZ7j0JeSakFMXOlOD2+BZ2tz14sd+pNgZwPkrGSkGZD9VxA
         ftrhAdEd6dT8/flfEX+rDwYYid9+M0pf9/lwqV6b3upPEMoVO9cgUhd7/su+i5aFN+06
         lzBMWjVAUC9OofKg7ajWfbdhhyCs72u+YsiUQzvn6JffT9W45/O9DVFHJZnkeVv6yOtc
         B2eaAGYoOijr2ouDTpLHtctgUuXWMae5wtIy2MSEn2UZtD5YC6qT5oM/y33dMLraCD7U
         UEBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784897542; x=1785502342;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Mv5tWqGLGkHnf04eMqxVT5ugoOpACtQyu5RJWX4G6Hs=;
        b=eNcndS1GIy0QLhB6UYnIeG3Ovy8YMESXq2+zd9NLz9eIZ7mkR0r3eM1Sr7G7BX8FQs
         B0e85mMszDiYawlt7qhVXoUCyaX9MFYrA0YCwxEuOmCXbMMs2yKpFBYH5WKI4i7NdpUA
         PzqYCqQjcJcocSlglG5m1eOq9w+Q/7VHtgoo6H2BEYGbGBJylww0RMtZnnKHavNuNMoQ
         os+V+4sQ+hodFBCZqKDdRNGhAa7GXq5d/K/RcREATW/OMffg6ZWDEuLFOKRSnXbuRVx6
         2NX4E+BOG2Pm7UFXzZUdcUtLgiJxYvQHbtMOau7MkHJ3o9c6efPs9OIolSeK/FusMtWm
         vSwA==
X-Forwarded-Encrypted: i=1; AHgh+RrlR/KMQj0ItjdOP89vxmW9oOTv4cbK2UzIns5QpAYBprENvWUAhXQuJAVcMp0iHXkVnLPOCeYV@vger.kernel.org
X-Gm-Message-State: AOJu0YycJy82YDtn5rMGY/HVoo6Qqyxh4C74Ac/olKoUGPL34qrOs/v4
	S1aVIBp3oXj+Gn+wDT2ttN6rcI8VY7yXBzr9v4q/oT4wjKNTKlSlFJqsXBY5+WGLXA0=
X-Gm-Gg: AR+sD13pu7FPg9LPKk471Uk+g4eij61d8gQKxSHj1GCkJecH6CynolthFufLTlzjGtD
	/dRgd1BFCpBXepMojaJz+xlOBoc6nuyfXaIAgLNi6KY+EJgQXWVne2/hRwWQq4I67IoBEGTnPAc
	UEBbAxuDivXr6GQ1pGpeb3o1MKcrg6aTazR43IEjmc/29L8YXquEPKvuFOlIKBnoA13dZznYiSx
	wr+y4iUlTSB4QRWYEmQFs8Kv7SNKvaUsBedbh+f2xblZ56JVnXP+/0vL/g74u/JKYa17zykoFYJ
	zZwiDuzWn8ThV9jhKzHv48I7HJKylRGdRPeSORP9yxzI6TIO6kMS3m/GZUWKGpuXYAwR+BcXfdP
	2e+Ofzjqp7NheGNlrSKk5rgRW51fK0vtj4FQudA46j5sn0U2m3v61Cse8pdjAvGhxPGxCSvqgej
	TOcia/Iw==
X-Received: by 2002:a05:6000:2287:b0:477:3986:9b54 with SMTP id ffacd0b85a97d-47f8d77c2dbmr9048250f8f.20.1784897541667;
        Fri, 24 Jul 2026 05:52:21 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c631fdsm23383475f8f.28.2026.07.24.05.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 05:52:21 -0700 (PDT)
Date: Fri, 24 Jul 2026 14:52:19 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Kohei Enju <enju.kohei@fujitsu.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, cgroups@vger.kernel.org, linux-coco@lists.linux.dev, 
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Steven Price <steven.price@arm.com>
Subject: Re: [RFC PATCH v1 2/2] cgroup/misc: Add support for Arm CCA MECIDs
Message-ID: <amNfGkkI5OIBqpmZ@localhost.localdomain>
References: <20260724094120.166536-1-enju.kohei@fujitsu.com>
 <20260724094120.166536-3-enju.kohei@fujitsu.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ax7rchmwlrf277f6"
Content-Disposition: inline
In-Reply-To: <20260724094120.166536-3-enju.kohei@fujitsu.com>


--ax7rchmwlrf277f6
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC PATCH v1 2/2] cgroup/misc: Add support for Arm CCA MECIDs
MIME-Version: 1.0

Hello Kohei.

On Fri, Jul 24, 2026 at 06:40:56PM +0900, Kohei Enju <enju.kohei@fujitsu.co=
m> wrote:
> Arm CCA MECIDs are limited platform resources. Add a misc cgroup
> resource to allow the system administrator to account for and limit
> their use.
>=20
> The cca_mec resource represents the number of Realm VMs using the
> private MEC policy. Each such Realm consumes one MECID. Charge the
> resource when the Realm is created, and uncharge it when the Realm is
> successfully destroyed.
>=20
> Realms using the shared MEC policy don't consume this resource.
>=20
> Signed-off-by: Kohei Enju <enju.kohei@fujitsu.com>
> ---
>  arch/arm64/include/asm/kvm_rmi.h |  2 ++
>  arch/arm64/kvm/rmi.c             | 44 +++++++++++++++++++++++++++++++-
>  drivers/firmware/arm_rmm/rmi.c   |  4 +++

(mainly for this)
>  include/linux/misc_cgroup.h      |  4 +++
>  kernel/cgroup/misc.c             |  4 +++
>  5 files changed, 57 insertions(+), 1 deletion(-)

Conditional
Acked-by: Michal Koutn=FD <mkoutny@suse.com>
(it makes sense along the other arches' miscresurces)

Why? I see this [1] (or followup) needs to be added first.

Thanks,
Michal

[1] https://lore.kernel.org/r/20260715142739.80398-4-steven.price@arm.com/

--ax7rchmwlrf277f6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCamNf+xsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AhXYAD/aF4cHB3u4Ztw+Epfxt6r
owvtGiLz50NxCjHVwV+x/xAA/jW6M8nVIZ5COXi3AcXAaZ9Jg4Hbfex1q/uwG0FV
VjUH
=szup
-----END PGP SIGNATURE-----

--ax7rchmwlrf277f6--
