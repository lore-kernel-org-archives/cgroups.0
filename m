Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793298546;
	b=AkEc3LMAaE483i5nUWdBlS/lyPwo+uHfcpw9tekqDtnrPV7PMXuE9C4VAC0zVn5DYrVi
	 OvQkUoV7I/1v5XbwxOE88aJ8lt2qjJvK0Yu0tAcXrZ4hsTV+sehmpqfRHXlHCobDZz4/w
	 L02QK4po7TshHyvqnw0fpgp79OxjpejP4vktz+5BJEwHa8zIZIecGd1lX7nKdm1vdqyDi
	 gu6R/bOOF3OcBzoxuCSyw2mEEdGvG3IrgvZhSPnph8zjBk1ABGcyqiNHIXhNHf9zfivnm
	 9uHjZsqMY92X4BhPjKe1KXgRvy4LIeVlBpoopNtN7F4kGVIcjeIV2zXlwL602/Us+Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793298546;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=wBU1aQb6Bt/HmHfcQIFSY0FYPHr0V9v7ccKJ7ONK6cA=;
	b=OulVBEqlG4NNL1OFHE3eMU9JWxEAcXBuP2g1HgYeuxS657ntah7WAArgo/pVdvgxdGXV
	 05Im+rIjQ3h1bW5lXoF1pHU4r/J45D9knUEB5mM7/MzrpwCiilwKRs9Gig6HO5l2qdj7P
	 ObQhNTZBj1ziPHE5t7AULGFrsxdelZ3SHPeVMZPXQyHIkTgu8ueS4FqiGHITgfKNtUEi9
	 OKqRfi2BMeXlp3AtO1tkPHCCDl3W64/kAML+qrHbKceXeQTyc7vVAtKn8iZyaqn9RJ4VA
	 CRSnRSQ8iNLZRiHK0zBl5r6lICOtxafdpoOvp+v2F7n2YbO27U/Jo8Fgx8dOKjPgMBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L5YUrnpk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6922606A31E;
	Thu, 29 Oct 2026 18:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L5YUrnpk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35131F01825;
	Thu, 29 Oct 2026 18:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793298545;
	bh=wBU1aQb6Bt/HmHfcQIFSY0FYPHr0V9v7ccKJ7ONK6cA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=L5YUrnpkTpqIAUoFNvFmxXbw1gpAR8fhYjVzcf8aCE3wpQ2M/SyKS2riOo61sApnk
	 fOcjBJCuqIPlNUo6XrAwD0PXePhj+A9U21O+qb+9HvpgmpqWUwAPHlq2Ep3RIRP6TM
	 qVP9ozrDOR5wBimHCVArdoMC6fKdtWTadXkmAn3Axnb7JP2jFz5qR75LzO+yvI1DF0
	 mR/kat4MacVoca7SE4ourmsncIcjBmo6MI4kMkI6lOzK9ICsgI3X0aOzzbvtX3jehz
	 wv+jvNL8zhzPTo+jmlblPp9jo9P/jkZ8RuDjD5tVZvxyfOSQ8N6iDgJvl7ugM6ks/X
	 dXKvWYmCtWZcA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BA20A3808228;
	Thu, 29 Oct 2026 18:29:05 +0000 (UTC)
Subject: Re: [GIT PULL] cgroup: Fixes for v7.4
From: pr-tracker-bot@kernel.org
In-Reply-To: <728f269e1bd680a3d18d3b7c826fe864@kernel.org>
References: <728f269e1bd680a3d18d3b7c826fe864@kernel.org>
X-PR-Tracked-List-Id: <cgroups.vger.kernel.org>
X-PR-Tracked-Message-Id: <728f269e1bd680a3d18d3b7c826fe864@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.4-fixes
X-PR-Tracked-Commit-Id: 518cec2def9992192291f5028edc077fb2e475e9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2152c755f76a9170218a098f79e2b081a08b1d6c
Message-Id: <179329854431.621556.11198579693496437353.pr-tracker-bot@kernel.org>
Date: Thu, 29 Oct 2026 18:29:04 +0000
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Tue, 27 Oct 2026 09:46:08 -1000:

> https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.4-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2152c755f76a9170218a098f79e2b081a08b1d6c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
