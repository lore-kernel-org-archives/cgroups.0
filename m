Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794774451;
	b=e+z5wFWhqfd+9TcRBp6EMjuVyEJ0SrbXk/Tn6dzvRz54s7pGfZf0xTfgzPgMrDNcK0XR
	 QaFLrTzWiVNC3tTy2yrgP77jeoSSWJ0GtcSMKvIP35a9bscz6Ch1RZv7YqrHNDemtbJXq
	 g3tV9L1SItoHCH3jkddfLUsb1B3k3SrfkfD3rWjuKYhTsDllhuYZ4MLqx0vN7tk4Nx+ZS
	 J3pbDVoTmnKAeXqTWKIUDQwG3tmLxE0TGk/tMrVxAz5nVQo6g1XbuS8OKwX9ROa16CaV4
	 ID6dNW0aMzWLvkG4MMeYiXL/xt+1z45mVRYb2fTmc/OqQpyX+uER7BfnDsfXOZzhxGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794774451;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=6F7GohaU+f0XhXsnA+vm5qqsTSHoj5QYEFtZjmUjPrM=;
	b=ecHW8kWv0ryvQlWMiOOH2ZO9xa2xpTFogafzdd7J44VKqfxo1wuF2aYFNDzEh9VfR8G9
	 stFiOFJ8UUtbVBvesg+nwXYehMYU/Jyth3tVT3HWLss4v0+VMEBdnL73eMG5kL2rEQY4R
	 bSxmfgwOC49fWJC2wxny42sy2XgG4HvmCdAsajtXNzcPYsqh6JJw7iakHmSvesF4c7C90
	 w65liDE5NR7KVCyfQDfiZyzTaALDn3w9zOD2o4NSq5dEzq52skP1kr23pNLJxPRPPd1Oe
	 J6MkPWHTHMaSa2vTWwua1MLEABFTDE6NCAbRdyuI5gsInnb0tkeT2drzoyIXe+gAyGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PNujdk8k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9DF606A882;
	Sun, 15 Nov 2026 20:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PNujdk8k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD87C1F000C4;
	Sun, 15 Nov 2026 20:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774450;
	bh=6F7GohaU+f0XhXsnA+vm5qqsTSHoj5QYEFtZjmUjPrM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PNujdk8k9mNExTnYJJrC8QqS9lcjgQsIPEij1wVTJTbR4WhUaKiAx+Vd2aNJnBG8J
	 BkK18M8URcFMJf+XG5j9Vk4pQSPAb+OkeIIuVJGuuXHFtdsnNY47pnLP9ZYXrJS92d
	 5HzopfyU952aHicmEJur87q3Vp6qpaLEsvp+FgX+4kRLoIzZJM87cqdz2bIPuHWg16
	 fiTu74onJG6UWxVYN8ZkAKhdHrClAEnTRufN5jFIRqZDW6FejUPPUVIKWGw8OO9Nn3
	 Sw+Aw+yaGRrilM6B2Zs+diQUwCbHtoVuz8fGqJTbqnbraj1ZyssHK8vVgkj3Nctk1Q
	 haMn/x8nP24gw==
Date: Sun, 15 Nov 2026 10:27:29 -1000
Message-ID: <cf99dd7c0d427313f28513270e3f2bc9@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH for-7.4-fixes] cgroup/cpuset: Remove redundant WARN_ON_ONCE() in remote_cpus_update()
In-Reply-To: <20261114100612.1380464-1-ridong.chen@linux.dev>
References: <20261114100612.1380464-1-ridong.chen@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Applied to cgroup/for-7.4-fixes with the following tags added:

  Reviewed-by: Waiman Long <longman@redhat.com>

Thanks.

--
tejun
