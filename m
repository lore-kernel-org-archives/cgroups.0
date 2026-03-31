Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964943630A5;
	Tue, 31 Mar 2026 21:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774992877; cv=none; b=sISiS+QvAEeVPKRzUiur8Z3m80v/1RdFAbEYwCKHrVHVjAWDmcehaZkfyYziQFt3I8UYv/17o3SNtNbCHP0jM/AMr6e9VPK1ter12mVUGnBsBXLRRDXVNbhrFb0Ip0Y81qYilsZK2iOhquCA4d+v5wHOW4cCYn1XBdNYT+CbRYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774992877; c=relaxed/simple;
	bh=R/x7CTRCwwDY5Yz/GHJSUKCXgsdqogzrVwTXWnKSiSk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=q20dRXh9/kWuywGbxnZBgxZJ41/im6DFaN0LMqEi1YXezCc2D/d8hLKr3e9Sb2llsz+qoyCaIHNSiFUGPpXpcyVhNTsTcKkoV4TwrusF4NPF/50ii+0aYuJ56HbAjXdhQkiDzmGw42LdFpxJO00xsHHZSdRXOCDhT0Ve4AKehss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IKOhQSVj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IKOhQSVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B898C19423;
	Tue, 31 Mar 2026 21:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774992877;
	bh=R/x7CTRCwwDY5Yz/GHJSUKCXgsdqogzrVwTXWnKSiSk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=IKOhQSVjp7YfJWiG206AWYUq1ck9pjpfk6ma5+O/7M1x81lY5rwEm1bkmTehbActW
	 svafDyNst1NtvFsNfZo+SolA7xWRDjgtB/v27FC0rql78nkXlORQ2zdWnPvDjLEutq
	 7AQdpIU2wweLMe49mO5uLs7KDqq72aF4PB4nEXTcmRsnW7n2PmJklcBmhkZe0zD4Lw
	 HsOC2zWB7zdddY8ShycDm5bDrAF9V1OslPuL9pmZiJ8YeDsPlpK8aXnp4KNjIhIvma
	 rzAiCh/SVrKhyrhAE1AGPLKXqn6d90FrAbpF+/1KxZFTZ2ij4uJ5HoAbvdiM51hyFF
	 ulwbpz8WqRqJw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BA14E3808203;
	Tue, 31 Mar 2026 21:34:21 +0000 (UTC)
Subject: Re: [GIT PULL] cgroup: Fixes for v7.0-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <85ee59a014d0eb2b005c623a0e7c45b2@kernel.org>
References: <85ee59a014d0eb2b005c623a0e7c45b2@kernel.org>
X-PR-Tracked-List-Id: <cgroups.vger.kernel.org>
X-PR-Tracked-Message-Id: <85ee59a014d0eb2b005c623a0e7c45b2@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.0-rc6-fixes
X-PR-Tracked-Commit-Id: 089f3fcd690c71cb3d8ca09f34027764e28920a0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 53d85a205644036d914a1408a3a301f7068f320b
Message-Id: <177499286036.2954688.4814338589250191973.pr-tracker-bot@kernel.org>
Date: Tue, 31 Mar 2026 21:34:20 +0000
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 31 Mar 2026 09:43:27 -1000:

> https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.0-rc6-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/53d85a205644036d914a1408a3a301f7068f320b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
