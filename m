Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85AC3AE1B9
	for <cgroups@vger.kernel.org>; Thu, 14 May 2026 21:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778794028; cv=none; b=FMYd5rQssQ+k8mDji/Zy1gC8Ns2lF8dxWYtY41mC0DQWR9k+RoF0+K8BelnPHpXs3l2ELRCIqyZTXBwJXEEVzYP0ZTBv+16kpGOG8nS7mYkAF9npbg3vNdGYKsR08zH9e8wIVTcPJzmGxfFPGIAEuil9ebydOeipUntMZcrxLxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778794028; c=relaxed/simple;
	bh=ICqq6yT6L0OzuLwOLkwbzZUQ1wutvXU4NnOmK1n5JFc=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=tahSkYoSKnTb2EP/FWOhZEU+lMcYkd5I6Y2n0s5C3RNj5tvRyLcI1qh9CRF8kFvVCSBx19eITHdJTAbycSlA+bRh3dgiao97GhYPXZkGGFVouyT7BnpjtdAWkFdMcOHSLyQqzxj8MNrR7C6ntbou3nwHG6kLISgwJdH6/cMs0Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A8znoV+8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A8znoV+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62477C2BCB3;
	Thu, 14 May 2026 21:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778794028;
	bh=ICqq6yT6L0OzuLwOLkwbzZUQ1wutvXU4NnOmK1n5JFc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=A8znoV+8g9i8oiHAL4mkJqpOz2lJSxRV+FMR+diSjHyzWhOgrDLvATbK0L3NfJipE
	 3GgUbvAOU0V7cSev+ipTtg0gTmwIPyJUeysRHlGEPHx8CwOqv1HgulZ4S99HNOY53S
	 hsUl14XBXMIIKrCPXMVG31JsSVJBWZHYaI5lqTa8/f+KCCqu4OV/TMgXrtlgFxwON+
	 y6lTR+9e/lCDj/63o2SX4y7PsqwghXOnmxSJtKwtcD7WEA7Zy9C2B2mPtL2UiU+oX1
	 4w5iT8CHIrvkOuzwAUU4r1//IMWvktX9DGDpvDp7fnTl3zLb36AYzO7KmTPamDjJ3P
	 cgmuG2FTxNoSQ==
Date: Thu, 14 May 2026 11:27:07 -1000
Message-ID: <fecd5643b3b87f7e40741975b9f5e4a8@kernel.org>
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
