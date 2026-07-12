Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7722A1FECBA;
	Sun, 12 Jul 2026 17:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783878591; cv=none; b=MdHszNW0EFT6i+Ztd8qNAUIljlQ6oKfd0v/jBPySjEGUBXjWupFGRfRl6wfdUZysYO7Z8/RVOcZE4yROYjSgNG3X4yMLbJJVcVZBz355DQn9g1lyX5fp5NCZszH+Wi4ZCjd7RwpqUo6wg4hAiADR1/JFaS2KB97838u/BDQS27o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783878591; c=relaxed/simple;
	bh=IBoTameHtApVct8Gcw/wRYeJ8o+Yi+AraZc0AeVgRg4=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=tiZ5k7BX40X75qT4J8/1CTmOwpwLY8BCyKUBiGDYO0r34qek4oXtWP0Dg9UL/7CDDx/Kzk8tdrudmII3me2Pv0nPc/ME68kj2JlESCcb+BM/1Inx5MqlwT7lHcZEqHq+r2GoaAQqF2kf8kNlooko+KvKiErkw+MYK0seZ4Rt1Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AhG9PMIy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AhG9PMIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C81E1F000E9;
	Sun, 12 Jul 2026 17:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783878590;
	bh=ZbTJLyMBEKn4K0UBdEH2PwNeOUsKZYezLVl/CAZSf1o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=AhG9PMIyPP2F5X3HHartainVwqGpzBd6VT75jmn9E4vkVDMKkTPQOYlIFQgnyUiex
	 J3tS5BNFNu/0X5kUXMHX2nsti3m41opGzGqrEKxwLnNGcOB1Mlp1fW3FBw/Cj5BIuI
	 yKCOft9APs3DmCi0DAsfUTXVXI98PzAr62njXDZsyt6OpNNbkRdvo+Dhe9DMLrEFAA
	 dICO7VXJ1zYtWuAhjWc5ZeUbj01AO5KH3/CHjm41dcCWfwF87K+BMLXEwgKk8vksT0
	 g28bXWiH5SPMTpSq0L6tC0W6gh/C/ldY/PCi/Ammqkd6C6FVfiYeOyACKqfRv4nMeZ
	 CODBcKc7hq9yw==
Date: Sun, 12 Jul 2026 07:49:49 -1000
Message-ID: <4e252ec5766ec86878fc6cc33e6efc7e@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Matt Fleming <matt@readmodwrite.com>
Cc: David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Edward Adam Davis <eadavis@qq.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Matt Fleming <mfleming@cloudflare.com>,
	sched-ext@lists.linux.dev,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	kernel-team@cloudflare.com
Subject: Re: [PATCH cgroup/for-7.2-fixes] cgroup: Create the psimon kthread
 outside of cgroup_mutex
In-Reply-To: <20260710134945-psimon-fix-tj@kernel.org>
References: <20260710100441.2653477-1-matt@readmodwrite.com>
 <20260710134945-psimon-fix-tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Superseded by the v2 posting, now a two patch series with an additional
rtpoll_timer UAF fix:

  https://lore.kernel.org/r/20260712174619.3553231-1-tj@kernel.org

Thanks.

--
tejun
