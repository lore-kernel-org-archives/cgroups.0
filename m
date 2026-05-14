Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94400341AB6;
	Thu, 14 May 2026 16:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778776861; cv=none; b=f8P6x89lndNh6vjNMA6ykrf7pm7NxqVdUCMKn7gsnrazgDzh9Z0+vv9ZP1g6UeIuqUkTW49CU2vhQSLFPswSXlzrg9ix+WiLJcqdatshfsC/8DKQXR5UM4cAKDKbZZBZVOEbe8WMlsLK2M89yZ4dDEzI8PDivqlwhuowi3/Dtt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778776861; c=relaxed/simple;
	bh=RuAxoJaksukeDIH0Xx87h9ulL4LkuuFU2sLLS7RP8mQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=PyUPAzScMzB5zol0O9Au5p3PIloj0t72RqUY5klpBuDM4agT4EpfocBaE2iVJc6JDn5NOnkpLPxjQNdxjgI95zB1+u3keAoJYoQOo3+sliWjd9fIwJOT4htsnsWCj7PLv7rli8s2Lxy3yHlDEOVUSlGlVUvQKmQLBWI+g80Y1A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TMA4Rq7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TMA4Rq7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046B1C2BCC7;
	Thu, 14 May 2026 16:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778776861;
	bh=RuAxoJaksukeDIH0Xx87h9ulL4LkuuFU2sLLS7RP8mQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=TMA4Rq7ldGjPuV8qp5AKNUDH523brYVkaI3u+8m/ZcZqX1YAMKlhbkFt9O2jtI1YT
	 CNflsCx1nJbXdX0NYK6d59/9lS1+BGElYvznnAboAJZTbeuNjn5wHPLPusWADQJ0Mz
	 7IRKrw+uhqES1pihN24gsA0i4ZQ0XXBP+v5PWON/aKiGHCXMeQMIt8vXCADG0av10W
	 vWlpzkqaUQm8Zq4fRU7nCGOKpNG9wrCQq6ZsxM+xrZW7VFpR1iQ5XEl4km7g4YJB2G
	 ugG9CLYEcW7scRzi9zLcpz2JAHhin21aWb8IReF0J3ZgO+H/rX3mtvSvVq93wIApgr
	 XSVwZewP5gxCA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 072D439D657B;
	Thu, 14 May 2026 16:40:07 +0000 (UTC)
Subject: Re: [GIT PULL] cgroup: Fixes for v7.1-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <6038eeed9424f26cc6bec8c0a01c8e43@kernel.org>
References: <6038eeed9424f26cc6bec8c0a01c8e43@kernel.org>
X-PR-Tracked-List-Id: <cgroups.vger.kernel.org>
X-PR-Tracked-Message-Id: <6038eeed9424f26cc6bec8c0a01c8e43@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.1-rc3-fixes
X-PR-Tracked-Commit-Id: 345f40166694e60db6d5cf02233814bb27ac5dec
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0913b580f8490caaaf08dd1591e0bc07ac2720cb
Message-Id: <177877680581.7067.12405825807424233739.pr-tracker-bot@kernel.org>
Date: Thu, 14 May 2026 16:40:05 +0000
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 13 May 2026 10:59:45 -1000:

> git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.1-rc3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0913b580f8490caaaf08dd1591e0bc07ac2720cb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
