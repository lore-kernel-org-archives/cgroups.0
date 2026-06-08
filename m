Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D9237EFFB
	for <cgroups@vger.kernel.org>; Mon,  8 Jun 2026 12:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780920963; cv=none; b=cgqfFY7AAD8EpeZPVFfN1dsl5ctiGaiVLY7G2KhUMd+79pf05GIOX+icJ7joNDmH6VR2CkGCyUktpEwCr3s2rFVNy/d/Zb39fJJEUBOKOw58vlnmjJNZeqGLvgvY0/m+bYbaS7FQa9Ce45IHZ0vdhMcuDzigMZD8bXhIXpyKpb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780920963; c=relaxed/simple;
	bh=TCzeSZTBx8lzpAQELS8A6vLFLj2ynJCbG3lDm1QkhmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpgfOGn3zIpTpE42Gr82dAwgBZinN+tQLv4qWCAYVeamqetVBOY1xKzbScOsX/42ySPaegVzBnLXppVILXQSDxA9SDkOz+8GXSYe7DoYhiD6Jn6K1fOeUUf7Y1K1nHQBirMiDiUajM/DETtTQjCjode/pDZYiRkgDBhHNIfDAdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sZ15FC4X; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sZ15FC4X"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-45ef1629ff4so2797631f8f.0
        for <cgroups@vger.kernel.org>; Mon, 08 Jun 2026 05:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780920960; x=1781525760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LUGi6GN5j9tpmC+RZ4hz/nx0wpr5cX/yRLcD8GqgOGU=;
        b=sZ15FC4Xo+dMBc8DAr8Nz0n5r8mJAwIH4eMX95UgFmlyZcTzctRRqlt/M/x8XgNkSL
         5jPuq4gNp8IBdoJB6kA9EpUT79G4LkLSkkeZfEP9I9RT7n1INIyLE5+lHJdfJfCy2BdJ
         5DaHBwG7aT7iOGVfGrNzKp5fpPGwSewmJtTB/asC2Pemwr18YhqpfXAk4YeeWb+G5YZC
         p+acIRPu1gwcAPAn13Ol4it4IWMcFw6dmzo5XmEzj6GbsJwnIx49o+I9U+Kb8qJfCHHw
         s8AmRHg3GLiAhNv1U1I4OOgyQBVNmUuUWtQQz1f92U0seTdKEB+144geQkw7n9RUjjVF
         bubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780920960; x=1781525760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LUGi6GN5j9tpmC+RZ4hz/nx0wpr5cX/yRLcD8GqgOGU=;
        b=ieaffi+hIzK2kGIQANJgB7z803EdGpyJAfSRjCA2IYpxFM1Ty0pdemuioFQ0WbCYPe
         +i/e0meMYora0mfbfTOolnMd/6BC5n2/s/HeSLhDx13s66qiwDI+mmtytfEvdwq6nKBV
         +uDKZXhMZarHAtQSizEiBLo9iZFMi9h8tBp17k51QSoo0TpoybFDLg9e6Nj4Egne6iX5
         dJ5+5r0mfGj8wyEuCizwV128FhFSRb0/UVXI6H4RujN9WFmlfCFvWXt74TWWLg63BO0x
         QIt9oOp5IvZvb81Ue1QBfCm/0+Ud8Fze+SJnW5hssO8eYXrF7SffMCl7BYzRftxTPsOE
         z1TA==
X-Gm-Message-State: AOJu0YzEZ+viMv5cU8F4hZKfZkTrP392SmHot40UdPmUB5E2b9FBpTpF
	bBR4QJSDlFlooNLyYowzwMIPgR3O5yXSEXrIgp0GmGrEpTi9Kk9a5mjd
