Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794961212;
	b=Y5sZc6IYo1UmgBxw+3K+YB+UBHtkzcjCMB+YRx8tQdM97rLwaZXiGMUuP0IYUMhCvJKX
	 cEZ9Q3Ru3q7SpODc7zE8Z5l3aEX7iXfgZ95E2VbGUDVDKwFhxbfr6PZROzsxJc4KY8Ggf
	 txRXwVmltiK0h9iGRin5qMS5yt7JkkEuDVxM+ShJc3A7qcyZgohudIPzCjvnEMbiV6WFV
	 sW+/s9tifLgjmRZPd8jqCNnTL71wdlrR9xVzcP02lZ+BWyrXF9hWaf5cFrMWg9SEd4bEH
	 UpizTMkHuP4RNS2EGaEJLIFeHUpCpy/R+rqHXhIizqnaQfMkdmXI1Hw9Rr11gTFut+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794961212;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=oy0tZArTQ8iY4s0PSPsEHwXzkcjVeEK/EWogk8QKuFE=;
	b=HJExCWPll4nFtCCoCTPWkefJoRemDZ2dSA8JN+bfDPj1i6l76UsCrNsWTStHf26s5NJf
	 StRRdgdU9bJrciQJ1neyebocOwX4Ph3+gxMHknrC/so3RxHEdFyN6xOEKKbKkwlgmaaV3
	 FPbBaP0OatHIZrt2cuIq3czJCRjiv89HeYmXyZrEmzBvJ8xLvK5OQZUE99+mMS9R77VuJ
	 tLAQDsQgvg2tRlKO2dMTR1o2Enwbf+zi8m0L6alRJ9bduNJIalu9erAA8t5ZCosA20ngi
	 f93fzLrLoz1xvPi1jLs9ge0KE02MYF6cOzh+vqf1ZHJqc1wgl7G/D2wzZH+GMnksb9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aFLMh+xD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9577606A330;
	Wed, 18 Nov 2026 00:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aFLMh+xD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B261F000C9;
	Wed, 18 Nov 2026 00:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794961212;
	bh=oy0tZArTQ8iY4s0PSPsEHwXzkcjVeEK/EWogk8QKuFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aFLMh+xDDGy+yTOG2rH18yB/wKGdV0J2WoYSljsYH/RhBGaFKuS16FdsDKa7MGN5i
	 DR+FJ0dgIvOw6+nvhQVEI562R+t/0ABcMiyGSfZnzjBR6iUppOXT2kNjzOQEbNZalO
	 ADBhz6OilStESaNZTwgtD4xK51OgdQ0MQxwmQDPfluxcqaQKKvAIFCttq2825czJwg
	 B2wiY7O67WsoBMBEuuCqtsVr1zu1Z6VwX472LII8JttSoC0IBh/k2dtH1NOeXAI2MA
	 2HPhkwBJ14QXyM/SWg6LnuOnG/cCtgmZilMl4weUq8rljDljwostsfi/l/uyRl5RZ3
	 hNFYVQ/gR6mEg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Tejun Heo <tj@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	reinette.chatre@intel.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	rafael@kernel.org,
	dakr@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	shuah@kernel.org,
	jolsa@kernel.org,
	alan.maguire@oracle.com,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Christian Loehle <christian.loehle@arm.com>
Subject: Re: [PATCH AUTOSEL 6.12 486/486] kernfs: Use RCU to access kernfs_node::parent.
Date: Tue, 17 Nov 2026 19:19:57 -0500
Message-ID: <2026-11-17-1-daily-reply-0006@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <c6918c4e-060a-4968-a43a-1b1cbdafd27b@arm.com>
References: <c6918c4e-060a-4968-a43a-1b1cbdafd27b@arm.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Sorry, my bad, this should've been to ::name, later in the series.
> Here's a lockdep:

Thanks for the splat. The fix for it is not one patch but the whole kernfs RCU
series, from 400188ae361a ("kernfs: Acquire kernfs_rwsem in
kernfs_notify_workfn().") through 741c10b096bc ("kernfs: Use RCU to access
kernfs_node::name."), plus its follow-ups. None of it is tagged for stable, and
one follow-up, 6034974e3aec ("kernfs: take kernfs_rename_lock for same-parent
renames too"), is not in 7.3 or 6.18 yet.

That is too invasive for 6.12 for a lockdep report, so I'm not queueing it. A
tested backport of the series would be considered.

-- 
Thanks,
Sasha
