Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032411;
	b=1x03hTVpPo6asuQF2C7MgVl2TtPl5vSx3xIVj0zxOuQFVqt2DwAVrAxJOfUp59w97ovA
	 ITVf25HWHGT7C8HXFFQioyT5uKZOripoG9k7GaDnh3i6Kwx2v3aP3mtuBGVX8NQG+9L7K
	 U11PVGO/0IeX8Zza6b4OvkM8cczNIskdAiy8IyfWh5fJuCxWFLoFvNb2Yp6N5/Mxc69+r
	 YzjRFmKiJ6qW3AxScmcIS9qQkbeyIHavEwbSxI1oqpvpgtYjoYPoqa1aUkFXofGLk09ve
	 xFWfxbS1QyzhdHgVPly+Ylytxbmut72jaRWHxkPj+npkSVe/ADxurO+2CwUYg4ls5qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032411;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=RpH3Eqg7iYrUnR+bT4B28VRSM1FxKzR8GEzsrCXC1us=;
	b=scpXD8cBNYybs0HxYX3cS0XsdDF20ZsbXT8thRL0rRGcoLDkUpBVuViKmiuWK+VIDR13
	 Y7Q9uDXt6HtkBuV3KKXet7S/La8lq3scEbT7Zq4vNT0hkHq/iTj57ww/bu4Bd85sUIV/a
	 8Y1NyRfsCw1hJnw9VAc+xn1weYN50mYTG/eWTL4BXGq/qTUlbWbqWK8FzoyJkjiDOtfgh
	 Jnhigi9p3C9Lo4sz+VK1K7ERCVIiI4fLa/EhNkhdLj3ogGA3KmgtGAiCOyXHQynbHuPj2
	 STUaMapnKztpTUeQvQTQAqjjgACKPW4la8lX/ZNsPOBaJIhUaTrhxwYQqd531nHJTYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=pvHk6RNm;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634A260A2611;
	Wed, 18 Nov 2026 20:06:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 634A260A2611
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=pvHk6RNm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795032404;
	bh=RpH3Eqg7iYrUnR+bT4B28VRSM1FxKzR8GEzsrCXC1us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvHk6RNmCJyCEKHG5r/IXfC6/bk0avtvPaMVD8tyWsmFdv5EN5Xb7dibxUjecbgXg
	 ShCWkp0yr6FVFj+Ongt3t3sABxHrEEJ4qKYFQqDzahs4NslEG8M+NlLbsScE+Asrsw
	 geqNTVvwJOx6fDNok5IQsWgC2Y/MD4mcILoCGk0OTyHjfWgyhCxkA+dbCNCu4c5ubG
	 GMaGk44zkODxPvkUnzzteHSnWuMG3FG57q6FPxplYy2nKNiKz8GI88xXa7D+evWpbg
	 e/JvdCKI/sXcvz+3n1nH6ntYGG6/I2bHO1rxO6q9ggOUkFH+NgunaNQDLbREuo0VFl
	 0u/rgeFrRgdIA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVCKw3P1szS2W;
	Wed, 18 Nov 2026 15:06:44 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	tglx@kernel.org,
	will@kernel.org,
	boqun@kernel.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	luca.abeni@santannapisa.it,
	mathieu.poirier@linaro.org,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	parri.andrea@gmail.com,
	m.szyprowski@samsung.com,
	kayracizmeci@gmail.com,
	weihengqiuu@gmail.com,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH 05/16] sched/deadline: Refuse dl_server debugfs writes while the rq is offline
Date: Wed, 18 Nov 2026 15:06:30 -0500
Message-Id: <30870826885d7aa42b641d23701066e03b1a2b9b.1795031605.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795031605.git.mathieu.desnoyers@efficios.com>
References: <cover.1795031605.git.mathieu.desnoyers@efficios.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 4043f5498416 ("sched/deadline: Reject debugfs dl_server writes
for offline CPUs") refuses a write to a dl_server's runtime or period
on an offline CPU. Its message says that such a write has no meaningful
semantics.

It tests cpu_online(). But during hotplug the CPU is still online while
it sits in the default root domain. This lasts from the rebuild in
sched_cpu_deactivate() to the offline, and from the online to
sched_cpu_activate(). That root domain does not count the server's
bandwidth. A write in the window still goes through admission. With
admission control off, it changes total_bw there. On v7.4-rc2, a write
of the current value divides by zero in that window. The previous patch
removes the division, not the write.

Fix this by testing rq->online instead. It is set under the runqueue
lock when the CPU joins a root domain that counts it, after
cpu_active() is set. Test cpu_active() too. On the way down, it is
cleared before rq->online.

A write now fails with EBUSY while the CPU goes offline or comes
online, as a write on an offline CPU already does. Writes at any other
time are unchanged.

Applied without the previous patch, this patch alone also stops the
oops. The reproducer survives 20 rounds with no warning, in 3 VMs of 3.

Fixes: d741f297bcea ("sched/fair: Fair server interface")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/debug.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index e6a3b516c703..ddb382df454b 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -410,7 +410,16 @@ static ssize_t sched_server_write_common(struct file *filp, const char __user *u
 			return  -EINVAL;
 		}
 
-		if (!cpu_online(cpu_of(rq)))
+		/*
+		 * Refuse the write while the runqueue is offline. This
+		 * includes the windows where the CPU goes offline or comes
+		 * online. The root domain then does not count the server's
+		 * bandwidth, and may have no active CPU. rq->online is set
+		 * under this lock when the CPU joins a root domain that
+		 * counts it. cpu_active() is set before that. On the way
+		 * down, cpu_active() is cleared first.
+		 */
+		if (!rq->online || !cpu_active(cpu_of(rq)))
 			return -EBUSY;
 
 		update_rq_clock(rq);
-- 
2.47.3

