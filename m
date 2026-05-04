Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302B32DF144;
	Mon,  4 May 2026 07:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777879732; cv=none; b=OpqrJcnQJh+vWZikLeadMHetViDdjn8GYemqpyNDs4fb0U2NpNQBMYukmEr9bhYknJGg0iOerC9AWT7GiJrL1EZPyizENk6cGPc2CV8PfMCjSV+t2PbDLhixbNmzi+XPC4BjEyXKz6jly48MJ4gGR7Ax6CIrsticmAAc71NEmcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777879732; c=relaxed/simple;
	bh=U8grDQsG4o7FCiABmuvMOAKAJ8HFDRDURCKVnfrZHKA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iO0Y1lOpyZM18IWynt+4kKKCEzWZsVNdmhlkulJUzFXPxRptb2JO8PmkGW6YgO/1WrZW3vzCfxFwQv5wq7pPcDaWC1z1CJwft1hhaSFUiGzmBfz8jgf98/diyblZ9X+oEByanthgT6+eRf+cWe2UFzwc/0srxRxUKwzXu1KLjI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=lkB0ncpt; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=tQ+TTJPc; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="lkB0ncpt";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="tQ+TTJPc"
Date: Mon, 4 May 2026 09:28:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1777879728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U8grDQsG4o7FCiABmuvMOAKAJ8HFDRDURCKVnfrZHKA=;
	b=lkB0ncptDjO+lD0w9K3flKDJovPeaeaIw8NDSAliM1dIacRt6kQQGQB9pQKmdsTxgEo5lg
	TCdR2MfMWr2JFylxeDeg/AEx9oh0LsLmmauPc3w2udkzICEvBq3wSDLQI03jMtzkbpqv6w
	91dcYogTzI8NZpqhP3wz6vaRutTT5Dx+1F7ZlrGrHkn4XSroDxVGm5YDwfI2iulLPWx27X
	GFf2c3g+OdofvMjbrFyrCJSd2LNyaaQYCJD/P10r5dsPPhwYD+nZljQEHOfEX0ulEJu04s
	iWD/jr38opR4lOdBqOofm7iMIu3yLuVQ1WL2XSnJ11bFLDR/Klq8Z81KJVPeqw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1777879728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U8grDQsG4o7FCiABmuvMOAKAJ8HFDRDURCKVnfrZHKA=;
	b=tQ+TTJPcsqIc5w5QGGg/5Oomn1KVNn4g1lIwIImtqX8PhQyW6/+Xqle7GOoLPvuQClk/w4
	uSoZbZqe16NWtzAg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Tejun Heo <tj@kernel.org>
Cc: Martin Pitt <martin@piware.de>, regressions@lists.linux.dev,
	cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 cgroup/for-7.1-fixes sched_ext/for-7.1-fixes] cgroup:
 Defer css percpu_ref kill on rmdir until cgroup is depopulated
Message-ID: <20260504072846.qM4LxsIF@linutronix.de>
References: <ad3b4597f3df81914b871618535370db@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <ad3b4597f3df81914b871618535370db@kernel.org>

On 2026-05-01 08:31:22 [-1000], Tejun Heo wrote:
> A chain of commits going back to v7.0 reworked rmdir to satisfy the
> controller invariant that a subsystem's ->css_offline() must not run while
> tasks are still doing kernel-side work in the cgroup.
=E2=80=A6
>=20
> Fixes: 1b164b876c36 ("cgroup: Wait for dying tasks to leave on rmdir")
> Cc: stable@vger.kernel.org # v7.0+
> Reported-by: Martin Pitt <martin@piware.de>
> Link: https://lore.kernel.org/all/afHNg2VX2jy9bW7y@piware.de/
> Link: https://lore.kernel.org/all/35e0670adb4abeab13da2c321582af9f@kernel=
=2Eorg/
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

I gave it a quick spin, everything looks fine.

Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian
