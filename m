Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631CE41167C
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 12:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787575025; cv=none; b=JU5x+srCH3v2Zb49hZtBErtJufTkRIBT36g1azL+OpO1R/anSOvnB/5ynInZ5PJfDoBA2pBg1/U1+Y5FsOEhWs/8a7RZWv8DkA0kw+c562uoq8VJADiBj0NNa92zKEUh7K9cgnRpuAzmF8kzVpleDbaTJyNTuBm2eIySB+1b8F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787575025; c=relaxed/simple;
	bh=vMMjMInCck9yF8tkMjBlrSp6ScF2a084G6L/dqZn6ao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XDNJkJHUmtGdtK7PKd6gq9797hhIdVLs59R02idcxFzZA3xUN5SOXfESrUyGlIBeP6k5zB5zgT1+NjZAbHNdx652PMELXpC0IlJf1s5HBjcoEgc1sz+KGi0zsEHuQepenfNNa/zdBs+i8UdHoN5gE5iV3ZaIHVGRUxJ9B+X4Cs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=arczoRj/; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="arczoRj/"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a0c8283146so5832115a12.0
        for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 05:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787575020; x=1788179820; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=86o2mla0Wt4YoV7NQUB6bfRSm8bpfsWlSQQ8/iZvyTQ=;
        b=arczoRj/jMWSEsCGnxDc8QgLgbHeY49YBrwFMJjF//o9YhC9w6uwlsNHXTo+oprOSx
         TuAVykOdEMNqTbKOFXt0lNVkPMQZ8cKj9++jUN0FRUzbbyh8OPzqvaZ1azFKg6eCxi3x
         r6i3nrGkrO5R3F2h31uS8i3Nw/WhoyXIsrck5ejsfng/uH4rOqDXtc6hohOEVtMsHrfn
         H/BIk/gn+alS+Yn/L+LA4igVEkNBtFwvCni/bQiQBEe7NJcPn7ws3I74k2sRVLcxCxXE
         QxeTx2RbH5V0n8vRo6jjldYRoyz1oqcR4iRXdQD0swOinXot8cqAUZlJRtAcnX2JL8jF
         r2oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787575020; x=1788179820;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=86o2mla0Wt4YoV7NQUB6bfRSm8bpfsWlSQQ8/iZvyTQ=;
        b=pZNTVGDG9xEs7DOxX5Gbz17O6bL7OYJp5bd5o6uxvjRXpfZzyGsFWqxN07tFY99Kcb
         pVLBCEVoYl1jLZEXj3botrG1K9uQepn4bTZdidvIYzk4cAp5ebd/H2Ipw8k5vdwyo7DJ
         vKFxx/TsxmcjCKc/zVbFZ60nxr7rlf18pajRMei97d3XbuT1x9P+iOmbwY73l9bk9aVV
         L+COy7r/P+vAXs8JuFtQEbKQH9htAsmQX4/unCDFkZISx+UqMwNXGD5lZjK9kX32YGip
         XjYPj0v8eB39vkcWXZb4uB7D7/2PtdZ7YlR4gY4CSgES7HF7sLzH2b4RGJLHIR22tyn8
         j3+Q==
X-Forwarded-Encrypted: i=1; AHgh+RqH1FyUxgIn9p+8FMCrEX/Hp9dtLp8CLDP6Tu79PX1nGg995PvOo5uaGOty9g4odqoEZxSwYN+7@vger.kernel.org
X-Gm-Message-State: AFuF++m/8ycKggRq0kAiml87KpZ3WpD63YQXs2IqH1Yvmg0G1Y5rFaIY
	iDd0ZHIsnENmkHoKKUjsPMxl18P/pmpI6AZZr3OpaAso5Oayha13103anLOymzxu4is=
