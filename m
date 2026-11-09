Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794237635;
	b=xlgpSyXlpvObebDnTUPgn0KgdKsLnqrutZ6DZbrUAHrN3jmanJNgCYVoIptM+qBE3aCx
	 uKJ03XJu0py0N5ccbwP4DzUZsuR7s5zeBtS8w0FM92JJvbfjXgk22SsFt2heIZgjx3AEv
	 GzDViBxmdPpmGcP0dZKPmQxXTPQ+W1m/iXjTjjUx2YPr+sUYiTzNCK5DG4fFdby1b37K3
	 8Q2l4ZbaMi4u5hS/LCCXgt72Yj+N6db8eG5e6DA8l5eqmW34XLAXY0e9RsLp8wX9BQ5xB
	 A9I7Z7jxUR9jiQb95xf7zMabKNl7ekKPyv+fH+ZTcVarRsCFRmltYI95X7x7MmEAfGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794237635;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=I07lJrgFsxm3E13lAXBgVpKwF3TGQ2q83seC4rcxvKY=;
	b=As8gg6dDftHPVRnmLGTPNKMl+3ErJrpzg8Q/V3eKEKp7/o5J+xbIYp+Ug5wy7LFH8QMz
	 MMnQYPyWxZIEhyzEv4othkd5qKfa0v9X+IvJUfirn+UyUE7TcUPlDBmO8MZZMyuwFkiKt
	 KNfn9r30tAsWspRqw2khL5XrzlQRN2TeyPMu81ZTtNlGPbrwB5P7DPejFOYMVyiS5yoNT
	 eYrRu6zARzGrT+Oe1QhinOypGS6jiSoIKE2y0Gq9qWTqW3dJ7s+y0i8QekGs0UaOWB1Ko
	 7gxtgkfShHGNaMQwzij6WNV28g+k0/JBu6vNtUoeHPoz0x7xQralStWGZgxsBM9C42A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=F5iB63bn;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942DC606A325
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 15:20:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 942DC606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=F5iB63bn
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-491d1f66968so122124f8f.0
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 07:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794237633; x=1794842433; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I07lJrgFsxm3E13lAXBgVpKwF3TGQ2q83seC4rcxvKY=;
        b=F5iB63bnhsmO90q8MxVwV83ZDUoaFJNnnq1HzxsD+rNZMFup9BWSjXxhdK7V0Yb6Mr
         ANXgfrq4vj4lGKTwfXcZMJ1/R907BYdVh/NFrNOV6Rw+cIdN1JHKQo8EB3xLl5lYuaSo
         o+Fp67gjxoFjegmQgWc3N30T3ocwZyTtyrXr731bsDgHlbLuHGZYSB6pJ/UgLqiTfQ8y
         oC64Z+10xV/h0DRLNtWw2EiL9zIrK+6ec1wixEwXTsr2AbJMV2zQHPHBwWyrio0D7s0d
         wCF9WB5zwjd39fil78E+XJgJnejmf5qsajZgFbHjadw7lNkuCVDjxOgUpGBYUvTzTKdQ
         BtNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794237633; x=1794842433;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I07lJrgFsxm3E13lAXBgVpKwF3TGQ2q83seC4rcxvKY=;
        b=hBvbJqx1f24dB+OMixgGSc6JXs0qhxdl8uIaN4z8aEfz8OogQjYMvnJ4ZvWLn32GQn
         Ebuqei7M716mSbLGWrYiWlEeYdgz9uw9/bOVNdpuYkV+0ukhrHK7fr/5oDYVtB/Udz4j
         9unLj/cE0mKE2ny1SeUHfIGh9AOrbqQzy3AuN+J1di3Gs50xXA9bGiJJ9hJzhW42OskP
         QyNHOPnIaNn68ylpLuI7pksmAlMKC8AwZ8JZIMn/faa3foH2KTQaQlpU6XDh71tVGY2L
         +iFRBGML2utVtPne2rbXizQQ4ilD5PDXhAArS7aM/mCiyEtXensouI6R3zJ9/8XJFnEd
         4GPA==
X-Forwarded-Encrypted: i=1; AL+hErH6nJE0FyuJJXuQMXekhB9LYlIs5E1+v0aUcfR36Nn8kMVIb8bbBc1mlToRe9JUIVZRAH6VKCn5@vger.kernel.org
X-Gm-Message-State: APuU4Z+p8Y3HHTVi3/ahy0VfyykjkJRZLcupEpn6hwZQFgSGJsvlrkeR
	GtYSTwOoYX7ZAJHyfG2+xYNk3ACX2iTmFOnURgBYuKnKksvwb//2B1eIIKIwWcGTgLk=
