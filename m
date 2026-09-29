Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2B53955C6;
	Tue, 29 Sep 2026 19:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790708945; cv=none; b=tDlw6x04LDRH43P1fLqYHO8CB8nHzXuEJ+F7WFhb726CTBxXAFodeX6bsZsyBRvGsqkuQR6qUMrk8X9T0ep8mJrOEvjZtrd1L5zXF50WM2G61fhX2drdS7/Pmz4nSuzB9SJwaGXFGiLbnbc2naCD8329m2YS6CHOTQ0nHKFf5DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790708945; c=relaxed/simple;
	bh=SC6HOZFcYJzZCPX+dxp9uLuOUF4afdKYZn1w1K8DwOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E0x7vWLgga1EdGTMKHetaPpTQAhuqGsvHkbccNUlz4OzJu0KfVMMsGrKJny704o8BUx0Ed+HW6fLadqE85X5iGXuSdZceI7EUk5tCADYUFJLq48L/ZJoU1y3HkAAQsHFQSfJzM3pNwRbE0XJvbcBLJtuTuTaPSr/UUAA1F6yhXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=W6A85EXA; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W6A85EXA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5BP/r/OD3abfcxZ5Nl2VrwziwrPOkjL7mZz1hc5au/w=; b=W6A85EXAAWy4w/3evgfbXjro/X
	GNL1UnxuoXm0vWHUJRX4wqis2+Waiv4ciufyHYkicVgC/uR3HWHOVGN8hgZnsz6Lx43av7Q95wMab
	JB3akywaVkjl6LZbdnzBcK04bnRxdORTOBR6jIbh0McIdLlmjXL9fSvoaqxjvLfFE5loRfE3d15d0
	pu9dQRkQ/C9sCez9UtjM9+r9VqXv+NGvBxsfP4OQNwizpyxkRav6FblbhR97pdUmNdNpkfl+ELgP/
	QpV2Ikxl8rU8r2GQ3bXimEqHxNT17ORJs/FJy2WpDf14zlsPLGMDrrWFzrR0fzPgCHwRSzMH6bNiy
	VtAmH7iQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xBdCB-0000000G9mg-1Ilq;
	Tue, 29 Sep 2026 19:08:56 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 12C0F30093A; Tue, 29 Sep 2026 21:08:54 +0200 (CEST)
Date: Tue, 29 Sep 2026 21:08:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <longman@redhat.com>
Cc: Andrea Righi <arighi@nvidia.com>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>, David Vernet <void@manifault.com>,
	Changwoo Min <changwoo@igalia.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, sched-ext@lists.linux.dev,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] cgroup/cpuset: Protect is_in_v2_mode() in
 cpuset_num_cpus()
Message-ID: <20260929190853.GE88198@noisy.programming.kicks-ass.net>
References: <20260929084124.626693-1-arighi@nvidia.com>
 <20260929084124.626693-2-arighi@nvidia.com>
 <20260929-making-language-254d9c6a6605@there>
 <af938567-01d2-4518-8f7e-974828e25d3e@redhat.com>
 <arv2-3-6-Ewv0gpb@gpd4>
 <b8f66cbe-bb1e-4148-b2e2-55bd95f1c8d1@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8f66cbe-bb1e-4148-b2e2-55bd95f1c8d1@redhat.com>

On Tue, Sep 29, 2026 at 02:10:40PM -0400, Waiman Long wrote:
> On 9/29/26 1:35 PM, Andrea Righi wrote:

> > > I think it is simpler to just change is_in_v2_mode() to cpuset_v2(). Almost
> > > all the cpuset functions should either take the callback_lock with interrupt
> > > disabled (which is a RCU read-side critical section) or with rcu_read_lock()
> > > and cpuset_mutex() acquired. This cpuset_num_cpus() function is an
> > > exception. Given what is said in the comment, this function is not supposed
> > > to be used with v1 mounted. We should change it to cpuset_v2().

> > The comment says that, outside cgroup v2, cpuset_num_cpus() falls back to
> > num_online_cpus(). However, on v1 with cpu and cpuset mounted together using
> > cpuset_v2_mode, it returns the group's effective cpuset count and fair.c uses
> > that count in the default "concur" group share calculation and in "max" mode.
> > 
> > So replacing is_in_v2_mode() with cpuset_v2() would change scheduler behavior
> > for that setup. I guess we could either preserve the current behavior, fix the
> > comment and protect the root lookup with RCU; or make the code follow the
> > documented v2-only behavior. Which one would you prefer?

> I will let Peter decide if he wants to support the cpuset_v2_mode mount
> option of cgroup v1 since he is the original author of cpuset_num_cpus(). If
> this is supported, we have to update the function comment as well.

So I was not aware of this weird mount option at all. That said, ideally
it would work in the widest possible setting.

The main constraint is going from a cpu-cgroup to a cpuset-cgroup. It
was my understanding that this transition only works in v2, but if that
mount option is sufficient to make that cross-cgroup transition
meaningful, then yay I suppose.
