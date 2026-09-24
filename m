Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA881279329;
	Thu, 24 Sep 2026 08:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790237166; cv=none; b=KJDHBT7tqHTYpxipAGLv/Q2itldlMDMMHnBAtQWFKIsSMOnSzK/T0+Ybzunf5IuRCbuMMO89BPHegVKl50aQTnUVGK4PfjpSpspyISNHfV98Wg9hq0emuwHfdUl6OmL6X9QH+1OX1WFmTrproIHdpfECitkVBxdvGuySEBxGtzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790237166; c=relaxed/simple;
	bh=fMy5L3onQ/mCMbk9uvhdtszHR00Q4pNzwNngSluHJU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CbzH2U6efl9iMVXLs22pWZGs8iFylIswIYWoEfp/TihVqLI4lr5QvHEPwDJYHb2iAx/PNulORULBz6fmg5rzdN5Ex18E8rhbZV06KlGCj39ej2qgf2GXuDeyU19aoDgpuYL6cTplIGgK+cC2yzwWix4qidWFI8A5Dy5cUwITgro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=F9wM4CdT; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F9wM4CdT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=D4pwJDZWOqh/hw3D17gGVEdJvGYroglznr17ndoiVvg=; b=F9wM4CdTNbYPVU80xe6fdTWnzF
	bvdZA245J9hWqzvUER1qYYN4LlttZZfSmKidXPwnldI4ShJmTtHG5O1WMEcPMpkvM7wlTBgZZvvWg
	MGz0MsjR0Zx4sE5VS6JwP8pUwcH5lejuK39d9GRjOIJoskT9TP8+KoKzwR8z/6ryebh4Ux5s5huCa
	Cvt9jmsnWd/8Co0lbE614AZEsUUYGArsEGAcQsnEdCbEitSCMQO5lgRQfRfABYhP+w72dKWzMC6OF
	/jxTaFkxPZM3t0EN6vXHQ9rl/I7VLD1MzaRvdEoxtL0yrHT6nLx1FsC7/v5qVbg69S5rvfjxbEj8v
	T1lu1IMA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x9eSl-0000000FhPN-1wnb;
	Thu, 24 Sep 2026 08:05:52 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 97186300756; Thu, 24 Sep 2026 10:05:50 +0200 (CEST)
Date: Thu, 24 Sep 2026 10:05:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	Paul McKenney <paulmck@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>, Christian Brauner <christian@brauner.io>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] locking: opt-in tracking of sleeping lock holders
Message-ID: <20260924080550.GI2009045@noisy.programming.kicks-ass.net>
References: <cover.1790139577.git.shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1790139577.git.shakeel.butt@linux.dev>

On Tue, Sep 22, 2026 at 10:01:17PM -0700, Shakeel Butt wrote:

> Shakeel Butt (7):
>   locking: add opt-in tracking of sleeping lock holders
>   locking/rwsem: track holders of opted-in rw_semaphores
>   locking/mutex: track holders of opted-in mutexes
>   locking/percpu-rwsem: track holders of opted-in percpu_rw_semaphores
>   locking/selftests: add KUnit tests for lock holder tracking
>   Documentation/locking: document sleeping lock holder tracking
>   kernfs, cgroup: track holders of the cgroupfs locks

Not sure what's gone wrong, but I only have a partial set. If you want
me to look at them, send me whole set.
