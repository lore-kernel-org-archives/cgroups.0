Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849FE36C5AE;
	Wed, 12 Aug 2026 01:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786499563; cv=none; b=AdTkHUhoi5/bm0SyhZcdCfrIObUUQMN2Y2mtW62qRae13Vy9VQ5taI1cRCV1ZR1f7Vy8fxs1iOrVS+CAp7sz4ssmYu2y/QOy3ovkB62rxFDF6lxYVDEwP0jee+Xp5sqDmKHu6M1bSz9k9zTvo6r4GNHR1HskaAgPkxHe3xWoAjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786499563; c=relaxed/simple;
	bh=AovqIHQqwVYs0zTuniHpmPmij/s519jnqC8QcN6eRkg=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=Z8dobrcu4SCiMql1hykJeDCZ8P7vCN1gN4CEOfME1GvU1Orb06Ny7P0VgHR9tTHyZp4Jz+8qOTj5jYFAjlg1bHjKxdN5UyGI5RBtuq94xuWto/aEguLeR255TWgf2toP0ikNVHy7Qj6Tal69M0GuBwWsSzPq/Lpg7hBtx1pG7GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=biETufs1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="biETufs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CAF1F000E9;
	Wed, 12 Aug 2026 01:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786499562;
	bh=AovqIHQqwVYs0zTuniHpmPmij/s519jnqC8QcN6eRkg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=biETufs1OZDQdowXS8Eb19gTzO32p42h6eAhn9J2BCuD8410AdvVz+N5PTxEDol54
	 mfSyPo/Gu1CJoIbRFEdQ5j9TJ1NPlLGt8q8DmQaZPvrVpmNJtDstwEzx0fu0nnwjYv
	 WBjbCQAscq0M6aqIPo8z+ngZUdh62mWIqSA8eUphgVSgrrs+amtFEOI2Y1PNZ2mEwj
	 OtJX0C8otMXGkxOFLGdppALHwPjAAbqUgkMjoIaiKmdv82EkbtA1t4H/YY6NHzKLMf
	 qXjo79MnezFJfFX2xOXsCf/Owm64m/Fym4dDTwEZlxrLAjL4b6KXv7Z9eGa1oWlSeb
	 gJQh2E0Z4CpiA==
Date: Tue, 11 Aug 2026 15:52:41 -1000
Message-ID: <5eaad4853be81db156dba79a6167f24d@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: longman@redhat.com, ridong.chen@linux.dev, cgroups@vger.kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, peterz@infradead.org,
	corbet@lwn.net, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, zhangguopeng@kylinos.cn
Subject: Re: [PATCH v2] cgroup/cpuset: Remove obsolete PFA_SPREAD_SLAB
 task flag
In-Reply-To: <20260811083027.140577-1-guopeng.zhang@linux.dev>
References: <20260811083027.140577-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-7.3.

Thanks.

--
tejun
