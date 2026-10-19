Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0344848BF
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 06:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792392156; cv=none; b=NCjJ5aYaHF3OWGrM7QF1gDSJmpF0Qroh7lgH6WnGBUlrfos436h8Cikx5U/CW48f056E48Ir5Af1pXSHnIZ1RFfvux0fJno1imBf0s5Y3WRyFEGwDjjkEOdiL67SJruu7hR5VnENlGWCvgUuOhfBydv8dTFr6WUBYx2aFuccsF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792392156; c=relaxed/simple;
	bh=sI0uRdJyIwS/576GKroHmj+P9dYFOWObm8nsBCmV8W4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ts5pSb0HldlgviQNTyIy9uKSg8B6XZAcm9O/r9P6Jp725foX5ZWitOt8K9KTE82IYCNhtha8GUvgcu7hoi5CaiGu4TtUlRscbPiuZ7hUg6RWCXBmayFuoGHpewuu7GCuB0lNrHDw+QFI1fMGE0DtciDIHfc2xJ0H4V+0yTyrYi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mym2WOqc; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mym2WOqc"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ac91ac8924so1036809a91.1
        for <cgroups@vger.kernel.org>; Sun, 18 Oct 2026 23:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792392155; x=1792996955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/fCpTvdWPIdjGXF0xCoYGynFxh0LgUrYpyRnN0Oo9VE=;
        b=Mym2WOqc9oVz5JdiDodpZbxyQrCS1b415cTpdTpqMAy/wGVn5Yt+0GCw5lXqdrKEPK
         3tkazyRF19Y+4sfvHKglEGcGGmAqHg38t9SiVo95NQTVaT/Z9ddMOlamcRVZB7Ep13X3
         S46CdaSerNZnpWJtI8jO2FMS1VpCM/ZMs+siWYFKBIAq8/rICFwFpEZ2fWlJKwYJ8VHv
         jv9KcDyQ67m3EJ1MbNCw0EOHxXJmT+0VarTbaGWo0Dwg3FMJ17o7PqRChM/T1LCY7DM0
         6bfJ4x2KD4kSBfDiBsrvLXDzfYLzMXKiSF/AuD7udoRD2OuY/D/e6lZeivcFJsGrUThK
         b3Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792392155; x=1792996955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/fCpTvdWPIdjGXF0xCoYGynFxh0LgUrYpyRnN0Oo9VE=;
        b=ZyTe4fvHcmx3YyJmh2k4k3rfIPgf60MY+asMaV+u4Z/2sCfmHsFhZyH8LuOu9JnGDW
         8eyYGXHvl0H2QmOM7f0ECnv9Unz0ESOCCj07KsyHizio8K+aEdugOFAGhgRza3FXbKMQ
         8QAL9sJGmKB+kQNSA1gH0rchCUhktu1mROAf1i12apPTD1s6mGoleoYvTzg0n0Ox6PwM
         +dafuin42UcqNhiiXzAp5iAUKJO7H2rZpy6lw4g2as2zm5yvU6Jqy1MpJ4EnXWxjVGEj
         LeyADb9/+J6jt/HliL8mVOLh/Y+Yl4PfceKiFfVXkYyQh8B1+pS2jFtLSHUMa9TD2dJx
         VtKw==
X-Forwarded-Encrypted: i=1; AKwUvByS493Z3FYTc5DnHVYYxpeK/KbTCXZFxe+PV79FgZTcdO50+EDbGqvswYr60i2TR0scqtcM1JGu@vger.kernel.org
X-Gm-Message-State: AFq9FYLvpoWQAzHPSQqbbSylgAofxyetxrQSIG5WtaIOdeeXcyCatzmO
	GVOmJrw6ETEjN/Dhi0uww1fUAiyPfwQ162yha9FcXUQI0R3EbHVHuGiB
X-Gm-Gg: AYBFou2HUo2N4HdiIcHCVWzCxkHx/zqOzoSK2J1jOi5lwys7yyk/u+vsCXKBXSD1kx4
	s3pjOpev3o2wnydGru8U3jr9Fo2zw4QleM5g4+wFKz6ex2movyKgkduGv1XvgCCq6fzCvSajcog
	tCqp+oFMW/3cWjymKZqiDQDNFhX8XnYQzADBSZ9KzZOfEYFe4DEU79rDM0ZpM9TayxdP/yctkvx
	wOir3WJoy4glUDj/DaUR0vcy3XzzG7T/6wZizHeCmCHyRldUvB+uMB0Hc3BmPTM8We3hqnZy62H
	FeXLaIQHeqxXrlPNHKRtISiuorkZk+vwgpSj0F2t/G8MLlI21OouicfOR7fuXSOG8YFRwv+nqE1
	QX6pD8FPXY09loiOGmzPksmE9I1EFUKj5ab8J1vHMOwYDyYILSizYaq7JkMPOqxirVNdlJ5q2eS
	7hFRzSxYPRbVOC5/KeRuYVFfYzuFIScXu0+O74MxdDnoN4VkpeUy73UW8zbUrjVXQ7T004/HJ2V
	go7CUoCCi75aqQOpLmLKqnXEXW2p0x/LHBfUj1aJcFs+1oF4EPw6pB48dEbdquEw1Flkw==
X-Received: by 2002:a17:90b:4c92:b0:3ab:b764:826c with SMTP id 98e67ed59e1d1-3acef134becmr6190292a91.12.1792392154938;
        Sun, 18 Oct 2026 23:42:34 -0700 (PDT)
Received: from localhost.localdomain ([240e:46d:2100:3fed:6938:3f14:63eb:c479])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd654a3a592sm3688960a12.30.2026.10.18.23.42.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 18 Oct 2026 23:42:34 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	yu.c.chen@intel.com,
	zhao1.liu@intel.com,
	tim.c.chen@linux.intel.com,
	lizhe.67@bytedance.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v3 bpf-next 1/5] sched: fix stale get_pref_llc() stub for !CONFIG_SCHED_CACHE
Date: Mon, 19 Oct 2026 14:41:53 +0800
Message-ID: <20261019064157.29885-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261019064157.29885-1-laoar.shao@gmail.com>
References: <20261019064157.29885-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit b636fef85bda ("sched/cache: Introduce task_struct->sched_cache_grp
to fix UAF") switched get_pref_llc() from taking a struct mm_struct * to
taking the task's struct sched_cache_group *, but only updated the
CONFIG_SCHED_CACHE definition and its caller: the stub in the
!CONFIG_SCHED_CACHE branch kept the old mm_struct parameter.

Fixes: b636fef85bda ("sched/cache: Introduce task_struct->sched_cache_grp to fix UAF")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Chen Yu <yu.c.chen@intel.com>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 57360f5cdde4..973647ad6c2d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2194,7 +2194,7 @@ void init_sched_mm(struct task_struct *p) { }
 static void task_tick_cache(struct rq *rq, struct task_struct *p) { }
 
 static inline int get_pref_llc(struct task_struct *p,
-			       struct mm_struct *mm)
+			       struct sched_cache_group *grp)
 {
 	return -1;
 }
-- 
2.52.0