X-Gm-Gg: AR+sD127qLsVhEoYMaqqZkK53sG2m5TRX+w/P+nA25YTEbX7CO+PTRVsqyeXnuYRsyQ
	RvXaji95KBGkoywx/Y1jZwc3iUmzjGuK2Xush/WjJbJI28R7efAG8y9LOxK0IG1BAE4JbnORIXH
	4fed/cdfYKRKZFUl5PvVdW1icS1d62T9FLlZb/beXk7hf3QiKTRC10cnl6j42+E6cthVg9SmGxY
	ViDoy90dl8LgRPvIuwZ/nNOf/DViCbjN/Dc+zUgWxXtIXZ9dA6iy69efeUyqgid8ab/OxdUVIDR
	3pi+sJGdKnljz7XB/To7DuOXVNbiYlhIJgGNZXE+nZwvAeKUytAw5Ogw9/MIYvHiUIqZ6iXo0TX
	AMDzou/8+dNZukZpReYlwtJ122ResA7cl52MTA7gS3TohYOnpdI1l4pq3GvjRRHCNmHKQccDZ3g
	oTpw+4hG8Mci6hxhb2ZPdJEDtqXpCgh68Ir64eswLGYo/zZ9ViTawBTggpbOLF4GE=
X-Received: by 2002:a05:6402:52d5:b0:6a0:a644:355e with SMTP id 4fb4d7f45d1cf-6a42f1848fdmr30356559a12.2.1787575020160;
        Mon, 24 Aug 2026 05:37:00 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a5ba19e053sm2079673a12.12.2026.08.24.05.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 05:36:59 -0700 (PDT)
Date: Mon, 24 Aug 2026 14:36:57 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] selftests/cgroup: test_zswap: wait for cgroup to
 unpopulate in test_zswap_writeback
Message-ID: <aow4qP5gj9CfiOr5@localhost.localdomain>
References: <20260824033533.2147900-1-wfelipe@google.com>
 <20260824033533.2147900-2-wfelipe@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lsaln24baban35xn"
Content-Disposition: inline
In-Reply-To: <20260824033533.2147900-2-wfelipe@google.com>


--lsaln24baban35xn
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 1/2] selftests/cgroup: test_zswap: wait for cgroup to
 unpopulate in test_zswap_writeback
MIME-Version: 1.0

On Mon, Aug 24, 2026 at 03:33:57AM +0000, Wilson Felipe Pereira <wfelipe@go=
ogle.com> wrote:
> When running test_zswap on a single-core VM (-smp 1) with 4GB of RAM,
> test_zswap_writeback intermittently fails on the initial run after boot.
>=20
> In test_zswap_writeback(), after waitpid() reaps the child process created
> by test_zswap_writeback_one(), writing "+memory" to cgroup.subtree_control
> can fail with -EBUSY. Under cgroup v2, enabling domain subtree controllers
> is forbidden while any tasks remain in cgroup.procs.
>=20
> When a child process exits, exit_notify() wakes the parent process,
> allowing waitpid() to return immediately. However, the cgroup populated
> task count (nr_populated_csets) is only decremented when the exiting
> task is switched away via finish_task_switch() -> cgroup_task_dead(). On
> single-core systems, the parent runs before the dead child has been
> switched out, causing "+memory" to fail with -EBUSY if written immediately
> after waitpid() returns.
>=20
> Fix this by waiting for cgroup.events to report "populated 0\n" via
> cg_read_strcmp_wait() before enabling subtree control.
>=20
> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
> ---
>  tools/testing/selftests/cgroup/test_zswap.c | 2 ++
>  1 file changed, 2 insertions(+)

Acked-by: Michal Koutn=FD <mkoutny@suse.com>

--lsaln24baban35xn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaow65hsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ai0QAD9GkXMc6bI0AhzKJwbSaqE
aI4XwcIv1S0SkdLiNbkxuPMA/3XaRn1ZHXQ5i2Jrq1+ppT0VNUvfWl9IlFN0Wc/x
KzEA
=DvGz
-----END PGP SIGNATURE-----

--lsaln24baban35xn--
