Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16D14D5968;
	Mon, 28 Sep 2026 17:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790617269; cv=none; b=p6gm4tBae3Wvay675nwobzG1L026LIxttYthbGEg2CjHqrnUXvsb9Bes7mIQrAnBV8rJ26WUExdPLLx563Qrvb3RF2Q8l1k8wWt5tgUA+GCGmcZ7k+wBvmY+0n6D6UQeQtHSu6jClJBAnGh58ZSb3RcbEar47ipJVKSqtg1puJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790617269; c=relaxed/simple;
	bh=AVyqwNOIJJE5Oy3B4xEkPP3qtlBr1Bdfm7ljQsvQro0=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IBMpXb82HUXzkCxHnziKrSLqylt5vZ39J+z43//DxqpYdBwtu6wLDGKrDaa+YOljaPm4jUJQipjJo9CySScXbkITPHuJRulneBcdCYGPswNmk7YC7ZZGqE+SsaBDWXg9KXWk5WgqYPcVgtf9C608K658YzhK6NWODzbLorw2DUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yg10KL/+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yg10KL/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C731F000FF;
	Mon, 28 Sep 2026 17:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790617268;
	bh=EGK7hzu3kS+Q802LB49BK6eGXyLzJjAB2nye+Q5bYmk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Yg10KL/+/ufY3qgdehb7Cfswu34PjVpeh3FP4UzeG77bVliA5ST71opYOjB/u0VLp
	 QAVlibDBf5mMADY00ByyG2vVFe/qAcftdNdft8klgtrpIdjJla6i33rTSFg48erDPO
	 85cKSbvKgPv9XTx1cEJ3rdx0eaQbyLHyOXYqZ43FDlVH1qLxF5GqbHFtQW/YwLQLWb
	 QkqRwYPNbNSGBjzkLUAFCaWuui65L7cSs6dQpeHS6EIGcsbTCF8pOVRBdn/qbe32Q5
	 x5EJDPM1xsG1lnQgS0KsnSjotImaf+1Rwevs0UC4PVw7ixepyZKoOANgGyN2MH2Ffj
	 3oEaDF3GpzRUA==
Date: Mon, 28 Sep 2026 07:41:06 -1000
Message-ID: <dd3f091c8b820c4c0ab39aa737d662da@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Ridong Chen <ridong.chen@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Hui Peng <benquike@gmail.com>, Guopeng Zhang <guopeng.zhang@linux.dev>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH-next v2 0/2] cgroup/cpuset: Run SCHED_DEADLINE shrink
 test on valid partition root only
In-Reply-To: <20260927215319.382422-1-longman@redhat.com>
References: <20260927215319.382422-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

> Waiman Long (2):
>   cgroup/cpuset: Run SCHED_DEADLINE shrink test on valid partition root
>     only
>   cgroup/cpuset: Remove CS_CPU_EXCLUSIVE handling code from v2

Applied 1-2 to cgroup/for-7.4.

Thanks.

--
tejun
