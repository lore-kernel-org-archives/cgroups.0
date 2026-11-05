Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907256;
	b=LQ1dP3mfX7IZMBjzPsuntAOxxf/gtdf3aXeBq1YPeYdUbd4zXoFmva4t18WHwsyj6pPM
	 8HapWKck/J9gwRX9QpQrP7JQ/Efmptezb4Z3ZQPsEpYp3wYOl33w0Vhv4yR45OFXRFjn6
	 ShBl+aZfN03i6XX3Egb0FA8iuyk9zlObxyGg0xwBOaNE44KH2OPrl+ZFWX+OwUmFcxlQy
	 2DaNwSHH3Z/g5gapQQloN0HZs5rG/zKacopmL8Xjri/AW1yyIT7IQxvwcb/SUhu/kMsZJ
	 07+QDZVpgM+U7MTX1mRpwtMV5CvJO6dDQii6tW59fQbBTFKRAiBYxcClEfNSYDlkJVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907256;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0Yq28bzTUJ3iNY//5LElOyTADXlqa2Uq2chixrgk5yE=;
	b=uzYDQ+O8AQ0qzx/5x8NEqrMPOrYc46tKjZNXS7na2lCdNv0wzUTDKnv0yyHAKAgqg3xw
	 gmj/CadtJulJQe1TRCBrybqxiTa8QKR4qyNFEEulue6ehAMv+Yw92ETW0waCVRZYAc7lr
	 jh9RP/IWkmCdk4aGopGld1G0GfmIF27iUoSCnW8XZ/Nt3pYEuqjtN1vxYbSOpXUMzje2u
	 MgSX0bg1SyBMJLXsJpGCFo28W4c2cAV3orHwbvvxbWLTSE3RpISYW64Lp+xpUUJEzapsc
	 eZvzG4ng5EHT3x17xlwMyDzKptjNSd9q3iPzbjUj3J9wXfDVabvJdJABzIwz5os6Flg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=HfL57BLk;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107A9606B053;
	Thu,  5 Nov 2026 19:34:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 107A9606B053
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=HfL57BLk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793907249;
	bh=0Yq28bzTUJ3iNY//5LElOyTADXlqa2Uq2chixrgk5yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HfL57BLka2BDhpYh1tekKR3jcQLzRaaQKIXqtNfxytbAxhHS5x7fDdx8T8KkNCkok
	 qsyss5Dmx2GI39N6c91Vh7bA4Xj2iyr+UzwAvJN9t3ZyElWBMDQzai1ORaF/pbjjll
	 zorMuVWIUkrbOn6HsAZC5LWIpfcLvRaw/82VPI+e6lN/LF2CPbrVQC3XOWYcw6SigA
	 6lzlWc7QwajDhjMmGvkRs1zCAQPlbPTFd4Yg6zW0jN+r3KVtziHZp7RtucITaufpqT
	 beE97QkVxz6R/byF1RZr2KRWgVMxOTiAOUh52TvK49r8Gte8O7bzwp7z+37uZl+RRe
	 2RTsZYwLGLOXg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLCDK2mbtzLYF;
	Thu, 05 Nov 2026 14:34:09 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
Subject: [PATCH v3 03/24] sched/deadline: Do not admit bandwidth for parameters that are kept
Date: Thu,  5 Nov 2026 14:33:38 -0500
Message-Id: <20261105193359.1450487-4-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
References: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
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

sys_sched_setattr() fills a SCHED_FLAG_KEEP_PARAMS request in from the
task itself (get_params()), with no lock held, and
__sched_setscheduler() then skips __setscheduler_params(): the task
keeps the parameters it has, and its dl_bw with them.
sched_dl_overflow() runs all the same.

A parameter change of the task's own that lands in between leaves the
request stale, and dl_param_changed() takes it for a change: total_bw of
the root domain, and this_bw and running_bw of its runqueue through
dl_change_utilization(), then hold a bandwidth the task does not have,
and the release at its 0-lag time, which takes the task's own dl_bw,
leaves the difference behind.

There is nothing to admit for parameters that are kept: skip the check.

Found by reading, after the Sashiko AI review of the first posting of
this series raised the case the previous patch refuses. Not reproduced:
it needs a parameter change of a deadline task to land inside the window
of a SCHED_FLAG_KEEP_PARAMS request on the same task.

Fixes: a509a7cd7974 ("sched/uclamp: Extend sched_setattr() to support utilization clamping")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/syscalls.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 6819f0fea3c5..b8c036d03d6f 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -690,8 +690,14 @@ int __sched_setscheduler(struct task_struct *p,
 	 * of a SCHED_DEADLINE task) we need to check if enough bandwidth
 	 * is available. Last of the checks: nothing gives back the
 	 * bandwidth it reserves.
+	 *
+	 * Nothing to admit for parameters that are kept
+	 * (SCHED_FLAG_KEEP_PARAMS): they are the ones the task has, and
+	 * sys_sched_setattr() read them from it with no lock held, so a
+	 * change of its own that landed in between would leave them stale.
 	 */
-	if ((dl_policy(policy) || dl_task(p)) && sched_dl_overflow(p, policy, attr)) {
+	if (!(attr->sched_flags & SCHED_FLAG_KEEP_PARAMS) &&
+	    (dl_policy(policy) || dl_task(p)) && sched_dl_overflow(p, policy, attr)) {
 		retval = -EBUSY;
 		goto unlock;
 	}
-- 
2.47.3

