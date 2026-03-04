Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47313CD8A3;
	Wed,  4 Mar 2026 19:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772652138; cv=none; b=pIw4i3IJBmq4WFLLwbnQwE6BgGOsQuBvEejXLzO5QaxLCUGPp6V0O64o+kaoFJGuJFHd2jCrowGsO8OM+py1Al7kwGrhncXVxsgRXrHVt3XDFkcJyRZE0+KdB93l+MahkD/BDS54fmAL//kXBPc9u7SKkBxL+q3fk7YmzzF5hcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772652138; c=relaxed/simple;
	bh=pgoTi6PGFtDox7b9hbGxnsMNwDeGnoXcoXrDbFeJ/gM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ML99TdCAyKT89aiqpTSFE/Gu/DVJpstgkqoRkS/eVWeFbE8rWmvNlQxPAQ9hhcJm5H/sAIezG/6mRT2b7L9pT3pFK2sGBpg9AQUflqULcuSy9VsRFE3/3UJlczJOjp4mODlOz2HRWn2QU04l8rTuGvDYhUomKKfUNWYxWKbnob0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qBfQQ4H4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qBfQQ4H4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480CAC4CEF7;
	Wed,  4 Mar 2026 19:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772652138;
	bh=pgoTi6PGFtDox7b9hbGxnsMNwDeGnoXcoXrDbFeJ/gM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qBfQQ4H4I1of8QHOgpD8BDtMbgfyuB2shTLSPqX6lCVJHMqSdD1dmO1GaoLmyTEGx
	 7ZGCCAo2xCSuga54+a6vbhppKzU8tUo9DAe4EgCHY5cw9BsQtVHNgXw5BiLna52jDf
	 +NMhlOzFWOrT/YHpSxZ20y0n4an2xnwKbxpOcb+h5zXH6ivS9QqQ8dkiBQMOyPXcTj
	 L/HBSdMBPaXWABOGbATxs3pRtzvwzMEOfRcq1QGToOK+DpObwmrDoHrwqb29CCS6FW
	 RrpttvqieV3YzneG3QOXVXfRY73gy8Gf1x06CdfApjQ6/QbeOzcnkod74biTAvX7BE
	 1Y/xiZ9mVWe1A==
Date: Wed, 4 Mar 2026 09:22:17 -1000
From: Tejun Heo <tj@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-devel@lists.linux.dev, cgroups@vger.kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Bert Karwatzki <spasswolf@web.de>
Subject: Re: [PATCH] cgroup: Don't expose dead tasks in cgroup
Message-ID: <aaiGaV6vdb0cFiei@slm.duckdns.org>
References: <20260302120738.6KkDipsR@linutronix.de>
 <20260303131301.ieSSCM4n@linutronix.de>
 <aachZbIFl6HCFSxD@slm.duckdns.org>
 <e3897a34013dcc785e93f503512574c9@kernel.org>
 <20260304191617.xFJgRT85@linutronix.de>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304191617.xFJgRT85@linutronix.de>

Hello,

On Wed, Mar 04, 2026 at 08:16:17PM +0100, Sebastian Andrzej Siewior wrote:
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -5108,6 +5108,8 @@ static void css_task_iter_advance(struct css_task_iter *it)
>  		return;
>  
>  	task = list_entry(it->task_pos, struct task_struct, cg_list);
> +	if ((task->flags & PF_EXITING) && !atomic_read(&task->signal->live))
> +		goto repeat;
>  
>  	if (it->flags & CSS_TASK_ITER_PROCS) {
>  		/* if PROCS, skip over tasks which aren't group leaders */
> 
> does work.
> So we delay the removal due to sched_ext and then hide due to userspace.
> Nice ;)

sched_ext made it more visible but the problem is shared in cgroup
controller in general. We don't want a cgroup to become empty while there's
active resource consumption going on and we tell userspace the task is dead
before it switches out for the last time, so...

> The signal check is to see the zombies, so you they pop up in the list
> until a waitpid()?
> Anyway, do you want me make a proper patch out of it?

Yes, please.

Thanks.

-- 
tejun
