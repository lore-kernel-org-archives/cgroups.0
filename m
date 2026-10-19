Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7095748592C
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 06:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792392166; cv=none; b=kZlsrsws9iYO10oq/HeWZiJ5kU/ExwximfcfrUduuuUrWjHf6uZMD58ouI40bQk8uhqL0C5+cdf+cmaGXVASH4ayObas5wZNrQgTxqhljOzD9Q1LxotI7KSTYpV6MMTbjsIypERiGwnupLznCn5L9QPa7qCiACiOsMW1JwxXQnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792392166; c=relaxed/simple;
	bh=QIHyivvelQsG5goLcwTZfY2CtoiPNubYt+UKx+e9SPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BzavkQrORiJeHvFJ5c2vKIciY6ADBvTc9m69mQl5vcsp2eb0kZ2lWE1crd+v/EtGGAFMeZC6KyMbJz5mxVonMXXvukr8A9t1L36HK5nrdfm3hmHDAlkP6W2VjVSbU3WOuflIZRIhJoHoEgsZukqJCg8i0ttauYCdGyQf3ecOu5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=STyHjCmU; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="STyHjCmU"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8a06b436dffso176848b3a.3
        for <cgroups@vger.kernel.org>; Sun, 18 Oct 2026 23:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792392165; x=1792996965; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vBI495sTrHPugfVjBEVGuxFJ+6JlCnqJ4Bwn59THMd4=;
        b=STyHjCmUI8Sq80l2tcrDAnicEQQ7oAaNMqvcYqa7Q0sA2kQSmbJ9TCkBYr8H3igf9V
         spmeHe1l7oyw9UAtm3f2oCn8hUxArOGBpgUetWu68UVACxeCFOScfkcgWt3ral5QrW9L
         p65Gn6LM4HHi3S07bukO7LavM+a/5Ni7SXTy1XUPG7zMpuY311WFqATXc7fHTguDJuI5
         oetQxFhJVVI07AUTbv1WjuCOW9avx+KtvmaFY4kotQa4qzxC2U20X/WtsYvU/Px6P65N
         TyJQk6n83q8xiGl5f2jFldpxTWwcaQZUA4MO5fM6dA9fULgJI6jkTD7Kr7H4h0K+jq3O
         DjAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792392165; x=1792996965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vBI495sTrHPugfVjBEVGuxFJ+6JlCnqJ4Bwn59THMd4=;
        b=vdZC86KCRhmYJlZiqFoLbipdp4Asp0UMEwO1gWOncKfaxFmO9Hnnu2GQ8iRIZLiGZo
         mjZ8JVL7NAJODboaziwh61jMJxTD1ky8IrcOlHFoUjmvZeDDZAAPF+MIQZOjNtGFwFja
         Suiyua9y7N2K1fS0Ksq+IPcL/YDv9/WOfwXNIR0P2jTURmZ46CXTUZLS7vyjitvaks++
         9iaTX4uLdTUPvrl/I85ez+S0Cp6cza//9LCx9ytGvE6gvbrHzMKI2NmEsIES80cysQVr
         zQejru1kI+3MSdABq4ZeWkmQjQPlJvn5oZ11qdL5eSvqxhUqN76lADJwC2XhWfbWn8G/
         FMsA==
X-Forwarded-Encrypted: i=1; AKwUvBxBuBPM3fBMpkE/YWdEKbbx9lAq2b6M8BgIPVYkXEtGzk8KR0Tdmqx4K2A1yL4lMXVEmJcmudys@vger.kernel.org
X-Gm-Message-State: AFq9FYIRpsSFlLs+ye0b4Vqzqt6BmHHZVkjY+jimfmQjNl2Yx/FgqZDX
	YZujoHmorbxTsnojFiasJkMEcor8coxb9hoGlR9o2H8N1d583KRFcNse
X-Gm-Gg: AYBFou3hrXa5/0TR8/WyyNLVt4DzwNWf5hGetGvJ1MsZrY9Ohcuk6WQ99Ya07gbrj9E
	zGxYTcRj3NMp+HS7HHd3So9Ersz0o8bY/Vd94nGVbOqmCZ7IsxMVuvnSR9r4w9jgAkoXrcseFhA
	VhhBVu5OqTl26yA5wuEbN1/lYbRU1lRiN9rOznzuvRsCqXZh/fJtqKC+DBmcn8uIB26QcjNspdG
	Gj/+Pxe+1F2i/VwOHJ47aYfqvD2z8ku2qHQB6kCmiSCizG5sUpAJb5LK0X9jsGn2l/quov4rHCK
	9Bh6FtBeIpGuFlvZxMo5VaFbvpMp74FzaCTbPYGxAZqoSCLrBWSPcGP7gtI36l+cRtve6I5AUeE
	XK0o6fkKLEKyx6eknTeDSky1LI+CZWFZiixFTVInziAX5930D0o0GsayLM3CyAVr7lykXADHWPN
	r5rUwxXWKWpTy5XWnalaiaLRFewiiAtOYbjIN7UEv3aMRZbjPdL+FJaHYCMKnqNA3tMOl3OXVy7
	bKUF5fmsmspxVjrkNNHx1jnEqaW1ldtCt22mxpF7Oz6N/W5GAq3tNiU7U9TvzGkGrPucVw=
X-Received: by 2002:a05:6a21:482:b0:3e1:bce3:c3cb with SMTP id adf61e73a8af0-3e225fd83dcmr5763850637.44.1792392164732;
        Sun, 18 Oct 2026 23:42:44 -0700 (PDT)
Received: from localhost.localdomain ([240e:46d:2100:3fed:6938:3f14:63eb:c479])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd654a3a592sm3688960a12.30.2026.10.18.23.42.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 18 Oct 2026 23:42:44 -0700 (PDT)
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
Subject: [RFC PATCH v3 bpf-next 2/5] sched: use static_branch_likely() for the NUMA balancing tick check
Date: Mon, 19 Oct 2026 14:41:54 +0800
Message-ID: <20261019064157.29885-3-laoar.shao@gmail.com>
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

task_tick_fair() checks sched_numa_balancing on every tick. The
static_branch_unlikely() annotation reserves the nop for the disabled case,
so the default configuration (NUMA_BALANCING_DEFAULT_ENABLED=y) pays a
taken jump per tick. Flip the polarity to static_branch_likely() so that
the fast path matches the default.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 973647ad6c2d..71dc47d6114d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -15351,7 +15351,7 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 	if (queued)
 		return;
 
-	if (static_branch_unlikely(&sched_numa_balancing))
+	if (static_branch_likely(&sched_numa_balancing))
 		task_tick_numa(rq, curr);
 
 	task_tick_cache(rq, curr);
-- 
2.52.0

