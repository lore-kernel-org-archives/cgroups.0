Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0686E49BD8A;
	Tue,  6 Oct 2026 16:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791305498; cv=none; b=OjfjYwKGc/4e2gCMArhsl8UUAu4QyvOEbXqK3hUY/zBo9Kdh9y8PHuhyZoPTAwCVIudlcNZmx3R6DJvSIgmBP4Fx5K8796AXw067ioiuzlanAoDiPhAV2W2WKgktt9mYy75zd4AR4hL85ADJeDz677ZSD5kFChfuo3hc5Hxfr44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791305498; c=relaxed/simple;
	bh=OmOHVbbpdDloU5fGWnKBdGiDwBeJIx+djjLfaECzLNg=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=ayLyM4Lu2BnUu65bHi8D02pyhnqrMiHgcoRMgKY/ObWMD4TCCDrLg6tT7xY5wbh/OXHdTExosBnbD72Q9vpQ8A2TSDlQyZObCrUu+9Qog25X1Y5FiLEqtfoMoGikusFFIKx5fMAl3S5kNa296bRom7MD3g3SeNA5qu7Pw5IAUPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ClFp3yLL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ClFp3yLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CB71F0089B;
	Tue,  6 Oct 2026 16:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791305496;
	bh=l8eWs8/3VI46KCqoa0BZXEkUUq6Ood4IYY9+Ijc3ouQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ClFp3yLLJAQucVEutcydo67neasdy65JA4xdUbEthgMvBEldy039L5IXg2lFsI8k7
	 WvOFaPqoNtZ5CHhZUyKsOaEfNO6S1munsQswMv+NNwJvcCgTMYfFL0HWihB7+8FelY
	 fYCPKsCl7WmoJl5zXnUGphfxEIhoDn7LpFmRowmR8e4oqHgcROeWyvU8WpWKj3cfIQ
	 k7yOarnvjV+dPfbGzjiHIEaeFGuO1+zV0fBVPSNPRZkf+ujWkxfTufCVhcaYz5semx
	 cSeRft7XtftbmYYUqQ2/dnA2lmzE42Q1iqx6KFK6+nlKKPJRFn4hv7nF5Zfc3V5rW7
	 imKXnQWWwt2tg==
Date: Tue, 06 Oct 2026 06:51:35 -1000
Message-ID: <a6eb28b7fb9c5dd4e636b12292129181@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Ridong Chen <ridong.chen@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup/cpuset: Call is_in_v2_mode() after acquiring
 cpuset_mutex in cpuset_handle_hotplug()
In-Reply-To: <20261005104310.1068789-1-longman@redhat.com>
References: <20261005104310.1068789-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-7.3-fixes.

Thanks.

-- 
tejun
