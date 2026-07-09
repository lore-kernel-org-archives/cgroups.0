Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1ED24886E
	for <cgroups@vger.kernel.org>; Thu,  9 Jul 2026 13:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783602269; cv=none; b=Fj55iU5B2GBOLb6YGnW7hPh/CEcetQg6c8R9DeuxkUnAdw9bMj/ZpuuK9b6tIg7OFOYM+xoXbMfgAsC+4y0fFXX8NKTnVcH1Gf1uMgY9k2hoKN9msjvbyjC9fGfbso1gYmCezgXEt1kcTT0dXIWMaoRlDEP71Ge8WqyQlo1+UIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783602269; c=relaxed/simple;
	bh=pomWuPe/tr64a82692VQtY4Wk2PnNc+aTLslFAls9Aw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eQ/zx5QbVkm0qPd1L/fgxQGSMhpTNsVFJaeUtYXfaf+BOqfu8iLJnk8WyKki7DmvHgWDhRSeue95AVQqIZMgNRaoEUu3MZV8xSqjt3Nuck1K5EjFTtwZa/2ru3oU1EZgX73iGf4sVTFxoq7TfpMxiWkJpqKXCeVKalHZZcSJIwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GH6Q3lUU; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GH6Q3lUU"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-493ed9d8c5cso3480535e9.1
        for <cgroups@vger.kernel.org>; Thu, 09 Jul 2026 06:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783602266; x=1784207066; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fOOmFkjlODizpn7Pcs0slVGKdf2bx5h/bU795bDZqXU=;
        b=GH6Q3lUUH5Jiyx1mink2Jtohp84TSDDEwackmOd/AdtmidnqTqsXgdvLLyetR8RVeK
         lYMoyOeS8Ai9Rwkx8+q7VssbZtSYDSxbj9whzWtRuZvOBLIWBbNx2INXa/0s+13BvPxk
         96qyo7AZNuJCGKyKsOaXepdd5rNpoDg/1+xvjfV5rIlrbjkeHeM7CLoxCnzFl8CDlgYQ
         jIWtgmx+/T0Ej2CKK3kpkA7HGtUg7Ii4PBMMj3tx1p8NgvtubSTu5BLVTLvXAAlpfy+L
         6g8NY3Do4fJXTEY1MdkqcOLUL/LUMjieUgAJ8jO/P4DSceQnZvVlACJ4A/zW6HgOL/HB
         rtLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783602266; x=1784207066;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fOOmFkjlODizpn7Pcs0slVGKdf2bx5h/bU795bDZqXU=;
        b=CUAJGURQTQ5rb3pe8V3gVK69h5robsvF/Fnx1W0AHsdPXBTdgDFvUPf94w73jrVZmb
         sTbH6gQ1GmuASHcGnMYnjJSTQVx9opuOcNfHqTn8WgsPfeO+aqJcXuX+hCcGiUHndSCU
         0+TD4lXsDRxXw4b7E+Dy25AeDYgDvf5Z+y668WfRGhxvW6RhwRUxf6+isR2s9H/gBbVw
         sQodk/lEzYPoIUub6abxsm+9Cvt85JUhVcQSwX8fsdLIfRmluVhALUzVlGhK2vxU3iEI
         L3GwLSYyvQME6KiznwUZ/HWdzDpGKZza5aNSOKIajSnu5AQzSFBuO/YsdSx6vMxfmLgY
         BLrw==
X-Forwarded-Encrypted: i=1; AHgh+Rqe1Zh+mqL947g6V7OesquguZu0hnvH+5uUx29RpRYC0nw+pkDLd/EXcXt6CZ5Wn1P9wOyh6j0P@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc8uF+2CDI4VAjf2Wow3zRuCEW9jwRtu4zvZA9WmVyiLV1IEw0
	AES5ZmXXg26koCXI81h9JxUMJuKDmrapyYYJuZ1m8S+dQkm1+8+9AwIDY5qliswX5Dg=
X-Gm-Gg: AfdE7cm62gR3D0SoXWRyP+OTd1hJTwCepE19pgsH0aoMH3jM3c/vpQhk0SN1DboGuWn
	dSPNvdpIQEaH4F1bWvqHYjCx23kziqAChtsC9vcnvgYnpOnDK8Prruj20nDHyNqV/UX3Gm6Asv8
	ObX1uP/hyo8Zc+7vpPfe7uA6yHiXtr3LKcIcWD5hV8moo3Afp1+s3Oe4GpybeUGt1wEV9xqFyN6
	dLboWCyGjCAUjGf36yt4t2VO2R6xaDZqIC6z43w9XiuAMO/e93hcVS/KnJxklVh5+u8dnzGtQv3
	XW0WeUuHql7bn1/LAGYX9i44bdZ6vCRijmLAU9xFIRhDUb89Q5vAHFzzo6KOEYNTgj862BIiA0S
	cQbjAJXBewlGmxKuhxsZiO+BYiMnR+YF5E85P8YRVcAPsCKRRSAgtYA5BqF/fgmNobdaJBEvmkN
	gxA8icNNWev0TLQoS0zMC9wTDjnzVZmPnabW43dA==
