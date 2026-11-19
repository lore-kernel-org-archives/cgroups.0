Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795105505;
	b=Rw5JWAc24u4YqQ+pUbgxH8yd+2mHQIN0s3stTn+Z1o04ftL3mw0WCIKg4iBkY4vvOKgt
	 qdFROMFgMM9hRhEn/ThdDakgsRVe4B78XUvpmz/ZtkG+HIAhEZcaCnqMDMmB1d0c7vNle
	 aH9wDrzSROeW8ZhK2RIHbALXTkDJ/6o80qUd4IfbHCwkhZ0DL8wyLSEugj5l4WPMp52B6
	 YENYYIvBcrkcuwyik5PYmH4z+aYEexCfFiL079fyZ3os+E0MNXc8KOJ3Ej/3rTwcktEon
	 a/TDEjwYsxgaeTZ1zNEIGw1Q6THY8kWTLU83WoWN3ZfbjO1UURLbkWFdKUT2mi61ghA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795105505;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=RpH3Eqg7iYrUnR+bT4B28VRSM1FxKzR8GEzsrCXC1us=;
	b=1iwuvgjNaUZexNChoKnN+msE/hTJGvpV+smeGs+yTJYXegYmSybEm4KKr3RJ8pLh7LY3
	 NXd4FKfayQx2MIs8hzZ3dtM/0IQUBC1rdtFK3Dr7duS4HqAF3Eu+yoAKXeWYKXImj9mWx
	 ye9jtmFbHBGnAhVav29iw6ykZWvq4cDFwD8gQpIxffoWJlTCDwiDSknqm06h8tmUL4a+f
	 kz7QhPuNF3AAXyn+t6KcQ8bQu9nfXHK6UU/2lfdf9bVRfz4KrmGYnl4YQz3+d9Z8Sm9oC
	 ogMrKjlWLKwdmFrbyVTeWnm48FEwHMDXr/QY6PYC2JXTE3g/aArub7tqKZlNNDjOX2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=n9yXJePy;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D4B60A2618;
	Thu, 19 Nov 2026 16:25:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06D4B60A2618
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=n9yXJePy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795105502;
	bh=RpH3Eqg7iYrUnR+bT4B28VRSM1FxKzR8GEzsrCXC1us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9yXJePy2PbjEMO7pTsvFCfi9girSjiUY6nBj0+hhexof+Fzecl8XQGTiypQTrFRE
	 Q9JQDVkco3sjcqZlvBlBSmMPPq9pJ6Pcd6WVFzLOLMSKMTIWCDcEpOLaQFVWXIP9aC
	 P0Pk/cmEybNr4STFI2oYwtf5JGTSaxp4564LUJEylhu/HW/ZfELqoCD1ipjNm7/biM
	 OVikwoh36I/JENYgzR4QMDflMWgAaN1wZ2WdeAYTHOwMQapj8ATMz/t1gd/WQycO/9
	 njP+r4FYGtzZjWBz4YLmaqNZVPVoPZqxK3ODrTNJU/Emyj4I2kJ6lKCM/o/Em01ZhI
	 qSJr00b3smOOA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVkMf4XC2zTnH;
	Thu, 19 Nov 2026 11:25:02 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: [RESEND PATCH v4 05/17] sched/deadline: Refuse dl_server debugfs writes while the rq is offline
Date: Thu, 19 Nov 2026 11:24:45 -0500
Message-Id: <30870826885d7aa42b641d23701066e03b1a2b9b.1795105408.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795105408.git.mathieu.desnoyers@efficios.com>
References: <cover.1795105408.git.mathieu.desnoyers@efficios.com>
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

