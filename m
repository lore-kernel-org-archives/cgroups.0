Received: from mail-24420.protonmail.ch (mail-24420.protonmail.ch [109.224.244.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123D94F55C7;
	Mon,  7 Sep 2026 15:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788795846; cv=none; b=GCm64SIN8MDvAzC1iAi85wK6WoxokpSu4yBPTS1b3BvvZLkij2nohyQr0Mb96f74duJmLfnOzlXJB/pZU31ncaUXaOZXSPqHD6KZY+MRlDYXSmAXaVU5NHGjnyLsMNCEOnydYxWQJilzZcXCcZC1wxBAcS+rPKfgcphdxwePt38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788795846; c=relaxed/simple;
	bh=/FZgfDnGoX+ire10E4Wl1AsaNQpBCMc+mcsKWPqtva8=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=AFCrMnB8dMbK9FTF6AyHUCqgW/MOZBefHVqeDalxfmG0iHcSDhB0ZRQmnWyfc1cmDrFPwniD7SKmUo8LBHXKXZ8t6quNNsokvZQ08fDeVyghXRY2AhlpFSCSyxzoKO3Fr646Xof39DWlZDqEyRsaCyNrOt4xc9e9BMILElqH92M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=feldt.systems; spf=pass smtp.mailfrom=feldt.systems; dkim=pass (2048-bit key) header.d=feldt.systems header.i=@feldt.systems header.b=eHm0Yb2t; arc=none smtp.client-ip=109.224.244.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=feldt.systems
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=feldt.systems
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=feldt.systems header.i=@feldt.systems header.b="eHm0Yb2t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=feldt.systems;
	s=protonmail2; t=1788795832; x=1789055032;
	bh=pkR0D31rVu/YiZFmAIFnyb6QlSompEq74ZW7OV+Buog=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=eHm0Yb2tXkhaq1Hi6N88Jp0UhGxnSj2elmLEjvoPvAnllGYcDqH2TUJx36X34mlwy
	 iFotdLlZ2U9BkDs8kckgvcZaAvhBZeMC55BwCy9wwK2bZvKZbY2pJILN4XO2ikGcJ7
	 /qME0UbcGiz93AJov3MaTBaMHxLxPDKdpQu/5pgxzk/04VllByj0t4c02Wz+5XDkfD
	 QxC47pNUvUZgPvrOiHCzoftEKdZ6Q8hfbrRCA0bMOtDMdx3w+F5cnU3ryc1/8C6QDr
	 A/p1WF1pd/BxE/Ilht/o9CBUDJqp+ZcFf1lhnW3lpRCuVkS1W0hmkMW+SL02mrF2Iy
	 Z/B5URMOuVxaw==
Date: Mon, 07 Sep 2026 15:43:45 +0000
To: tj@kernel.org
From: Noah Feldt <noah@feldt.systems>
Cc: carnil@debian.org, cgroups@vger.kernel.org, dschatzberg@meta.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, mkoutny@suse.com, peterz@infradead.org, stable@vger.kernel.org, Noah Feldt <noah@feldt.systems>
Subject: Re: [PATCH] cgroup: Avoid iteration of dying tasks with zero refcount
Message-ID: <20260907154324.91918-1-noah@feldt.systems>
Feedback-ID: 113045274:user:proton
X-Pm-Message-ID: ba06ed4c0107d1cb5ab091803c083e11ed334b3d
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha256; boundary="------dbd54100772eff0bbd62aef01cb43fd7b87c958a643f8695175bb7b3b4cd37cc"; charset=utf-8

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------dbd54100772eff0bbd62aef01cb43fd7b87c958a643f8695175bb7b3b4cd37cc
Content-Type: multipart/mixed;
 boundary=dc970138a169a5fda25c477f7c7829e7fcd8bc377702300cb4a26856e571
From: Noah Feldt <noah@feldt.systems>
To: tj@kernel.org
Cc: carnil@debian.org,
	cgroups@vger.kernel.org,
	dschatzberg@meta.com,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	mkoutny@suse.com,
	peterz@infradead.org,
	stable@vger.kernel.org,
	Noah Feldt <noah@feldt.systems>
Subject: Re: [PATCH] cgroup: Avoid iteration of dying tasks with zero refcount
Date: Mon,  7 Sep 2026 17:43:24 +0200
Message-ID: <20260907154324.91918-1-noah@feldt.systems>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <aphyG4kapy2MBcnH@slm.duckdns.org>
References: <20260902161653.1051794-1-mkoutny@suse.com> <aphyG4kapy2MBcnH@slm.duckdns.org>
MIME-Version: 1.0

--dc970138a169a5fda25c477f7c7829e7fcd8bc377702300cb4a26856e571
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On Wed, Sep 02, 2026 at 08:59:39AM -1000, Tejun Heo wrote:
> How about something like the following? It's more in line with other skips
> and the resulting behavior should remain the same as before:
>
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -5228,6 +5229,21 @@
> +	if (it->task_pos && it->cur_tasks_head == &it->cur_cset->dying_tasks) {
> +		task = list_entry(it->task_pos, struct task_struct, cg_list);
> +		if (!atomic_read(&task->signal->live))
> +			css_task_iter_advance(it);
> +	}

I tested this change and the crash did not happen anymore with the second
PoC I sent.

Thanks,
Noah

--dc970138a169a5fda25c477f7c7829e7fcd8bc377702300cb4a26856e571
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="publickey - noah@feldt.systems -
 0x9B02BBB4.asc"; name="publickey - noah@feldt.systems - 0x9B02BBB4.asc"
Content-Type: application/pgp-keys; filename="publickey - noah@feldt.systems
 - 0x9B02BBB4.asc"; name="publickey - noah@feldt.systems - 0x9B02BBB4.asc"

LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCkNvbW1lbnQ6IGh0dHBzOi8vZ29w
ZW5wZ3Aub3JnClZlcnNpb246IEdvcGVuUEdQIDIuMTAuMAoKeGpNRVpuV2ZveFlKS3dZQkJBSGFS
dzhCQVFkQWpjOWlieHJoOExkN2E3YjdBM1hXUnZSdGt6V2cwcEZUaUpDTgoza3J1ZnM3TkoyNXZZ
V2hBWm1Wc1pIUXVjM2x6ZEdWdGN5QThibTloYUVCbVpXeGtkQzV6ZVhOMFpXMXpQc0tNCkJCQVdD
Z0ErQllKbWRaK2pCQXNKQndnSmtFQlN1OWFxLzJDcUF4VUlDZ1FXQUFJQkFoa0JBcHNEQWg0QkZp
RUUKbXdLN3RGM0s0QUt5ZXdZWVFGSzcxcXIvWUtvQUFFSjdBUURaRlZLOGpTa3FDSk9oS1NsTVp6
T01Ibk4vQjhyYwpHZzlXei9UdW1lejVwQUQvV2l6V2xGem4xT3NibzBzV0U3L25FLzRMaXRKS2k0
bjlObUVGczRob01BVE9PQVJtCmRaK2pFZ29yQmdFRUFaZFZBUVVCQVFkQTc4U0JLZkc1Ymd6SjQw
bVZxTmNGUnhqc0lTT0ovVW4rZU1TaC83MkQKVUVJREFRZ0h3bmdFR0JZS0FDb0ZnbVoxbjZNSmtF
QlN1OWFxLzJDcUFwc01GaUVFbXdLN3RGM0s0QUt5ZXdZWQpRRks3MXFyL1lLb0FBTWJHQVA0anZ3
YlBacnFSY3dzRk5VdWI3aSthSFVTY2pwQTJIazFUdTBKTG5HWTlMQUVBCjRBOGQrWGNsdEVhUEtp
Vi9sbzh2RFdPaFBBQVBhbTFuQi8wQWhlenh1UTA9Cj1jQkVoCi0tLS0tRU5EIFBHUCBQVUJMSUMg
S0VZIEJMT0NLLS0tLS0=
--dc970138a169a5fda25c477f7c7829e7fcd8bc377702300cb4a26856e571--

--------dbd54100772eff0bbd62aef01cb43fd7b87c958a643f8695175bb7b3b4cd37cc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wqsEARYIAF0Fgmqe268JEEBSu9aq/2CqNRQAAAAAABwAEHNhbHRAbm90YXRp
b25zLm9wZW5wZ3Bqcy5vcme/3NRsY21mPDC//7NeCXIuFiEEmwK7tF3K4AKy
ewYYQFK71qr/YKoAAJBsAP0YmhyeD0Z8ayca+d/HTzh64SzpYVy+SHMw4NgY
j7FifgEAn1+GGegrKm6a60b6WFOZ2bs3GcqWu39YMWKXDWTedAc=
=oh2O
-----END PGP SIGNATURE-----


--------dbd54100772eff0bbd62aef01cb43fd7b87c958a643f8695175bb7b3b4cd37cc--

