Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9F57263B;
	Wed, 25 Mar 2026 18:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774461987; cv=none; b=jEAf633IgFE/eo9ZvoPbPtfpeApxwt5LhWPAtq3uqPk84cdpFZxdIfLRovBtuS6PFsya4IQtm7Xo/ycQyY1lU+uN40XSXT7m6pZVkB+TsDULHxlY0Y+PP6yZAMXzAy+FLhJws1gLtHDgtiO/H7uQptxzf7aOV3AAGWnaGJAWfMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774461987; c=relaxed/simple;
	bh=bD7MgkNGeu/Yje4V0Nr7YUOixmtk7YxumIFtxeHnw90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IkQQctbMYGBjBQS57VA1FLmH5LtdRDrPX5ZxbRcSfqRUh0id3FyOtDzdiq/fSwqo3bBrmZ4HOpOgojXj0KYFiYlXNwHcXUmeGdKJzPPtSluxnMobR/K1uMvxha/G1UvUq/2A6tZ+ZVevMNd+0dv/W3kxZ9jtAldU2Zca6onbu5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=f5KmIQxm; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=8e3O1glO; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="f5KmIQxm";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="8e3O1glO"
Date: Wed, 25 Mar 2026 19:06:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1774461984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bD7MgkNGeu/Yje4V0Nr7YUOixmtk7YxumIFtxeHnw90=;
	b=f5KmIQxmTtrxyQQ9o80lfRyp9VEq9de3cjg41orhSja1frgOuVyybJGcIME2TonXxm1/wV
	2/9/6V1VdAI3sxgOIYJeQs65pBfweoXP0NtGqKzmIdrJEv+eA8sepARP3s6i1ZJPkhrcNJ
	IgAByzL1tE/fMGUtoVPoOdZm77qotZtlrU4z8E1rBlP6LgSRLnDNhl+5Q9jZ9xkcVtc7tq
	K/2Q7/7tTIDHogKRwWzdoBWUj2MDl6PdSOLHymv65VEQrLbKBr/TJCUw0TvU5nQBBg/ZTy
	fPVEnIr7rKODPMuvi3KSvNZwrFNI7uz8D5TpLMy9u0LOekjzEkPWXvZNnNzGuw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1774461984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bD7MgkNGeu/Yje4V0Nr7YUOixmtk7YxumIFtxeHnw90=;
	b=8e3O1glO3toTLmT9JDpNbveiRsZYf2rVEVppEuBDjwzvf2CYdqfYrdsNOP3JJYtvwkzY+t
	g0PfQFZR5J818/CA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bert Karwatzki <spasswolf@web.de>, Michal Koutny <mkoutny@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH v3 cgroup/for-7.0-fixes] cgroup: Fix cgroup_drain_dying()
 testing the wrong condition
Message-ID: <20260325180623.EcyNsp2L@linutronix.de>
References: <68d8881fd985a410c0f619f009334c28@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <68d8881fd985a410c0f619f009334c28@kernel.org>

On 2026-03-25 07:23:48 [-1000], Tejun Heo wrote:
> cgroup_drain_dying() was using cgroup_is_populated() to test whether ther=
e are
> dying tasks to wait for. cgroup_is_populated() tests nr_populated_csets,
> nr_populated_domain_children and nr_populated_threaded_children, but
> cgroup_drain_dying() only needs to care about this cgroup's own tasks - w=
hether
> there are children is cgroup_destroy_locked()'s concern.
=E2=80=A6

Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The only issue I see is if I delay the irq_work callback by a second.
Other than that, I don't see any problems.

Sebastian
