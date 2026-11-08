Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794116460;
	b=kUmAMcDaJ2nepG+L3NOLJtpjSOjyTsQpIGyZ+B0Z6J/PNkuMyV00a9uiZ+PFAT/8swdU
	 rBTco34g6xHHlrUZDaO/J2qCrLs18Gof2BvdKWfvHr1nq7slM3PJc55oEv67pHNiB7DB2
	 3fAp0OFRhMWXRs82LJgR3zwtXc7fqzKYVRrpBCGpXkdRzkLj+W6Bmx9C8u5/Eo17jlDP8
	 GQS9lt9KCBPurOsXqKIpRiUcuzEmF+I9OB4V68GsaS/mr9z7prB7zPSs3rq5y7A0X30As
	 OzQp743Aasn39WKOLLVDZTpsU60iXlKQcAlL4Ut2jY5c0rbG9kQ2a/fFTRGQuEvZg/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794116460;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:User-Agent;
	bh=I3WRrinu/jT9Jg9NAfoNC4MFsm/rU54sJV2l8lqiR7g=;
	b=RoHA8JGGQAc7fHM1aIm93Z51rKX11CNcLzeX2m1mogNKsAY1knuRYvqJy9fSs1bNnMxJ
	 KnBQFpakE4P7W2rCm7SDhAdmSUSFKSLFckGC4+Unxew7pTCSNlo3IFtcc3YCJICCpVxrM
	 tBJEsd22HTInTbm2UALT74g2AVaKt66mvTk/JLlVNEQeGCVrAYeF0ojAo3IlUwUsMWvLT
	 Dv2BgjQ+WVX0TWZzw/DXrwBb8hX5VZLxbZwqh2JGA3LnWp4NBIHgX+SRjMe1SP1zLWDOO
	 qijvtlgfJLnABqBzzd83OBaJ84fTet9vqm+krp49cFAtv9rI+xft4mopfBr/+28xhmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=N8mJQtvW;
	arc=none smtp.remote-ip=209.85.216.44
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93049606A31C
	for <cgroups@vger.kernel.org>; Sun,  8 Nov 2026 05:40:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93049606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=N8mJQtvW
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3b09c07b3d2so119987a91.3
        for <cgroups@vger.kernel.org>; Sat, 07 Nov 2026 21:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794116459; x=1794721259; darn=vger.kernel.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I3WRrinu/jT9Jg9NAfoNC4MFsm/rU54sJV2l8lqiR7g=;
        b=N8mJQtvWxnysTtHwSJZoeu2dpC/Z2EeY/G+qYBoLA0KHgqQHR8NyBcaNBl8Dwpq62D
         LR9kmIKdTOdfKV0UXe8w4rlPK8EadFNs5EkvSr0t0puvu85DD/6PLCfW59XcCeLXDSga
         rwYpM39+SldIYZsmteLsb+Vyah3NBzFS3PHY0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794116459; x=1794721259;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=I3WRrinu/jT9Jg9NAfoNC4MFsm/rU54sJV2l8lqiR7g=;
        b=l8Xs9jFxDsOl2DlGt2QGGbbAtyu7gLEMpaHmCNeA7LSrZKnSlowwPrgkcsuiROe77M
         MxX4Bz82A7tJ0AbzMsTN6L6Fopx5xwhSxX089LRWvRXz+xRdGRBDLKQjbKxyeEHFIygp
         w36DO9fEKyAzEMY+VUmfEzA1A/qfFc11/2ux00Ur1V2udzzq7rRG/Ac6kM1SKhMuJU5v
         fAAqzRnGuUwJtwnPf4fyhBvYM1Q+8pY8OztZqRz+O1hy6OFq4+UM/ju5Al1EZxqXUSXb
         7KRBxGabbyJOIm/hpJ4HNVBB7jzKsgWuJTuP6xcZCwD7Xbjd+O0dcfffxznZiJ+/bq3i
         w18A==
X-Forwarded-Encrypted: i=1; AL+hErHwl59MYYUdTdhcX7G5Skt+bfwx4GEmgFKGxwvMQNdjt7lNYzi9XCREH3HLTXokik7z2Xy+hfYW@vger.kernel.org
X-Gm-Message-State: APuU4Z/3MavXSS23KtIcCcPBzTrc1TkF2a7JDTZYfypiZvt6KibYlyj8
	pztE8yBLE0KH3R4IofJZCXwzJOUUgpfTdYtd4+WFKdqrmMuJHDiOwEjrB8Iz1ZHhYmY13qDFEDq
	Rd0mLLSjqxEPy
