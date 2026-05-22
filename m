Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F91392828;
	Fri, 22 May 2026 23:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779493438; cv=none; b=UXuea/uQK5wtD2rEUhNmtd2qBOOUCzBelfXwToKHyLwwaWNSu4/vlh7m4+VgnSMJ+FadPCwkxfYvi2KV12AamYizrrMILPpVsqDtvYOudUDa5lCtR5o3+90GcN6MdyOKGzw/c23I8AsPWNMCKHz/GulJJgHhJsaEEEMqb21ix0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779493438; c=relaxed/simple;
	bh=pi1QjVqt+0xcTuauMPmhlMua9Mketrk1oKXW8t6YGSY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=B9nID2nvYNkmB5o1qkRv/t0Irqvmil0iNke60JGnzepFBmLtjSgN1ucfOz8o9Cre8cvevmDs3FHkF9AJH3WDNZA4bYAxkWymNkxmZHwdDnzPLapcfmGSjuMEq2vZhzdkstZ8tkOIl4TbhYjcG+fRlpk0yI3ZSSkWGWodP0ME/K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=owxdnDc2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="owxdnDc2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEBD1F000E9;
	Fri, 22 May 2026 23:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779493436;
	bh=CbiRHgiGyGbRLS8PpK/UEvnugabe6Lt1+50vDtqN0Qs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=owxdnDc2XKkv8q/sg+vo+OzaYryQXLNmehWi66lGhhykDyZ/xIF9XmYT4PlYyRL4X
	 z/XtPXM7U8zXR/yyqeQEPzq33xXyPof0e9E3i/BAG03TD+oRV+CAyP8cY0idCY+vJE
	 5SMblcrbG1/xiNPaRu7uHxstD7E9NwNVOLsLhqMWsxB+FkFuNUi644LWUGWfa3Avux
	 CYRyxpiKdsWmi85+tmheNIEv/YkMlKRXwlv6yNka0ATnCR/RVNbY4hKakaXRpB42/f
	 R80dRzn3tTCSt3UTggk6t+FO7LQKf6GtnCjoXrdg79La3jBGDPLWIPN3uegu0JpZMs
	 87u2OhN3/nHew==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0A94393100F;
	Fri, 22 May 2026 23:44:06 +0000 (UTC)
Subject: Re: [GIT PULL] cgroup: Fixes for v7.1-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <cff491d26895c2d56392d153592009ea@kernel.org>
References: <cff491d26895c2d56392d153592009ea@kernel.org>
X-PR-Tracked-List-Id: <cgroups.vger.kernel.org>
X-PR-Tracked-Message-Id: <cff491d26895c2d56392d153592009ea@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.1-rc4-fixes
X-PR-Tracked-Commit-Id: 22572dbcd3486e6c4dced877125bbf50e4e24edf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: de37e502a315677138009d2965f87e2c0721e76f
Message-Id: <177949344553.1408813.10404655840652147470.pr-tracker-bot@kernel.org>
Date: Fri, 22 May 2026 23:44:05 +0000
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 22 May 2026 06:47:51 -1000:

> git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.1-rc4-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/de37e502a315677138009d2965f87e2c0721e76f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
