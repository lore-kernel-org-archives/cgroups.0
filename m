Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3FC3033CC;
	Wed, 24 Jun 2026 20:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782331677; cv=none; b=L+57Giy7pfk6CkSNFzZJKV0Y/vuqoPanLbVqsBduNhPr6ugzdVlXiwecM85S387hWcBXQtoYgH1KYJn9grzxqkivMHosn7DiW/cy9mEcKrK4PLk36WsiVj4LhiJDhU32F1lICSeVEaw1hWKOEp1ZS/Iya3jXBes0TY4XZGiYVbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782331677; c=relaxed/simple;
	bh=MvdxAoJ7YexdWzyjieZxC0ZqQhclQ8yHQTQhbVrniGg=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=qxxtiBDN1tSXdKeGg0UoDQALT2ICo6HMd2U6OgWifLnvn6rxOT+NKLzJficqAMuHT2EFk3Ctk2TbQau9gbG3Cmkh9t/8ECVJsrtBQXuUWwOEnk/pY0nRj298g7QJ6XvkfWLp6ZIjwXsBYG4vGGFNUT+VnLyeeMJJvfF3FbJDcf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O/KTWK0/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O/KTWK0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE341F000E9;
	Wed, 24 Jun 2026 20:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782331676;
	bh=MvdxAoJ7YexdWzyjieZxC0ZqQhclQ8yHQTQhbVrniGg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=O/KTWK0/vfMmCWHBKZ383cCO4oBFSbI516hL2/lOepxH8pj71PnQKFdqZwg3DnXgp
	 qUmlUWtx+vbuWa2u9sXyWfWEkSYPKOpXadD+bKRg7rVI1LdMIm1I3RwXk9oghc9RCe
	 nIqG5v4bqfbjlP7WG3e/uTv8P0BeE8OxKcuXdAWmJGHab/8CIlL9oSqeSlX1Jb0aQp
	 LNHGtRwEHka/75oZoCCgutlYct7RXLHjGPp6sRAKIinNQ2hKF9gpIVJlxZcbXXLNil
	 xaIpAXf5Wz6i4lX6dDey10XVs+a8/NYw5Natj06ddj874Nje3FURfOmcFXRI16QPrp
	 A22245zAVTwgA==
Date: Wed, 24 Jun 2026 10:07:55 -1000
Message-ID: <0130538fffad5f2457c422133435bd60@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Doehyun Baek <doehyunbaek@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutný <mkoutny@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>,
 cgroups@vger.kernel.org,
 linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Docs/admin-guide/cgroup-v2: fix memory.stat doc details
In-Reply-To: <20260620122751.388770-1-doehyunbaek@gmail.com>
References: <20260620122751.388770-1-doehyunbaek@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-7.2-fixes.

Thanks.

--
tejun
