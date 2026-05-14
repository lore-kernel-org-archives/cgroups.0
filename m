Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7AB25B094
	for <cgroups@vger.kernel.org>; Thu, 14 May 2026 21:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778794018; cv=none; b=WEdphJpC5FmVaawZPqWZibsU5d/YshL62pzUfIj60JJMqQZNxop1bbGuIsfRT5X/mi3lnH3bVQHRntmMe2paByUR45LIHAZaNn27HA3BLPwE2ZsB/lEYqo5p6Dza6DG7QKYv4JRF0cBVqG5xr8/WWcAef0CS9zMUICfq2QHAfEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778794018; c=relaxed/simple;
	bh=ICqq6yT6L0OzuLwOLkwbzZUQ1wutvXU4NnOmK1n5JFc=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=WAfy+KN3P2MTgMxl1hhQTz79H0DiJvzvkRwAbtwXNBnc71xxpxFs9CffMWwEqg45pqA1vIrZWJZ3P6SfXx6fI7hF9VDF5illYefjeaugTutImHs/iRTOYY1WlyZxawIpPDQdqYpn3nbY/f+85PtJUJT8Wyb4HU36uzbGUivA/Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JCa/hBaY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JCa/hBaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B1AC2BCB3;
	Thu, 14 May 2026 21:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778794018;
	bh=ICqq6yT6L0OzuLwOLkwbzZUQ1wutvXU4NnOmK1n5JFc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JCa/hBaYstQu8mlPmiFKdz3Tn/I/TpXrkdVY+QLN6BguNlL/GrZOUq2+hxCj5cbRG
	 z8gOAe77YZmmImPkShlCGoRH3C/i18bdXIAKh3BBY4u14gp714Z8Bd+YR3HNIHnYQW
	 YzOEakFnO128VnP+gJ8cVBhc1y6rKwXD8xcqdxiAeCWOK032QgTlG1zt00vYSozT0E
	 N0sSMc6GRQ2oUo76XhZQg4W2wdYrDeAkQ7ozuDN1SyDvOog+iTy50h67eNlxBd05o5
	 4g++KNUuphevX3va6myPIX9Vf+6uJ8fR5VUlhY0bpl9nn0uVGXgyMJwW7Ytn0hpVne
	 9MbzQv6sPW2qw==
Date: Thu, 14 May 2026 11:26:56 -1000
Message-ID: <1d47de9b305b1576a24c242aa9e72c28@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cuitao@kylinos.cn>
Cc: hannes@cmpxchg.org, mkoutny@suse.com, cgroups@vger.kernel.org
Subject: Re: [PATCH v3 0/4] cgroup/rdma: add rdma.peak and rdma.events[.local]
In-Reply-To: <20260514065034.387197-1-cuitao@kylinos.cn>
References: <20260514065034.387197-1-cuitao@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

> Tao Cui (4):
>   cgroup/rdma: add rdma.peak for per-device peak usage tracking
>   cgroup/rdma: add rdma.events to track resource limit exhaustion
>   cgroup/rdma: add rdma.events.local for per-cgroup allocation failure
>     attribution
>   cgroup/rdma: document rdma.peak, rdma.events and rdma.events.local

Applied 1-4 to cgroup/for-7.2.

One follow-up: the new event counters use READ_ONCE() on reads but plain
++ on writes, and all accesses are under rdmacg_mutex. Please send a
follow-up patch dropping the READ_ONCE()s.

Thanks.

--
tejun
