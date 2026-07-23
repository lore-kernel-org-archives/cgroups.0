Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94D93FD12A;
	Thu, 23 Jul 2026 20:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784838961; cv=none; b=Wp9SvNgsxiNMb9fTh8geIOsVOIJVxcygqhADjITRlo7yB+iMNpWnQpUbfEBN1mdUwOrkmI2DuLGH7dDd2ycpjYVljF1IXtjVjVOkDtGxZXsiNdPpj9nx28eTFks6q9/0yRJOshMAd3Tb6qS5xWEscNWtZARpylzGOpmprPc+bZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784838961; c=relaxed/simple;
	bh=040CU0fTbz2clP5uNxYtwycGAOXuBzg9J45o0jsuH5Q=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=c3jB0Adtt4ve3aJvnsz4cS32sYX4OCEeQvQNUyF50juAiFM2+z6VIoLIsokIAgQOgGcNe7i6qglc6IbcMpLniQaMu/8mzWqOC1qZrO0c7eJEJMnTGR4TMsecJtr0JNuKYeCiKfBlsQ+3zP5sK9gOxHvR2UGixuj72hW/xgh0WRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0XxJV5UF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0XxJV5UF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A6C1F000E9;
	Thu, 23 Jul 2026 20:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784838950;
	bh=Nac04wlAP2t3HqF9mb3TQViUemoTPGuh6MRheYC0KBE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=0XxJV5UFLXYx3mOBaBVQS6f3P98xfPPk/e8U3/q0wpyVtYOnr/68ZMpaEz20HeB3N
	 XXHt3Mz84hugaUifCCWikxxzLzdoUZvsYIx38HhALzbY5oT5oUaipF1Rao4U2KrIFg
	 kMrjJye3gTwtjQZsXxkNVhIaFEufIEd4VxrAComg=
Date: Thu, 23 Jul 2026 13:35:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, kasong@tencent.com,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, chrisl@kernel.org,
 nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com,
 hannes@cmpxchg.org, roman.gushchin@linux.dev, muchun.song@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 rientjes@google.com, kernel-team@meta.com
Subject: Re: [PATCH v4 0/2] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
Message-Id: <20260723133548.2e12b638bd629ef63b935113@linux-foundation.org>
In-Reply-To: <20260720164207.450685-1-usama.arif@linux.dev>
References: <20260720164207.450685-1-usama.arif@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 20 Jul 2026 09:41:21 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> The anon/file scan balance heuristic in get_scan_count() is fed by two
> scalars in struct lruvec (anon_cost, file_cost) that every reclaim
> producer updates under lruvec->lru_lock. The cost-recording work
> itself is trivial, but it both contends for and contributes to
> contention on lru_lock - which is often a contention point on
> memory-pressured workloads. Specifically:
> 
> - shrink_inactive_list() re-acquires lru_lock at function exit just
>   to call lru_note_cost_unlock_irq().
> - shrink_active_list() does the same after rotation accounting.
> - workingset_refault() takes folio_lruvec_lock_irq() purely to
>   record the refault cost.
> - prepare_scan_control() snapshots anon_cost/file_cost under
>   lru_lock.
> - lru_note_cost_unlock_irq() itself walks parent_lruvec() and
>   re-acquires lru_lock on every ancestor, multiplying the cost
>   of every update by memcg-hierarchy depth.
> 
> This series removes those producer-side acquisitions entirely.

Thanks.  We're still awaiting review of [2/2].  I'll get this under
test in order to parallelize things.

> Measurement is a 30 s `perf lock record -a` window
> over otherwise-idle hardware.
> 
> Workload rates are identical on both kernels (the bench drives the
> same memory pressure):
> 
>                           baseline    patched      delta
>   pgscan_direct  / s      172,662     171,817      ~0%
>   pgsteal_direct / s       67,162      66,306      ~0%
>   workingset_refault_anon / s
>                            40,696      39,830      ~0%
> 
> perf lock contention (total wait per 30 s window):
> 
>   Lock Name                Before      After     % change
>   shrink_lruvec+0x770     722.84 ms    0         -100% (eliminated)
>         (= lru_note_cost_unlock_irq)
>   workingset_refault+0x167 385.26 ms   0         -100% (eliminated)
>         (= lru_note_cost_refault)
>   shrink_node+0x4ad       689.43 ms    26.95 ms  -96%
>   shrink_active_list      208.34 ms    15.97 ms  -92%
>   lru_add_drain_cpu+0x34    1.96 s    917.71 ms  -53%
> 
>   Total LRU lock wait      ~4.23 s     ~1.66 s   -61%

So it saves 2.5 seconds out of 30 seconds?
