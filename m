Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D024D23D7E3;
	Wed, 16 Sep 2026 21:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789594244; cv=none; b=H7bIyCtJXJD8ctqswALuR8EO3iANtCoYjIHHR0Fi3FtXIC9emwsriyMYMsDGWC/MU/ZxU8xa3e91wWsWvqSG+KDkNHqiM/ud3fnlwTnwuyR3qjiR5NlAYKZN2XIRFUh4QrG9i4xS0ZL7vF2W/cNumQcp2UhG30ZtwJhh9aNjnE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789594244; c=relaxed/simple;
	bh=2nzSzoycrfwe2uud5bUJoBtH/3BuHnvkcQd1i3N2lQs=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=CthZkBZz2GE6kq3EhdjieqobAJp2bgAuoZfmSRzEO6OQvYx13r7zmIZwzmtxj94bEz9620mPe8GfOyJcP72ckaWfNfgTVGiL5M5KTRL6awPJRLZE3/0MjF1yjnWVIUbS9+vD9pi+3Yqh2U/lGREjWzjKqLq+JKtEOTfiYPCY4hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fXT7mazK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fXT7mazK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9B91F000FF;
	Wed, 16 Sep 2026 21:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789594233;
	bh=2nzSzoycrfwe2uud5bUJoBtH/3BuHnvkcQd1i3N2lQs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fXT7mazKQbr7VC4dIrK8QNIGQs58lRoCJ/K+BUq9p+JNhS5vuNDvCYwDuXNvaM2qK
	 Hno3Hr6eonSY36B6fsG6bFel35zeRT8jQfGlQuS4jqWQ4m7+FUlaaz0R/n/Ivxcr0A
	 wksc+thKIWuB/RJJfb5JpuZm3BllRqhJUPcmrdBgi5UkQ44PQ/WCybTKg5J5bL7Vw7
	 zZFoTq8hC/pbw2h5wgdx6ajVXa8cFM8QaBkH1tZiQzwmS+0xktzpIkpM2P8roHzSwV
	 GmhMykbXU3N0HRCIeqEpcePHHe26kF+vQFxbKD4e96LLW5hvn3nrzj9igIUdi4KGyR
	 IIAn2Jjcsf2mA==
Date: Wed, 16 Sep 2026 11:30:32 -1000
Message-ID: <37f5a5fa8fc2552c4cb6c5320e6c71f6@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests: cgroup: give the O_TMPFILE open in
 get_temp_fd() a mode
In-Reply-To: <20260916204436.821378-1-eva.kurchatova@virtuozzo.com>
References: <20260916204436.821378-1-eva.kurchatova@virtuozzo.com>
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
