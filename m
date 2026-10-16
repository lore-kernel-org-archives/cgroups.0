Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A92351C22;
	Fri, 16 Oct 2026 17:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792172996; cv=none; b=CPE0o9pbJBCvXkCOmfJtUEKXlgPU+u4c9IiLRzLHwNG1xcUiyYJJbI/pXv7jlNr8bsYHondFBljv015wuZFuoh0RjLv+G2Rx6t5zRO0TSj3/byQxaHJ9x/DPoRSxF9Dc4qbPECXoClt1et65YxNsQGRVnTQztVPUnEWr0SRw16o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792172996; c=relaxed/simple;
	bh=pSjLH/yCCSHdG0Q0bwai3AqjRZ9jkiTSV8uBDnc3gXI=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jc7D1rTkgPQlGXOvWYkycXESEDUEwVmmKdze6B5z8eMi657gBwVf96LUN9kHdWb606L0cSUbuib3Pau6lE6jVtFnJrFIWrv3nqD4gA+LytYcR1csO3T13xbX17V6nz3WTIo8aeIJijAviCNBlyGWYVlDVwT55hBC/4nZ3Fbnhfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ASrX+V+r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ASrX+V+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C061F000C4;
	Fri, 16 Oct 2026 17:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792172995;
	bh=Scc1AGhB29157GeRJcHiefY3d5MyZEp2mObT10hnnsA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ASrX+V+rmd6/XwyA84tCS5FlqWwc+hXVrD0Huu63PmGOXLxfDhjt68L0/blD2xPUd
	 5qasWlLgw1w5Xu3PJuXIcMZSFKUP5t73C06itsOC1WNl2p0bEyj8Gh+tLcx70nC78B
	 mkFf8F6d+p0kDh61iyIyPcOJY5wgPzQ/TzivAE4nNABVBbhVG0tunc8RfpmsjkCJTq
	 agdV4BjDLZCmleYeB0cSghOxWpfLi9GJWci+SyBc3fzdb7BFloZu7tqOwvf3LBezeL
	 8sW2FrbkAa6M5wWoTeMySDLdDVTuT28bU0L4squl+zwituJQRnbopLtXSFfjNiw6JJ
	 hKBB+6aEPmC9Q==
Date: Fri, 16 Oct 2026 07:49:54 -1000
Message-ID: <20e2b2a51fd97292add8d8e527b14a45@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: josef@toxicopanda.com, axboe@kernel.dk, cgroups@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com, ast@kernel.org,
 daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>, ameryhung@gmail.com,
 alexei.starovoitov@gmail.com
Subject: Re: [RFC PATCH v10 0/4] blk-iocost: add BPF struct_ops cost model support
In-Reply-To: <a3dfbc2d-8580-478c-8189-3794d49aee11@linux.dev>
References: <20261003124045.1289305-1-cui.tao@linux.dev>
 <a3dfbc2d-8580-478c-8189-3794d49aee11@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Tao.

On Thu, 15 Oct 2026 20:00:20 +0800, Tao Cui wrote:
> When you have a chance, could you take a look at this series? I'd
> appreciate your thoughts on whether the implementation still matches
> what we discussed, or whether it has drifted somewhere along the way.

The behavior matches what was discussed, but the implementation needs a
lot of cleanup, and there are bugs in the detach path and the
iocg_init()/iocg_free() pairing. Details are in the replies to the
patches.

> Sashiko flagged a possible ABBA between the BPF paths and
> ioc_cost_model_write(): attach/detach take the queue freeze before
> q->rq_qos_mutex, while the cost-model write holds rq_qos_mutex across
> its freeze. That is indeed the current ordering, but I don't think this
> can deadlock because the queue freeze is a depth counter

The attach and detach order matches ioc_qos_write(). The reverse order in
ioc_cost_model_write() predates this series and is better fixed
separately. An earlier attempt to convert it ran into blk_iocost_init()'s
percpu allocation under the freeze:

  https://lore.kernel.org/all/aV5OwAvw1sRF1IW1@fedora/

Thanks.

-- 
tejun
