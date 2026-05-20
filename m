Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C609B3BFE4A
	for <cgroups@vger.kernel.org>; Wed, 20 May 2026 22:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779316878; cv=none; b=EH4ylqs6Ex0vQQa9nAuE2Je76KJF88slGqqk39NzG2zfJf4KHwCwfECgFtF6El8G699sfSOQaWjkXJpsuifT2xIao0YSkkjskz7xdJuDkaoB17uRlYhHKbM3ASrmLtHQCWde96U827GMJ0LTN/U2PzrvNH5NfDnDCZ2HBgwhWgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779316878; c=relaxed/simple;
	bh=LTTHC7nCI6rdhkod/bjZUi0gT31fDwFEgi9sHukIvx8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DuaGeeGuWhqNBgHWHx8t2CHxJoJ2d6/8taT85uFQtc11AAosv90tdcl8776sE/T98/9c+/5mTSooenI8zifipLeg5TmJNtB5bbEiHBIEK/oOqt4k1l2EBmEyfjFNx5li6wPTXHtLTC1e21/QoODjTPcI9tSYG/a3F0tpAkvdcRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ndDl0alY; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ndDl0alY"
Date: Wed, 20 May 2026 15:41:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779316872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=42jMn+QanOajOQv4a0/S9dKcB3YFw7MjARjHljvkjIs=;
	b=ndDl0alYgUpBOk43py9ss1rd0JKeg53m+W66aVPWVEP6sLg9FaDGp07l0fl/S52iiK4Aes
	8LVovcWKmqs83RPMLXR5wsFc1TQ86X1OkyA3wMTIGui43udyUYjz0QxMR82+kOyhkl8+UW
	qna/7u4WqpEKYKvzC6SWIqwvgopKvec=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Cunlong Li <shenxiaogll@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: rstat: relax NMI guard after switch to
 try_cmpxchg
Message-ID: <ag44Seky7krETHe6@linux.dev>
References: <20260520-nmi-v1-1-f2c8f08e4a2b@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520-nmi-v1-1-f2c8f08e4a2b@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, May 20, 2026 at 11:30:54AM +0800, Cunlong Li wrote:
> Commit 36df6e3dbd7e ("cgroup: make css_rstat_updated nmi safe") used
> this_cpu_cmpxchg() for the lockless insertion, and therefore required
> both ARCH_HAVE_NMI_SAFE_CMPXCHG and ARCH_HAS_NMI_SAFE_THIS_CPU_OPS in
> the NMI guard: on archs without the latter, this_cpu_cmpxchg() falls
> back to "local_irq_save() + plain cmpxchg", and local_irq_save()
> cannot mask NMIs.
> 
> Commit 3309b63a2281 ("cgroup: rstat: use LOCK CMPXCHG in
> css_rstat_updated") later replaced this_cpu_cmpxchg() with plain
> try_cmpxchg() to fix cross-CPU lockless-list corruption, but left the
> NMI guard untouched.  After that switch, css_rstat_updated() no longer
> performs any this_cpu_*() RMW operations and only relies on the arch
> having NMI-safe cmpxchg, so ARCH_HAS_NMI_SAFE_THIS_CPU_OPS is no
> longer required in the guard.
> 
> Relax the guard accordingly so that archs which have HAVE_NMI and
> ARCH_HAVE_NMI_SAFE_CMPXCHG but not ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
> (e.g. sparc, powerpc on PPC64/BOOK3S) can benefit from the existing
> CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC path.  Without this, the css
> is never queued in NMI on those archs, and the atomics staged by
> account_{slab,kmem}_nmi_safe() are not drained by flush_nmi_stats().
> 
> Fixes: 3309b63a2281 ("cgroup: rstat: use LOCK CMPXCHG in css_rstat_updated")
> Signed-off-by: Cunlong Li <shenxiaogll@gmail.com>

Looks fine but how did you find this? AI?

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