X-Gm-Gg: Acq92OEAPZUUHDGfS8SlkoFSgv6vjPoZt6LOi5Cp2jy5cPSIPTVFkU7iBsKGDUK68SX
	Kkr4lbekUkD9CdQsqvjgNEiIxqiXz3BYFHa+GHZLs43JhYNOSHAo/MgfHAkcXFXbL3rE0cvdnk2
	Dd4yfbXW/3lOPwN8bw7TpRnpYlHpyWvJrVMqBnZPXA3NoTNr0BBfwb9RlQRI9u4KcWrs1CzBZqK
	EpAb6Z+MJPNWJmFs0Huxa76zbY2wAojoPAMmNDhr/aLHn+Hr6aI8+PpImd1tKKSZAAl2WWgRhy6
	0j8CQNsBdn3WssQ8NAzdfkvyktu1Jhevd2YoAsAZq+PzXghGby7RXqtY19eYVpUJabtPlxQFpEQ
	WiiPWnDYwVr9jRrVFYF8HfwbTNBCDaKSPRRJq0abbqX1esbBYa2uqPBkjuqa/bFHmi+b4DQ7O49
	0us7I4ZfDvrD6TsIzlchR6RURhn9lozSE=
X-Received: by 2002:a05:6000:4029:b0:45e:f798:5531 with SMTP id ffacd0b85a97d-460306095b2mr26881415f8f.23.1780920960169;
        Mon, 08 Jun 2026 05:16:00 -0700 (PDT)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2ec711sm50644906f8f.12.2026.06.08.05.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 05:15:59 -0700 (PDT)
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
Subject: [RFC PATCH v6 13/25] sched/deadline: Account rt-cgroups bandwidth in deadline tasks schedulability tests.
Date: Mon,  8 Jun 2026 14:15:32 +0200
Message-ID: <20260608121546.69910-14-yurand2000@gmail.com>
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

From: luca abeni <luca.abeni@santannapisa.it>

Account the rt-cgroups hierarchy's reserved bandwidth in the
schedulability test of deadline entities. This mechanism allows to
completely reserve portion of the rt-bandwidth to rt-cgroups even if
they do not use all of it.

Account for the rt-cgroups' reserved bandwidth also when changing the
total dedicated bandwidth for real time tasks.

Co-developed-by: Alessio Balsini <a.balsini@sssup.it>
Signed-off-by: Alessio Balsini <a.balsini@sssup.it>
Co-developed-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Co-developed-by: Yuri Andriaccio <yurand2000@gmail.com>
Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
Signed-off-by: luca abeni <luca.abeni@santannapisa.it>
---
 kernel/sched/deadline.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index afadc3521bc0..166d23f45cab 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -205,11 +205,22 @@ void __dl_add(struct dl_bw *dl_b, u64 tsk_bw, int cpus)
 	__dl_update(dl_b, -((s32)tsk_bw / cpus));
 }

+static inline u64 get_dl_groups_bw(void)
+{
+#ifdef CONFIG_RT_GROUP_SCHED
+	return to_ratio(root_task_group.dl_bandwidth.dl_period,
+			root_task_group.dl_bandwidth.dl_runtime);
+#else
+	return 0;
+#endif
+}
+
 static inline bool
 __dl_overflow(struct dl_bw *dl_b, unsigned long cap, u64 old_bw, u64 new_bw)
 {
 	return dl_b->bw != -1 &&
-	       cap_scale(dl_b->bw, cap) < dl_b->total_bw - old_bw + new_bw;
+	       cap_scale(dl_b->bw, cap) < dl_b->total_bw - old_bw + new_bw
+					+ cap_scale(get_dl_groups_bw(), cap);
 }

 static inline
@@ -3490,8 +3501,9 @@ int sched_dl_global_validate(void)
 	u64 period = global_rt_period();
 	u64 new_bw = to_ratio(period, runtime);
 	u64 cookie = ++dl_cookie;
+	u64 dl_groups_root = get_dl_groups_bw();
 	struct dl_bw *dl_b;
-	int cpu, cpus, ret = 0;
+	int cpu, cap, cpus, ret = 0;
 	unsigned long flags;

 	/*
@@ -3506,10 +3518,12 @@ int sched_dl_global_validate(void)
 			goto next;

 		dl_b = dl_bw_of(cpu);
+		cap = dl_bw_capacity(cpu);
 		cpus = dl_bw_cpus(cpu);

 		raw_spin_lock_irqsave(&dl_b->lock, flags);
-		if (new_bw * cpus < dl_b->total_bw)
+		if (new_bw * cpus < dl_b->total_bw +
+				    cap_scale(dl_groups_root, cap))
 			ret = -EBUSY;
 		raw_spin_unlock_irqrestore(&dl_b->lock, flags);

--
2.54.0

