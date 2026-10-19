Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792451773;
	b=h0/ZZebyWaIXydFRkRU0nhLKuK4loGq5Ew4gMUCS9KIGhs6A678UgOQAfK1crEaP/4uo
	 IMwYqz2u/zN6F9L090Rlb0EMdlS/bQiTwl1mlgg/kdD/+7eTeODshjKO3GghFfpbVkfGg
	 7d0t8SKMou//gFqpNQttEoVkQoFzixJghm7c+ETQ4UCzmSNsNf5P+kMSnwFml85xH3JDv
	 dVCHcaf4M5SPAfgcu057KpC4KiVlpYmEzrXQsWXj/qgV53W6G6x78UZWGp0TVZc79tNwV
	 8nE1EDQJS/ttUaLt0JPT3sF1gyMzlDQeQ0vIUPcGick8zpsgha4TloI7KJjvzJwWbZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792451773;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References;
	bh=sb5/RITy1eFGsr3qG/Edmwuyn6lOyRFKHbFGJssFJTc=;
	b=EscFs9bRPFJnqwzp4f8WLGSjKLXr/bzsXQPDqhgGWANhGY5prQq9ZDbQyjSMVcj15M8/
	 2HIFMtglvV8l50gINy1HQq5f3gMYbZSInAMYBZohUeXNIX5zDiciXwOz+jKHO06ONmUTg
	 POTFd7oB9hzlN8jlvvX6eTD4ofgnJiGUd5UrnGlw70Lyj5/o3Nk15mbUSAgvzTYOrrjcF
	 AzwLV+WJh9tOfHrvw0khoPlauaX2drNPEzJ7NEJgKbXzR3mUgCk8GH6WR0oy4ayQBsgpI
	 Sm15Wq/cc809EaPd09fCMcXb5hueuTTo0VKeFEmJjxCFrpI38qKJQdbHN/NcTi9N50A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OPcQG4ai;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28185606A31D;
	Mon, 19 Oct 2026 23:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OPcQG4ai
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2F01F000CA;
	Mon, 19 Oct 2026 23:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792451772;
	bh=sb5/RITy1eFGsr3qG/Edmwuyn6lOyRFKHbFGJssFJTc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OPcQG4aiQe/HP4yIZioj8N7r6ZbGA10GQ4GlKy2l0Zime9ouyffpoaiQ+48mzKGHX
	 UVGwFlFZwAO7Hr9IAk+MsiXqXJ5Y4APIZjGQE1OJkRgh+a5ztRvnpZjKYREu61KnuC
	 ev+tQHxB1SVb0zB+bAKhrR1XiMVykfViIDrr2ybrBp6FmkVolQR76nrQ+qNKd/R7Yf
	 JJ6i/d1vp3Swci0vb3UrOd8IaNqdD3tTNSKhcbCYfl6rXHdjqTEDc9oOWZ2vU57M2I
	 wPXcD/Mjf/E1NQjW0o2ILeALOYTUsuZvNLaPDvNwHTOBSJhGPkaW41NtOpIgEf5ePc
	 adRQwVYhc/0/g==
Date: Mon, 19 Oct 2026 13:16:11 -1000
Message-ID: <abf437b321bfa2e1c84f2d4bed0b9b58@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Ridong Chen <ridong.chen@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Hui Peng <benquike@gmail.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>, sashiko-bot@kernel.org
Subject: Re: [PATCH-next v4 0/9] cgroup/cpuset: Fix various housekeeping check problems
In-Reply-To: <20261019181020.1069325-1-longman@redhat.com>
References: <20261019181020.1069325-1-longman@redhat.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list

>   cgroup/cpuset: Fix a missing isolated_cpus update in
>     update_cpumasks_hier()
>   cgroup/cpuset: Consolidate isolated_cpus_can_update() into
>     prstate_housekeeping_conflict()
>   cgroup/cpuset: Consider all the exclusive CPUs when doing housekeeping
>     check
>   cgroup/cpuset: Do housekeeping check before converting invalid
>     partition to valid
>   cgroup/cpuset: Properly disabling partition when partition state
>     switching fails
>   cgroup/cpuset: Don't allow a child root partition under an isolated
>     parent
>   selftests/cgroup: Add tests for isolcpus housekeeping check
>   selftests/cgroup: Add tests for nohz_full housekeeping check
>   selftests/cgroup: Skip test_cpuset_prs.sh test if some required CPUs
>     are offline

Applied 1-9 to cgroup/for-7.4-fixes. Never mind the post-rc1 ping. I just
opened the fixes branch on top of for-7.4.

Thanks.

--
tejun
