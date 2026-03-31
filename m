Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E86738F93A;
	Tue, 31 Mar 2026 19:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774984946; cv=none; b=Jz0h+2vL41FLtyQqU6S0clMZ+R7MKi1UmzUARCGKGJ1e7FKz6Q+ULK8/msIsVQpvkfUH21J7Ioj3AHD664V9Fkh8Q2qkzTlW+v2jeuvpQvSXdTHrULt2U085k6fTzTyv0y0Tj7Z6jUCAY9jzaYBDFMeDB3oyn7adn6BwzPHSCVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774984946; c=relaxed/simple;
	bh=Sf58aoT19CsK3lZ2Pnvw0TdbAJjqX7vQdRpW4C8D3Wg=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=DZttEItrwhI6xHIyx3zsKvYUh88EgiruFuGF6RSH9XrPi/98ou2Ytj2+hl2Pe89ezmVrGoul1FeFrKR5ciGp8hmODkbhX92LMj8U43c8fTqPs+7jP0ATd7Gc35oLHFQNBseiOGZWDPNEyfzArwsinIqQmyt2blBR85jJ8MaHooc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gtYh4o6D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gtYh4o6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7471C2BCB0;
	Tue, 31 Mar 2026 19:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774984945;
	bh=Sf58aoT19CsK3lZ2Pnvw0TdbAJjqX7vQdRpW4C8D3Wg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gtYh4o6DBK5iBiS9pkLAspkisoq9g4XZwlUbIj2353A1v/jotYpQjh+74Qzq2zg1+
	 iIy3NVxnBjGVNSjYHONmlQ38V3FyUEFxUtc7039ySng9hkXZAVBqLu00kgeSEBWsXN
	 AR4MpeMoE7TNTlp0YyKRFAQSQ7mzoEnk9hh2JyWsWv96mjHae89bN6Kl8qE/H1VsVO
	 mgH5q/GR8isU7SVUyBG0+FCzMSskBvNMTaTbJhyHsmGIiwQMHCA1akxvq3G1lJwYlo
	 W9Tyydy8Cw3FI3ZyT2dLwJH0Z304Jx3BUUt1oOGTiD1Icx38tfKGcTXt6+dbFe1Gom
	 7I2z+m+RzQ39w==
Date: Tue, 31 Mar 2026 09:22:24 -1000
Message-ID: <ad03c6121974d063f409d5d4b2c7f244@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Chen Ridong <chenridong@huawei.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutny <mkoutny@suse.com>,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] cgroup/cpuset: Fix v1 task migration failure
 from empty cpuset
In-Reply-To: <20260331151108.2771560-1-longman@redhat.com>
References: <20260331151108.2771560-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

> Waiman Long (2):
>   cgroup/cpuset: Simplify setsched decision check in task iteration loop
>     of cpuset_can_attach()
>   cgroup/cpuset: Skip security check for hotplug induced v1 task
>     migration

Applied 1-2 to cgroup/for-7.0-fixes with a s/EACCESS/EACCES/ typo fix
in the second patch's commit message.

Thanks.

--
tejun
