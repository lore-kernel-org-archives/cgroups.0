Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BB53F926F;
	Sun, 27 Sep 2026 19:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790538556; cv=none; b=uG8KDpC1B4VF/Wf8ODNmVnSlRsFgPC5TPOGAi4lFi0Ie/2KQ0RUbTX/VHHJULePdK3XQUSk+1Lyo45N1lwHsC2c608OgCb5+RAKSXTKW9stu+/Ud3kgKDAw2wJNYMY5JzuMRLWTBYTTqByxgoxyvmodx+3EMBUPqkyyYJs4So6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790538556; c=relaxed/simple;
	bh=yi0E6uQrXV4mdhHIhN5WBmmwkuoiuY8hMWj0FaBpJQo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=A0syEWFr13A25sUn+9Nf5UO/kCY3bVlAA/p1MHKGmy2aao6TkQP5/ZF9SllEAzjQComNlJ8WZSr7wbQJwFqw/2joSliN01opOKLGTIzqHuqvMK+JRKihuHW4YKu0F3SLeDJJYdq8jl//d3YZ4i4UH0izZuILYeW73djPBcF9NrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nkf+05B8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nkf+05B8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D11A1F000FF;
	Sun, 27 Sep 2026 19:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790538554;
	bh=3a9zqb863gvVRSpFBMjEtRYHh+8jsK3CSZeCloUeDdA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Nkf+05B8ZnppSF6KLvLvK72LslptJILaJsJKZqOh9us5TBfqtSIbs10XLgNYdV3Li
	 j8eD6ihToDVxW9qkbvjeh5Zmr5vYqmnrkvM+VLDld0Hjo6pHXlXMBjYydOlL2zD38o
	 iGn0t4e6tER5GbRJW9iFh7rPi8k8B0kYEUr9Rzew0G+05HLH3V34WaJxsIyCfUpeOz
	 KRl3kP2SxzNOVXJw/yhdeGe+7Oe6oVuYFi+1eubjNLFeiNgrgMSuBmVAI38UsO0qbd
	 aiEKOSXnhHx3vbHwPWJD4/Y0YgJK01Oyjkf5DuCrSBuzbWt5/5F5sQ2H2nyh0Vv0vs
	 ihSDmi/j6z0rg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 80D92380AA5F;
	Sun, 27 Sep 2026 19:48:01 +0000 (UTC)
Subject: Re: [GIT PULL] cgroup: Another fix for v7.3-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <ce6ce5c6c2072b5f38afe4f0121a8542@kernel.org>
References: <ce6ce5c6c2072b5f38afe4f0121a8542@kernel.org>
X-PR-Tracked-List-Id: <cgroups.vger.kernel.org>
X-PR-Tracked-Message-Id: <ce6ce5c6c2072b5f38afe4f0121a8542@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.3-rc4-fixes-2
X-PR-Tracked-Commit-Id: 31c88350b7dd1522792f726f79607f31bb55c50f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b1fa457bddf009907b023bc0c09ba4eca3191a8e
Message-Id: <179053848015.2777566.8634628030897000893.pr-tracker-bot@kernel.org>
Date: Sun, 27 Sep 2026 19:48:00 +0000
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 26 Sep 2026 22:49:05 -1000:

> https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.3-rc4-fixes-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b1fa457bddf009907b023bc0c09ba4eca3191a8e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
