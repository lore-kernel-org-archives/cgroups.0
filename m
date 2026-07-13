Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122C13D34B9;
	Mon, 13 Jul 2026 23:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783984614; cv=none; b=Igm7E0FDlW7MPmH3OEDRQYessqOkJBEJretaZqFBLmy1tVB8r+WwaeZiP1nTk+ozF9bAw1RyWZ6zt+w9smqFSBd8bfcksCEFBgKCUlJJ0MzGaR+VqEkgZXyaFhBVQTB/aXf7szv0jtxZXdVH/ibsw6K0RPc2lDyFlyfbTMyKiF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783984614; c=relaxed/simple;
	bh=6q2lg0jnyNkV18VakmrWPjUrD1lqvxErLEqW3js61rg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=K8hI1JVyWkCz5rLZKg4Ng0Rjm5i9ylOGIfOWjTn6wuNDM+ttTzVkgVQLNWsmjCUJiJhyWPoIGHMRd/IlOVKzZgTSBTE9+UHIlepAqzymhVFlqXLJ/sh7CMu2N1TJzQJvXZVV8YiGgrwYTp7dRHiLDgr65YbFqiVf56/htxOaaf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZAxpwZ6t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZAxpwZ6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F741F000E9;
	Mon, 13 Jul 2026 23:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783984608;
	bh=M1rsHwo6/xC7c8PgUMSfshfAquACO3wLcSP3ZZQ4r20=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=ZAxpwZ6tIIHHfRG5z3Z6CNhUMEJLeIIOplr4mtwLE1gk3k+XdU6iYqG/pOuD+J6R0
	 mCKFGtQHMlF7kAYqMWz/obVhW9otgSIwLTk5PRNSMIZskoyoBd8Sf+BcI1XjlF6n0V
	 yyVLmkbmrO9/Pe8kAzULAjN9ktkloDgV1z9dzutwNiAm6w6/cYTu+0Zri3P7STemY2
	 5a5MFoPGoUBt/LuAMMa2iLIxZOUEO64+sQ2c9XErIpSg1dnTYz8BMe3sSUyFGAjHXA
	 qsbD4jSlZxujot/NgLfexVYA3yTNEWYdRbN0T0fIHVHPDFYFYeRaXhjGZ6Jc5h4NKx
	 QtW23YPELa2vA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 198E23924FA3;
	Mon, 13 Jul 2026 23:16:25 +0000 (UTC)
Subject: Re: [GIT PULL] cgroup: Fixes for v7.2-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <75e18325175b5439095c4248e0aa802d@kernel.org>
References: <75e18325175b5439095c4248e0aa802d@kernel.org>
X-PR-Tracked-List-Id: <cgroups.vger.kernel.org>
X-PR-Tracked-Message-Id: <75e18325175b5439095c4248e0aa802d@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.2-rc3-fixes
X-PR-Tracked-Commit-Id: 97fef602584458b100d383afed9d176c0bc689ab
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3b029c035b34bbc693405ddf759f0e9b920c27f1
Message-Id: <178398458368.2881721.13179426476487917547.pr-tracker-bot@kernel.org>
Date: Mon, 13 Jul 2026 23:16:23 +0000
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 13 Jul 2026 11:29:11 -1000:

> git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.2-rc3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3b029c035b34bbc693405ddf759f0e9b920c27f1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
