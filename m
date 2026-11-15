Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794781774;
	b=KSPDd53olXWYdskzyPU0MnkcE4nJxAnAqrHSeQ1ILTyilG8vONSHBNB3cuRRXi2+3pi9
	 LIaWQbHsgU73+JvpU4ujsHp/9OKYIAIG15RazIHEraFxdbSSYgVZKVJHUaGyWHfbyekxJ
	 385/tm1+IizESByjZRedkjPt+bUfwwSLSjy0LDIBB6vwuczYi/esAWv9fpYW39xVHPNn5
	 WlfnXuc9c+VSw4GDcbLThOZaP0kG5q6eeEmO0VuNFHc8sDXQp+VC9h4Ovmfn9Zi3j5Ycx
	 fkBKbooALFI+/NTmzV77MN9YMwp2hOc/OS3T9Wwrc9Zhqf8zOPCnUKJHot1c/eL7p3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794781774;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=TcODEdlkju4ZendFhoFzxd1FfauDAoVYrMfNBRO3ryA=;
	b=44kvl5FtIySG/bJqY2WV2G9oRgSu5ExtnApwOf06R8A5Jx7sBX4f2hFjqfEpkmZ+CwLL
	 6A8gQT7dpvDPqZ9fOM6c+xR73JJLY3bM89kvmaY59nxs6ktqdB21okGfy2gxe1eqwisK6
	 qzxV3kEtOuBWtes2qyJ75ynqx4wequJJVFVKFCEpcQuIIRSZJX+9wzUB24L2/Lq6Ip7Yp
	 dwhtxS7fRSenNlT+KVQsnWCWo4owhhYDCbD9/hU7Ni0mafxx1xQCsCDdC482VmWEeTIzW
	 oA8/Z5J3XB3jV2ZVV8l76p2lxsuBYYVytYJ/z14p4V3nfJXOCCt6UJm8tAEKhwsgpWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ACRFO1eY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74486606A32C;
	Sun, 15 Nov 2026 22:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ACRFO1eY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4F51F000D3;
	Sun, 15 Nov 2026 22:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794781774;
	bh=TcODEdlkju4ZendFhoFzxd1FfauDAoVYrMfNBRO3ryA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=ACRFO1eYWvprw+erGm2gQbpGSzJqpSKxilqTDPXXGPUoKabz/wX2X9ORhb32T3xOR
	 6Fk7WvSmwqpbg5znaN5/CxICyuvCZySPZJ0pZz+V482NxhPpum4LRwyetGvSFSL7zI
	 gN3BmCQUbmoKC9LXYQAF562VCtHppnyvKMrwgvjHD5mDVaUpciSQI/d/l11/tM5LRm
	 1ZcRH7Sl31dzIYWGoq3slHwikh+PsACBoNvP+0tcbqyuirhxc81fHvq4+XB5zahZ2G
	 GL1pphFAimzcyRd/Xh0smZ4nfeSjEGq8teGqBoUIbBfA6BvWmlcTQcsuH8RURVhVlK
	 wjKIrE5BT9s6Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F2AAA380823F;
	Sun, 15 Nov 2026 22:29:33 +0000 (UTC)
Subject: Re: [GIT PULL] cgroup: Fixes for v7.4-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <7a3f079589dddf1444f015b874f1b9ed@kernel.org>
References: <7a3f079589dddf1444f015b874f1b9ed@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <7a3f079589dddf1444f015b874f1b9ed@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.4-rc2-fixes
X-PR-Tracked-Commit-Id: acec9637e03ca54bd3c3a0c1a6ad5c6dfa07c0df
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4b15991b3be43e9581aca489ec30a351310bb49d
Message-Id: <179478177272.2784423.18188423379049180050.pr-tracker-bot@kernel.org>
Date: Sun, 15 Nov 2026 22:29:32 +0000
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

The pull request you sent on Sun, 15 Nov 2026 10:48:42 -1000:

> https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.4-rc2-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4b15991b3be43e9581aca489ec30a351310bb49d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
