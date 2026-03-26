Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F65C45C0B;
	Thu, 26 Mar 2026 00:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774483755; cv=none; b=S4Ro8pSL9BVeYUbDNqC7cfuaaO1gg+5ZmT6EZwzxCH14cJEkURhCBiQFyV+gjXdO6YLBV4Hpz1XP7ZewSOfzp1d3Lac07caCjwTJYFS1xUpPJKstvYii/8euXdgPg+ed7rKWXOif5qJSVUftzC3ohNrjLxK8OnmY4pijxm8KJcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774483755; c=relaxed/simple;
	bh=VmaD37WXPGQSvuLKFT2fUj0oK545HtswXhwSFdPLL0Y=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=fn59qGsHZlZXszTlzIfFBn03EIWL2ZyJayubbvAuin/VLh2ionNCh9e09Ay4eJ3g5iIZ/bJHjBvejeFcO/MED8/jbNnFdTHdEHlMmCurNpoWtvjrpU702/IP6Xz8erXBWbJqUdHFMiL5jFGUwcFHSju3g8DWejTFb6fPqbR4080=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jvbKhnhY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jvbKhnhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B897AC2BCB0;
	Thu, 26 Mar 2026 00:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774483754;
	bh=VmaD37WXPGQSvuLKFT2fUj0oK545HtswXhwSFdPLL0Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jvbKhnhYFkZy86JdChLNFdMMqoawWknzAq0zT6k1j/d7Yw+le7INlB/+JPRKHSe+R
	 Iw6gM1fSn1XpTbyKRHGG7jKJeA5iHzVQzbohlE+MCrLjGpwlrlVgapwkVPj3RmiWmx
	 XqK2jXzQxxQ2s10zvoq7DPomRCpZsXA9T8odOd/oj6H0PRnZBT4w4IyO8wfFtJ1ZuS
	 tl6aMb+2fIpwNK9brekr4bk81NdA3Q6Ub3X2kmAyF4WTFCA4vifN7IAJVUy/0SBu10
	 qqzRhswj7cUx51uP5DyHfDTrgutzxo/xYQg/vqhQBWgTmsHVvKtzmgRYmFYljLaIao
	 9doGKzMnBUD8g==
Date: Wed, 25 Mar 2026 14:09:13 -1000
Message-ID: <7bfbcd3ee9af63f0f4c50b574bf468bf@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Michal Koutny <mkoutny@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 cgroup/for-7.0-fixes] cgroup: Fix
 cgroup_drain_dying() testing the wrong condition
In-Reply-To: <20260325172348.1836430-1-tj@kernel.org>
References: <20260325172348.1836430-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-7.0-fixes.

Thanks.

-- 
tejun
