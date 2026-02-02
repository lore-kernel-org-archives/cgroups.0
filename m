Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320E02DA750;
	Mon,  2 Feb 2026 20:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770062778; cv=none; b=PvNmk075uL4NJoBIJCPgn/Kjz4btBAaOI+xs0eejoTBpo7OY9xNy2Gmzwx0TXdANsWNShCMB83dFLvl2xnqrBRdpLo7PNViVs4JIU+6HwYe7orHKrQDOTjQxrC+uwoth8IuRVvn9++jC9gw2GwdFBchTav8BSc+q9JJzFuHkoN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770062778; c=relaxed/simple;
	bh=HHrXkej/f/a2t9EQOmJlB/QYwWVipv0R/r6Z2wXnlXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fEbHXpHGUvPB5VqWxBqgbU/5LG7006JZB6R4EAQzAsLuZtm+7C0VGKNNE/cYdJzZjYr9mF1nqGlO7uBs/CjsdLSGWUuQO8w7N5yx8lmDcTx0+NbXeAzZhDj9HNP37pwTCbox1tkZoVNu2MMFMPbRk3E5XRpvK9IPlaPrVzbAsiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pAi98Agg; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pAi98Agg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZhU0N631qBi+iE52tj9a+dPE2D9hgfFQrTqnyjNKhFg=; b=pAi98AggagaMHaEsNgavBewaYs
	OgZ3EqIMz3qy8QydkF78WIZMIFkgDgpLfn79YIS6QGcpgqFwp9DdDg+3SDHr2fLCx0BTn6zsrtgmt
	tgZkCmHnBDK+ECG0V5S/54nQgUvvv4RnHkQg21DmRnhceq9ddQTFSo5t3xyLOxtL8ZmowKUhHfPVu
	di3b+UP6IrKqqu7pi6fVrWAZQqPIW2yaAmdvAyO1BZKPv5SBazl7I3/k5iqIqZ2Xgi8FuVvqtP4Cz
	LJAQIhxRiA/g702hZi0wv/tsQMV0ZNeDvoTCYjolk6PNse438lGNzLrMNufOFjgobs5Hm36yt9tTO
	CQrzKEzA==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vn0BX-0000000H06o-0N9p;
	Mon, 02 Feb 2026 20:06:11 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id A49613008E2; Mon, 02 Feb 2026 21:06:10 +0100 (CET)
Date: Mon, 2 Feb 2026 21:06:10 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <llong@redhat.com>
Cc: Chen Ridong <chenridong@huaweicloud.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Shuah Khan <shuah@kernel.org>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH/for-next v2 1/2] cgroup/cpuset: Defer
 housekeeping_update() call from CPU hotplug to workqueue
Message-ID: <20260202200610.GD1395416@noisy.programming.kicks-ass.net>
References: <20260130154254.1422113-1-longman@redhat.com>
 <20260130154254.1422113-2-longman@redhat.com>
 <20260202130526.GE1395266@noisy.programming.kicks-ass.net>
 <ca4e6c43-2bf3-42b9-91eb-dfce4777b5da@redhat.com>
 <20260202200457.GJ1282955@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202200457.GJ1282955@noisy.programming.kicks-ass.net>

On Mon, Feb 02, 2026 at 09:04:57PM +0100, Peter Zijlstra wrote:
> On Mon, Feb 02, 2026 at 01:21:43PM -0500, Waiman Long wrote:
> 
> > Yes, I am going to remove cpuset_locked in the next version. As for
> > __guarded_by() annotation, I need to set up a clang environment that I can
> > use to test it before I will work on that. I usually just use gcc for my
> > compilation need.
> 
> Debian experimental has clang-22, but there is also:
> 
>   https://github.com/llvm/llvm-project/releases/tag/llvmorg-22.1.0-rc2

Damn, copied wrong link:

  https://www.kernel.org/pub/tools/llvm/files/llvm-22.1.0-rc2-x86_64.tar.xz

> See: Documentation/kbuild/llvm.rst
> 
