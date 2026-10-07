Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32F528B4FD;
	Wed,  7 Oct 2026 00:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791333921; cv=none; b=esROQ2Q9S9PZGxcnx6B5eMFOPyJDvgAizOvZjEksJoZGmG0X7W+SqeHkZ+HAUNnoSRMfcAUmLNk8ce6Rf2QhzHSbL927U7yF1w9GxTa4vvqHDAc6AvBOapb1pPBA11X/CIwvd6eIaLXe7V8m5qMAFZQC2QySU2cwjlGkz088bLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791333921; c=relaxed/simple;
	bh=C1rEHiYqNGP8b5vu31IYefoKaKqg7PJB2f+hPqkorNw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=jJbaUADLX0Ef1KC4NNNVQv3gPqWi3YjrapsDM1HwTtBDPp+xK31a88hUvK9fqULTRkOVzYfrZ6xwLzWFJlFdfm7im8i+dYGbK7XqY5lf5dq15QmJyv9uplgGTgzgeHBW5LpJnJEkGoO0H391TKJPtJHkn2OxwpigFpya77SW3Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TVi8+ILo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TVi8+ILo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFD71F0089B;
	Wed,  7 Oct 2026 00:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791333920;
	bh=msu9NnSXMmJuvopotcl85AurxzJ+kFkSe1nmrRsCKbo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=TVi8+ILoe++oxXcn3lUnDpNcWJ2E/NZ3fOs/pVuKNpLd1Gf7xoX2Hhri0zMc43z3J
	 iFtDEbvyGX2c9mztItG36T8PnweW5z3zyFnCOHDvC/niWOmxapSEUVNAimGL/OOQNc
	 DmZtpQ2WtCMxvEuK2C3hyoTjizxo+SzGxFrTllXvYLSgiU+jH5hB+kbwCznK6Js4Jz
	 aXad27QrK+dVeSkMGktM1GZzlDVy9WjlNR+69GWh3uivdv5s8iPXWyK1ddcg3lZ40G
	 aTOUH9qBy5DDqpzWwWsn9zHHLIMcUPDX8L645aQFG6X9gC+pMuipWdI2Yl7Xgznryn
	 vo2n09APD1ucQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 775583806541;
	Wed,  7 Oct 2026 00:45:20 +0000 (UTC)
Subject: Re: [GIT PULL] cgroup: Fixes for v7.3-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <e2cbf80a5cffa62a2dfcea51b4fa7ac1@kernel.org>
References: <e2cbf80a5cffa62a2dfcea51b4fa7ac1@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <e2cbf80a5cffa62a2dfcea51b4fa7ac1@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.3-rc6-fixes
X-PR-Tracked-Commit-Id: b8eb5fd5bdb4c03758b056c70e5e1d962ca89757
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0d32b3ec5f902bf40d03db08837f3eafbb6a4577
Message-Id: <179133391896.2846339.16776987634469433229.pr-tracker-bot@kernel.org>
Date: Wed, 07 Oct 2026 00:45:18 +0000
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 06 Oct 2026 07:35:52 -1000:

> https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.3-rc6-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0d32b3ec5f902bf40d03db08837f3eafbb6a4577

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
