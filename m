Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BC53B95EB;
	Thu,  1 Oct 2026 10:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790851329; cv=none; b=ZCiKpuHuqEmYrHauri997n5gtuQrBBqtX7zW51gA9mMtfM+32CfIgt5Qw3/EwdR+IRTNPM3/OQAstTfrfLjVLYEwAzAwvesccQtXoKJUA+TCU2rF+FyP7cjDG5oVAflAKaXEDAg8Po2U/qXlfekzkMnw3qviRxIIx6IvBeAqIUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790851329; c=relaxed/simple;
	bh=7yxKVVlFjjts2ps+9J65V0ar42v6fPCM67zlMdMwzfU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rPPiTblB+JAsMjKsxnNjYBbVLbjHSPeR1V29W9bogvD7JBMy8X6SJniiz+uGmkkDu7g3YQxSvl9oGN9VM7CvIKZ5MJyNoiwREctsT2cVtcVS1jJRJtWvEKfca8LYf6D9yVFww8D/8XQnhGFqSOemYkcnU0QufR0o/nfh1RBOrpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EDM6jYBI; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EDM6jYBI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3jvlOYAfRG/h2UHzfY1/Kmva+2DZEGA6G7zK/F/KkI0=; b=EDM6jYBIEteo4ELbq7d/er2aUm
	xbxd3LrhGGSwQOm2b0bpVtFNHYWdpZj9ccwPOKv6mjlVXmwFsRR3SDPdn+E2sV4piwrFakNfKDjS6
	y5Bh44XCNbMl9r5s/w0ul73budwxMpO1XU7wtwd1QIF/PsLOGGufYQky7tyq52/qPcbVbPHFGOTFN
	gihk9FHlYoibe7bvfzqkygUbtk1bXHeoO+shfpciy21/8ned8DStQDw1WPNUWPdaailgUbzcjKW4N
	p1G4EhDnrrh3BNxxY9fZbiCjSIc5qZ3Ly7PRwMxemRwcop1wgUwP7ZC4aAjHbaBUmVMFzWqK0vjEh
	Slr6tswQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xCEEd-00000006nOq-0WS0;
	Thu, 01 Oct 2026 10:41:55 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0C7CF3001FD; Thu, 01 Oct 2026 12:41:54 +0200 (CEST)
Date: Thu, 1 Oct 2026 12:41:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Paul McKenney <paulmck@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Christian Brauner <christian@brauner.io>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 0/7] locking: opt-in tracking of sleeping lock
 holders
Message-ID: <20261001104154.GJ4121339@noisy.programming.kicks-ass.net>
References: <20260924155025.949998-1-shakeel.butt@linux.dev>
 <10b93dce66eb13a23fbab563df259092@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10b93dce66eb13a23fbab563df259092@kernel.org>

On Mon, Sep 28, 2026 at 01:34:30PM -1000, Tejun Heo wrote:
> Hello, Shakeel.
> 
> On Thu, Sep 24, 2026 at 08:50:18AM -0700, Shakeel Butt wrote:
> > The answer is a count in task_struct. Only the locks that ask to be
> > tracked are counted. The mechanism introduced here is planned to be used
> > by solutions for shared lock isolation scenarios [1].
> ...
> > [1] https://lore.kernel.org/20260921192559.2619635-1-shakeel.butt@linux.dev/
> 
> Let's resolve the discussion on the overall approach first.

So I must admit to absolutely hating these patches.
