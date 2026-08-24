Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF9346AA8C;
	Mon, 24 Aug 2026 17:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787590818; cv=none; b=rIhlPWN2GYbthOuqgT5QC6weJWp0Y19yflKawFH8HRipLy4KETB2m0xSjUYHhuEkDk38NoOz713SUPif23C4RY5SazwnbCTFrigaKTC26CfAkNQGC6YU14PNZSNiBtDpv4TMJxEuLMu/SBe6u5B+0Z2FjMjCkS/ksZUOLcL+/6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787590818; c=relaxed/simple;
	bh=2nzSzoycrfwe2uud5bUJoBtH/3BuHnvkcQd1i3N2lQs=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=IEyx9G6rTT6jxdHm+MkbWUUvP8SlUSM5KpOm3QNd5pO08cMPUa3VgGbOntGOcM//c1WB+CTh5UehVcW27PZJ/fPpXClVMs/0Gyyn7lsvX6KM45ek2qW5N6ioH+p8iE9/8lcK/bCdyJbZ5zrjG+D8jUT/BIXmMHKIvDjlmIRi81I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LYZfCPsP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LYZfCPsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4A21F000E9;
	Mon, 24 Aug 2026 17:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787590816;
	bh=2nzSzoycrfwe2uud5bUJoBtH/3BuHnvkcQd1i3N2lQs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LYZfCPsP43oqSUoiIybp/Z6HI8UG6JjBDvSOJT8WQ5M7eStFQ/gDYksrF8xsEiZ7Y
	 a2UsYjF1AHx12BO2/ORy08r8UGxv6dB/r8wyLvzXmZ7nUAmUhnWQDGk2bMJ9Z/XfSG
	 2h0XwhmbCbPIr5sVIxNzDVG1k6Gg62E/zxovsCKtydvXEOSf7J3jWej6AVTiMwkvVW
	 J5rrV+5Os28iwplZiwC9jHknhvm3ShZvscfQq8COuroA5fEHo6ShuF8wNrR2bTan+b
	 FVsHoGPtbpZb+qpKPKYTtXgbm91xH6FfZKH3G+fHHlUUsp6Nth0kHXhhmXaxCralji
	 IYcEVl4VwlGcA==
Date: Mon, 24 Aug 2026 07:00:15 -1000
Message-ID: <1d7232c615f2077168b49f37486f826b@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Cheng Lingfei <chenglingfei@foxmail.com>
Cc: hannes@cmpxchg.org, mkoutny@suse.com, corbet@lwn.net,
 skhan@linuxfoundation.org, rdunlap@infradead.org, cgroups@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] docs: cgroup-v2: fix misc.events key format
 description
In-Reply-To: <20260824-master-v2-1-00331c3cfb6e@foxmail.com>
References: <20260824-master-v2-1-00331c3cfb6e@foxmail.com>
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