X-Received: by 2002:a05:600c:6206:b0:493:d078:796 with SMTP id 5b1f17b1804b1-493e6a4a8a4mr66442385e9.17.1783602266150;
        Thu, 09 Jul 2026 06:04:26 -0700 (PDT)
Received: from localhost.localdomain (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb6fb526sm69825665e9.15.2026.07.09.06.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 06:04:25 -0700 (PDT)
Date: Thu, 9 Jul 2026 15:04:23 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-rdma@vger.kernel.org, cgroups@vger.kernel.org, 
	netdev@vger.kernel.org, linux-s390@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	jgg@ziepe.ca, leon@kernel.org, parav@nvidia.com, mbloch@nvidia.com, 
	cmeiohas@nvidia.com, roman.gushchin@linux.dev, bvanassche@acm.org, 
	zyjzyj2000@gmail.com, shuah@kernel.org, tj@kernel.org, hannes@cmpxchg.org, 
	alibuda@linux.alibaba.com, dust.li@linux.alibaba.com, sidraya@linux.ibm.com, 
	wenjia@linux.ibm.com
Subject: Re: [PATCH rdma-next 08/13] RDMA/cgroup: Scope rdma cgroup device
 visibility to the net namespace
Message-ID: <ak-Z071LrWhnI5lK@localhost.localdomain>
References: <20260709095532.855647-1-jiri@resnulli.us>
 <20260709095532.855647-9-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="y2qmoqgw5gkrylpt"
Content-Disposition: inline
In-Reply-To: <20260709095532.855647-9-jiri@resnulli.us>


--y2qmoqgw5gkrylpt
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH rdma-next 08/13] RDMA/cgroup: Scope rdma cgroup device
 visibility to the net namespace
MIME-Version: 1.0

Hi.

On Thu, Jul 09, 2026 at 11:55:27AM +0200, Jiri Pirko <jiri@resnulli.us> wro=
te:
> index 993446ab66d0..4523c1884d67 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -2752,6 +2752,13 @@ RDMA
>  The "rdma" controller regulates the distribution and accounting of
>  RDMA resources.
> =20
> +When RDMA devices are isolated per network namespace (exclusive mode),
> +device names are unique only within a network namespace. The device lines
> +below are therefore scoped to the reading or writing process's network
> +namespace: only devices accessible from that namespace are listed, and a
> +limit is applied to the device of that name in that namespace. Configure
> +limits from the same network namespace as the workloads.

OK.

> --- a/include/linux/cgroup_rdma.h
> +++ b/include/linux/cgroup_rdma.h
> @@ -7,6 +7,7 @@
>  #define _CGROUP_RDMA_H
> =20
>  #include <linux/cgroup.h>
> +#include <net/net_namespace.h>
> =20
>  enum rdmacg_resource_type {
>  	RDMACG_RESOURCE_HCA_HANDLE,
> @@ -34,6 +35,15 @@ struct rdmacg_device {
>  	struct list_head	dev_node;
>  	struct list_head	rpools;
>  	char			*name;
> +	/*
> +	 * Net namespace the device belongs to. @netns_shared mirrors
> +	 * ib_devices_shared_netns: when true the device is visible from every
> +	 * net namespace (shared mode); otherwise @net is the only namespace
> +	 * that may see and configure it. @netns_shared is updated when the
> +	 * sharing mode changes, so use {READ,WRITE}_ONCE() to access it.
> +	 */
> +	possible_net_t		net;
> +	bool			netns_shared;

Any reason to store the netns_shared split per device? (IIUC, it's a
global parameter.)

Thanks,
Michal

--y2qmoqgw5gkrylpt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCak+cKRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AgSmgD/Vgg6K9wF0JX4NBgdz4NM
xV33/zTua20t6++MDiv2LGQA/iiwBIKorFXkq2bd30gmVkdyXN6gNLUnmclqxnfK
+M0P
=L3DZ
-----END PGP SIGNATURE-----

--y2qmoqgw5gkrylpt--
