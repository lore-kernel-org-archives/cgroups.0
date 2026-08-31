Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2A33BA24F;
	Mon, 31 Aug 2026 22:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788215248; cv=none; b=FapEzbTVgqLiKmQ2TpVKUDlaKRZB0FjjEUzBONEom7gX8AUtFaCRDOr/uwzIqVAmiqWshXT+jEjkQNG+sqr+WoDqBHTHCT5zjiO5IEuJEGjECgloR12OASHzOYxkpYD0mu/31WijnZH/A9bGwGWwn+7BVina/oP2F+dMMW7TIPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788215248; c=relaxed/simple;
	bh=yCRLDhcgi17IWgdUaUt83p8NVcc1zgL7J+Om+mL5T/4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=sQc6Sk//lTsrPoCpqhbXOoQIL+T9ZJcbjM88/hi5uWZxXA6V9MiRl7lO97hGE6zlS/7WOC/rOmKZ6YoYVMMTsKbYexhDaPlZwTVPlOzrBhk+Ji1pVZWhx/r7c9BXc5RN+2lOkJoMbhsmX0brxy/tnLqOA0X2yTJYUkSZmN78pko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f1wNdBv8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f1wNdBv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636C01F000E9;
	Mon, 31 Aug 2026 22:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788215247;
	bh=YXhUCVst330kVAG5F8ATIlSFx4JAp39Plhyr4xOS73k=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=f1wNdBv8ZoS6FjpMsVw+HYtt2NTqUlLptvjv/iejlX8//y0JcYwgG/fx71DZ5icDP
	 tEITwvwKcMUGhUzzUK2jd13F2Vuq29ieaP7K/rBoX0rde8sYI+Zmq0GicDZuB94WjC
	 rgWBPrDtEu01VIYSYFbWuO0FUexkpECjCmsaeh6/0bnsl9MYO4TtlERpycsl824TwM
	 zTeUeCVIVtY/ck0g4bBC/MwddBIlvBPvxRIH7syTKFVRymxY7omedVS0xeZY5nECOR
	 2Eu1e17V9aDiX8XfS1PYzLFgyZtJhE9P262WTzKjJAaWW55Gy6iYugOWj8OBUye0Gi
	 sKvva5cIVxFkQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93AD5392446F;
	Mon, 31 Aug 2026 22:26:31 +0000 (UTC)
Subject: Re: [GIT PULL] cgroup: Fixes for v7.3-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <946c7fbb6329562f80c4900716aaf1a6@kernel.org>
References: <946c7fbb6329562f80c4900716aaf1a6@kernel.org>
X-PR-Tracked-List-Id: <cgroups.vger.kernel.org>
X-PR-Tracked-Message-Id: <946c7fbb6329562f80c4900716aaf1a6@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.3-rc1-fixes
X-PR-Tracked-Commit-Id: 3f4b7d1a49c5c826f3be9b684313eea5b83ac232
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c3b510de420d70def08190083d388e0873c1aa84
Message-Id: <178821519013.808525.16798998382277253784.pr-tracker-bot@kernel.org>
Date: Mon, 31 Aug 2026 22:26:30 +0000
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>, Waiman Long <longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 31 Aug 2026 10:43:14 -1000:

> https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.3-rc1-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c3b510de420d70def08190083d388e0873c1aa84

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
