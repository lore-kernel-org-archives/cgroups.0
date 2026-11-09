Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242220;
	b=Ry7rVgknRsEnazzW9TNTfdxMkNInm2p5xN18jSMM57V6wK6CjBiDBXTrriDdzSBudEBO
	 MyKULM71ykV+Pbj0qGib5iUSgfOsRPbJ3LGl9XMupY1tniOaCoqH3cH0iMHOHaihHRIz/
	 G1cwgAJwV5JS9PckPKnrWFyD604ONJEEBqkC7x4Qn6wy0/5DFoAkAWDwr5wyH7e+PrAWv
	 MnKnjyxtb7LPcIXr9OefR97fBz/ZnRsHcpbOLgkTmZKs7gQkPeZvN3B4eU74Q4Oe9tO6T
	 TfnpY+hhFp9Yz0xh3FFx5QfGK6GuYtobcOLvFodp15d56GLA6Rnprf1h/YKxpgTD3+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242220;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=U11DOD9x1cNusT7QAmX0bThmlm5Nlcj6algrIF2IlmQ=;
	b=coJMug38aV94AVMFT82QobwAXM7IM2oAn07RABJCapMc4QgobVtGPgUqD5N+NmmLRXwe
	 xN8AvcCZIjyOZHf28QSQ9OCFBCk+5O0JCnmcIls0hCFVoOGkpMQSqzI6lbGA659pbt9DP
	 j/blHy0PT57GQFweweR9iOB29Qn5qtxsz+KBRL6XIyezhpxEjJ9je2jy9Z5MKqieHpdee
	 ouvs2f5mQICS8Ocqpthn/UzqQ3SLum510LiCtLuF3WEt0RqbTPRaM6Mk1LtXS6whHe8jr
	 UpPhQurqfhfj7s2n5+vz9owAP5tibiRCObJ1VmMBuJkC60sDfck8UGAylIQQMrnNQxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GL2sWGvP;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619E3606A85D
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:37:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 619E3606A85D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GL2sWGvP
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49d05d51553so8142525e9.2
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242219; x=1794847019; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U11DOD9x1cNusT7QAmX0bThmlm5Nlcj6algrIF2IlmQ=;
        b=GL2sWGvP5KOADZItlVVWu6JpHTutKbXU3SM3b3Frh6CccB/iCZQ6gcZkL23htQwXp2
         4507352zKlmOIdYaE69s5bv1M7Ibrafq3RaJ3U5eArcQKYSMOK0OeLnR3m0+k01lCHkA
         E/yWiFbLrCm/p9i+wzgpoVuoY2QFENzu59UEd/yU6ZHzdxqxDJfSZTaWwskFQ0gy+KIa
         vzZhZUVOuRD6SLXLBROv3EhSqc5HrvcnaVp25cWJT7iflvW7cbR1QDraXFeVO/o6y0RP
         bO3gjj21+3PvORsPnRwnllF9CPzGwAGXXV+rhaiBFN4xdaL4SrhajsXOdwh6vlNP7p+b
         uvIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242219; x=1794847019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=U11DOD9x1cNusT7QAmX0bThmlm5Nlcj6algrIF2IlmQ=;
        b=S882z/f5/Y9fxxzgYWDAe/mO0sJxji6q1IWNF4Msrf8qRYVTbfY8VJHP33XNEwR53a
         8cseS/CZ3Awg2QFWmCEbIGzZ6w8MC6QwBW8J2/w0MdV9jkKvOX4YwwIe9ztoyRwq72R7
         r+n93P0facCRmmSb5ocS6QG6yoq2xrW8DFjNKOrAS71Qo/vo/u8IsDzKXoTX20dazxL3
         CckjSG8cW9228FW51hzrcNntmOH1sZxC8yUvUcbPtYcst0of2b6SmeODzDOnTSXa/CWw
         mlBK5H7jmfRiCrumwKsN/rAefNvOY/ul28Kdt5R+BHAGGWI4R7LYtsHh62Fg4PuZkYy+
         qCrw==
X-Gm-Message-State: APuU4Z9mdHTta4R97hMnhlNfxj5QH9n1ah0Az5ISi3Pbc83Q9aYS/StL
	nkxg8A7N7D34BFcM5i4sKu2pPsPVeoNio3GzazRqnyg8eV5ySWnUSUXW
X-Gm-Gg: AYBFou2HHzGIzfelvM6Ko6/ED3ULXPbNWk9zdy132ZGZGAygvui8VvkXyz45WZuJujT
	A3vSGRx+wXcSat5xmtwAqWolpHqQ+TdYTCcKdMcDQw34kfWd1KwDOeQ/ycaMNtHN0DWvmVTl+L3
	jwDiu2k2P5vqaW/QzyZWl70SDrSVNFq95mgw0OQ2f9blJM4XiGFjFfjAOB8zkbx8+1HK6cLJit9
	2fEKhR5W9wnnYRxyCNgQ7eVyj/Ei7hE07xtMmNt3pE0Gbx30Qpgv3kkyAv6ZqI+G9tbXzNyBZND
	5yt4F28Y6Hia4/i4fgpk7HUAt0T1jBVOXXDsCcYSdRp1+wEHNB/LAhzPL8lU+Uvqgybx+yF/6iR
	lzrCIev5QhszyV8i44XF1B8CiH3twxmy8seX0VBIxUxxA+r4JAnTNxk3R2FpG0sFHakc1MseGWH
	COl10O8PDkwRKLZWzkcj1nwzIiCvExC7PC61aHor9SntMjEc6lmbxqGP5t6Wn8Bk2xzlRcST962
	tDIiiTOaR3p6t6vDOBJrU4+D5bkSaQbu+b1olhiXMJlyd509+HYJNvcsZoQhDiQDM3c3XNV5hQu
	/2fOnKhflqZh6Ra3uU5tSsnqDg==
X-Received: by 2002:a05:600c:83c8:b0:4a3:18ca:806 with SMTP id 5b1f17b1804b1-4b963c6bc6amr78431705e9.20.1794242218834;
        Mon, 09 Nov 2026 08:36:58 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:36:58 -0800 (PST)
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
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>
Subject: [RFC PATCH v7 23/29] sched/core: Execute enqueued balance callbacks after migrate_disable_switch
Date: Mon,  9 Nov 2026 17:36:09 +0100
Message-ID: <20261109163616.195264-24-yurand2000@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261109163616.195264-1-yurand2000@gmail.com>
References: <20261109163616.195264-1-yurand2000@gmail.com>
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

Execute balance callbacks after migrate_disable_switch.
  Balancing may be requested on the __schedule path, in migrate_disable_switch,
  when the running task is throttled and then pushed away from its runqueue.

Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
---
 kernel/sched/core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index aef019cef859..e4e50202896d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2470,6 +2470,9 @@ do_set_cpus_allowed(struct task_struct *p, struct affinity_context *ctx);

 static void migrate_disable_switch(struct rq *rq, struct task_struct *p)
 {
+	struct rq_flags rf;
+	struct balance_callback *head;
+
 	struct affinity_context ac = {
 		.new_mask  = cpumask_of(rq->cpu),
 		.flags     = SCA_MIGRATE_DISABLE,
@@ -2481,8 +2484,13 @@ static void migrate_disable_switch(struct rq *rq, struct task_struct *p)
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
2.56.0

