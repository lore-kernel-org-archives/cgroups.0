Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A1737F00A
	for <cgroups@vger.kernel.org>; Wed,  4 Mar 2026 19:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772651781; cv=none; b=mqzIP5Yuk5F01iyGhYKE+vjODYJUuFQtGvrS06czFEGjZjZpqI+s3J0uOa+N6+PFclLVQKLWqbRJ8z2H4BCGJkiwMiHr+qhotvujzXXDIbo2gHGMHaEqH9cjHgciooDlS1YRECF+VGlFBb2VDO3vvTBKWIGkrn1dmt2+NwLnleQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772651781; c=relaxed/simple;
	bh=13EDEFgxbbdA8a1BMHHFY9wgkTFJOG3SWj0TnjRwRsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cJL0tgooF5stD2drkI6ZaTVxY75xTnwX4cVe4bCC8spusH6/i0qJLQmqf55PCVBMvmRXspKoKguPM7JjRiN9bAksjojGyWUN2jcBctlOyNTpHhXARru516w9V6gppYPHrxzfjejK8K9hrBcwUzFqj0L373/tI7x9DzMiDTA85Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=2vtrV0lN; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=+1FbgNTo; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="2vtrV0lN";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="+1FbgNTo"
Date: Wed, 4 Mar 2026 20:16:17 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1772651778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DT4tLwxJhwfp5qtAl7JoV4ax0ojDo/Wp6ojL15trh70=;
	b=2vtrV0lNOqIxfc5Y9ZcP6FFD02uB/HRjPU42p1I/EtsEA1JM249xzB0tnjZ7ecxYSTZApS
	NntTy5sWqUlukfrOBMExL8UH4qBk0ZF2sgDMpr+255L5QfakgKVGZmcKu7+ni3voJGSukB
	AoBrbXcFm9CMfvV6KQg9Jmdfvz69gNxFIY+B+HAukyUt7GKxR2F+uQ+aRo9Z9DEzlBClyD
	4LmGGaqU4u95ZS11P/v4DhfOYkTQE1HoJEpwwnD2q+eUFOS90AhHZDElzYRk+AwZ13y4IT
	LxMT4o2Usqmui2V/3wqxzhdGFUE94bDTeTuAPdxBOlsrYlmRoBiPUC0l/QJ3wA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1772651778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DT4tLwxJhwfp5qtAl7JoV4ax0ojDo/Wp6ojL15trh70=;
	b=+1FbgNTo4hMpODIWkPn/FLz9m8Wi6HmKC/3WypmTtn/95OFtqFoQpvERBRMR1Snuu041gK
	SMXTlLCN1t/mdgCQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Tejun Heo <tj@kernel.org>
Cc: linux-rt-devel@lists.linux.dev, cgroups@vger.kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Bert Karwatzki <spasswolf@web.de>
Subject: Re: [PATCH] cgroup: Don't expose dead tasks in cgroup
Message-ID: <20260304191617.xFJgRT85@linutronix.de>
References: <20260302120738.6KkDipsR@linutronix.de>
 <20260303131301.ieSSCM4n@linutronix.de>
 <aachZbIFl6HCFSxD@slm.duckdns.org>
 <e3897a34013dcc785e93f503512574c9@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e3897a34013dcc785e93f503512574c9@kernel.org>

On 2026-03-03 10:22:38 [-1000], Tejun Heo wrote:
> So, I think we can fix this in the iterator without moving the unlink.
> css_task_iter_advance() already skips dying leaders w/ no live threads
> but only on the dying_tasks list, which gets populated too late. We can
> extend it to catch PF_EXITING tasks on the regular tasks list too:
> 
>   if ((task->flags & PF_EXITING) &&
>       !atomic_read(&task->signal->live))
>           goto repeat;
> 
> PF_EXITING is set in exit_signals() which is before exit_notify(), so
> by the time the parent wakes up, the flag is already set. The
> signal->live check keeps zombie leaders with live threads visible. I
> can't see anything that would break by this being checked earlier than
> cgroup_task_exit() - everything between PF_EXITING and
> cgroup_task_exit() is just teardown (mm, files, etc.) and it should
> close the race window.
> 
> Haven't tested this yet. What do you think?

So this

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5108,6 +5108,8 @@ static void css_task_iter_advance(struct css_task_iter *it)
 		return;
 
 	task = list_entry(it->task_pos, struct task_struct, cg_list);
+	if ((task->flags & PF_EXITING) && !atomic_read(&task->signal->live))
+		goto repeat;
 
 	if (it->flags & CSS_TASK_ITER_PROCS) {
 		/* if PROCS, skip over tasks which aren't group leaders */

does work.
So we delay the removal due to sched_ext and then hide due to userspace.
Nice ;)
The signal check is to see the zombies, so you they pop up in the list
until a waitpid()?
Anyway, do you want me make a proper patch out of it?

> Thanks.
> 

Sebastian
