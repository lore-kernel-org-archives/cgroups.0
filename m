Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B6B33F589;
	Thu, 24 Sep 2026 22:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790287604; cv=none; b=dohz0N+dUxFm+ruGrltagFsVF8dM3Ad9AH7aCt0kpihkTFsfSYDqc1DfNktt0mdF+Ik/vaUtKhNrfnC70PGYReAgglF9wJbaeXJoWaFYjBxHrWU2ENrTwUX8uesdy2hU5kAp2jcvbiJ9Oi8/qsx8gysXHCCP1griNTTjHL6C2ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790287604; c=relaxed/simple;
	bh=eSPLFPgnwRu+0e9m0JOs2YSbpl+0ZiL+fU0ezr93Sg0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=F+lezl1EoYp36qhSqo7t4jjiIvBtnzaK9trIQdxS6yhqtV6TSykAfpvtXiymxLrveHYmgCMIdAC/Nj4Hzvp1x9wQiLcDK9DWoHKQLdEow8gqf3DutmR7Lzr+8lNpoyonmm8AULjQg2sTqK3eL/093srrUHt72UC5Bxs2b/7C/RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jI1oc+Nf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jI1oc+Nf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62ECB1F000FF;
	Thu, 24 Sep 2026 22:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790287603;
	bh=HggRw1poduf0XmZkohzTTrwUy7OtNHSQLMRD+1D6A5M=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=jI1oc+NfP6dHvTwVl32+SZxlOtkQEQBJm+EwfXVtzGnJzjYrS1/7RiQgOpJEj/K1g
	 9ufghsq4Ci7dBSlTd/CTucwEW7mvm6Iz+qdSoUuTGyxbHkQkb2pnYRaXHwO+GNeyx2
	 01NwCwatDph+18bgBzBEEw6kg6UKbfuoEWU+azh12K2c/7ncxwQGFQs8Mn8B8/1dfa
	 jAVsoT/HFCaUnAB65KTFI5fV+98QlP7reTx5o943b15wBnyB6tIOuXka3FxluIsWO3
	 MIz/QLZhbJoU0jEtmcno7jHbY4apMztcIrZ0JUkefT5qokByPUeHvMyvxwHbOlHwwQ
	 e9APCisk05Gig==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56C953A566ED;
	Thu, 24 Sep 2026 22:05:33 +0000 (UTC)
Subject: Re: [GIT PULL] cgroup: Fixes for v7.3-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <1e7eeebbabc3a9404fbea6928722474a@kernel.org>
References: <1e7eeebbabc3a9404fbea6928722474a@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1e7eeebbabc3a9404fbea6928722474a@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.3-rc4-fixes
X-PR-Tracked-Commit-Id: 1765a153d985c231357145e26798f9408db10e42
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e8dfd03a1c51c4e84fbf2e5ef5cd7d33cc8b7578
Message-Id: <179028753185.2222164.17918567933132947756.pr-tracker-bot@kernel.org>
Date: Thu, 24 Sep 2026 22:05:31 +0000
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 24 Sep 2026 11:19:27 -1000:

> https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.3-rc4-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e8dfd03a1c51c4e84fbf2e5ef5cd7d33cc8b7578

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
