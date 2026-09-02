Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB36939CCE6
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 18:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788375409; cv=none; b=f5/r0ENE8MKHMzecoPJLEERDsVGNjkJ/8JZxnAR9EGoksdIQH9eHQJpTjcGV3nkIqBuQt9yMPP3K8zLUbW9mDCAwKWfEhp9vg/rcEBiIrSdVJk1WwsFFsQOIL81aKFQiMCxhBz8zaHJSo7eI4A6sLYVKKv7aolzf6RlHmLhSmYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788375409; c=relaxed/simple;
	bh=Bl6Z+yhon446XPiSec64jLZfYGcpfzZ7kRoEQk6o8wY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SGSR1UwGFhFRWzHK3s0hbBmzWTTWy9E5aZCmrVsXTPaapXkiyx6tFhvloVEW2O6tSkMrOfbFFZHAFeVXVQyrX7m/41UNZugEaR6KlSa3gNA/PEfHn+kLI8++dUPqfqbNEqalAvH2mQgsBSI369H9UU7JjWW7GJVlR13ToMI/ofg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cOQBfnTl; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cOQBfnTl"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-485538d3499so1026170f8f.0
        for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 11:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788375405; x=1788980205; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ce9zziXevwzztTUtUBuzSZewu7sUb5iK8933/ZqFADI=;
        b=cOQBfnTlbQ9OfuOLJJcn435IH5QOTVq0jNGYIVjOUXKTRxSWgBjM4dMxjFlOj1DpFr
         JHnCG5UepMh99Y4Xy9jlXrs3zuHi/FtdlLBMrlpIidVgtUOrl+Biq2McrTueYgCeyOjS
         XjdkU4CW8CYtXVTnu4N/PLe+UdXnelB1reDrxVy8BPnLeqcFDr5Euy0AhJjd2zOMzqLG
         LOYg3vyUdKXX+vRhFrg+JoE3hHp4IdCAGMaYeM4fzv9vjYmidr6sGo3MWPt7phnLIV9B
         p+m0q27SQ9GP/VnLhUHhsPR6ueN12+mfkgdfpQ8/9Kk03fY00GLVp6VvahWAot8P8ulO
         ohAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788375405; x=1788980205;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ce9zziXevwzztTUtUBuzSZewu7sUb5iK8933/ZqFADI=;
        b=DkYVeyXJ/u18+G91gU6btxpn0/u9zCN3Cjsq64UMvQt6ab6rGrIIaVZZn8E9dejKI8
         GnpfQ6sKDDuhAgJnIIbzWhjzCb17ZEMKO5gN2A5Vdjay/8kxE2uBBv7g11xFR8B6qU6Q
         xr8grT4hZ84+QH+N0NzmMXD3iQ5K8O6u+nhD16+Qt+Z3/curZpErJKLOUzbHoJyCamGe
         AGB4CuP6WtJiVOOBsba2knBI185lv6GIUgsxp8l1YS6BTrTrD3Dvmo1ngk1ki/bbyZvh
         lDIBHAiJzTxPOfr8Cc8xCu0jGdFOEO9NM5oENtAbOkQ3WmflyrLLq6P8Z3XyCrgkjhds
         dMRw==
X-Forwarded-Encrypted: i=1; AKwUvBxO8KFEgabU71i7cVe7tRRr3Vja17YCjyNLFrlIMXC0snCIeImVgRTcPbh4n1f8+kW+lRhMGbdI@vger.kernel.org
X-Gm-Message-State: AFuF++k8t7FVpl+zDEUJG+gdrt1bqzsx3vsyC9qk+tzPWkqXM+MRB935
	a0K/wOKIW6BaBRT5/qm7UNx01JPGKOeg8657vTjvoTUbNo+KOlApumRFs0G3Aro+9XE=
