Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548363CF1F2;
	Wed, 17 Jun 2026 11:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781695558; cv=none; b=ZJgbItM7Rx9iif5x7D1VkAh/abEU0Bja5oFWJDbuxdSJdwrzEL43SZ0H80RCSIXbB+ffPeqo5kHz6RL5s/lEoIO7PJ5mnCi9rt1DRslF9ZTdN6IQHntSFO3dzRV2mVYJD76pRnugUxfR8MHXnoCxLtrOf3p1GerZZWXWOrfNfkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781695558; c=relaxed/simple;
	bh=Bhn+AIDF83oIsJubpKUP63QBgWxFSp8I+aJegIgHEY0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=dBErazJNPv5NjIvY7Xtrofa/9u3TedPm8CUV/HwbrN+RWGYAd2O2e4wzERHRn5RbKFn3lg6N73XMaBWCu/ujWy1fG3XMt/mUE3A+cdAOfA7ge3C1lpmQ3A5IGjsOU8ooh+/qEf4I9O+toEBQbJ6zSc7bUHkQGRfWWQVDAl6RyZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jlw47906; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jlw47906"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B181F000E9;
	Wed, 17 Jun 2026 11:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781695557;
	bh=kDfAEBbS2XgKIOeFfr41yo9BKQczd+dlVWMu5KYOGMw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Jlw47906SaspngeHu/N92fhmCJol6hnUGr5Qgbj5qTeh74Ncrmvlld04VDdcLm6k2
	 aZl3ejWUh2oWuPfCC1xFhA3XVWOqbHUyesR6/vKzxgneAQoooq2Ld55QzLSLw5+tT/
	 ovUv7ZTpgQpW8ZN1/PmHY+0VVz8HhAiHZHZWo4aOrajjVXhAAwrNk1bbZwW3bJxUXg
	 JyRw3qUt3Ezapo2YJkxfg//2mH5psX0hPHUiX6kawLInSzWPCvvoRd+nuIskjhTA+D
	 0uQpqcYiuvE8zZQsEF9aJBicqdfQRrR7sH5iqjbNK0FiVvVvo//UQDnN1jlKYqXvq4
	 HBML5ZadjMPog==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9389E3930E03;
	Wed, 17 Jun 2026 11:25:52 +0000 (UTC)
Subject: Re: [GIT PULL] cgroup changes for v7.2
From: pr-tracker-bot@kernel.org
In-Reply-To: <b935100af77c4a118f8180ca31627e35@kernel.org>
References: <b935100af77c4a118f8180ca31627e35@kernel.org>
X-PR-Tracked-List-Id: <cgroups.vger.kernel.org>
X-PR-Tracked-Message-Id: <b935100af77c4a118f8180ca31627e35@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.2
X-PR-Tracked-Commit-Id: a99ce697ea5e27b867c9ba4ee55fa5ba3b8d1188
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 83476cc97bc635a3ff502bd194c79bfb1f1ae050
Message-Id: <178169555132.1566750.7088063571239906149.pr-tracker-bot@kernel.org>
Date: Wed, 17 Jun 2026 11:25:51 +0000
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 15 Jun 2026 12:01:08 -1000:

> https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/83476cc97bc635a3ff502bd194c79bfb1f1ae050

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
