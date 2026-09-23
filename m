Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4491B440A0D;
	Wed, 23 Sep 2026 18:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790188626; cv=none; b=kJdLg20XTryvGk4q5bW9FkHPQz0FP3H2XqlAGQcnSiK+JAOA6y1dDXmK80OkOEg+ig7S6l5Q3NUp8cwNR+hVZnX7nyKDrALml6GI0c6IHBukg6aGDpJsiG23Kn+2XshnKW6yM1rPbi/eYRGS2CuekK004UnFXRk8IlBBJRHcbGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790188626; c=relaxed/simple;
	bh=X/IjDUl7BP+UlooZeK31LjjY5Si9HwCDPSn+kH3l/E0=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=UKuWQKFpzjNRNjsgz4/+gtrvHRp153LzEQB8rBPViuyHEcZ6JFQDZS7tcEECZdWH5pm74U6wJGwuktUvEKos9tYyg+INXd3++XLyXOJUvPh3qGs8m35ARk1BVsaF7WEBtwIryVm2KkVwQ/M6iFk/bfRqs7U9RkEyY+SmhG29uyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BtDAAeK8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BtDAAeK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A081F00898;
	Wed, 23 Sep 2026 18:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790188625;
	bh=2ooicT7eQs/Pd54Ov012FDl0o7+EYvnYIGlpdEkMO6g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BtDAAeK8ghtN2LhW6tW5XH2aHo+BDL64CzN+XFKIwadGZB4Kzak2NueiwrRAOx6bs
	 a7MW04g32l5mVVftULMy0saoDfdnTsk8GqUQa9NRuWc3fQqOVA713okJgGrYsRL2WA
	 g4AfXNUjQpuL81jQfbyKn/wYj/7WGWl2St+5JXG/JYKYpkr2j46ytg72qxL9PcFDKY
	 mc5GBKYYFYLosWd/jHhuC6ogkUHJzvN8AsIvTuskLHkSGG+OY2tb6/f9OHr7R5jddA
	 IhYh4gI39wPsSprgngJ0PYUy5RVMzOwfuGz3c3h5xgGFPGMDLAjfSjYKEbsr+bg5d9
	 aSxer6J+qs3wg==
Date: Wed, 23 Sep 2026 08:37:04 -1000
Message-ID: <4bf7126377947d8d5ce3420abde87009@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	sashiko-bot@kernel.org
Subject: Re: [PATCH v3 0/2] docs: cgroup-v2: Correct cpuset CPU descriptions
In-Reply-To: <20260922092034.68840-1-guopeng.zhang@linux.dev>
References: <20260922092034.68840-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

> Guopeng Zhang (2):
>   docs: cgroup-v2: Describe boot-isolated CPUs in cpuset.cpus.isolated
>   docs: cgroup-v2: Describe effective CPUs of partition roots

Applied 1-2 to cgroup/for-7.4.

Thanks.

--
tejun
