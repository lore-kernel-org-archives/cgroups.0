Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3275A4DAF8D;
	Wed, 16 Sep 2026 21:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789595815; cv=none; b=JVGNXPJWTKEXxPMS4eIg+SE5wcpybLo5nnabsOXZDYdSXYhXaXLzYf43ryhr+eHI9+n6fNdz4Fu6dQzzOqYjqb3y9vi7Xelt08WFXcdFkk57cq6cBWdMIG7rv2DsQFFKKgNyfCEyLe+we9l2xmSS8smF4+Jv5/+sf4stZwYkDAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789595815; c=relaxed/simple;
	bh=2nzSzoycrfwe2uud5bUJoBtH/3BuHnvkcQd1i3N2lQs=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=k7jNjHIo8KYfCfSqAwwY5nxyvvTjOrjRGY3tu8AMTH27RUXXA1BiOi0Untw/Put+b8NIzSN8xBebaDuwSWbisRccAF5BIoKY+5WsXanWloJQnKGWephj15VKfugGqOM9aXbdYBj6N2ioF60gDe7aVdCA2+9P+pd0Mp0o0DeWfU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fAU30XFz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fAU30XFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B631F000FF;
	Wed, 16 Sep 2026 21:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789595800;
	bh=2nzSzoycrfwe2uud5bUJoBtH/3BuHnvkcQd1i3N2lQs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fAU30XFzau1IdUZkaB6jcPh80bDm2sKByD/lKwEe6gPUHVLmJkfCNTDwOZHh2wcmN
	 FuymcrJsHhKKGqfY/IECeyBbcWROtF1X1OoAlMsq0Z/GAf7/ggXEB5FakQSloh358t
	 ND1I0agZjYRuhiIVJqrlzmZGTlkR9/n62sh+dbHlNLm4tj3+6FEh6uKvLNVj80Wkrd
	 uowdDr3uUJXcuQ4dJIVtakuFbzqUpDjKmJRdHL7j8T6iSqd10B4LgtVN9RIRfG5zsk
	 NF9l0z2tZEZa8+Z4m7oT9atTbBEcDdQxKrL0y+EjuMTT+64emTthiSp255O97FGEKH
	 bTIys84YGGSWg==
Date: Wed, 16 Sep 2026 11:56:38 -1000
Message-ID: <a294a7f90be611f6da094421e5476231@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Dan Schatzberg <dschatzberg@meta.com>,
 Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
 Noah Elias Feldt <N.Feldt@mittwald.de>,
 Salvatore Bonaccorso <carnil@debian.org>,
 Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3] cgroup: Avoid iteration of dying tasks with zero
 refcount
In-Reply-To: <20260914121911.98132-1-mkoutny@suse.com>
References: <20260914121911.98132-1-mkoutny@suse.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied to cgroup/for-7.3-fixes.

Thanks.

--
tejun
