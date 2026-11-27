Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795790184;
	b=AZaAnoDhLuNhYs0P+S6l9vwv92wWTeqWw2ZxQgp+uZgLCG+c677GwQQkSSdpIRqZheHf
	 hbdNGQMJv5jJBMQj5/GskmQDZuPJG8EBG912XyjD6F8qe1py0yUxnNvGY6sckRi7jB5aQ
	 EL2D/c3KA2txLU4QI1D2sRi2IWfF93nyx3i/RqePfFenNfSSOsEz73CoaJBP8sVk9d5p4
	 NhqRWSHlHp4rKxPU6vNsN6XDBOLpXd37iVM51xZvbs5uhmnO8JK4GWEgYXHjRV2IIWsiV
	 qSOJGcdK71xtvPMx64ap4dK0uO2+VHomeYv1tbAZY2dgwBQxbZ/InFzknSq3KO8TTZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795790184;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=366yT3iPmRePI8urwseNRrcT+qiVkjzfQ+7FESfhOXk=;
	b=KSlcPKzdbwYGQ2h1tG4uTj9mQpQEX5kHSB+NLtTzw2WOhQr/GqzYDwZrEsEd0cbLVDgS
	 WI3DZVnCLwK+65JT8WMNBj137+iqaDSdfJ+LtNGYHQCJpT+Gf+diN5l6CmPSP5ELqiWG5
	 dDJdAmBeRnWL5tmoirR7Bl1BbA2zupfSopsxuMBCWtrUuYw7rag3MXVPoeoLFH5vuvP+r
	 wOkW1iVqf/WTmFc0gEgsE6ALb2whMT//nYKR3OvyofDldjID2mRi58hcDrA4vXfBmvbBm
	 8+GLTbP9KXBYKnYU1spWhYaW29w+C4fi0FAQbcOZU2JSFzVfC3D4lDj4vCxYBfW/kxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=fnTX0ezH;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646F2606A6E3;
	Fri, 27 Nov 2026 14:36:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 646F2606A6E3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=fnTX0ezH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795790179;
	bh=366yT3iPmRePI8urwseNRrcT+qiVkjzfQ+7FESfhOXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fnTX0ezHykWE89mQh1g2buC+Ho+bSum3QvFNDhk8c+APr5Z41lIIvkcyvu+dxdRsl
	 E+XY85WdJIRFRdgam8nm/oixQ5YIxPZbxWdGceNXmVCz5bEKsIE1f/WiWhUOmjC507
	 v6gA0PFbvxYk7gENKflgtwqMrwb3pzs0mjPSQJ/H7wiAwvnzcG2bnETyxP8vtixRQm
	 sc/t2kDPhQ9TEBLTFJv7Teixe+LG7C5UsWX/5miyYAvg8vXm/SSPpwhJnO3v/gAOwV
	 +rJ3nf+59dA1biK/BOuKf3qM5v4zX7YSdzXFaFDDwJ9ut4m5TsAocjU2DGC8YIHN0q
	 LO5JnMNptbgGw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jbbZW5vMYzXCS;
	Fri, 27 Nov 2026 09:36:19 -0500 (EST)
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
	tommaso.cucinotta@gmail.com,
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
Subject: [PATCH v12 36/43] sched/deadline: Check the runtime of a task that comes back runnable
Date: Fri, 27 Nov 2026 09:36:03 -0500
Message-ID: <0175b68963df6a2658049220183a8f3f797502db.1795771148.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1795771147.git.mathieu.desnoyers@efficios.com>
References: <cover.1795771147.git.mathieu.desnoyers@efficios.com>
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

Commit a649f237db18 ("sched,dl: Fix sched class hopping CBS hole")
keeps the runtime and the deadline of a task that leaves
SCHED_DEADLINE. A task that comes back before its deadline goes on with
them. So leaving the class and coming back gives no new runtime.

But the task can come back with new parameters. If it is asleep, its
wakeup checks the runtime left against them, with dl_entity_overflow().
If it is runnable, enqueue_dl_entity() starts a new period only if the
deadline has passed. The runtime left is not checked.

So a task can come back with a smaller runtime, and still run on the
old one. Admission control counts only the new one. Juri Lelli found
this case. On v7.4-rc2, a task of 50ms every 100ms came back through
SCHED_OTHER with 10ms every 100ms. It ran 39ms of the next 100ms.

Fix this by applying the wakeup rule to a task that enters the class
runnable, with update_dl_entity(). It starts a new period, or reduces
the runtime of a constrained task, if the runtime left does not fit the
new parameters. The task gets no more than a wakeup would give it.

The return_running_new_params case, added to deadline_bw_test later in
this series, tests this. It fails on v7.4-rc2 and passes with this
patch. The return_asleep_new_params case tests the wakeup, and passes on
both.

Fixes: a649f237db18 ("sched,dl: Fix sched class hopping CBS hole")
Reported-by: Juri Lelli <juri.lelli@redhat.com>
Closes: https://lore.kernel.org/all/avHvPjz4dL0zNyGb@jlelli-thinkpadt14gen4.remote.csb/
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 8babc3e2ac51..884fe83538ab 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3196,6 +3196,14 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
 		update_dl_entity(dl_se);
 	} else if (flags & ENQUEUE_REPLENISH) {
 		replenish_dl_entity(dl_se);
+	} else if ((flags & ENQUEUE_CLASS) && !is_dl_boosted(dl_se)) {
+		/*
+		 * The task enters the class runnable. It may come back before
+		 * its deadline, with the runtime left from older parameters.
+		 * Check that runtime against the new parameters, as a wakeup
+		 * does.
+		 */
+		update_dl_entity(dl_se);
 	} else if ((flags & ENQUEUE_MOVE) &&
 		   !is_dl_boosted(dl_se) &&
 		   dl_time_before(dl_se->deadline, rq_clock(rq_of_dl_se(dl_se)))) {
-- 
2.47.3

