Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242219;
	b=DaELewALvQzv/qBRYOmTfeGt34waAyo5dkRtRIzAhNl6R7dS1KM4a0z8UrVxD1RVllaQ
	 FRdVDlS042JOWK9snpyI7epBMs+O8RLkdSyTNnILt0mmGPZwyxcYXraRhlo7maa+Hdj7F
	 P60nRmVPAwjtIEZDbNXHwbV1OwtX7egI2SCeBCcisOq0j2wN9TiMeHIUEvTRzsl53et5y
	 YsdkcDNV8puYMtzezb3KsbPQWvRXmPrylpphhy6AQQoLfqpIjc3QnIskxY388RD09MAkh
	 PFR2gkqd6rtWDoSA95zALyPGknepjlfRcZIfHkQPEOaeEhve1NkiurntxEqa4N9u+ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242219;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=69bP/4rCl9jdLnFN99AScdBIIFJeIH0XLbeU93aGJjA=;
	b=2OFxaoALomYD9wgpjOpBEGfC0j6SQ8hrkz1wj0L3flBGqNhk87wJqXxtMBgps4cBrgIr
	 ZrK0csyEFh9vEgjdjyWuxvtm4mOaY6aQAJvJ5P8I+VYjwp+KT+1UCDBtbJ0a+ocliMLxp
	 Ltj+VSnQXMbLKoEilfnGhXeUbmVuZRBu4Tyz34kaW2z7Cl+xbxmYjLPTQ/YOzhsfH4tDA
	 06JsEwtsDwYvWlsF9EmMe4umtdkHB+65K+PF3klTLQY+JIRGF6zmQ2k+fPxD4Gh2rL0m1
	 qzWGnc3r5jbuchEJBQpOEpLCTaq0h/tjJ//SSkqTLANIf6axTAdkcubQnipu0oPx7KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ep1W7ePw;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC896073679
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:36:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADC896073679
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ep1W7ePw
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a5036bbac7so7537905e9.3
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242217; x=1794847017; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=69bP/4rCl9jdLnFN99AScdBIIFJeIH0XLbeU93aGJjA=;
        b=Ep1W7ePwIQXen75mrt6J6STtIpmrwco+Tx1Vgp+NrUCzJiwL0grCFvIss/Ac8Rixew
         ucIciFozXgIdYhqQ63XUIun1S86yOLc1uG2tjPEwVc6vUPZwfDqWqbAHG1qlXTdolOB0
         8Zw5xdhjNOm/ACvOkybSijhu9gBJE+MHeSlEsTC+hjctTsP/1zzO4uwSkbM9OpRYK4RR
         S/lTDhmlpi6tlR1TfM9UGhrk6MFEEura65jUH5nuGbIhEtDQZo5d3uPcWVkdICUV+kQJ
         y2ykxzpqef+VC1hltG+uBwzmBRfA/TAOVT0zH+EGZZ1c2NtS/SEtVG3b+V23dwRRYtfM
         LTvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242217; x=1794847017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=69bP/4rCl9jdLnFN99AScdBIIFJeIH0XLbeU93aGJjA=;
        b=HlJK7HcE3k5THY/mLpqTKMfuBlh8zutvXCvmMKG5qBLM6iHv6S+Bc6T6+WBmLQZeht
         D8vhKPCem291LfLbS2etGl/qt8Kn3cDHKcszLXFtLuY4I/N3646Sh6nZ5A5GJIOdrhkV
         ITkn5kVYrQtTUmgaXxOo0tCM/t35y+vuTQJI0x8t+YLlJgbHJdVJ9zKfnh5QFr+Z297B
         9UBOUjUqwN5uhrXDty3omtw44COtByEyjIqE8xMtMf05u68BjgtmErrcRcwVEo0mNIxA
         l+m6YlMqXS9FUu15PMtwyxQjOvN0TRnEMftKLzaHScbwtWkHYfWwesVJs+CqSSh9Rw9f
         R00g==
X-Gm-Message-State: APuU4Z9cJPzK0YI9th7V7yWbcpZ7EcmBDKxLW5/0FFnQGm3WeXfmxCZ5
	04JEYjkamM7ljX4jlFcnxaNYv2KdWhsv8lrLfiIIhcLL3kMJg+tXNU/M
X-Gm-Gg: AYBFou2gTQKOa1uhe9t1tOL8XB/0cdeHqC2WN48vSk3cifjb826SdIDl1d4cQx995sB
	nE8w3Ip9B+VhCwgp1nB/lCjcrTaCn16FOh//3/+Un/VXAC5ej3Pj0Aex3t7okQX5ZaqLj4cT2TG
	j71rd08Pmw5rMVtZlxOLg1HL4DdXzzz/uY15qVRoCyHcTmRguWpxQtUr/jaQWdtxV5ko9AfLYfM
	d5Ilhal4GhH278v4NpDbZPUwjHe0M1yxZnysCGdyPS5bcikcLCD5Q5cqRHsjwH4SjU8dywSp/DM
	pKA1gbVxZAT3iOmoxGmDV9tZb22w9iSbJbXNzPRNKW7tYDcbZBPVE/2FwToO0iQGSIyXGtH6R9r
	i942YozrJTmyeb5ZiStoBr5/iR/GbW5id8C2YiTcFeaN44ZIk8xnkRba5JOIxb032kphr8Bdo3y
	HLMJpWx5JWbcSfsWV2qAqRPAMIBNYumViNX3bR8TWPko16+jwmIGBfIpM+EFRmMlh/EDPKszd6g
	OVDzFXlhyO2kI6jITzUdSxxqOXhBA75iDRGEiIrFu52Ed43cxB2+Ahfci9iem7X0jCKUBNWltPX
	CUtLSLWEDUl01Uz4MErbmsegCQ==
