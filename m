Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F37397341;
	Wed, 15 Jul 2026 14:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784127184; cv=none; b=ir9r60M0tFx+4SYHG7KSkAD0kXi+s6NDycf9k3M1B/EmCb6+r6hkjUSvGBwEZm6hFC232aquDu0RTlynU6fxSOgHk9D5tSu9OmBQoVBMLsenk86slpN4yQksO2IAN6RxivrUXNsD45/dbECKHFVY+7oZQaOlA5A8RCUEQWC34B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784127184; c=relaxed/simple;
	bh=oOW/i3u2gDqzP3S18fPy+MdUIeXPVEpZ9/Z2DpO7uq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rotSv+QKp6Tgkd6kqGfUfyG8iJpFjDM1eo9lgHDSySWHtAKpApcrAkN0KwDIwheRetUoMMCq1VZi2B25JzFpLF/4erKaI0WnNeNmtrSxDY89gv161NSrt9TQ/dNomdbxoPK/pw2zTBZcyzaydDflV2tG4ALykZZnvR2aWbxkyJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L2yL9AdT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L2yL9AdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E321F00A3F;
	Wed, 15 Jul 2026 14:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784127182;
	bh=IGI7jhE2HjCJJxqodayCLjM3G9IgdjGjn7HLTwbN1HE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=L2yL9AdTJ5x+gPpxFTOQHsSXG/Nl+jnXj6B+Zpe3/UzyX1FXpmbdVdOswtXj1IsfN
	 Yf3ZVJcglBSpr8sbJVjor1ltGBE/c5qQUmaLdwadMcESASEbINkDYN9aELjrJaTX7h
	 o3nUxzh7s4XoRzeC0fzL04tUxQbfQaCq7A+d0jiIhViObzw/L3W30AFC7d4GqVix04
	 lzvjxNhZJZFmFGLUpzmJ1qJsPvd8LYovF4/o0a5z3JgLjlYsd1cmFVihZIAHi+by2E
	 EKHNXqBIazm46W2GvJIioltmtbvwOfjVYzV0Y3VWsr39XRLxnkQAkWidm8cvFVl3Zc
	 OOFwlPvbQndng==
Date: Wed, 15 Jul 2026 04:53:01 -1000
From: Tejun Heo <tj@kernel.org>
To: Matt Fleming <matt@readmodwrite.com>
Cc: David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Edward Adam Davis <eadavis@qq.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
	"ziwei . dai" <ziwei.dai@unisoc.com>,
	"ke . wang" <ke.wang@unisoc.com>,
	Matt Fleming <mfleming@cloudflare.com>, sched-ext@lists.linux.dev,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [PATCHSET v2] sched/psi: Fix psimon fork deadlock and
 rtpoll_timer UAF
Message-ID: <aleezbzv6Fo72uiR@slm.duckdns.org>
References: <20260712174619.3553231-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712174619.3553231-1-tj@kernel.org>

On Sun, Jul 12, 2026 at 07:46:17AM -1000, Tejun Heo wrote:
> Hello,
> 
> v2: - Retagged sched/psi (was cgroup) (patch 1).
>     - Added a fix for a pre-existing rtpoll_timer use-after-free that the
>       Sashiko AI review flagged on the previous posting (patch 2).
> 
> v1: https://lore.kernel.org/r/20260710134945-psimon-fix-tj@kernel.org
> 
> a5b98009f16d ("sched/psi: fix race between file release and pressure
> write") made pressure_write() fork the psimon kthread while holding
> cgroup_mutex, which deadlocks against the sched_ext enable path blocking
> forks before grabbing cgroup_mutex. Patch 1 moves the fork outside
> cgroup_mutex. Patch 2 fixes the use-after-free from a schedule attempt
> re-arming group->rtpoll_timer behind psi_trigger_destroy() by shutting
> down the timer when the group is freed.
> 
> Matt, patch 1 is unchanged from the previous posting except for the
> subject prefix, so test results against that posting still apply.
> 
> Peter, once these are reviewed and tested, how do you want them routed?
> I can take them through the cgroup tree if that works for you.

Applying this to cgroup/for-7.2-fixes. Please holler for any objections.

Thanks.

-- 
tejun
