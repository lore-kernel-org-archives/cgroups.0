Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E184A3C09E7;
	Thu,  4 Jun 2026 19:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780601502; cv=none; b=s70/lw1WEdegdgISn78JGX3+cLzCyKrjgHTPiVWc8eIK25BYeLjlviUBNe8ahZlNVNSZSqfZC4xvIZznxSyWUN0Nm3lnfn8x8yWxolQiYWIX/YLEJfMBwN4uVTXYzzBpwQtgbps/MMmodiYY6pq4iOYq+pHJOjvMkNhsimptNYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780601502; c=relaxed/simple;
	bh=OAPSFlTzyDGeJiyfpnOYgq0q8v7xFBw+GkGB9Hh1+Ys=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=RimcU5cVbLf0yTGkfER3wmrPpW1hVGM58Bl3Kef0aO28da/DyMWz+sCCMwHBQ0YN+gwXBRfFicSwYQm0v8NOqz8B/nz3p5ijcAjkB+ZG7Rha2zbulKrVAih61oXT6P+b8A6bLnY70IUWes73iCLDBIJXkZUTeACceAxboe3OWic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j1uc8j3k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j1uc8j3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C871F00893;
	Thu,  4 Jun 2026 19:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780601501;
	bh=TLQmD9vCgVmThmuPA/QVw0Rz7WDxMHmEcMm0k2V0m8k=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=j1uc8j3k0HjQAIK6WerSzGtebX1FlzqNMYgKq3MIjgW+yMIwkVFd8MONBgUsRanu4
	 ZXDvu+d2Y+meyqm294ZYWWBSv/KQjMcU1dHb9QvuB2r34U0MjIkrsGDCy9UkutWA8i
	 lpTk1J9ul8CjcCxcvuqKgoq68EmsA/FEOtgsMlqnHvILm3/Wv/gXpJxE0RXaX2AlC1
	 juLJrbYgJWISALQWi9kpR8bYmEV3rpNt1PWfv3FEwRxYpwWwlBTWitoL6N9GNFxEus
	 LSQrRFkZA2uuZ15Kj0axlWtRAPrn4TIEUgHi+1xlZLp9b4uP+7gdbtsdz6fWJvKYQW
	 R8Cnp4UIGY9bQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0BD93930A18;
	Thu,  4 Jun 2026 19:31:43 +0000 (UTC)
Subject: Re: [GIT PULL] cgroup: Fixes for v7.1-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <547622bc7e85cf6c2c3a2f95bf146f5e@kernel.org>
References: <547622bc7e85cf6c2c3a2f95bf146f5e@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <547622bc7e85cf6c2c3a2f95bf146f5e@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.1-rc6-fixes
X-PR-Tracked-Commit-Id: 57aff991119693e09b414aff3267c0eae5e81da0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e7524845cda3c0713c0e61681dcd5263f0270fbe
Message-Id: <178060150245.2990765.14926213268493189472.pr-tracker-bot@kernel.org>
Date: Thu, 04 Jun 2026 19:31:42 +0000
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 02 Jun 2026 12:47:53 -1000:

> https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.1-rc6-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e7524845cda3c0713c0e61681dcd5263f0270fbe

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