X-Received: by 2002:a05:600c:4f4c:b0:4a1:ac66:6059 with SMTP id 5b1f17b1804b1-4b963c7d397mr106385035e9.26.1794242212383;
        Mon, 09 Nov 2026 08:36:52 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:36:51 -0800 (PST)
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
Subject: [RFC PATCH v7 18/29] sched/rt: Remove old RT_GROUP_SCHED data structures
Date: Mon,  9 Nov 2026 17:36:04 +0100
Message-ID: <20261109163616.195264-19-yurand2000@gmail.com>
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

From: luca abeni <luca.abeni@santannapisa.it>

Completely remove the old RT_GROUP_SCHED's functions and data structures:

- Remove the fields back and my_q from sched_rt_entity.
- Remove the rt_bandwidth data structure.
- Remove the field rt_bandwidth from task_group.
- Remove the rt_bandwidth_enabled function.
- Remove the fields rt_queued, rt_throttled, rt_time, rt_runtime,
  rt_runtime_lock and rt_nr_boosted from rt_rq.

All of the removed fields and data are similarly represented in previously
added fields in rq, rt_rq, dl_bandwidth and in the dl server themselves.

Co-developed-by: Yuri Andriaccio <yurand2000@gmail.com>
Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
Signed-off-by: luca abeni <luca.abeni@santannapisa.it>
---
 include/linux/sched.h |  3 ---
 kernel/sched/sched.h  | 33 ---------------------------------
 2 files changed, 36 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4816e408b332..112e6a450a16 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -627,12 +627,9 @@ struct sched_rt_entity {
 	unsigned short			on_rq;
 	unsigned short			on_list;

-	struct sched_rt_entity		*back;
 #ifdef CONFIG_RT_GROUP_SCHED
 	/* rq on which this entity is (to be) queued: */
 	struct rt_rq			*rt_rq;
-	/* rq "owned" by this entity/group: */
-	struct rt_rq			*my_q;
 #endif
 } __randomize_layout;

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 10eb56aba3d4..1242d297532f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -313,15 +313,6 @@ struct rt_prio_array {
 	struct list_head queue[MAX_RT_PRIO];
 };

-struct rt_bandwidth {
-	/* nests inside the rq lock: */
-	raw_spinlock_t		rt_runtime_lock;
-	ktime_t			rt_period;
-	u64			rt_runtime;
-	struct hrtimer		rt_period_timer;
-	unsigned int		rt_period_active;
-};
-
 struct dl_bandwidth {
 	raw_spinlock_t		dl_runtime_lock;
 	u64			dl_runtime;
@@ -343,12 +334,6 @@ static inline int dl_bandwidth_enabled(void)
  *  - cache the fraction of bandwidth that is currently allocated in
  *    each root domain;
  *
- * This is all done in the data structure below. It is similar to the
- * one used for RT-throttling (rt_bandwidth), with the main difference
- * that, since here we are only interested in admission control, we
- * do not decrease any runtime while the group "executes", neither we
- * need a timer to replenish it.
- *
  * With respect to SMP, bandwidth is given on a per root domain basis,
  * meaning that:
  *  - bw (< 100%) is the deadline bandwidth of each CPU;
@@ -515,11 +500,9 @@ struct task_group {
 	 * different deadline server, and a runqueue per CPU. All the dl-servers
 	 * share the same dl_bandwidth object.
 	 */
-	struct sched_rt_entity	**rt_se;
 	struct sched_dl_entity	**dl_se;
 	struct rt_rq		**rt_rq;

-	struct rt_bandwidth	rt_bandwidth;
 	struct dl_bandwidth	dl_bandwidth;
 #endif

@@ -887,11 +870,6 @@ struct scx_rq {
 };
 #endif /* CONFIG_SCHED_CLASS_EXT */

-static inline int rt_bandwidth_enabled(void)
-{
-	return 0;
-}
-
 /* RT IPI pull logic requires IRQ_WORK */
 #if defined(CONFIG_IRQ_WORK) && defined(CONFIG_SMP)
 # define HAVE_RT_PUSH_IPI
@@ -909,17 +887,6 @@ struct rt_rq {
 	bool			overloaded;
 	struct plist_head	pushable_tasks;

-	int			rt_queued;
-
-#ifdef CONFIG_RT_GROUP_SCHED
-	int			rt_throttled;
-	u64			rt_time; /* consumed RT time, goes up in update_curr_rt */
-	u64			rt_runtime; /* allotted RT time, "slice" from rt_bandwidth, RT sharing/balancing */
-	/* Nests inside the rq lock: */
-	raw_spinlock_t		rt_runtime_lock;
-
-	unsigned int		rt_nr_boosted;
-#endif
 #ifdef CONFIG_CGROUP_SCHED
 	struct task_group	*tg; /* this tg has "this" rt_rq on given CPU for runnable entities */
 #endif
--
2.56.0

