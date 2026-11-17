Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794924669;
	b=PK36BFnt7W+8Sg0TrbQ10vLzTFs8prsPejxOj4E6j54S1T2S/c74ekv0IYUsNYOKep74
	 G2F3sS7SamN3J2Ub7dxA4fGQ/+7Ku99s9GWrxtKl+/dVzdrnXB/OL083Hp2AtbMYEkO3b
	 TxiG6Oky28+4pbQLnPSa2lY2MmO6dnCIfM+qHvyuwGLQumsGUngZTFgSXmWdzAh7hNpO1
	 kxxiemxma9t4263yXhRg19kV7qgq2rxRQR+EnYRzzVo11WnJINxtd0jx8bQV9lV6/JwHT
	 lb8jC/RctRcCGLt0KyLd6bq3HojdjbQC4hbDX4oPb7g12leTRQpyURNLlEp+2NjSZjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924669;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0mpHTZ1wTWSyVYujmTmJVz2NigpNkoFUGWUyz0iXGUA=;
	b=ky/YYh7uMFXMZKAtaeRWUBN5l22QAbtI4rkGpK3kQnmmq3Oa9N7J8o62MB6M9VoXzKCZ
	 qVVbmPWPdNaHe5EWY504b53eIsIEYYwyEFvMZW6JT6l0bSNPXrw28vGVWnbKyrx8lVymx
	 NcvFpgC1IOtlJd+Cg3sPD9GfWuLmViH46TTaqyoG/5uFmrI/hWdijXGo3qAL+WodIkW5j
	 zTkwse2g84F8ZgtiazNa+U7A+cEEzxeDoEjnHk7LEc4/WzevvgJeNuO6JQ+Hiz5k+xS81
	 3XmeLDeT5tLlszdQGxMwojMGydiN5h/VKzzoJCKnLz7S2BGyoPAqABVBnv1AVizePbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b="MWhH8vH/";
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB5E606A8A9;
	Tue, 17 Nov 2026 14:11:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EEB5E606A8A9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=MWhH8vH/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794924665;
	bh=0mpHTZ1wTWSyVYujmTmJVz2NigpNkoFUGWUyz0iXGUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWhH8vH/Di8WSKIoOslI/Kj+6VicLN4cBsD4mdkfmi2yts4DSr7Awm4AgJYjq3Nia
	 7+xL2YRBS1OCSrNhwy0YAqObpEOGEXznNx+h+EgcLPZi4pRKcpz2xa56bNXC+t+AcP
	 p2+XQtemuOYHdh5ckAjsrMibar1OHAIq8KZmKy5LmZDtQ48pE+OiphqBdHmmCUYR+o
	 w09vc4LzWekvHJTE4yUd5Z+7DRei5eog4wxYiWsBgZBRlCHweBY1ug7l3tlEuEcE8g
	 wiZIqR+g6lt32INpQvzlvLDv5WLKVbSFJfNICPIdJxqMvOrQq68A4YMb7KROmZTMhy
	 M/jthicYhvbyg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTRV10RkQzRKN;
	Tue, 17 Nov 2026 09:11:05 -0500 (EST)
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
Subject: [PATCH v7 05/40] sched/deadline: Refuse dl_server debugfs writes while the rq is offline
Date: Tue, 17 Nov 2026 09:10:26 -0500
Message-Id: <2bee6a143319301f082855a15274f0563e99b8a5.1794922146.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
References: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
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
cpu_active() is set.

A write now fails with EBUSY while the CPU goes offline or comes
online, as a write on an offline CPU already does. Writes at any other
time are unchanged.

Applied without the previous patch, this patch alone also stops the
oops. The reproducer survives 20 rounds with no warning, in 3 VMs of 3.

Fixes: d741f297bcea ("sched/fair: Fair server interface")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/debug.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index e6a3b516c703..e0d6cd3bd607 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -410,7 +410,15 @@ static ssize_t sched_server_write_common(struct file *filp, const char __user *u
 			return  -EINVAL;
 		}
 
-		if (!cpu_online(cpu_of(rq)))
+		/*
+		 * Refuse the write while the runqueue is offline. This
+		 * includes the windows where the CPU goes offline or comes
+		 * online. The root domain then does not count the server's
+		 * bandwidth, and may have no active CPU. rq->online is set
+		 * under this lock when the CPU joins a root domain that
+		 * counts it. cpu_active() is set before that.
+		 */
+		if (!rq->online)
 			return -EBUSY;
 
 		update_rq_clock(rq);
-- 
2.47.3

