Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A661A682A;
	Tue,  3 Mar 2026 22:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772577114; cv=none; b=gA8j0brn7sMfQtHic+AWGIUJPlGm8x82yEVSc/5Hv7Amn5ck6g3/TE3L9obsmDr1y8sarGRqlbJw7ixfGuRa+MJ2diaLjDGSkMuLLuoHW6pMQY9RtJXE+1mh+3DGTNVCbZUlS3gmPJQEYprfBRP9hVvP1BeCWHVsdnVSDzjESUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772577114; c=relaxed/simple;
	bh=v3f00Vag9Cu3Wo438Z0DHq/NDXP7R7GlttfbGNgydwA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=USxKwuqtL54TbzgHMiXoaMAXzYjjMB51fRDQxixOpJ92+nQEi+nPCoJ+x4lbW77BLPp32e6l6yo+CzCg0G/WXshUNcNA/TWJV+mouEbMl1vB3ZfP5sqcyt04kI3mtU+haKxbuzNSl4hD/0sr1b+UZF6wU/RAKwz7v95mwp5bvv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q5VEDb6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q5VEDb6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA56C116C6;
	Tue,  3 Mar 2026 22:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772577114;
	bh=v3f00Vag9Cu3Wo438Z0DHq/NDXP7R7GlttfbGNgydwA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=q5VEDb6ge331fjkWlRJFKaQFmK4VfJjuygvaxip3C1UacOeqqUz8G4piZlk/T0GXy
	 WqYRInpUtWOV1rHJChwIe2uTJLJqkCYg6QQeStVzLTFYei5L9KTDCqjBoYTbGRr1V8
	 CUxb6Rvkkc4pvuoK7B/teh+LLy8FUPPLZyqSxl7l/irJ3OVbVERzkurcVBtr9ME2wT
	 EL/ew0OChsSYgjYUKRkqx8pRUn8IkX1ME+ElIwC1N/hn3XAmPutbaLpVEuTPIfIE/V
	 k4hhRx1kMzaUanIGywA3FpEHLIYix+Nc3eaBnxzRIf/nyV3lF2Sm8EJu77+qwZsFIU
	 uboYfSKwa48Jg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9E963808200;
	Tue,  3 Mar 2026 22:31:56 +0000 (UTC)
Subject: Re: [GIT PULL] cgroup: Fixes for v7.0-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <c04ce0bbeb7a461f3bb0d571ff5a2911@kernel.org>
References: <c04ce0bbeb7a461f3bb0d571ff5a2911@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <c04ce0bbeb7a461f3bb0d571ff5a2911@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.0-rc2-fixes
X-PR-Tracked-Commit-Id: 085f067389d12bd9800c0a9672a174c1de7a8069
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0031c06807cfa8aa51a759ff8aa09e1aa48149af
Message-Id: <177257711522.1500124.6671998072182867424.pr-tracker-bot@kernel.org>
Date: Tue, 03 Mar 2026 22:31:55 +0000
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, cgroups@vger.kernel.org, Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 03 Mar 2026 11:48:57 -1000:

> https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.0-rc2-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0031c06807cfa8aa51a759ff8aa09e1aa48149af

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
