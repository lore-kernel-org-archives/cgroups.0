Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C2538331B
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 18:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787596072; cv=none; b=ZzTyX6hrxruZoW7cALq/lORmg8ZJAGZlF8wtO5SppuqrQQvnLCb9UHpSnjCTNzmaMzyRackBtjorZP7LXxVCik2aDHJatoPaEuu26OF4WnXmANXOOrdlbrn0+jKl7J8nbLVNBoCSq/gaDWeZKRX5glTN+W2fmvyA1vLTOCVAl+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787596072; c=relaxed/simple;
	bh=13LELk8VSVqjwxGhmPIIBe1EWeOwasFsd4AmcyS2tJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ey+pL/dV9mtdkpPNHjejUhkIBMLdWNBhSAo4+A1mN+U+sAgC5tVzhlARRRRB/ptLbDL3DKwvZFgndeHjtWMwvK7MPGHWaScX1wNztYMKLV8k6sMCjCjACkXCSxuuaxg0oPNXmQo3Y8aQmOGTyWD63ZkY9kdCXejKk37CesBGcxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aU7vkXO+; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aU7vkXO+"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6a17cb94b26so7262785a12.3
        for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 11:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787596069; x=1788200869; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EB2B7v+uOalGTJhdsfkjyW1djogcDRKyPkWfgQX0tgo=;
        b=aU7vkXO+Fn6D4oXtWFLEZO/XFi6McErR0GCuPq/reDJwos55eRO+L2SVeIpOfZRxsF
         JgMRmSj5wq1U4aAlWZp/9Oi5S5pYbiDY+BUnFo8g6N4IerFcSoJslctGxR8JNA13zSty
         mD3qk361tGjE6niCOhgFaE4hSwmq0Up20dQfaUGajGaorsETtS85vroco1QvC+6/Zwog
         hs/3+zUvGNxIFpGIZylkgYtOiIgT6tDKD7JLjR7n0Wqkcw181vsABY0jnMUeOZ/L6e1r
         TzkDxe82YL40ZYarCq9ZPHwhtWyygcq2AkpuA6yJHIGa6Tp43oVxrpb55sUuRwdoYdYx
         FA8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787596069; x=1788200869;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EB2B7v+uOalGTJhdsfkjyW1djogcDRKyPkWfgQX0tgo=;
        b=owg6EN1o9tx+lp8h3oCdryyAIvIz4pM3FhXf9Rkj8M67mQPtZ4WRLQSKFYGUhI9rAR
         K4YSwyXeHl0d1QZZn/q6tPejhHKz++doi7B5DKZy25u4qKqLjE8IOChR9Tc1mZE137FM
         oUIYcU4vMKQTZxt1lSYrDW3vBbluEQIbfSv9gL3fc+B3z8Sh8kj24YE/juuivEplhmXD
         GFTBAHjpRtsmfhyGCDSkeRYSaueDQRxVvJGizvg1EqtQY00pwoTDayDB2fuYRvbeBU/I
         fgYXezWpMg6Y1e9j6oZ4LwCh8pxED09U9xR0GFQYO3mbeO/q/rz7sQwUVxvpwulXKpEw
         gzWQ==
X-Forwarded-Encrypted: i=1; AHgh+RqCmZ0nvG6RC4GG1SAkzOcYpcZqZnkmfw5QYt1s7aOTIXjHUdXyC++pVoe2Su2+F8u79uU8NaFm@vger.kernel.org
X-Gm-Message-State: AFuF++l1gbh8AlHbloeMPzhp5aA2Ev+OHu2LURmJ1POQtZS6ueYXZhZ3
	Vs1Vu8VnP/L6Afz2hIHcxintYpBmAwUW7rTaKb0BvJfPKiBS7nuB0rthnc8QBQV5yfg=
