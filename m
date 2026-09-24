Received: from mta0.migadu.com (out-36.mta0.migadu.com [91.218.175.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0163370AC6
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 13:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790255824; cv=none; b=d/nitxLA7B9Z2+3p+dsuLy7mwLg7a3jbBlVJ1yGYsQQJMHA01//HGB+foDj2lf7yXMxUuXgiHkg91efZb80i6UDZ+9nRU2S78tXf26r3ktnnEYsHggXFo1l9l9nBRyARnvey3UBUSMkkMbGXWtsQlmtWYLKNC3fkfMhJTY2PkhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790255824; c=relaxed/simple;
	bh=u+53vzFnta5gTX4bl+C+7w/lw2NhO9X4vU7rO809IvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EiwhD9QwH8Ugmfcx5A1yFRLJnc/d6homQSQPdtF5FBFus90kUZlZKxYiJk2PUGWOQpoJ/yRi/VbVGPcfPNGb4qBKCDZ6XxczD+7qNCMGji6WpINSjMleP6amLy14HXOTRo1bAK9YkLaT4YxprcEQFtuCQHYgKY9zj+BrcV46vRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rLF0sWLo; arc=none smtp.client-ip=91.218.175.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rLF0sWLo"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=u+53vzFnta5gTX4bl+C+7w/lw2NhO9X4vU7rO809IvQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790255820; v=1; x=1790860620;
 b=rLF0sWLoB5G26MdWPm/SE2xDnrqXH5K/97tWtxiB0BOS49AZAkUa3I4B6yTKbWT+Tex2STUw
 pVDGAJvB2fOyOA6WSTwIIYvjOZqSwWhlwTegn46GGw4scOWMNfsYTSxeRAX5jq12WMG5yyAYeg/
 vRqtCdXUZ+M4AiCNbBVnhgzU=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 12a4a4590ac8a704;
	Thu, 24 Sep 2026 13:17:00 +0000
X-Mizu-Trace-ID: 12a4a4590ac8a704
X-Migadu-Flow: FLOW_OUT
Date: Thu, 24 Sep 2026 06:16:51 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>, 
	Paul McKenney <paulmck@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Tejun Heo <tj@kernel.org>, Christian Brauner <christian@brauner.io>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] locking: opt-in tracking of sleeping lock holders
Message-ID: <20260924131558.GB25882@shakeel.butt@linux.dev>
References: <cover.1790139577.git.shakeel.butt@linux.dev>
 <20260924080550.GI2009045@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924080550.GI2009045@noisy.programming.kicks-ass.net>

On Thu, Sep 24, 2026 at 10:05:50AM +0200, Peter Zijlstra wrote:
> On Tue, Sep 22, 2026 at 10:01:17PM -0700, Shakeel Butt wrote:
> 
> > Shakeel Butt (7):
> >   locking: add opt-in tracking of sleeping lock holders
> >   locking/rwsem: track holders of opted-in rw_semaphores
> >   locking/mutex: track holders of opted-in mutexes
> >   locking/percpu-rwsem: track holders of opted-in percpu_rw_semaphores
> >   locking/selftests: add KUnit tests for lock holder tracking
> >   Documentation/locking: document sleeping lock holder tracking
> >   kernfs, cgroup: track holders of the cgroupfs locks
> 
> Not sure what's gone wrong, but I only have a partial set. If you want
> me to look at them, send me whole set.

Thanks Peter for taking a look. I will resend soon (couple of hours).
