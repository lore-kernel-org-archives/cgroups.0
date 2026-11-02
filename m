Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793641926;
	b=qVLosBEj/F97MEdZP1yQqAqK9wCCf5AUfzl2XVIrVpfmun5MvRRc02HVJTPpklV4kg2L
	 X/wwqfpz4xYP3/A3sVXIB9nEuGM29nLkkepa4c9EdGjbwVKuSyPFgcCgygsBCzsTpStbw
	 SahsrLMnMwEdPqcNmXYW/o+yQEYXMpbpeaFlu7zYKnICSmZcIeKffXMJFyfIfEj38Ra2G
	 sqcAT3wWchgBW/ACWB+x6YvBuDsgzEWkazX384pDoNsPmZteStyZd7bFpzQkIerlL2/e5
	 FjLwaXbYP2eDSMhwtTg5a+ztOL3gUvoYEAjZ+gVUDNj+kv4QA1bLrFKyLqNXfFvZ7Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793641926;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=oWXp8S6+lnKG9OXZefu0eIGH6M8O+T3jLj5fDgMXlD4=;
	b=o3tr8vGTwvd5p4dr3MkvQ8zwM+PWRwZiJXwoPjJjONdibrQ7QClY6VlWP6dJUnHgP8tY
	 xQjbUfMkxU2ON1FPzp9MLM7O09TKLaDCsAJXWH5teJI1XTd2Mr7nT6Z2rpLAwEZvu4lLE
	 LqxuV1DdhzUmt9JNXxdV4ZTUW9urLqUVjQYDTRnSQi8u09nDVfxmf0skyWvbJl9ZtuubD
	 f4q8GQ70NDP31iQF+cAbQ6GSklYJwW4ExUdBOMl+46oGML6I9RZf3YunydVhOKr1I2fV/
	 GaxGhp3x8heXXdUvMkCVU6Dd6qv+f58tn9SqnaiMmcI6EV7Ndx1bPzRtvQAFHHIK6DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eLzMDftG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4BB606AE9F;
	Mon,  2 Nov 2026 17:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eLzMDftG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E471F00A16;
	Mon,  2 Nov 2026 17:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793641926;
	bh=oWXp8S6+lnKG9OXZefu0eIGH6M8O+T3jLj5fDgMXlD4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=eLzMDftGl4KAsdidYGxb7Bc6IW5Iv2A9Xn1/DVNoZ4weSuRGZAv2qtMn5vr5X+oKi
	 l1k+/PtfZuCYEFZYXrCdseGpWyqpIrl3SDRcYGROf1kRvwKsLNT/LVXzfDdPtGlhdw
	 oPa2GVAgWWMc2KfFpHz0MrYTx5Kh/gi9jvfR8eW6jy0LlVusenmoh1e6V7FxPr2GKp
	 iXHDbUVq0gZVVd96ARrm9aMXsLTVRhGaG190Am3f89LmanZW5uh8u+rvhJMEBqqSwX
	 p33/FXJ/EstV3jFt7YradTWDXssSId9VlkkCyCrx+efn74secl6exAAnWBme2XEbpQ
	 JB1zX2hcY1ENA==
Date: Mon, 02 Nov 2026 07:52:05 -1000
Message-ID: <b7cbd936d19c5292f58243b7bbce43d8@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Mani Tofigh <mt4022@columbia.edu>
Cc: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, tz2294@columbia.edu, stable@vger.kernel.org
Subject: Re: [PATCH] cgroup: arm the notify timer only while the file exists
In-Reply-To: <20261101-cgroup-notify-timer-v1-1-060c07b81aeb@columbia.edu>
References: <20261101-cgroup-notify-timer-v1-1-060c07b81aeb@columbia.edu>
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

Applied to cgroup/for-7.4-fixes.

Thanks.

--
tejun
