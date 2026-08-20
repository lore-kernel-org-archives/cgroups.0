Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A50397338;
	Thu, 20 Aug 2026 18:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787250877; cv=none; b=IeMf3mrF7SG8LDDkXHhVf/zAcwKe9eHHMeQBGCX/8bcnb519D+Dy+wm1+GF7eQR0eVVLE//Rj/RVfeH4dGiArYIEFtv5Ga1BBpFBynI7faq0FPiFBpBvoh0HUXj10oKucXwMcVwv7hG5zOHaHj2U944tOW0uhRcaSNFHC4G5KEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787250877; c=relaxed/simple;
	bh=xkrCldl/RNm5VmCEk7ifpUGku4pQ+z3vFxeOn1N9HDI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Ryhg8mENxAynv+MhTy014Pw51PCin3vKr9sijIiL/8N79oeWwhEkTLOntbF9Byip8N/MChC1V2ts1TAoqtOBTtpMRLqLeaoRMqfbvOTnH2el3nHM1PfVlZ9PCK6yLWzbenATThTtySi2ud15l5Whv3Qpc8+9SipfAtxZAu6GxTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bnw9cTXh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bnw9cTXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DCE1F00A3A;
	Thu, 20 Aug 2026 18:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787250873;
	bh=wxJ47V+4yjGnRjBUpHsM+XD634NCu/TF4m6ztDdpyBI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Bnw9cTXh9P5i7VSJmq5tNEKn0nBWQruPGCvxEs1WBTxiYC4G8hOMMSXwfYwZyoVIC
	 R9MKPZeMCIytLmTzyCGA9z2L8ekERE9nX5wnXDLAeQwf5vSu+bKd/6p8Aq7BeSK8Yb
	 +2w7KrKWc36vJW6vHp+Zj/Iash1nz0CBtCWaB+1NfdMwKpRTiGZwulnFTup/EqTKep
	 kIJ1G0DvlqfL/6bwWsIk7hLav3IanaPMNNIKKfecNefQB2F8KRyQPmsW/i1alyWtWl
	 iooHGj6/PtQC9++3qAJONkII3GhOpP4xMQFzUG9/DNjQ1Z1jg5zEpvyfoFwpQ8WW5i
	 16oCiboRhQwDg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 198493822D60;
	Thu, 20 Aug 2026 18:33:45 +0000 (UTC)
Subject: Re: [GIT PULL] cgroup: Changes for v7.3
From: pr-tracker-bot@kernel.org
In-Reply-To: <e066a6c46c8b345bbb78c50ee9de81d3@kernel.org>
References: <e066a6c46c8b345bbb78c50ee9de81d3@kernel.org>
X-PR-Tracked-List-Id: <cgroups.vger.kernel.org>
X-PR-Tracked-Message-Id: <e066a6c46c8b345bbb78c50ee9de81d3@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.3
X-PR-Tracked-Commit-Id: 2d19207f3fc8e08bab3270af2e3835358ab1473a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 40d8c81577db09b71ee5402ba336b642d32d6a82
Message-Id: <178725082353.422553.2681841377163768489.pr-tracker-bot@kernel.org>
Date: Thu, 20 Aug 2026 18:33:43 +0000
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 17 Aug 2026 11:49:42 -1000:

> https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/40d8c81577db09b71ee5402ba336b642d32d6a82

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
