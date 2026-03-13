Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CBA3859CB;
	Fri, 13 Mar 2026 22:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773440121; cv=none; b=FqdV7J/7BMh7OG91LL53u0c0pY32bouo9xw6IDV0ebkkTeSRY2OMNeUBE7gkGMHBNXd5HZqbnz5hOfltNfZu3wjORpXYDItrUkIcP6TJsiOrvCt8BauXzseQl5rc1uq0Jj9YhCDojRpbwMjN3QkdKY7RCSlOm9qizo9o0Ei5n3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773440121; c=relaxed/simple;
	bh=+HWLngxqlq9HjGL/RwStnp+CVGwlrhpGwJMUNAnXl+U=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=LuXTyHpabqBUO1W6+bhdcZ0Uq12bNBYhhHnHsalIfiAl0nKhCAFzUHF/qkUu1XUvHcI//NPA5Pxixi5dEZjV2kt6lgzxGeDhZW2sKpcaKV4RKddc6S05jgskW16T/u7TTZf8BJBzx9k4VXZMUr0tcoFiULLUHcZpbfXgCdfBY5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YrJ4zqes; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YrJ4zqes"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6684C19421;
	Fri, 13 Mar 2026 22:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773440120;
	bh=+HWLngxqlq9HjGL/RwStnp+CVGwlrhpGwJMUNAnXl+U=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=YrJ4zqeso0LHAfDSOY3ivgiu7kyR+IAueJbzWFF4x1v+7MhS8pQI1//Oe07B42EsV
	 b16trSxurJZJWhd4t3+tdAaTP5p1fgtCvHo0xFF+7ywpKCuz+ehqWVN6Vmf8Yg1UNB
	 HgNqpW7r8sho57vIZBZneuV2FPd+Cx2s5rzmbrx4BG9Boxwt/TL8MP28O/oGVoxZJv
	 MBEbx9GbrsRFBT1YPDjHIuRQt5TNAHU2KCTxxWcKRufi4n94CuPkrcfL0EysMZ3rcv
	 dozcbHZM/kkymByC7Kse6xxDNRs5H7h6aVxSToqq2m1I6tQ5I8z17S4ESMm0dk9gfk
	 6k0OktEFQ76NA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BA0163808200;
	Fri, 13 Mar 2026 22:15:16 +0000 (UTC)
Subject: Re: [GIT PULL] cgroup: Fixes for v7.0-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <bec9d24e3542e85a4bdb229dee142b19@kernel.org>
References: <bec9d24e3542e85a4bdb229dee142b19@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <bec9d24e3542e85a4bdb229dee142b19@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.0-rc3-fixes
X-PR-Tracked-Commit-Id: a72f73c4dd9b209c53cf8b03b6e97fcefad4262c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b073bcb8d43fd39f00ef07df5a47818a99c999eb
Message-Id: <177344011546.1522840.5425381142573967798.pr-tracker-bot@kernel.org>
Date: Fri, 13 Mar 2026 22:15:15 +0000
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 13 Mar 2026 10:28:42 -1000:

> https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.0-rc3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b073bcb8d43fd39f00ef07df5a47818a99c999eb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
