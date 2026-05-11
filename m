Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D53B383C9F;
	Mon, 11 May 2026 20:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778531359; cv=none; b=Ojap81u1DImojrjgesHuZw3izVyuktFzDfpbsr5d5ZRbu1z2+WIOXuzwhsHXzV7uenk7rT+UZG0XN93hb6LXWvaPbelmSNwVkW0+ehPeKc3bUeVDD8NBX4CD03IksVrUD3IIuyENH/h406W9DQnh1d66SZpeQuhx/DXpqVXUgOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778531359; c=relaxed/simple;
	bh=hWjbWtiDBu72Qh74EE3ReQTIoVFBCz4fbmKcz4u3yDE=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=T/PzjO2kZJJ61HfS0xRc/zo6yUl2lHHESFxlEvket61m/4bU39E0JRpT6eHUsYwSUMZLLxeNUDIizhyBlNDUaMfMY7LWU95BTbbMag+fy4S4g5tg8+rSNq4TlnYK9Fm9/kVuHB7W+cFfxH7CwTozJwNJFeCTEHJmxHjinEgrpog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kHF14FNH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kHF14FNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826A5C2BCFB;
	Mon, 11 May 2026 20:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778531358;
	bh=hWjbWtiDBu72Qh74EE3ReQTIoVFBCz4fbmKcz4u3yDE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kHF14FNHMVv4PRelWdRKSIUWnVFiL+28HaA8/LyT/wR6QQrbDAQlqvhwH1mlWE4Ng
	 0Y3SC5tL1R9RkmYFDvOQOEe4U1vut9gfoykhMJdc6w+zfov+OgV9PlMIcMBefzn33n
	 KOGhUAPfCf3PMR8yFwZZ3rW+MH72UVep42LfGLkqoQXMfexs80L5NuP6KATvgi9lwc
	 a7FNmx1dNJ0uhHaqvQC6kAslcD3lMSFH/8BU3vejhsmHyDDqrCu3Uvyvy6xUOl9Tv4
	 lEhp2toWn/qQTRLqpSOwNae6z9lRGyTdVoSBqMF6FEH9eKbqFS9FiJ78PZyBwm9lli
	 sV2MOJ57aKAOw==
Date: Mon, 11 May 2026 10:29:17 -1000
Message-ID: <9cd69a018db1e06365c62f7f210334bc@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Guopeng Zhang <zhangguopeng@kylinos.cn>
Cc: Waiman Long <longman@redhat.com>,
 Michal Koutný <mkoutny@suse.com>,
 Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Chen Ridong <chenridong@huaweicloud.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 Gabriele Monaco <gmonaco@redhat.com>,
 Will Deacon <will@kernel.org>,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org
Subject: Re: [PATCH v3 2/2] cgroup/cpuset: reserve DL bandwidth only for
 root-domain moves
In-Reply-To: <20260509102031.97608-3-zhangguopeng@kylinos.cn>
References: <20260509102031.97608-3-zhangguopeng@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied to cgroup/for-7.1-fixes with Cc: stable@vger.kernel.org # v6.10+.

Thanks.

--
tejun
