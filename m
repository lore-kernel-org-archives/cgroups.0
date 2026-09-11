Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E4D35E1BD;
	Fri, 11 Sep 2026 16:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789142911; cv=none; b=RdABK5XTbS/8ML5s+dXtMDlHnvCt4DrbuBKnMI0TEANTUCVE21QE00vSN1rZBRGDuZlYqVPLh1sXovg90ABVJA6kIFhH/66CVzx6d0uI1a44Wf/Q1M47iLnof6BW7wmfTdWYfON2xCWP6FRuItdVUKUH1vPP+WGnLAZfZ7lJfTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789142911; c=relaxed/simple;
	bh=UGb4CA9WwvcjfdKdeB3B9MST9GItVCg+vUyOLKad25I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZzZAR5ltFUg7d1DpelwfRCg+B10h+vlojtMaaAB9K7QEpJmNviOD0CkSDC3DxgqvXaf2VuddYAeMy1kX6Sx/p9RsHqZp70Ulv0iYQEMPbe7yctv6BUVMzjdLOyN1PZ9r2SlNxaJ7WkpbOHsY0YMqt9IY6qCULrf8bDHcWUWq0Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kJsP4k1Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kJsP4k1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B791F000FF;
	Fri, 11 Sep 2026 16:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789142909;
	bh=1D+iwMZKHM3aqzSebw0CYsd29ulfYf9HQcJG1kZnqiw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kJsP4k1Q5iPE1PJKHrdPeGhz1Ri+dteYH/6d6oixlAa2xrMnLLFuww8NZvAf6YMjy
	 jjyrt7NEyKFEgKrsd+9mbr7AeTCrFBnx2uYA0ZvIZsC75xMVZEKhPnhykAXjOf3m1k
	 6nBW2RrRtKYxJAMUiAlg/0gBFMw3RcHgQSvjIlhwbRDQLo6KQlhIx5jm2JohyeIN6M
	 6QE6nnMGcJ8ipJ3eEFWcYycdLzEzbczfnAEbR8uyfgxKw8L5sxlYSVNy/duGHrU4x2
	 DWRP2V0ysMHCKFjGq5mghwn7CnjyaXWmbsETaYpJ6XrCETX65edUWnELROJZSr2Mji
	 qycdz8t8IAzlQ==
Date: Fri, 11 Sep 2026 06:08:28 -1000
From: Tejun Heo <tj@kernel.org>
To: Hao Zhang <hao_zhang_kdev@163.com>
Cc: linux-block@vger.kernel.org, josef@toxicpanda.com, axboe@kernel.dk,
	yukuai@fygo.io, ming.lei@redhat.com, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: [PATCH] blk-cgroup: save IRQ state in blkg_tryget_closest()
Message-ID: <aqQnfAjViY7sO1JZ@slm.duckdns.org>
References: <aqQmqb1k57PXj8Ef@192.168.1.215>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqQmqb1k57PXj8Ef@192.168.1.215>

On Sat, Sep 12, 2026 at 12:04:57AM +0800, Hao Zhang wrote:
> From: Hao Zhang <zhanghao1@kylinos.cn>
> 
> bio_set_dev() associates the bio with a blkg through bio_associate_blkg().
> If the blkg lookup misses, blkg_tryget_closest() takes q->queue_lock with
> spin_lock_irq() and releases it with spin_unlock_irq(), which
> unconditionally enables local interrupts.
> 
> Callers may call bio_set_dev() with interrupts already disabled, e.g.
> dm-thin's pool_map() does so while holding pool->lock taken with
> spin_lock_irq().  The nested spin_unlock_irq() then enables interrupts
> while pool->lock is still held, so an I/O completion softirq can run on
> the same CPU, re-acquire pool->lock (thin_endio(), or overwrite_endio()
> -> complete_mapping_preparation()) and deadlock.  lockdep reports this
> as inconsistent SOFTIRQ-ON-W to IN-SOFTIRQ-W usage.
> 
> Commit 3a762de55b4e ("block: save irq state in blkg_lookup_create()")
> fixed the same problem while the lock lived in blkg_lookup_create(), but
> commit 9327a865e395 ("blk-cgroup: don't nest queue_lock under rcu in
> blkg_lookup_create()") moved the locking into blkg_tryget_closest() and
> reverted it to spin_lock_irq().
> 
> Save and restore the caller's IRQ state instead.
> 
> Fixes: 9327a865e395 ("blk-cgroup: don't nest queue_lock under rcu in blkg_lookup_create()")
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Hao Zhang <zhanghao1@kylinos.cn>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
