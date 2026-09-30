Received: from mta0.migadu.com (out-192.mta0.migadu.com [91.218.175.192])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E1D4F4CE4
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 13:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.192
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790774918; cv=none; b=dUUKouwkRLmyetceNafggebWGDomONd6XaKhVaA/wGV5T4Kws7/sRTqFYeJ5Acc2YCr2P41C74OwuX5DzsoCXk4M9Eh8zpvBueH17rKi5v0g6u6kxItdedXHwUYtqd+5Nh7JrTHgkiBYDSyGNxfP6z3OSr102MHoPi5EJe2j9/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790774918; c=relaxed/simple;
	bh=Hsdm4rJdIk1UsbW5gttlY7rEJh2gpgb8d3cHbDg7CKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EouI5k7lTPYSevaUIrEru7U6HKCrMDj7nqwMmeGtG5LgFFjiEQBkrzRdcBEjXpLZeuAStJyxK8nV4R3cY9nnmrYHM/fPhxAixBPertkYgHB8v0cphkBjyCBUKk9DYLIntbDBOJ2OdPIF+fh61cnv7YUeTLrYouTNVK2G5h2XOyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dw9rFbZO; arc=none smtp.client-ip=91.218.175.192
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dw9rFbZO"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Hsdm4rJdIk1UsbW5gttlY7rEJh2gpgb8d3cHbDg7CKw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790774907; v=1; x=1791379707;
 b=dw9rFbZOf7XvxLNqrULbYFqI/7sEpm2RPYJqOonRKM+bEjnj1BKPUV76yuCHYg67mCK2+OXQ
 wMMl/bOPbsOOp/+ZsWSRIONsey/wvGPgOpPhjHoqgxDk8pr099nRBEDh/qaFit9hTjnLM+Slu8L
 q1JKEmWRYRONghXKspKAWN3c=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3a312f617140e728;
	Wed, 30 Sep 2026 13:28:26 +0000
X-Mizu-Trace-ID: 3a312f617140e728
X-Migadu-Flow: FLOW_OUT
Date: Wed, 30 Sep 2026 06:28:21 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alexei Starovoitov <ast@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	JP Kobryn <jp.kobryn@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Michal Koutny <mkoutny@suse.com>, Amery Hung <ameryhung@gmail.com>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	John Fastabend <john.fastabend@gmail.com>, Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev, 
	Donet Tom <donettom@linux.ibm.com>, Greg Thelen <gthelen@google.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] memcg_ext: memcg policy through cgroup-attached
 struct_ops
Message-ID: <arw4rjVkm2ob9ioL@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
 <bda525506b3fb3e61da28a112f28abba@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bda525506b3fb3e61da28a112f28abba@kernel.org>

On Mon, Sep 28, 2026 at 10:40:20AM -1000, Tejun Heo wrote:
> Hello, Shakeel.
> 
> On Mon, Sep 21, 2026 at 12:25:55PM -0700, Shakeel Butt wrote:
> > try_charge_memcg() calls __mem_cgroup_handle_over_high() before it returns,
> > which reclaims and can throttle the task.  That happens wherever the charge
> > happens, so a task holding a kernel lock can be stuck there, and everything
> > waiting on that lock is stuck behind it.
> 
> Why not just raise the lazy bound high enough that most charges never
> enforce inline, and maybe annotate the specific paths that can allocate a
> lot so that they do? Inline enforcement should be the exception, not the
> rule. Flipping that and then trying to reverse it with custom BPF policies
> doesn't make a lot of sense.
> 

Please correct me if I misunderstood you. Mainly, you are saying that we
should have a sane default behavior for memory.high. At the moment, if the
current charging process accumulates charges totaling more than
MEMCG_CHARGE_BATCH pages and the target memcg is over its high limit,
memory.high is enforced synchronously. You are suggesting that we should
increase the threshold from MEMCG_CHARGE_BATCH to some arbitrarily large
number. In that case, synchronous enforcement of memory.high will be very
rare.

I am fine with changing the default behavior. Actually, I have been
contemplating whether I should propose a revert of commit c9afe31ec443e
("memcg: synchronously enforce memory.high for large overcharges") because
it has introduced more problems than it has solved, but that is a separate
topic. The initial commit already mentioned that MEMCG_CHARGE_BATCH was used
arbitrarily, so replacing it with something big might be acceptable. I want
to keep that decision separate.

I am not sure about annotating specific paths. I think it would impose a
greater maintenance burden as the kernel evolves, since the annotations
might become stale. Also, people might object to adding memcg-internal hooks
in non-memcg code paths. In any case, this can be explored separately.

Returning to the actual proposal, my plan was to start small with a narrow,
specific use case. However, my long-term plan is to provide a mechanism to
change the default behavior for custom use cases. For example, for
memory.high, I will provide a way for users to specify what behavior they
want, i.e., whether or not they want more synchronous throttling. Second, I
will introduce a mechanism to trigger async reclaim workers. I also plan to
extend this functionality to memory.max. I just wanted to convey that I will
keep pushing this proposal, with the use cases adjusted a bit.

> > One concrete scenario which can be resolved by this new feature is the
> > kernfs notify worker. It delivers notifications with the cgroup2
> > kernfs_rwsem held for read, and the charge for the delivery allocation goes
> > to the cgroup that set the watch, usually one already under pressure. So
> > the worker reclaims while holding the lock, a waiting writer blocks every
> > later reader, and anything touching cgroupfs stalls for seconds.
> 
> Slowing down the kworker inline doesn't make sense. It's charging on behalf
> of the watcher through set_active_memcg(), which already tells us whose debt
> it is. Wouldn't it make more sense to defer the debt to that cgroup instead
> of slowing down the kernel thread?
> 

Yes, that makes sense. When a non-task-context charge exceeds memory.high,
the kernel already schedules high_work for the charged memcg. I plan to do
the same for kthreads so they need not reclaim or throttle inline. This is
best-effort reclaim rather than exact debt accounting; I still need to
examine userspace tasks that charge another memcg through
set_active_memcg(). I am addressing the reclaim worker's CPU accounting
separately.

Thanks for taking a look and providing feedback.
