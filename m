Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F67C32572F;
	Thu, 14 May 2026 22:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778797231; cv=none; b=dEKi/yKxEbv2UblxHXluuveB2XfeJRDwPnXkJPsgLo/7lBWmAUtogjeqtDx+fYrmoLunPSowuH2lHGFvEQi0/eSUhOpPHfaHc84/uSMEPjHxT6G3YLsHl7Roqi2wxGw/SS1+Ks+xYIvsdze/WZ/WqGBvQl52mVDpLWfMlkBudr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778797231; c=relaxed/simple;
	bh=6Eaq2f+J/zWvVEzvWYmoFBIswIN1eoI1PJywJCiqFaM=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=oPKp3prvsZZ3gryN0DxCXPcV5140cXMlnzrKXOfQXiwbnN/k64pjU4LW7LwoT3s8WQIgPRW/vLrauh9atn5AmyDfh3maxPvrYNiDaSCepX3cmP7KCuRMNA/v2srv19njKPFVXh0AwFu4oDjE6/kvTyoHu3JYp/L5PRXiQWXdJqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TCOsHtGZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TCOsHtGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2100AC2BCC7;
	Thu, 14 May 2026 22:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778797231;
	bh=6Eaq2f+J/zWvVEzvWYmoFBIswIN1eoI1PJywJCiqFaM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TCOsHtGZXR9IFUa3/QvVtv1UGZ9KEJH/GjjPlRCQq6eAcYYbJAMsm9jpfuiWzMTPj
	 YVVCPDy85+q+h6FAdwqP9AQ8rl0tf7RV+fm67NN4ZTTxCt+mFp+KSn+J+gcRu7mwLh
	 RCP3R3RC35dbbqcTeilfcFL9yxR77xt/6BY1f3J+xE4Ev9ZWW6LXfkeihp1t66lUwt
	 ps9p2VvZp6ONZvo2fvIMCuLrDI6A/qHfRDKk3h/SF28Q/bdSBIdS0navCbf54awAKC
	 YSGpF9DG81I1DDnUjV3+dM0Q1CtMXnepufzRz434W+wehM5FNzWbaAo4WC/QfVKZf7
	 hG83NQRaPb2ow==
Date: Thu, 14 May 2026 12:20:30 -1000
Message-ID: <8672eb9e7bbd6abde7762feb267799c5@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: luca abeni <luca.abeni@santannapisa.it>
Cc: Yuri Andriaccio <yuri.andriaccio@santannapisa.it>,
 Peter Zijlstra <peterz@infradead.org>,
 Yuri Andriaccio <yurand2000@gmail.com>,
 Ingo Molnar <mingo@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>,
 linux-kernel@vger.kernel.org,
 hannes@cmpxchg.org,
 mkoutny@suse.com,
 cgroups@vger.kernel.org
Subject: Re: [RFC PATCH v5 20/29] sched/deadline: Allow deeper hierarchies
 of RT cgroups
In-Reply-To: <20260514092546.4265d486@luca64>
References: <20260430213835.62217-1-yurand2000@gmail.com>
 <20260430213835.62217-21-yurand2000@gmail.com>
 <20260505151523.GF3102624@noisy.programming.kicks-ass.net>
 <afpLir8tD0Ycb3D8@slm.duckdns.org>
 <20260507163058.2c435922@nowhere>
 <agIfvZuvXEtK45em@slm.duckdns.org>
 <c446b9be-38d7-425c-9ca8-eda721fe1c9e@santannapisa.it>
 <b549b3cb062f2823ba6d4723b7b9260b@kernel.org>
 <20260514092546.4265d486@luca64>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Luca.

Yes, the admission rule prevents subtrees from escaping ancestors'
cpu.rt.max, which addresses the main concern.

Two interface simplifications worth considering on top:

1. Drop cpu.rt.min. The parent already owns the partitioning of its
   cpu.rt.max via the children's cpu.rt.max values, so the local share
   is just the leftover. Admission collapses to Sum(children.max.util)
   <= max.util, and the cgroup's own DL server runs at cpu.rt.max's
   period with the remaining utilization. One fewer knob, no
   information lost.

2. Use "max" as the off/inherit sentinel instead of "root". Matches the
   existing cpu.max convention. At the root cgroup, "max" means the
   feature is off and behavior matches today; at non-root cgroups,
   "max" means tasks bubble up to the nearest configured ancestor.
   "root" reads oddly at the root cgroup, where it really just means
   "no DL server".

Auto-revert falls out for free: writing "max" at the root cascades
descendants back to "max", since manual tear-down isn't reachable
anyway (you can't set a leaf to "max" while its parent isn't).

Thanks.

--
tejun
