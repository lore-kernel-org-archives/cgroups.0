Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7E53B8958;
	Fri,  5 Jun 2026 15:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780672392; cv=none; b=J2/ywGQwRBFsR6nlRPl8pmg/+6cndN+E2ZjdxIvisTbrEZrMU4TCpCg4a2OMMjbXej7mqPlHZpWgdHV2NSZwhYMFu54avj11FUVYuN44AtWbnrGwfoWVEHodVxOZurtCAkPDAqGDjAkscn7Ig42UYu0tOQWjPBHWy+vrN5rLj+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780672392; c=relaxed/simple;
	bh=SZXTFqBeWNU8o2baX8AIUXgoUdkdWZrTkypA0qEaBvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HNHP3o+OTaZNch8JpPo/gg4lgQWztRmnNbPtmTYwF/DXYcFS6r6BS47NnyyIhLtp//4CdUliIKHZz8z3wurhTZD3VHzh6bQayyb6zdLbmNQ1S89LrD6itnoCSw0J+jS4ybzh8PgWXv+za4vwdUD9Oef1gZyl6gVxrGVY16jg33I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OrV5u+9F; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OrV5u+9F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rplKE1cDt2PxD7RNYFurKRhUkQYpl++hHWZ6g039jnI=; b=OrV5u+9FOmIuDrXfEmU8JYwOGj
	GFoqvr2ddOeTPi7mhwD4KZtxyJGhHRTLHx6uR8j7YCoPUAOclo4EzrmU6M51dWgPCRnl0EbyE3448
	I67S94JQoS1S8Zf200tNI/RC46tcFTm5LPKZTGhv1lGhLZW0M57qFqK06J9yWvmKLBw0m0OvWBLdq
	3i9rOyeSb9peIkF+KrFnH4FJVlThqdErW+pBjN5QWGCjQZVgx7ncl6DbqoylKv2iaDcY0ltAxhUZK
	ZG0GqtgLaFIFCW4YOtzjnrEGdFDt69vSmqIpSKcmIRg0MP2kJpxzHriZKc31ltn5RAGd9O50ky3kM
	s93ulp8Q==;
Received: from 2001-1c00-8d85-4b00-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:4b00:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wVW9M-0000000FkOk-0E82;
	Fri, 05 Jun 2026 15:07:56 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0B4153001FD; Fri, 05 Jun 2026 17:07:54 +0200 (CEST)
Date: Fri, 5 Jun 2026 17:07:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org
Cc: longman@redhat.com, chenridong@huaweicloud.com, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, jstultz@google.com,
	kprateek.nayak@amd.com, qyousef@layalina.io
Subject: Re: [PATCH v3 2/7] sched/fair: Add cgroup_mode: up
Message-ID: <20260605150753.GA3117850@noisy.programming.kicks-ass.net>
References: <20260605105513.354837583@infradead.org>
 <20260605124051.450303977@infradead.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260605124051.450303977@infradead.org>

On Fri, Jun 05, 2026 at 02:40:15PM +0200, Peter Zijlstra wrote:
> Instead of calculating the proportional fraction of the group weight for each
> CPU, just give each CPU the full measure, ignoring these pesky SMP problems.
> 
> This makes the SMP cgroup fraction (F_g_n) equal to 1, and ensures a single
> task in a cgroup competes on equal footing to a task in a level above.
> 
> However, as already explored, this is not a very good policy because it gets
> the SMP weight distribution wrong. Included for completeness.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  kernel/sched/debug.c |    5 ++++-
>  kernel/sched/fair.c  |   31 +++++++++++++++++++++++++++++--
>  kernel/sched/sched.h |    1 +
>  3 files changed, 34 insertions(+), 3 deletions(-)
> 
> --- a/kernel/sched/debug.c
> +++ b/kernel/sched/debug.c
> @@ -271,6 +271,7 @@ static ssize_t sched_dynamic_write(struc
>  	if (mode < 0)
>  		return mode;
>  
> +	__sched_cgroup_mode_update(mode);
>  	sched_dynamic_update(mode);
>  
>  	*ppos += cnt;

Yeez, I'm not sute WTF happened here. Let me go fix that up.