X-Gm-Gg: AYBFou2l9nxdlKZGhBc73is0xI0oz8Wrk9AbZBf/aGSI66IKFgscjC0TE+PlnbcVZtb
	4n61YAWsHXuebgjgQ+p7F6FGg59Xd5PmkCu/nei4/j8g7yQ/kZWAvcibI2ooi+qW0zSI0eJdsyS
	pXWXxhlavQ75MD15IkYkVgAQJys7UOoRMVDhDF0CAouCR81O0coPcyYqK2XYlI9Pqc4mZPnhu/t
	xQ49FWdTzZ/PgdR5gg5BR80WyrCotY/qEPP8lGJ0GHGX4sFiWodAwZGhBz92ji4TUVB+6u5fBMi
	QrU29mtk87KaahiTrnU+OxlOGqMfJ6vrLr1cNHueqA0lfqF18jQn6eJaxaiqMA/APeNbpJNFwZm
	loqqLJBdMpIrzUFxiW7dq6xLcGKpXmJ0sbtjsLZYVTd499HRTYQIsCeM7wJuMQ+JCn9LmKFXO+i
	47mUgWSBSjj1p1dtWQPfNcTzJkFmQfqkpu0vMWhUYjIKKTo4quTq9oh3P4jrj/yNBfCsYaN1YAK
	P8Oc4GRHz9s1KBTRZbU9eNJyjGu+PmdsE/LKY/ztUII94xRpd7fFhL521ouqKRRc1E2GC7CgxC4
	MVO7kmGQe1fxuUufhMBy7URERTwNmxLlTohsHf3TeI9CEB4c503s4//ewNeIBmI+/2hhtkl/MLx
	KQhPZXoQoJxIQ8IUv605hrvVkRCG560zxzDAnDgrDstU6oAtC+X3UZkH7rwJjlxPQ9walE55gyO
	34SgAKhD4o8ti0agoaWWlCG4Ft+q0htMJcteMvQtLvKzKIe6RfJM3j5uLBpqVTxcaSvy0pIzgWz
	Q==
X-Received: by 2002:a17:90b:3b4c:b0:3a4:e735:b39d with SMTP id 98e67ed59e1d1-3b12d57457cmr400027a91.64.1794116458854;
        Sat, 07 Nov 2026 21:40:58 -0800 (PST)
Received: from localhost ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1278918e8sm1796511a91.5.2026.11.07.21.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 21:40:58 -0800 (PST)
Date: Sat, 7 Nov 2026 21:40:56 -0800
From: Chris Down <chris@chrisdown.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Zhan Xusheng <zhanxusheng1024@gmail.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] mm: memcontrol: don't lose track of exiting OOM victims
Message-ID: <avALaDR1_epaAfOp@chrisdown.name>
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
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)

When oom_evaluate_task() comes across a victim we've already killed, it
backs off until the victim's mm has MMF_OOM_SKIP. This gives the victim
a chance to free some memory before we kill anything else. However,
since commit a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup"),
css_task_iter skips exiting tasks once signal->live reaches zero. That
happens before exit_mm(), so a single-threaded victim can disappear
from the memcg scan while it still has all its memory.

In tests I used a 64 MiB memcg with swap disabled, and found that the
OOM killer could kill both processes if the first was still waiting for
AIO. The first process faults in 44 MiB of anon and submits a direct AIO
read to null_blk with a 10 second completion delay. The second then
tries to fault in 40 MiB. The first OOM kills the larger process, which
gets stuck in exit_aio() waiting for the read. About 5 ms later we kill
the second process too, even though the reaper gets to the first one
about two seconds later. memory.events showed oom_kill 2 in all three
runs.

The cgroup iterator hides these tasks so that cgroup.procs doesn't
show processes that waitpid() may already have reaped. That's fine for
cgroup.procs, but the OOM scan needs to see a victim even after its last
thread has started exiting. We already have CSS_TASK_ITER_WITH_DEAD
for sched_ext, so use it for mem_cgroup_scan_tasks() as well.

With this applied, the second process finishes faulting in its memory
and memory.events shows oom_kill 1 in all three runs.

Fixes: a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
---

Zhan's patch for migrating a process whose leader has exited also
changes this iterator call. This patch deals with the case where the
last thread is already exiting, which came up in review of that patch.

https://lore.kernel.org/linux-mm/20261027144016.2582880-1-zhanxusheng1024@gmail.com/

 mm/memcontrol.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..cb7cfae9ce5a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1451,7 +1451,13 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 		struct css_task_iter it;
 		struct task_struct *task;
 
-		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS, &it);
+		/*
+		 * An OOM victim can start exiting well before its mm is
+		 * torn down. Keep it visible so oom_evaluate_task() can
+		 * back off while there's still memory to free.
+		 */
+		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS |
+				    CSS_TASK_ITER_WITH_DEAD, &it);
 		while (!ret && (task = css_task_iter_next(&it))) {
 			ret = fn(task, arg);
 			/* Avoid potential softlockup warning */

base-commit: fa4ad798f6f681031775266044ba1b0cf3c670bd
