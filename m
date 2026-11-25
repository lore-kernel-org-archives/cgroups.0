Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795649515;
	b=bzrAq6DNz6bfYiSCWG6f5JS4A3kKRGHdJ4ZMVpRJfeJMDR3lHV4WeJIMKdtt4GiGN0tV
	 5H4CAFi5x6XcHkpP/3kuF8JhZyuMFBGqjiLV8ZhRc5Tbnmh79D8TzHxY0GsFhbd2Ld05V
	 x8VsplnXYdOEAnNXWIkq9xMUQvef6l3KN8JKDTeYc+TP/0VIAJ9Z1spz36fkPO+byzKaP
	 ETm3GN2psQXPFfPC25Xm9qUJ05f7Fo84cAbU+EDpbh7b8LYGxItYvNiY8LlcKTsdr+hJ6
	 XhXrexu+/U1KsTQDOhHoCgeW+eWxaqO8GXybTmkLucMF8J+x6aZayELIyie7/HqyM6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795649515;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=udZcNX6hN8ZPSvU4MJ3Hgonwb+lNamdA8FW7RfhuJX8=;
	b=PMgf72Q4aFTFXHJy7V5if/EJweYzOd0W9yEsSquFDCY0flwB9/OnWLlu7xfYqyaIa9TW
	 2neumLGtDNINPbPbyDg2OPd5agshyH+D3XftI/WsFiP7yk7e0eCl3ENcjc6O77N9fhGJW
	 VofePMRDC+dnez4LuwvcAp/72RBSRo5p5GDHO96OmRVtKlenutMWSP6nQB+ACZgNlXkdI
	 GSwrXvRqJB9+9EYERC1fBXou554bASZ231nKt/+twEkNFpwC2WCcJrhgNNf2S5kav6Pr+
	 /Y4G3Zi2GTWXNi5UdSBhtEfrzbCX0/mgxuGTE6Y/3JBtFE2NUWJkzE4iVs6JhmK05Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BZcqYgy7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EAB606A69B;
	Wed, 25 Nov 2026 23:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BZcqYgy7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4E91F000CA;
	Wed, 25 Nov 2026 23:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795649514;
	bh=udZcNX6hN8ZPSvU4MJ3Hgonwb+lNamdA8FW7RfhuJX8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=BZcqYgy71fnVlpSP/7O9tcAjKX+GHzGE4TzLUGYlcmMphBK1RQaqmaa+O9EfMHkJx
	 a22AZY+1uOa+95PZoZe47+Lc2f8X3kI88XHFRCxByawKRXWzyautFv4HJHr+nzaqrG
	 +fQROc62CBvVDxSpnEkQUA/VSHYde9tD01lnKVNvr2k6J3vrtfLIkMtP/77D08yVJl
	 uWUBu04WK6PciORwYURWIilnKwu2aH+uWXcEyiQAMi6PkWi9H+pvRfgSX9PmHNihT0
	 IY6DUNa4Ympn+1Qf4l5IAjudTFlma9VRmqMikyb9kJv9T3VfuxjamV+VY15vhQkwD4
	 07IOu5jqWGlKA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B36513809A24;
	Wed, 25 Nov 2026 23:31:54 +0000 (UTC)
Subject: Re: [GIT PULL] cgroup: Fixes for v7.4-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <6a805a6f23f76761c1efac4817ea1510@kernel.org>
References: <6a805a6f23f76761c1efac4817ea1510@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <6a805a6f23f76761c1efac4817ea1510@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.4-rc4-fixes
X-PR-Tracked-Commit-Id: c99f50e4acf86bfbbe313d79f281d83be1763260
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9569562af0e0113c91f92e83c7f35adc53e051a6
Message-Id: <179564951352.1391833.3522237348525896711.pr-tracker-bot@kernel.org>
Date: Wed, 25 Nov 2026 23:31:53 +0000
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Tue, 24 Nov 2026 23:30:59 -1000:

> https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.4-rc4-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9569562af0e0113c91f92e83c7f35adc53e051a6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
