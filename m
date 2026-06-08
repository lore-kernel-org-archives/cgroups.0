Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36743806B6
	for <cgroups@vger.kernel.org>; Mon,  8 Jun 2026 12:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780920973; cv=none; b=Hoby3OA9rohDjj1wmCx8B+oB8X1UjuSfLrxnBL3oITs5BqKqH7sDzns1z9z8gD+cPUUcPYtmQxSAnftnslCWa9GqJ1hQ7mMH0ZdFMuLaU0CE86q7xH/DtMqUeZX93ijeTwlFZsVHiHBqMXj/SuAXMY6m+qbvpT3P8R+cvlgmKfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780920973; c=relaxed/simple;
	bh=HcRNgF/O8yJDYJTUnmjZ+m7CiqJa3AxT4FmrF+40hgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Auvb7KCa7Fs/di1AbRK6+i+He6LMHiVjrKkagM7nJCddogVFFPZ/m/EcRdqYvELHnTbGwlCG1kjpLrSnTytGQPz7s7Ht9RJMHNufSBNfmzoA1VazgYUyM6fsAF2iUShjQuY/zAyIbAjicCyQftqSzRdEOUJCiNfusfh0eCXlxtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A1tOrh6+; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A1tOrh6+"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-45ef5146b56so3310206f8f.0
        for <cgroups@vger.kernel.org>; Mon, 08 Jun 2026 05:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780920970; x=1781525770; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EkbH48zQzOxR1p1OVZ36l1CXw9g8/fUqm1rKlMh4u8E=;
        b=A1tOrh6+vWISxf0DC5FfGjtd4KVa+Ua4GQNNGnqaO8CbEHPRvL380V3YXJZSKmSLtF
         lpZ+CY62OXdfN6+7y/nR80QR/yptJcLa7SYEOyVewXq4g9+B7psnOXQmDTh6yKESDW9R
         1rOOcIZ48cHFx/Ng+VXdLzDiKkpkBm4CKS3cev3s+VJ5VXKb5G1OtW0Zcg4JXvogn9aK
         H58L+4gizlzv2NWqpEJuOfYruaUkdDS87W+r4LEZAGEP9kTXmSuf87ACzU7LF+M4iRK5
         voIDt0/tqeXbmZPsvWlhzYTZpnPzL2bcgdvzCDopuuTZb90GycBb68gw4eyLwcHGjB+J
         YedQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780920970; x=1781525770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EkbH48zQzOxR1p1OVZ36l1CXw9g8/fUqm1rKlMh4u8E=;
        b=YVRYyNLkaMulEMEQIm5sm0oDLVeQFpx+sTsWYQs9dsC9hYoRymyuRTeqPqYUPqSnVJ
         l5FWqOcIs8/xBxGYhEVCx/zDEgKA8JMGqD7KnXbMUbHkVoAtWTJeJdY806GZqN58let7
         p/LA9JW2iRGB4U8QvtWkeDGmsvFZPXdUUgoFE27A6jOxyh2dhul9muFcfu+MlH3/zHHB
         4OgQdXDhPiiLsE3FKXEz2LAkiJCyI/fK8GmeXikfL5SZgEFWib8qKVyR+9DKRGJ0YnJE
         VBqjkiMlLF/tHNuuZdrOlDM+/EReICarS11vgXUpr4EW9cN4ayibwCPwUMe6SZ7FewXh
         baWg==
X-Gm-Message-State: AOJu0Yw4APe6e9pyI5yk+pc1Rs7vcPpd+cDg8HZxbK4WMAAqtfXwsR76
	9Fm7hGva0NIFYyl7XuCBxKecQx5T4agS8TkVce39OF23lBbYgjm8di6f
X-Gm-Gg: Acq92OFYBYx5WTLfdx6OX9z5ibG3rdIoOHofHUDjT6hZPM7xl8TPi0Rk2MxctDQGPv9
	PVQh/Ywj7uSuMjGyFkb05aIiCC+wtvRJHksuZTCkbCt9I/kTSiHE4PpkfA526EkkyirQpI0yxCk
	KCiOvcUMJc2wZ5LqZviJIWFxsupi+8Qi16t6207WYOMK8BsCmp8GgmG5g8p5zOI5YyxVxKYTuVr
	FOvMghNGo81UuUchM3rbLb6SOfgnwBPdRLW0S9BxwEP5SzZlWs3/1SPFT603zj4qdIybP4kt838
	X3KvATv0itS8XgLrbRrB801h9R9LPQR7QGRM4GH2Uj5QJnosX7YBr6p8JwJnoTqPRYEr32KLtit
	n2LnztWhZvguJdwyV3T/+7Ewb+z3KoLGTVBiDtuPiURly5P7y/pvxdVIX8TyHxEQ1EDRDZxcZDi
	rMlbj6YOCdSyjRLkzPwH3hKAYsj7X4Sj4=
X-Received: by 2002:a5d:42d2:0:b0:44f:69f4:39b5 with SMTP id ffacd0b85a97d-46032dd94d2mr13083394f8f.29.1780920970201;
        Mon, 08 Jun 2026 05:16:10 -0700 (PDT)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2ec711sm50644906f8f.12.2026.06.08.05.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 05:16:09 -0700 (PDT)
From: Yuri Andriaccio <yurand2000@gmail.com>
To: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>
Subject: [RFC PATCH v6 24/25] sched/core: Execute enqueued balance callbacks after migrate_disable_switch
Date: Mon,  8 Jun 2026 14:15:43 +0200
Message-ID: <20260608121546.69910-25-yurand2000@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260608121546.69910-1-yurand2000@gmail.com>
References: <20260608121546.69910-1-yurand2000@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Execute balance callbacks after migrate_disable_switch.
  Balancing may be requested on the __schedule path, in migrate_disable_switch,
  when the running task is throttled and then pushed away from its runqueue.

Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
---
 kernel/sched/core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9e337f0090b3..1d458638aab9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2410,6 +2410,9 @@ do_set_cpus_allowed(struct task_struct *p, struct affinity_context *ctx);

 static void migrate_disable_switch(struct rq *rq, struct task_struct *p)
 {
+	struct rq_flags rf;
+	struct balance_callback *head;
+
 	struct affinity_context ac = {
 		.new_mask  = cpumask_of(rq->cpu),
 		.flags     = SCA_MIGRATE_DISABLE,
@@ -2421,8 +2424,13 @@ static void migrate_disable_switch(struct rq *rq, struct task_struct *p)
 	if (p->cpus_ptr != &p->cpus_mask)
 		return;

-	scoped_guard (task_rq_lock, p)
-		do_set_cpus_allowed(p, &ac);
+	rq = task_rq_lock(p, &rf);
+
+	do_set_cpus_allowed(p, &ac);
+
+	head = splice_balance_callbacks(rq);
+	task_rq_unlock(rq, p, &rf);
+	balance_callbacks(rq, head);
 }

 void ___migrate_enable(void)
--
2.54.0

