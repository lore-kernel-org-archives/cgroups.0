Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4354334B2;
	Mon,  3 Aug 2026 18:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785782617; cv=none; b=G6LNo5JoO8Bwz6HwiuE3nyDnPZesf/qBxipZxIHeXFaD77awJ2b+12ASTHGEbGieNhhsbSimhiIwKTAexpm1czhR0rQtO7CLeVlHIdATIEhofHE7j2f1WqYGkBjksPw4AJBEEXv6wLbIKGwiLJUAztr4i8yox/Igb6AxMAv8IUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785782617; c=relaxed/simple;
	bh=9lgSTFrjQ8MHWyOYWmkmmv4rHd9XLvP0Dqj7uGNGFDk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=NhL5Of506QXRpau2VNIclOPa1dzpnWH6Ay0ZMe9AiFoqgAszd2ikp6hPqo2fAggCsnyXxosFOifu3TdGXwpkEyRiBkSOepKMoDi5OI9lhY8qJrzCJcfXxX6E2woBugY4/LI1tKx25p8sHDwCkOfsz9Z+4dVNb29hWtlOvOl+RUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TJhvR+OK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TJhvR+OK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A54E1F000E9;
	Mon,  3 Aug 2026 18:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785782614;
	bh=pldOBO7JoU9tukMOfaY9FqFPAetMMIqiJUZbElavfpo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=TJhvR+OK0coi2VuQAA90aFzmnOCRlxDvAQ32QiMVm5pPoEs7+UEQNQxyFxUYSysmg
	 qErGjgocVjvYrAlPzikzcAMebGFya9UJFREPR+H/ewdIfG0dLOcr+ZstcCahBdVPBv
	 CcvNWNhoMZcRfSo9KDeZzmzjyT63EpIt/WkTfAB/7qCrfaWrmOvkOFtp86i+p11t7c
	 TQm8paoIR73ggY8x9mJAheORi7U8rUv7JmtMkCdMTkKXHd5//cAlQk9mpKESb+ynl7
	 nA3UfZbnCrAuOqdK9NJfEGiLWHLvOoyGMnqM1NjPk3d7Pl93A2CYkLpg1/BTLZnBSv
	 AKJ+iwA0oN8Pw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0A373924441;
	Mon,  3 Aug 2026 18:42:56 +0000 (UTC)
Subject: Re: [GIT PULL] cgroup: Fixes for v7.2-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <0f3381afd016a711c51e3c3b94a9eabb@kernel.org>
References: <0f3381afd016a711c51e3c3b94a9eabb@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <0f3381afd016a711c51e3c3b94a9eabb@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.2-rc6-fixes
X-PR-Tracked-Commit-Id: 2fd9b4cfcefe30cb506072f78f2cd3b6dc8a29b1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 35e66f03de8f5343825adfc21bcaec4a99d3d4c2
Message-Id: <178578257536.2780879.1733224006728961552.pr-tracker-bot@kernel.org>
Date: Mon, 03 Aug 2026 18:42:55 +0000
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, Suren Baghdasaryan <surenb@google.com>, Peter Zijlstra <peterz@infradead.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 02 Aug 2026 15:13:20 -1000:

> https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.2-rc6-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/35e66f03de8f5343825adfc21bcaec4a99d3d4c2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