X-Gm-Gg: AYBFou3l+/N6K14DYPns/aPu2LCYFdwCBRqUhLcqw4J/PC6lkxvWIU3y0C9LhSyVXUP
	rh7eyusIPf3rLGn08uKYTBTMJZ48gFd197OFf+OKkZWd4KR2THcs2qeuoE3y9KQKyHFr58I8wFI
	gdl8r3zs1TN6oaG1nc9awf/RhOm5clhwD60yA38zLI/f77A28ffq5CpcXLK8F4j4qkO/q1KlcF8
	0lZwEbUnAvijGfErHL1RZb7q2GYNEBUYi7t7JynDqFOMcteQIUXAR5Fr+YSMa3aGs1btF2kq4AQ
	Fn/mZcmT4anNj7wqDvrxJYNjAD1+VAl901ETf/6TKk0zU9QmydY0QUkhH5Njk/s8vXeSbLTHyf3
	mZfB+IL01tzwfff8vrWb7yiYxfhBRa3aq+24AFG9aSRbVUv3AOmRrhk9eqdkgmmfOv30ixUJTol
	40VxfU/AZcjo7xmzhwob34VxTtY9U+9RHd85dtRJHIUfXjtfn3qR6t/nFxNidCppAWFnTwbfuap
	Es/UEhff/I/v5LZPD4oXqC4ZwyoMUKOjLDbvnFMoYzKROA4Ge13iGxl+Z2j7GZoU1Sld8PPlT4C
	630kGiD1gQhdF8SNllinPMn2RVOp54Z3klMKq2KqmQ==
X-Received: by 2002:a05:6000:230d:b0:48b:9ed:b81f with SMTP id ffacd0b85a97d-4958a10a3bcmr8781666f8f.10.1794237632787;
        Mon, 09 Nov 2026 07:20:32 -0800 (PST)
Received: from localhost (109-81-94-245.rct.o2.cz. [109.81.94.245])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39899sm9626204f8f.3.2026.11.09.07.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 07:20:31 -0800 (PST)
Date: Mon, 9 Nov 2026 16:20:30 +0100
From: Michal Hocko <mhocko@suse.com>
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Zhan Xusheng <zhanxusheng1024@gmail.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm: memcontrol: Don't lose track of exiting OOM
 victims
Message-ID: <avHkvtojxFyuH5mb@tiehlicka>
References: <avA1wXhTMs9eY2NF@chrisdown.name>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avA1wXhTMs9eY2NF@chrisdown.name>

On Sun 08-11-26 00:41:37, Chris Down wrote:
> When oom_evaluate_task() comes across a victim we've already killed, it
> backs off until the victim's mm has MMF_OOM_SKIP. This gives the victim
> a chance to free some memory before we kill anything else. However,
> since commit a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup"),
> css_task_iter skips exiting tasks once signal->live reaches zero. That
> happens before exit_mm(), so a single-threaded victim can disappear
> from the memcg scan while it still has all its memory.
> 
> This can kill another process when the first kill would have been
> enough to recover, and we've seen it happen in production. If the
> second victim is in a cgroup with memory.oom.group enabled, the extra
> kill can take down the whole workload.
> 
> In tests I used a 64 MiB memcg with swap disabled. I started a process
> that faults in 44 MiB of anonymous memory, submits a 4 KiB direct AIO
> read to null_blk, and goes to sleep. I set null_blk to take 10 seconds
> to complete the read so the victim would have to wait for it in
> exit_aio(). Two seconds after starting the first process, I started a
> second one that tries to fault in 40 MiB.
> 
> The 40 MiB allocation hits memory.max partway through and triggers an
> OOM kill. The OOM killer picks the first process, which has more
> resident memory. With the read still pending, the victim blocks in
> exit_aio() before it can tear down its address space.
> 
> memory.events showed oom_kill 2 in three runs. In one of them the first
> process hadn't submitted the read yet when it was killed. The slow read
> just makes the window easier to hit.
> 
> The cgroup iterator hides these tasks so that cgroup.procs doesn't
> show processes that waitpid() may already have reaped. That's fine for
> cgroup.procs, but the OOM scan needs to see a victim even after its last
> thread has started exiting. We already have CSS_TASK_ITER_WITH_DEAD
> for sched_ext, so use it for mem_cgroup_scan_tasks() as well.
> 
> With this applied, OOM selection backs off while the first victim still
> has memory to free. The 40 MiB allocation completes and memory.events
> shows oom_kill 1 in three test runs.
> 
> Fixes: a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Down <chris@chrisdown.name>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
> v2: Give more concrete details in changelog (akpm)
> 
>  mm/memcontrol.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 84f4a8fd4d16..cb7cfae9ce5a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1451,7 +1451,13 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
>  		struct css_task_iter it;
>  		struct task_struct *task;
>  
> -		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS, &it);
> +		/*
> +		 * An OOM victim can start exiting well before its mm is
> +		 * torn down. Keep it visible so oom_evaluate_task() can
> +		 * back off while there's still memory to free.
> +		 */
> +		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS |
> +				    CSS_TASK_ITER_WITH_DEAD, &it);
>  		while (!ret && (task = css_task_iter_next(&it))) {
>  			ret = fn(task, arg);
>  			/* Avoid potential softlockup warning */
> 
> base-commit: fa4ad798f6f681031775266044ba1b0cf3c670bd

-- 
Michal Hocko
SUSE Labs
