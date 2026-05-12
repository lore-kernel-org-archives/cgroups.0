Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAB3356741;
	Tue, 12 May 2026 18:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609944; cv=none; b=B8W1bDsc+d35BCI+AdsNOIdHRJZk6V1SosJLqfRqR1M/ex7WlJxuOE+9/xWJ4rVuvudEWq8QR3MqOUMvdLOdoc6EOFCAXKezC4YB1lLdQ7z9NKTya7YVy0wfpU+h3ih0W9dKy72+3ulA4tMpzlgiT5zfb17Dijv+DGUIKiLs9s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609944; c=relaxed/simple;
	bh=N1WR3oJ1M93TcD66wBLy2PuWMj8UZxgV3MASIKa8ASQ=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=fiTSFaQIW+JwSv3RrWhk9rj71jHdmYfix7pDmkaa/U8HZtqee31sZVfa6AH60XlNptKFVTHdz3TuL1SAaI/Rzgp9cpfhGdQX13kdoxQBfPdKQJ33dLz35ktjqQc8wH9d83t2b+cjucRBaKkfvwavoK0Mf6JqJOucQy0vVt6FtnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=khvrq4K2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="khvrq4K2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B0BC2BCB0;
	Tue, 12 May 2026 18:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778609943;
	bh=N1WR3oJ1M93TcD66wBLy2PuWMj8UZxgV3MASIKa8ASQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=khvrq4K2MyB3BP5e6Ktn3Qv97UAv1E7VdARTMcF1cD8KFpXm/zHbstfmnjLhzAwCR
	 xAPUV6ZDID4rH8AkOmQ1mLXw+yFDW+/5s/bqZzkvrPuVu6dhVxjx0B2m0GqI3A1igF
	 81zPUeNwaE23dzWmLutR/ng0Yfl8GPzRfKkpneT0Csa7t1x1AUESIM+EupAzVpfufS
	 LHj3F5aRUFTh6WDBrlrJRm5SkEqsxMr3zJAfGdMx0PHMzycZzn01ywPQHwDpSKbmGJ
	 WRobJUCYkDtKyBrjTUbLBA8lXipvknd7fB8W2/QFIOW95FqsRfkrlTcfXXFrAe3xwG
	 g/LT0IKKSiROA==
Date: Tue, 12 May 2026 08:19:02 -1000
Message-ID: <b549b3cb062f2823ba6d4723b7b9260b@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Yuri Andriaccio <yuri.andriaccio@santannapisa.it>
Cc: luca abeni <luca.abeni@santannapisa.it>,
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
In-Reply-To: <c446b9be-38d7-425c-9ca8-eda721fe1c9e@santannapisa.it>
References: <20260430213835.62217-1-yurand2000@gmail.com>
 <20260430213835.62217-21-yurand2000@gmail.com>
 <20260505151523.GF3102624@noisy.programming.kicks-ass.net>
 <afpLir8tD0Ycb3D8@slm.duckdns.org>
 <20260507163058.2c435922@nowhere>
 <agIfvZuvXEtK45em@slm.duckdns.org>
 <c446b9be-38d7-425c-9ca8-eda721fe1c9e@santannapisa.it>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

How is a delegated subtree prevented from setting cpu.rt.min = 'root' and
escaping its ancestors' cpu.rt.max budget?

Thanks.

--
tejun
