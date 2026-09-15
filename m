Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D17C44C50B;
	Tue, 15 Sep 2026 19:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789499935; cv=none; b=QPuhpx8Rsk32ejCGDtK3XpZGwPaaov+R1XW+YStp0/u9Oqd//BaGE8ySVS0Irv05jZj1kmq81LfJrsO8S/ejrKu3ieZZjDP2JwVqB6BO55OvH3vsbJNHzIqQ01M7DfC4Obh3owX9ztOta3g+LwMi7f46COpk94fqai+j/j+SNDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789499935; c=relaxed/simple;
	bh=JgKoLZ1Urn3xEtiNRvhVBIhLRbKwhwplnGS5mgTB4ZM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=uW2arWrUGaVuLc81tFACtO7GP13QQX2CZ7DlgEClVWYCo3MEFE+Pl5uP89ESxMeikow/9qi8faBZTcWHAm1RJXQtSy7k2+TcJ4SKp4qT29XSfGis1EsB0QpRqvz6M0IsaNiiJ1teoITTCcBn5UDIO0NmMhRhimS+5dvK3nDU5A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bGosx8ff; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bGosx8ff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A701F000FF;
	Tue, 15 Sep 2026 19:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789499933;
	bh=0htcwjEV4s2qlK2xuDmdMsLZb0XRpDR/Y0eJfoHKJ0E=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=bGosx8ffK6k7W/qW/ucj0A0reUQMpTYAJlVVjTTiQk8fjz6SeGeK5RUnd1aOu/od9
	 1RJ1fTqPg3k1diiUjedSs1WqsW8L1TD0C1VcAkG9/4U3jVAuhBMjHC6Mnu0rdgjmU1
	 f77xNtIx52a1xvJMB530hR7a+Gj1ua/aoKa4UnhcFtMgpoPDNTrw2ieX/eAuITvHe0
	 M9zJe8Gt2UyOBpS/VeyhALtPeHtveDOoWyOTw/FnPZMatPhvJHcs47vA8Zs3rpgn9w
	 j2g5W4RczLQvf9Dzkfqj+x9DspOfjFCNHcctOL3jzCQ6Vo5SStp453DGhsfvXkkmk1
	 fgxeR00Zl+2ZQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93E673927050;
	Tue, 15 Sep 2026 19:17:49 +0000 (UTC)
Subject: Re: [GIT PULL] cgroup: Fixes for v7.3-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <f2f2c870036c471d557bf1a3859a23a2@kernel.org>
References: <f2f2c870036c471d557bf1a3859a23a2@kernel.org>
X-PR-Tracked-List-Id: <cgroups.vger.kernel.org>
X-PR-Tracked-Message-Id: <f2f2c870036c471d557bf1a3859a23a2@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.3-rc3-fixes
X-PR-Tracked-Commit-Id: 057dac23d329d5c5ed62352f2659a39fd46c6d4a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6fb20c02710dabc2f63aa21cb23a154d76ef9921
Message-Id: <178949986819.2238025.10484621541708412928.pr-tracker-bot@kernel.org>
Date: Tue, 15 Sep 2026 19:17:48 +0000
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 15 Sep 2026 07:32:33 -1000:

> https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.3-rc3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6fb20c02710dabc2f63aa21cb23a154d76ef9921

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