X-Gm-Gg: AYBFou3b9g779jnSil1zf44glAXpOR1WN+BteJEVZnGfQfAY1rGMcqzQM81UiAAwtFN
	4TXBjrrzhzNzKUgGZmyFDOT8InQJbyThrRkZ7EoKsXr2j33nTnvtWOPIz2Er22yjeLwzrtD0WWa
	HhcQE8O6W6ATV9d8PTRVdNhEQFEmKTC7IAHvupswk0ty+lceaXiHaw56LqpoQY4YoObRpzOqYHu
	31Ou4rGp/HnWmylW0r5611bxDMsuxQdlqN/tIedhLWbAZH78msCFvpzwcrDRlKpNlim9t61n3Zn
	Ca0BFnBI0bybu8Y+M/1+YgYwb/3+hnYDzJ0SYfG6XFrjTdS3pNlXi503bVLcpAiqblBl6Nfcqg4
	w2/kdDjwzn+TL21Z1lZVRsypqOxEqc6H2G55W3BoD/e86CoJIgR1aH3UTQTRrXKUuSTRd7rgBiD
	K96PprvxcQIOXW0eKTuRaZgh1c0LZ8brf8uB133fH5MElkURmbH34FObQuDmzqLI8=
X-Received: by 2002:a05:6000:27db:10b0:484:f26c:b9f3 with SMTP id ffacd0b85a97d-484f26cbc06mr9882672f8f.28.1788375404776;
        Wed, 02 Sep 2026 11:56:44 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48448ed3716sm8647593f8f.22.2026.09.02.11.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 11:56:44 -0700 (PDT)
Date: Wed, 2 Sep 2026 20:56:42 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Shaojie Sun <sunshaojie@kylinos.cn>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: Re: [PATCH] cgroup: namespace: replace BUG_ON() in copy_cgroup_ns()
 with WARN_ON_ONCE()
Message-ID: <aphwXq5bEQwKhqx2@localhost.localdomain>
References: <20260902101856.225493-1-sunshaojie@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ybus6cnw3pbkpvuz"
Content-Disposition: inline
In-Reply-To: <20260902101856.225493-1-sunshaojie@kylinos.cn>


--ybus6cnw3pbkpvuz
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] cgroup: namespace: replace BUG_ON() in copy_cgroup_ns()
 with WARN_ON_ONCE()
MIME-Version: 1.0

Hi Shaojie.


On Wed, Sep 02, 2026 at 06:18:56PM +0800, Shaojie Sun <sunshaojie@kylinos.c=
n> wrote:
> copy_cgroup_ns() uses BUG_ON() to guard against a NULL old_ns. The
> condition cannot currently be triggered by any caller, and the sole
> caller, create_new_namespaces(), already checks the return value with
> IS_ERR() and unwinds correctly.
>=20
> Replace the BUG_ON() with WARN_ON_ONCE() and return -EINVAL instead,
> consistent with the policy of not killing the whole machine for a
> recoverable programming error.

Do you plan to tackle other namespaces too? (Adding their guys to Cc:)

It'd be good to have some consistency across them if this is going to be
touched. (I see that some simply don't care whereas others have the same
BUG_ON(). I might personally prefer the former)

Regards,
Michal


>=20
> Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
> ---
>  kernel/cgroup/namespace.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/kernel/cgroup/namespace.c b/kernel/cgroup/namespace.c
> index ea4ee13936be..13930955c254 100644
> --- a/kernel/cgroup/namespace.c
> +++ b/kernel/cgroup/namespace.c
> @@ -53,7 +53,8 @@ struct cgroup_namespace *copy_cgroup_ns(u64 flags,
>  	struct ucounts *ucounts;
>  	struct css_set *cset;
> =20
> -	BUG_ON(!old_ns);
> +	if (WARN_ON_ONCE(!old_ns))
> +		return ERR_PTR(-EINVAL);
> =20
>  	if (!(flags & CLONE_NEWCGROUP)) {
>  		get_cgroup_ns(old_ns);
> --=20
> 2.50.1
>=20

--ybus6cnw3pbkpvuz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaphxZxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Aj71gEAiXb5ZRIcP6X8Mw+2xR1l
CoKcPIu+bFvoeVnYWEwuERIA/26K3m+2Kyeo61hpHTBgSt3V2OeB8wHqvgGpCIFM
pVoB
=09pG
-----END PGP SIGNATURE-----

--ybus6cnw3pbkpvuz--
