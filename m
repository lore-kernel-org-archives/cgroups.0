Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BCA1891A9;
	Tue,  3 Feb 2026 01:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770081593; cv=none; b=QZXC4f0nZmdoFY2Q7HqafHtV09um0cyh8MqIBSCyd+2jsmfp775DOHeRaZb9GKWU1C7yjwYcu7MZN5klQA2v8x3nqhTrYgJqByr4edEkm9liH3MVPBJa0NjgQxCTrVEc2uqW6gfN4DzEOQwwkaut+R16AGNMYPoc8DfXKiBuRQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770081593; c=relaxed/simple;
	bh=/FYS35MMKL2tNo84SVyfH8r3fkD9uXXdm1le6ysArqE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=tkhb5yw5CR7TOY2y4alk69DMB2BePKqdSK34xHP5UtPfnTrtZ7aTYFgpCB8tFDimRa2Dw6VyFesLYQl4Mx8FCjyXZ9sqn6uzDp1IubbOXsrbSu3wxCgXX2qkaQMq6qUCUgQy2S0zROVYq0RjrV64f1BrhKAsNo3HS4yDhPoq++Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FOBJLlDv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FOBJLlDv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C0EC116C6;
	Tue,  3 Feb 2026 01:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770081592;
	bh=/FYS35MMKL2tNo84SVyfH8r3fkD9uXXdm1le6ysArqE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=FOBJLlDviMB4Lu5twl1e4nZCkD+TYBBwLSZZDCjisDeTRpsnljF/20iZcno0xd8GM
	 rVSPHjf01IurEtORwWErRrFDjagHP5MVuMlgIbmgG8Vi71ZNLCkEVSKU7gvUmzhtJr
	 ufszGdyZ+jrfbyFE/Myrc+6R9dwt9HdrVhpOD5QJGxCkfLgiQKuh7DaVgb3LO3+y+g
	 3I30sUL69wh0pRZJkmyt9/rcDy8nEcxk3nF4kaWZXYIuP6V79adr3YcoCNPabYRxdu
	 WgY6WG3QEfXNc6gSdJu8za5ygxN3jZIB201dZgEZ+VGaoYgHogPgwBur7eCkARANcL
	 eE2FPGYYgUnpQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9115A3808200;
	Tue,  3 Feb 2026 01:19:50 +0000 (UTC)
Subject: Re: [GIT PULL] cgroup fixes for v6.19-rc8
From: pr-tracker-bot@kernel.org
In-Reply-To: <2fe2b534479363ab3aad3db25fa65377@kernel.org>
References: <2fe2b534479363ab3aad3db25fa65377@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <2fe2b534479363ab3aad3db25fa65377@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-6.19-rc8-fixes
X-PR-Tracked-Commit-Id: 99a2ef500906138ba58093b9893972a5c303c734
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6bd9ed02871f22beb0e50690b0c3caf457104f7c
Message-Id: <177008158913.1261185.17599032125609778758.pr-tracker-bot@kernel.org>
Date: Tue, 03 Feb 2026 01:19:49 +0000
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Chen Ridong <chenridong@huawei.com>, Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, Natalie Vock <natalie.vock@gmx.de>, Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 02 Feb 2026 11:12:59 -1000:

> https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-6.19-rc8-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6bd9ed02871f22beb0e50690b0c3caf457104f7c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