X-Gm-Gg: AR+sD12JK9SZT++DDGpTY503AL6GD0H96ptd16U1V5SBGD/NmP/2BlYkFDrpbvilTN4
	eFNJDNjRb7R+qJwP2m3adx/mPqWTblXrAUer+Qclp6fJVz5LjcBsTVYGfHvVderm+XWn6Wc5dRA
	i7tfgPO80y7wxkzQnI1Jz28hAqBjqg4XaluJzXIQMK8QN98b+D9N3o0efdmWt47m6zMi89NSrmw
	hjm+X/tdLUo7h+5Dcz5hCdIAYj4mIqFobYDQ4tP+n4i1d6H8MqyT7lsOVEejSGSEO2/RLptEzdt
	XMbqJiQJlsNm5HVBet0Jv5On3gmOWyOhDKSTlBahua87/CxeIOOsWjgNDRATxj3NwHQCE2bjX8Q
	nshggE/3vkrRkfKWfsvmsXvhmIm8W4VuC1WSo0FYhYHY3YoMETuDs6t/JqCmwT83q+BTHOGqMFM
	CMndKTXtypsKrjiNMy9KIhdHArQrlO9bSJVMoFagFoQ6pCOXX3kg8xO7/Iiztp6N0=
X-Received: by 2002:a05:6402:21c3:b0:698:5610:76e5 with SMTP id 4fb4d7f45d1cf-6a5c410e337mr705621a12.6.1787596069348;
        Mon, 24 Aug 2026 11:27:49 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a59dfff20asm10732159a12.3.2026.08.24.11.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 11:27:48 -0700 (PDT)
Date: Mon, 24 Aug 2026 20:27:46 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Albert Esteve <aesteve@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Eric Chanudet <echanude@redhat.com>
Subject: Re: [PATCH v5 0/4] cgroup: dmem: add selftest helper, coverage, and
 VM runner
Message-ID: <aoyLV5ovAaY15G-h@localhost.localdomain>
References: <20260706-kunit_cgroups-v5-0-6c42c8753468@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="oenytjx3ur4yv6iw"
Content-Disposition: inline
In-Reply-To: <20260706-kunit_cgroups-v5-0-6c42c8753468@redhat.com>


--oenytjx3ur4yv6iw
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v5 0/4] cgroup: dmem: add selftest helper, coverage, and
 VM runner
MIME-Version: 1.0

Hello Albert.

On Mon, Jul 06, 2026 at 02:06:39PM +0200, Albert Esteve <aesteve@redhat.com=
> wrote:
> Hi all,
>=20
> This small series adds practical test coverage for the dmem
> cgroup controller.
>=20
> The motivation came from following the recent dmem API discussion in
> thread [1]. That discussion considered changing the dmem API and
> adding a new knob. Currently there are no dedicated tests covering
> dmem behaviour, which makes such changes riskier.
>=20
> Adding selftests has an additional challenge: dmem charging paths
> are driver-driven today, so regression testing is harder unless a
> suitable driver is present in the test environment.
>=20
> This series addresses that by adding:
> - a kernel-side selftest helper module to trigger charge/uncharge
>   from userspace in a controlled way,
> - cgroup selftests covering dmem accounting and protection semantics
>   (including dmem.max enforcement and byte-granularity checks),
> - a virtme-based VM runner for repeatable execution of the dmem tests.
>=20
> The goal is to make dmem behavior easier to validate when evolving the API
> and implementation, while keeping tests deterministic and driver-independ=
ent.

Thanks for the dmem selftesting. I'll respond to first two patches
individually. I find the wrapper scripts in the last two a bit of an
overkill for the selftest (as it adds dependency on particular VM
environment, I'd keep the simplicity of selftests such that wherever
they are executed (w/out wrappers), there they run (be it a physical
machine or a VM). At most, I'd consider a simple wrapper that'd load
ensure the test module is loaded.

Thanks,
Michal

--oenytjx3ur4yv6iw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaoyNHRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AiweQD/WQd3+fVtfyX/uBnKUcuN
mXObyqxAxzxpIeCyeH/5EQgA/AytNhLSty77aTGrZcE9kvvawwinP4n5uzJoqzAA
EJ4C
=GGfO
-----END PGP SIGNATURE-----

--oenytjx3ur4yv6iw--
