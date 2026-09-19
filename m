Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114C117B50F
	for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 00:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789777056; cv=none; b=J4QPtXYpduq6IcHPMM3i904shYhVglJ/KorRaQwp/Of/XJ/5Zuuh2zcPfRwA/2qykgOA+qd+KTU2OciRLS9n6hUAvCCxwdtxqRfD5vgXsFsxiiNRzqnyIeQEnSjg82DJymt5Z6Cl8azlBf63BDtQ8l6FIfcziJyLZQ1n/gMe0+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789777056; c=relaxed/simple;
	bh=5dFRbpytj6bE76XihON6nsd38xUmBkF7Bqr8TEFGxDA=;
	h=Message-ID:Date:From:To:Cc:Subject:In-Reply-To:References; b=iO9gtSd/EAAeEYyszRyIsLTkkOdF8H97vWL0i0K0RNsUMXH6qTyFYrmLhCuNWm2J6+52ncisZiJyhPfbxItvvGFKuEkwJ0dM1EZlgauPf4mFtucmX+mvI5LFLcLA3OjsHcFAPlV3QFzZDhLoZHpw94No+d/daB4R3HUoJeq2xqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WOes5ecY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WOes5ecY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC091F000FF;
	Sat, 19 Sep 2026 00:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789777054;
	bh=5dFRbpytj6bE76XihON6nsd38xUmBkF7Bqr8TEFGxDA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WOes5ecYtSTYnCinjXZmDfVEQb+H89pb8RjVPDBQu6I2UJWf9NNv0osPbf5VRaw2b
	 RZQncqDQcpnZT0evUE5StNeO1vN87XiobG9NHfYjJpa1YTF46XzcTVGzxW8lJNi9r9
	 gQiNgVAMNuNufK7JWXs/BxJA99ZXGh75D9yaMcezOc1TyYLeFh5i6ZCUoFlZBnHQCX
	 AMGAfPmuhFvXjjl6LhnMFLspySIHBzEsxSQQJMK0SrLWPW5Iw8SLGndDz4iED1+g1D
	 CZusEWRLpgo7knEeqO3G4GPRDviTrqplGUbOuptGwKtLUXsQpmq2+L4cu77dqvh6vk
	 x++MGA2vViRPw==
Message-ID: <82bec8f155d6c3807cc54a7712ebba8c@kernel.org>
Date: Fri, 18 Sep 2026 14:12:44 -1000
From: Tejun Heo <tj@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Subject: Re: [PATCH] cgroup: Use %p for pointer formatting
In-Reply-To: <20260918104852.1p2fz_-_@linutronix.de>
References: <20260918104852.1p2fz_-_@linutronix.de>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied to cgroup/for-7.4 with the description reworked to spell out the
policy exception and what changes under kptr_restrict.

Thanks.

--
tejun
