Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A3347ECFC
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 13:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789133886; cv=none; b=vGmB4ISKgK1PY5owQpY+x+/k6JSURo8nV6OMCZxf5oo7WPLRoBI4Tz/uIpedWrP4vubgq8UOZFbI2KRUcOyhcCjFPOQQbDKqZMGl7Q6V2h3iS8A1RAikLaZX6vbH+A9VA2qLPWhn9JNcX5ERm9Byr9T+qTkY3SJ+Uj5vN+1Rer0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789133886; c=relaxed/simple;
	bh=G5oGKlY5PoXFYrQbr90UtLh0FPDjEic/9QCE85WaxEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AXpRNEsx8lk29TR0E3ueCblscqM31hBh5V7rrSbbqj6xtHfQE2npkhPNOAgFQTHwsDepjWxmrPaPDiSRwvdyG5gt+SDYDvwPtJppK+cmcLfIieV4LQkJBNpREN7sVE9KXg6bICyymWIw1eeF68l9goT8BMDEMipzMXPpMsdK9UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Rt8QOKAS; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Rt8QOKAS"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cd38e0f79so5557955e9.3
        for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 06:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789133883; x=1789738683; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=osp+4Cm30+6Iu5OpGQes5EkKoH1z/cunw3a7Qh7uS1E=;
        b=Rt8QOKASasJGNmmR9ka5Uo0n52yNMcx9eminTOAlN2Y2IsC4LbUyqxUpYNHYnvzypN
         P7EXQliT49Kw5BRVv3FizFn8HKTgXIhPyzLldEaHbRw+uFMp0TZe7md73931yYn/ixOS
         ttOpPageH+Y57cJmRDoTWoUjqjPEOvVqgLAhXycJZaY/ZoKfPS9Z9lyRB1k38CR8eROB
         hfXeK9XuvRPXkfFo2Nfwm/mNjlhO08nojmBdRoIl6IzV2iw1F0wqZuML/SBcTArMrFgS
         ahVJ3f0efAWiYMITMsrHVtAdjU5R4EjN1TGojSjl4/u496GzUTiR8FKPzNwOBGibFbR/
         aDPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789133883; x=1789738683;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=osp+4Cm30+6Iu5OpGQes5EkKoH1z/cunw3a7Qh7uS1E=;
        b=XaOYsZ49ydrQIjnFyRZicx01DiL9cdAr+o907ulihVPm+Qq5EaDN5Ftxe36sHoz4HG
         pkD/lzjptDDAlKWPCGVvWuvzcsFdTVw3nh3JjxCFLjs+Ne1DPr7WNSHLxeqwY8bvF4Tn
         mXNJqgdP68b1qMTlatKBZiag7QwBtsRm+eYSq947WsUnld45ObPzuIX2Col0UtTj55aN
         4akbobZXUQa2sovRre+1LidHgsTu/uYU40QQ12RsMQzyti6SGPpkp6RpLHcKrbqip53f
         rDXFAjJgnDyKWoZYSbwKAjtyP/pNTqDPxMnNMdv+6rLN1wEVCaQkUx+PkmRHs79rVPoy
         Y2uA==
X-Gm-Message-State: AFuF++kSTVG++ZJoJ+Oss8EyRPFwOhr/MGL9g5stjOerqLVNo93knK0R
	ITlzR4pAP0LtBwMW4F4A2zDZ6lXGHIt3quF3XBYJbGtPt9VCBJydb0Zd/vsHfOhBFPM=
X-Gm-Gg: AYBFou38SkcKCnLvvbCOxj+txiljoeuV9VrAgAuLsbefkD6DHhqzXH9zddfpWrOHbam
	xzDgqHVNgtQHPBomrWpkCSSn8rGPiUgGESbPh9k1Sn/MIetOuWuyv48aD8r84s3mUIdzwv32cwg
	SHQU5bwJd6fNITV1/IRVCUU2Om7M+4F5p+/pecOPEqZeov2d8cDSu3wE4Fu8N/vGG9AbQqMphYh
	UyM0NlYUOvZGG5h29VIbq9RcNv40N2cPVcC64tgMTV0Xf1XV1uwWsgbnEjE9f1/19x9Ha9BdwtE
	chifL+jb6RnNC7KKXe0hKJAhQ7fldg6OkSCY1CNsl8ioSRngPlRoAyFc7rvbJ659KZqzhBpC3OI
	WfTAv6J/YlztsWBHo9src5pSUVIoPIU20NUvQF0ybpUB7DtjujdffJmrnSGMUnYQFfPQrEBI7Ul
	YCGxOrDvtCmzFdTSTTqacRnkxOYpV5FsXhInf7zdbYpzB+XqbZ44ykMYUdyHtZxP+I7cjdhVjYZ
	g==
X-Received: by 2002:a05:600c:3494:b0:49c:e3c3:5efd with SMTP id 5b1f17b1804b1-49e619aab42mr116115395e9.9.1789133883115;
        Fri, 11 Sep 2026 06:38:03 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d26d49d57sm148647335e9.14.2026.09.11.06.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 06:38:02 -0700 (PDT)
Date: Fri, 11 Sep 2026 15:38:01 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] cgroup: Move cgrp_dead_ task+iwork into its own struct
Message-ID: <aqQEDRSoZDnsCTC1@localhost.localdomain>
References: <20260911101900.984420-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xwykti33if7bkyii"
Content-Disposition: inline
In-Reply-To: <20260911101900.984420-1-bigeasy@linutronix.de>


--xwykti33if7bkyii
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] cgroup: Move cgrp_dead_ task+iwork into its own struct
MIME-Version: 1.0

On Fri, Sep 11, 2026 at 12:19:00PM +0200, Sebastian Andrzej Siewior <bigeas=
y@linutronix.de> wrote:
> cgrp_dead_tasks and cgrp_dead_tasks_iwork are independent per-CPU
> variables and are independently accessed via a this_cpu_ptr().
>=20
> Having a custom struct with those two members makes it possible to have
> only one per-CPU accessor and access the second member via an offset.
> This makes the code a bit more compact and is micro-optimization.
>=20
> Besides that, it allows cgrp_dead_tasks_iwork_fn() to access the list
> pointer via the passed iwork pointer. This not only eliminates the
> this_cpu_ptr() but also makes it possible to be invoked on a different
> CPU. This does not happen as of today but might if I can flush the
> irq_work items from another CPU during CPU-hotplug events.
>=20
> Create struct cgroup_dead with the per-CPU variables as members. Access
> the struct with a per-CPU accessor and use the cointer_of() in the
> irq_work callback.
>=20
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  kernel/cgroup/cgroup.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)

Acked-by: Michal Koutn=FD <mkoutny@suse.com>

--xwykti33if7bkyii
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaqQENRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ah07wD/QHk6ijDMHWWVtRs0T6tN
4hMYgT4/oE3txfzgpwDOKYYBAJ8K8a3t0441GRf8yVMBArRz0dlxn8LuPgZoAc43
PCYB
=nk72
-----END PGP SIGNATURE-----

--xwykti33if7bkyii--
