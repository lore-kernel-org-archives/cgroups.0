Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31B514EC73
	for <cgroups@vger.kernel.org>; Sat, 14 Mar 2026 09:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773479884; cv=none; b=Uy61ya1BLWuevwxuJEWRmN7VMOkH1aFr2jolYnE7lyOyoZIPmfgZrVFlyhJIT5090bBxqyWSlFVXdMpbDxuuBOWvP3GHUAi2+XGuXiGXSqCE4qzYOz+/tHmTZqXOFmSheU18ESG2cYseH0Oke1gByXW+M9SSrlenOLH53lqhuOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773479884; c=relaxed/simple;
	bh=QWYHgF2U0wYDzLjZRZsKk1Sb2dueEXut//IM2sWmukY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K1gnmzj5hAyIxPh5g958LiCeQeaiXBZyyv2xC/rWiPVvNtFc8wBO3/BBNmqg9GWw6/G80dmJ6VY2P9LXcTbOXOA6793EtCtP2BCXUgrfCDQMwVDkpQHKIWyxYrtp7TvNc70xrOgD5no3zw1WOMVY2ncDd95dZHB3D8ZMIokFV24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=4PzGEU9M; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=7BzrdUhT; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="4PzGEU9M";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="7BzrdUhT"
Date: Sat, 14 Mar 2026 10:17:52 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1773479874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pqH/l6bYhrPe7oidKxX4BdHLqO0dpH8/I+brV0dWCsI=;
	b=4PzGEU9MM0/fidlqUf8nUl9uwjZm8fSi0anfV9F4vTxDDCaJzNymi8gIp88Tj3SrHoOUiB
	7aqA3boagCFM1KWRihOJtGU59uCoOCmcyHVOACmyZox3gqj4iKqtT2ixWJgfjIQ3n+mqjt
	VLTJZJhCBikRwui5Vn8eACotZjNfNxmdXpaPuYAvHpkz2woth1FoKRVxy3hFVxZpO6+3ot
	LyAkpfmwCpHPs7W73sSZ2nT+zmJrxuszX5U2fri4dXVGb8x1iZbDT+jRsQFo4w+tum5+Wn
	rtQe0aVXB3iYEmp1lnQvrOTxWfuKIRyfIn/ckDKVAL+qDzfDIVcRQgQoZpu6sQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1773479874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pqH/l6bYhrPe7oidKxX4BdHLqO0dpH8/I+brV0dWCsI=;
	b=7BzrdUhTrZxwwRmuiezFIcVk34DmmrfhOMpRDXMgUoAENJW3uD/t/2+6d9tz9aty50qPjR
	RWGdIXYiSlVoqoBg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	Ben Segall <bsegall@google.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH] cgroup: Move cgroup_task_dead() to task_struct clean up
Message-ID: <20260314091752.B7CXvQxn@linutronix.de>
References: <20260311120829.rEHY-xh9@linutronix.de>
 <ydymxaffr2s7npif37msq5q467m2ql26ib6wifwoztuhqmg4ao@id5c532lhorb>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <ydymxaffr2s7npif37msq5q467m2ql26ib6wifwoztuhqmg4ao@id5c532lhorb>

On 2026-03-13 18:33:14 [+0100], Michal Koutn=C3=BD wrote:
> Hello.
>=20
> On Wed, Mar 11, 2026 at 01:08:29PM +0100, Sebastian Andrzej Siewior <bige=
asy@linutronix.de> wrote:
> > @@ -7084,6 +7031,7 @@ void cgroup_task_free(struct task_struct *task)
> >  {
> >  	struct css_set *cset =3D task_css_set(task);
> > =20
> > +	cgroup_task_dead(task);
> >  	if (!list_empty(&task->cg_list)) {
> >  		spin_lock_irq(&css_set_lock);
> >  		css_set_skip_task_iters(task_css_set(task), task);
>=20
> Erm, isn't this way too late?

My understanding is that the point is that the cgroup must not be
exposed to userland once the task is about to die. This has been moved
after the fine schedule() which is too late because the parent is
signaled before that and the removal happens after that.
So now we hide the tasks in the iterator once the task is PF_EXITING.

> I see that cset->dying_tasks is appended in do_cgroup_task_dead() (which
> I was used to find in cgroup_exit()).

So this could be probably removed later on if this is the only purpose.

> (Also, whole cgroup_task_dead() becomes single use thing so it could be
> open-coded in the place where it belongs.)

If this what we want, I could inline it there.

> Thanks,
> Michal

Sebastian
