Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC60243367;
	Tue,  2 Jun 2026 21:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780435905; cv=none; b=suwsC9OsGNNl83+RW4LXCHsByusJ698wSCrSrDpE1CiHZXPFk1ShapWnlIgRxGUs1Jx0U6VidmfeotuwYfidDtNqaVDysmxnZYhVL9BsQlm2yI2bAsvuLLal/UBjzbSAVeAyWBb2BYjjFizwBk5lxF4iPNFaryh0rwI6VskHzlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780435905; c=relaxed/simple;
	bh=kAHb6UBp4emrhytW5HZoIVehGmzsgP76iq85RTas4/A=;
	h=Date:Message-ID:To:Cc:Subject:In-Reply-To:References:From; b=Z6PDAPZ1FJH+6Wy24DDTSS6/VM2MvMJWKEhbcRTzlD+G3UYPMl+yVoJRVpi01QfEyNwJP5NRGzmu66eZwlT0zjUQQwteAHlXPfyT9JBnsCcrXTvrtHl55E+2ite2kTWoSSGfdk5hONwz1zji/Jg9wwwTnKLkyCPI+/fR2vIwvjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fmt6hpBC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fmt6hpBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7FA1F00893;
	Tue,  2 Jun 2026 21:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780435904;
	bh=kAHb6UBp4emrhytW5HZoIVehGmzsgP76iq85RTas4/A=;
	h=Date:To:Cc:Subject:In-Reply-To:References:From;
	b=Fmt6hpBCLz75Bi7j3nTaW++lUY/tjeWHQEa7aaEpDz+yqNZgo2gaU+oO82DuMsG9F
	 aGsqY7jyzGBWpoN65V8vbWJw4TadHUaHukUA0WwFiXTI4y9SfRhmreI3Iu1iBE6t+3
	 7od8axAtMVMD50Zqdd8VEn1567k5WgMpA7rI1GZiGfQDFpwz82qG/B5BVSsbaeTVEJ
	 nUlV5CXCPWyNq7zAAbKUBIM5w/GuAYnxBgITVJxcGQtNvo4Xs8Jc2fn15CIItziH28
	 IOAeIqdQDAILCquft6UjHXCfUXK1MStie1jafNeYVE3hV2yxE+3I9rdQYEu0QIZgpU
	 Wftubx1kfYR4Q==
Date: Tue, 02 Jun 2026 11:31:43 -1000
Message-ID: <ab08bb53225ba774024e576c17ab7478@kernel.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Koutný <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup/cpuset: change ridong's email
In-Reply-To: <20260602091038.26901-1-ridong.chen@linux.dev>
References: <20260602091038.26901-1-ridong.chen@linux.dev>
From: Tejun Heo <tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-7.1-fixes with Waiman's ack.

Thanks.
--
tejun
