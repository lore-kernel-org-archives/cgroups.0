Received: from mta1.migadu.com (out-151.mta1.migadu.com [95.215.58.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD103F106E
	for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 00:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787963582; cv=none; b=qRBAJrS/JUknaBk1itQPXkJ/+KanzyMqOPM07XjVWeNF/TQtnc1t6JhDy9Ljo4GR8D5VHIPtar+bUfrWLUFXlZuCPLQGW5NHKdDXLf7j1/7q9xVzqmXBt47VmPKGaRe8qMYvnj2ZKMztRF7WRB4ZpNe7eTGJSWzVzR0bPXVYong=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787963582; c=relaxed/simple;
	bh=XHL0G3FrD3EaKeVkxOn/16guskz9c3p8tk2uofgjOyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c49FQ8sC/l/bxDSBNVKvtg5pMjChDBJ3LEiEYzLCph5vG8Ni3PnpyQnqt8OLQjkA1ih09UCXCCPVfSR0bLYX6NEO+FH1GL9gYxACXga7bzOhSr4gU6hMH05yhUrduLBjeLhaphbx1Vrrsx8RvMn8VNLOj7NevaJZ7mpQV0/TqWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=csYZR4Uv; arc=none smtp.client-ip=95.215.58.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="csYZR4Uv"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=XHL0G3FrD3EaKeVkxOn/16guskz9c3p8tk2uofgjOyw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787963578; v=1; x=1788568378;
 b=csYZR4Uv0jCerVCL8b4JHJCF3OVcG7teAwwbDC09u4KlLq/iTE7WPvx6NE63Hkh26k0E/Rgl
 5WBZfHSXAScTScly+1bbI2iOc6bY1dPlyOXQYbC454CU/N+JjhIdwYvK93WEobqfZxK9du3ncCe
 tIjEQR3yVlZ9QLIXpmbxKmok=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6fb6e2f96245975a;
	Sat, 29 Aug 2026 00:32:48 +0000
X-Mizu-Trace-ID: 6fb6e2f96245975a
X-Migadu-Flow: FLOW_OUT
Date: Fri, 28 Aug 2026 17:32:42 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Etienne Perot <eperot@google.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Christian Brauner <brauner@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] cgroup: fix spurious SIGKILL of CLONE_INTO_CGROUP
 children
Message-ID: <apInuCtg9UnoB9w0@linux.dev>
References: <20260828215252.4126811-1-eperot@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828215252.4126811-1-eperot@google.com>

On Fri, Aug 28, 2026 at 09:52:51PM +0000, Etienne Perot wrote:
> Since commit b69bb476dee9 ("cgroup: fix race between fork and
> cgroup.kill"), the fork path snapshots the kill_seq of the child's
> future cgroup into kargs->kill_seq, and cgroup_post_fork() SIGKILLs
> the child if that cgroup's kill_seq has changed in the meantime, to
> catch forks racing with a cgroup.kill sweep.
> 
> For CLONE_INTO_CGROUP, however, the snapshot in cgroup_css_set_fork()
> is taken before the target cgroup has been resolved: kargs->cgrp is
> always NULL at this point (it is only set at the end of the function).
> So the "if (kargs->cgrp)" branch is dead code and the snapshot always
> records the kill_seq of the parent's cgroup. cgroup_post_fork() then
> compares it with the kill_seq of the target cgroup, so the child gets
> SIGKILLed whenever the two cgroups have been killed a different number
> of times.
> 
> As a result, once cgroup.kill has been written to a cgroup, every
> child subsequently cloned into it with clone3(CLONE_INTO_CGROUP) is
> killed on the spot, for as long as the cgroup exists: kill_seq is not
> exposed to userspace and never resets.
> 
> Re-snapshot kill_seq from the target cgroup once it has been resolved,
> and drop the dead branch at the early snapshot site.
> 
> This does not reopen the race fixed by b69bb476dee9. For
> CLONE_INTO_CGROUP, everything from the snapshot to the check in
> cgroup_post_fork() runs with cgroup_mutex held, and kill_seq is
> only ever incremented under cgroup_mutex.

Thanks for catching this. Overall looks good. Can you please fix the comment
where kill_seq is defined in the header. Currently it says kill_seq is
serialized by css_set_lock. After your change, it should for normal fork it is
serialized by css_set_lock but for clone3(CLONE_INTO_CGROUP), it is serialized
by cgroup_mutex.

Orthogonally, we have plans to remove cgroup_mutex dependency from cgroup.kill,
so we will need to reevaluate this at that time.

> 
> Fixes: b69bb476dee9 ("cgroup: fix race between fork and cgroup.kill")
> Cc: stable@vger.kernel.org
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Assisted-by: LLM
> Signed-off-by: Etienne Perot <eperot@google.com>
> ---
>  kernel/cgroup/cgroup.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index c3a12fee7528..2d532bf2c0c7 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -6873,10 +6873,7 @@ static int cgroup_css_set_fork(struct kernel_clone_args *kargs)
>  	spin_lock_irq(&css_set_lock);
>  	cset = task_css_set(current);
>  	get_css_set(cset);
> -	if (kargs->cgrp)
> -		kargs->kill_seq = kargs->cgrp->kill_seq;
> -	else
> -		kargs->kill_seq = cset->dfl_cgrp->kill_seq;
> +	kargs->kill_seq = cset->dfl_cgrp->kill_seq;
>  	spin_unlock_irq(&css_set_lock);
>  
>  	if (!(kargs->flags & CLONE_INTO_CGROUP)) {
> @@ -6940,6 +6937,7 @@ static int cgroup_css_set_fork(struct kernel_clone_args *kargs)
>  
>  	put_css_set(cset);
>  	kargs->cgrp = dst_cgrp;
> +	kargs->kill_seq = dst_cgrp->kill_seq;
>  	return ret;
>  
>  err:
> -- 
> 2.55.0.897.gb25b4bd76c-goog
> 
