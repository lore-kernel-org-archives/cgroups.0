Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794567036;
	b=XKR2423Vd97ZXM3On2RMjk4xZPXt6PBCHaeBCy6tACX0Bh2o8bpCISeqYVU1p0ppktxg
	 BpFl1CYFcKfu8haJo1uGzAzY4RwHOWVfNNisAl/zQxK3JAxx+BwRQsu++yNFy/0QA+9od
	 0dB0Pi3/wFUSt/9IMW/a1xhFY0YD0fMcl3gE0nVHSsJSkjuBVM+Du0ePFgqd/MImfWYRG
	 JPVBs0GG5sMDKr2Sr5S4id6qCTiYOzhWKN2shyblJUg1RPsZ2AFTOmlSWpMKZCliifFfd
	 EeKWfSJqoojd4Hnymep4RysjnpgaTWprX5va9m4NiMGc2oCvAzzem3SIt6R/ZFqkw5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794567036;
	h=DMARC-Filter:From:DKIM-Signature:DKIM-Signature:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=kRkIP5hgj/Fu03bggTO+oiUcRsXjx1vX9mZQQlD/ICA=;
	b=FOD7HIosYKryrgJNlEnGzLSqcjQFK8/nBEdfgOPL893GcqCEptSIxgqZHdewnsLjav+C
	 aHhf/RlG8yYBm+rqWHcZXr/Ix25xlXAJs18Naqr+rJ8E6O7ubiDzVX4aBwW4T5AJ8xXlw
	 iTDjIjSO7vVHqE1mmgBR0hB4xxwUkrlnHX82ckjusaN+FfodfsvenqNlwm7xXMVOwtk0N
	 p0ceTS/s2DwO79MnkiehCB2aWUJjytakfS1OHlTMaRCdxwDdMpCVkKEoZjr5Ikr2CbXBP
	 ioFfLImmjkv10uBc4+79IWjNtP7QPfCyQyxD3ZTemCHPghiRSnFF6GnVtkLs7KkrqyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=abCuPkW6;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=Mc6TEYWS;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C64606A321;
	Fri, 13 Nov 2026 10:50:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3C64606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=abCuPkW6;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=Mc6TEYWS
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1794567034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kRkIP5hgj/Fu03bggTO+oiUcRsXjx1vX9mZQQlD/ICA=;
	b=abCuPkW6BdDxapCjQchZX+h8zrhAipDofBW/wYVacyOOareWjXjS1wgpxep6T0VEMIp6/e
	TJsj0knci9qGSvQY4yUrf2yYB7CIT0is334rC1W9FA76eHIOqDwT0vBgKxA/x50IQrifI+
	DHvnkG/vXdNcb7HI7tvH8qPxWvE2XMCb8tWhAKn8E68RoMuGiKjnq3M7bqRBAW0Nr4x4E2
	Xplp01gUcnLPaeXiB1cHZ6pWLAILT/OBUBeyOVayYS7tgs4S8cqurFEE5iBzF21o3t2Nyr
	Y00OgoeZbWogBQddpGnKeWTNDW50IpHLtjYWPnPntPKkkpSBkxeMW+VWY/7+RQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1794567034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kRkIP5hgj/Fu03bggTO+oiUcRsXjx1vX9mZQQlD/ICA=;
	b=Mc6TEYWSbnRVRAoyOWt052EY3MXGlJyIqmtIjWvrWUec8DtM0Y8uihfbfTtoPHD6RWV+Ye
	uVNIKvN03BQ/CHBQ==
To: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	luca abeni <luca.abeni@santannapisa.it>,
	Yuri Andriaccio <yurand2000@gmail.com>,
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
	Qais Yousef <qyousef@layalina.io>,
	John Ogness <john.ogness@linutronix.de>
Subject: [PATCH v3 1/8] sched/deadline: Reject debugfs dl_server writes for not-active CPUs.
Date: Fri, 13 Nov 2026 11:50:22 +0100
Message-ID: <20261113-sched_dl-v3-1-a76ffa1cdeee@linutronix.de>
In-Reply-To: <20261113-sched_dl-v3-0-a76ffa1cdeee@linutronix.de>
References: <20261113-sched_dl-v3-0-a76ffa1cdeee@linutronix.de>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

sched_server_write_common() checks if the CPU is online before allowing
fair_server updates. This is important because updating the fair_server
runtime/ period will use dl_bw_cpus() will return only the number of
CPUs which are also marked active.

The CPU is marked active as the last step during CPU-hotplug. If the CPU
has been marked "online" but not yet "active" or is stuck between those
two states then any update of period/ runtime will lead to a divide-by-0
error.

Let sched_server_write_common() check of active CPUs instead of online.
Additonaly, let dl_server_apply_params() return an error if dl_bw_cpus()
return 0 CPUs to avoid the divide error.

Fixes: 4043f54984161 ("sched/deadline: Reject debugfs dl_server writes for =
offline CPUs")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/sched/deadline.c | 3 +++
 kernel/sched/debug.c    | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index dfae08625342e..10beb54281881 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1920,6 +1920,9 @@ int dl_server_apply_params(struct sched_dl_entity *dl=
_se, u64 runtime, u64 perio
 	cpus =3D dl_bw_cpus(cpu);
 	cap =3D dl_bw_capacity(cpu);
=20
+	if (!cpus)
+		return -EBUSY;
+
 	if (__dl_overflow(dl_b, cap, old_bw, new_bw))
 		return -EBUSY;
=20
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index e6a3b516c703b..1545139e52443 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -410,7 +410,7 @@ static ssize_t sched_server_write_common(struct file *f=
ilp, const char __user *u
 			return  -EINVAL;
 		}
=20
-		if (!cpu_online(cpu_of(rq)))
+		if (!cpu_active(cpu_of(rq)))
 			return -EBUSY;
=20
 		update_rq_clock(rq);

--=20
2.55.0

