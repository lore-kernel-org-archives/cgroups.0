Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792702206;
	b=wnfexDUI/KtI+DQ4KITGLfkZWwnfMB0YcwTNMbQliI/qcxcj6q9eXgZ7DoMmtPF6GHa9
	 PDt8EE4snpiSz/QjvJsfj1rhGuxbSBJgog/guD7SRd9Xkv1bGBGGkRUfwFlPdxZGc4eFF
	 z0GuAbMqenjkKEwS9ZjkCouZV+2lhHTwknyTo/UEYr21B4ClwmFb3Z1U6pmPVYaUd6z0U
	 4nptJ7UwgSCGSGCSxKWma6RvS24ic7xHvlb+UHtniy8fUZnbYOIvDGqz6bd6j5AXiw5In
	 h1b84QxcOhfCj2Imqsy0j1Jacc0N7k5W7IlXa02kxi2xaywz016GhQBBYykhT1x+dNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792702206;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=IdnKocCdXj+iV5c0EdFDkKZnX0h4MN8ipAkkR5ZHUJc=;
	b=kmJ0psqkM14yVfSjcq25+bfcbzSGTfd+YRUQj3qtLhqZ2VEWCqdULwxNF7Pb+i5EZMi/
	 qcZOo2kXc3q2emJBMJwIvCCULokmYj+tVVVHI4NBioZi5Id1I6eyhBdOeuf1GLPeW3vCV
	 dpu5Tvm7xfHr1T9esPWyd+TOrCCeo7B9tIdVCgFDrC8Xh5a4sijgRh5n0iIlA1wayZ71E
	 Fl7nC3IKkgRcpD/iPo6gTwNU4OsgN3+c9hb5Mn1hNc1QIubFyu3w8SY8PzUxAvkU2uyJ9
	 x90DpQDiBTeuC0Ze39pvUNY+p6doPr3NwXPFrKIbh978eKALDKHReP9sBnaRVavri8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aw4NcMkO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BDC606A334;
	Thu, 22 Oct 2026 20:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aw4NcMkO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CF91F031E5;
	Thu, 22 Oct 2026 20:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792702205;
	bh=IdnKocCdXj+iV5c0EdFDkKZnX0h4MN8ipAkkR5ZHUJc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=aw4NcMkOgEEJpWNnOPTxrtDyvUBccwMp+DPndeIRCk6pJnAWkC/ociChd4U75WNiM
	 +Xt0KQSAAp9fbXjwTT1kjxUBdmMBs94oSWMNBgMNujtoZE/KNpPzHMEKClgcf7YtGo
	 vgRQE+v6UACuucg+NHO5c+caU5SVqSL6ZimvErwirp10V0cBfcE4pcsTZxUrYbvsWN
	 ue2uHjQ7b8Mhp9LzBjAB8JNuvsECj5uIDdQionWDVXIoUhr0v2HYhO/59Tm+WyCN7s
	 UNTWWss1tBXydvUufNeHwQA7jZLvOiFAo0OZmQgZ8nFznS2fWkOvHQ6MTACtBsWHAg
	 yFX2IxjDs5SnA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D888D380822E;
	Thu, 22 Oct 2026 20:50:05 +0000 (UTC)
Subject: Re: [GIT PULL] cgroup: Changes for v7.4
From: pr-tracker-bot@kernel.org
In-Reply-To: <410cdfd35a22cb6eb13ea6324bad7eda@kernel.org>
References: <410cdfd35a22cb6eb13ea6324bad7eda@kernel.org>
X-PR-Tracked-List-Id: <cgroups.vger.kernel.org>
X-PR-Tracked-Message-Id: <410cdfd35a22cb6eb13ea6324bad7eda@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.4
X-PR-Tracked-Commit-Id: 1850c669516cb8568150937497a9a16a7bfa1582
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 77f77fb7923feab3edd0accf793235623ef4b342
Message-Id: <179270220467.170280.4225243094301909023.pr-tracker-bot@kernel.org>
Date: Thu, 22 Oct 2026 20:50:04 +0000
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

The pull request you sent on Mon, 19 Oct 2026 06:31:28 -1000:

> https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/77f77fb7923feab3edd0accf793235623ef4b342

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
