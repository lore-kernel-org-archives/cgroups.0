Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E9737D103;
	Wed, 25 Feb 2026 05:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771995743; cv=none; b=YU7xlGRXDJH1dZQXn+9oE0EGzOchvK4ezldGNW/aD+kpiT9IkPvatqHItsIib7mtr+En2SdgufzXNhTU7erN3ByxGGDTxPGWloR2lnRgSlGSCZqyy5NjbeEsGnaJAHV2stqcmr9tAKmxX6WrQVvJWZ3mRmS34FQXNQo6oXC+MLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771995743; c=relaxed/simple;
	bh=hthDZ9ReGeQ2kRKYJdyU+XM1DwCu0LqDFbreT7Za8ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gd2bs8EmhVbku5wHWlxSSAXTbdzORUv6vd284fg74m4bN1U3fvBBXNKeKAuwZjuSJYEbf3GTjkiJXpCvWpVKQNwiSj1hKJ2tJEXTdtskJnZ58MjAJ7hgNrBAXPVcL+Ffm7YIEQ1wk5b9exQbztBRaOdBz3MgFzRL2cNUZ57j1uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YmaH3AV9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YmaH3AV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498FBC116D0;
	Wed, 25 Feb 2026 05:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771995743;
	bh=hthDZ9ReGeQ2kRKYJdyU+XM1DwCu0LqDFbreT7Za8ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YmaH3AV9LaRdirPrrNfsyG3doh5046i1Ky0gsdfDsTWgazOq36y3+IBhmXHE6+HHw
	 A89BQkef0MOGZ49YDjUr8wC8mkvMIoNOsnckO1QzIGZnlmpZaTD73rcuYtDoI/rNM3
	 q55WrjxznKaqU6/gAk2udCl/hL5bDQO5hbmg5LHNJJ/ogA+SJ+kZdjvWGblzEDvNYN
	 79LoWbS+LsMUYoxn4sFj/8rHSYAKpfQc3U4TOsAaTx8SEDGgfcSp6wsoLxPiqbv4L8
	 fTCIbAQSd2/5DRQcY+xfSzXT4HBuQBO/ZVuhsFZXG+lLkhycxkILcRe0zWHsEDGF2/
	 ioKe9MtZEiA7g==
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org,
	sched-ext@lists.linux.dev
Cc: void@manifault.com,
	arighi@nvidia.com,
	changwoo@igalia.com,
	emil@etsalapatis.com,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	cgroups@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 27/34] sched_ext: Convert scx_dump_state() spinlock to raw spinlock
Date: Tue, 24 Feb 2026 19:01:45 -1000
Message-ID: <20260225050152.1070601-28-tj@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225050152.1070601-1-tj@kernel.org>
References: <20260225050152.1070601-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The scx_dump_state() function uses a regular spinlock to serialize
access. In a subsequent patch, this function will be called while
holding scx_sched_lock, which is a raw spinlock, creating a lock
nesting violation.

Convert the dump_lock to a raw spinlock and use the guard macro for
cleaner lock management.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/sched/ext.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index be800ed5d9f3..2a1db509bcbc 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -5201,7 +5201,7 @@ static void scx_dump_task(struct seq_buf *s, struct scx_dump_ctx *dctx,
 
 static void scx_dump_state(struct scx_exit_info *ei, size_t dump_len)
 {
-	static DEFINE_SPINLOCK(dump_lock);
+	static DEFINE_RAW_SPINLOCK(dump_lock);
 	static const char trunc_marker[] = "\n\n~~~~ TRUNCATED ~~~~\n";
 	struct scx_sched *sch = scx_root;
 	struct scx_dump_ctx dctx = {
@@ -5213,11 +5213,10 @@ static void scx_dump_state(struct scx_exit_info *ei, size_t dump_len)
 	};
 	struct seq_buf s;
 	struct scx_event_stats events;
-	unsigned long flags;
 	char *buf;
 	int cpu;
 
-	spin_lock_irqsave(&dump_lock, flags);
+	guard(raw_spinlock_irqsave)(&dump_lock);
 
 	seq_buf_init(&s, ei->dump, dump_len);
 
@@ -5342,8 +5341,6 @@ static void scx_dump_state(struct scx_exit_info *ei, size_t dump_len)
 	if (seq_buf_has_overflowed(&s) && dump_len >= sizeof(trunc_marker))
 		memcpy(ei->dump + dump_len - sizeof(trunc_marker),
 		       trunc_marker, sizeof(trunc_marker));
-
-	spin_unlock_irqrestore(&dump_lock, flags);
 }
 
 static void scx_error_irq_workfn(struct irq_work *irq_work)
-- 
2.53.0

