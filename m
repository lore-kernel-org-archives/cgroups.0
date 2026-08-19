Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E6139A7E0
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 13:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787145673; cv=none; b=o87Y0M9SN1q8kk0QsCO9BD7DChf5EJxJi5yaUjuh4YBaFXeszH0Mfmpgr3Jm7L1XT40Hoyo3tXJYHsokl6eFigIWwVZ9wlKfPY9w5G0UsRF60g3GP1qVESTutGxFpWMauOhszqaR9dOSBEukYOF9IeAeOema3c+vJ6hnBuFscww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787145673; c=relaxed/simple;
	bh=Jim1wAXD4iHFPChMBC10PwuxmAUKP76/FI9HT614/wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y930IWNED+JtHHexWO2fvPA+CoTCf9DSTRt7i5HLsX8z2GVszd80m/+dj+zdrgI/Rijapk0+XvUKHPaYPd+4GzFp6FxDjhrHeQtRuWkPlOXqGDihNzMREpn3iPD8+/oFZfsMsOuYWsJpmEj8d27iHZYscBC8sOe1skIGG8kBjp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=metarealtyinc.ca; spf=pass smtp.mailfrom=metarealtyinc.ca; dkim=pass (2048-bit key) header.d=metarealtyinc-ca.20251104.gappssmtp.com header.i=@metarealtyinc-ca.20251104.gappssmtp.com header.b=e99h6wuq; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=metarealtyinc.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=metarealtyinc.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=metarealtyinc-ca.20251104.gappssmtp.com header.i=@metarealtyinc-ca.20251104.gappssmtp.com header.b="e99h6wuq"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-52d7ef16f91so4935141cf.3
        for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 06:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metarealtyinc-ca.20251104.gappssmtp.com; s=20251104; t=1787145668; x=1787750468; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rV8o38P8L7ym1wIEKuZA4cI3zO+vMhOv6I+Do+Xml2k=;
        b=e99h6wuq4viGZ6fgsyggXlRjuRcZJU6aa15/MVo4YUnMKnptyE64d0zzFmNxERw8P1
         hqZEWiMKnfHMDUXbztuw8OI/o3zDWXIgCTTULWfXLwqrrIKnd8biDuor2KOS/F8R4cGm
         CmYXSOqohsQi4fwYvlJE7oxLeZCq20riM4GAdsp2b0q3Vg0hNMlitteobk9Q0ddn4xf+
         eNGYCW/RbGcubjTPMiErgRzkR/p3Zt0A9VrOcQKS2uY+h04cBFWjPoyGUz0ScnpP6f1r
         RyRmQ4JcHFxu2ufFceH7iMyEbigWHIDRU15Pcgidhe9uqyVaIvKn/yFwKDxAK9IGMeYD
         ENjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787145668; x=1787750468;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rV8o38P8L7ym1wIEKuZA4cI3zO+vMhOv6I+Do+Xml2k=;
        b=sjGZ0SHFtPxIW2RhsVsXGRQkJE6UAlIiMNHoO6y+3giaTY07X1mxY9rzxUb6QFPiT6
         gAaVO0bapzqitPCIirAiuoJrKEgJ6usGh6MMfAaLlyUZz6dVDLlUOTFaUHwkTjJ8vwmK
         qCuNneFPjHvR9jGjBRxvtmdYa1Z9FVTlk57nItK+noMN9zbyIKAnj7yh1c10mnXeIaw0
         J9LP5ZyiSUNatafKP0sdxU5n9T2O7ycHAJfnjK1SOt5ENKpSvLTba7r0mOQhssePFSLR
         QLselO3rbhGdDRGjbBq7NjapdZZY4/RBtfjVt7dMMdnXs8qZG9ZKv3eqt37TKE9fHFbI
         rW9g==
X-Forwarded-Encrypted: i=1; AHgh+RpSa0b7e2Bw4DnUmZ5NPzxspw/oy97SY+OLVOOFBCepP0XEVcNAzv8NGwUc5PvS+lDrQtzkeM//@vger.kernel.org
X-Gm-Message-State: AFuF++npj/Ohllocv1grnE7Fby8JqS9uA8cWvKP5si+l5c3vWCe8ipy4
	uSIBgvB32gyHyLbNkqFeKPAkeyUv62D40o/4UuZNZWRlqswmkgFIiSnALwUJVEUvQwk=
X-Gm-Gg: AR+sD13JJ5Comnl0UT4wlcvC+m+ABDEgQuCMk0zzmi8btbtRHP0Pa/jsmnReY6VK0+Y
	7VsvqeQE0VhA8Shrn1MQ3V80QnakMYRQHLBlhc3ceSBD3E/BANCqtMMlhAbI6PVI6G0gW1FcWYQ
	qjDoJUaPVliaXyd1n+UFZBpK2Y/VK1zjZ1DW+bf4f1Vk6+Nnxvb9SjyXyRWLCVYmcqbXKDDOT+Y
	b1Wbi2PSMNEvixOK1mxcnX8B0Z/b1cIXvCOh/GVnk30o+/XJ3TCltj9EFU5yGbHFCchVstC9E5y
	A9/Klxd1wpLU4tBwrUnAybgOWQ89kibaAjAfjpgj55VCURsRmk9KWDPPAFrLPdT1L1g9oQRDFfl
	KupsX9fOCve0ZArOaVVIfhhplTyVHPBrl4XHFeSLOMsC0ZiaCyc873Zdb2yAWjB3MtDm37ADj9Z
	WoQA4QYoTS/oXPhqshi59DFAc99CVOxnlq9QMnB/gBW7i2R5A6hPfBF0Q23O7aCI42siDa2NaPg
	w1KLRtbuycL7dxpv5hCx96UCpEmMcfVvsqBu3NHPmJ9St6Wrfio6vEtjKahNYSZHFvVl2yl3gGj
	YkrEj0MxizuCSQUxypw7thmQC96SbZahYugzmUDWZvs=
X-Received: by 2002:a05:6214:d4d:b0:8e7:d752:ab34 with SMTP id 6a1803df08f44-90c5e6fdb7dmr43203476d6.12.1787145668202;
        Wed, 19 Aug 2026 06:21:08 -0700 (PDT)
Received: from jake-laptop ([2607:fea8:e5:500::95b9])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c5eec1f31sm14392726d6.13.2026.08.19.06.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 06:21:07 -0700 (PDT)
From: Jake Steinman <j@metarealtyinc.ca>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>
Cc: Jake Steinman <j@metarealtyinc.ca>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH] sched/fair: floor tg_cpus() at 1
Date: Wed, 19 Aug 2026 09:20:59 -0400
Message-ID: <20260819132104.2148918-1-j@metarealtyinc.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260818231333.1441757-1-j@metarealtyinc.ca>
References: <20260818231333.1441757-1-j@metarealtyinc.ca>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

tg_cpus() returns cpuset_num_cpus() unfloored, while its sibling
tg_tasks() already floors its result at 1. calc_concur_shares() feeds

	nr = min(tg_tasks(tg), tg_cpus(tg))

into __calc_smp_shares() as shares_max, so an nr of 0 makes shares_max 0.
__calc_smp_shares() ends with

	return clamp_t(long, shares, MIN_SHARES, shares_max);

and clamp() yields hi when hi < lo, so a zero shares_max silently defeats
the MIN_SHARES floor and returns 0 -- the exact case the comment above
that line says must return MIN_SHARES instead of 0.

That leaves a group sched_entity with load.weight == 0, and
__calc_prop_weight() then divides by cfs_rq->load.weight:

	weight *= se->load.weight;
	if (parent_entity(se))
		weight /= cfs_rq->load.weight;

which takes a #DE inside enqueue_task_fair():

  Oops: divide error: 0000 [#1] SMP NOPTI
  RIP: 0010:enqueue_task_fair+0x422/0x950
  Call Trace:
   <TASK>
   enqueue_task+0x8e/0x250
   wake_up_new_task+0x148/0x2e0
   kernel_clone+0x1c6/0x390
   __x64_sys_clone+0xcc/0x100
   do_syscall_64+0x147/0x3c0
   </TASK>

This is not survivable in practice: with panic_on_oops=0 the kernel took
the first #DE and continued for 476 ms, then faulted at the same RIP with
identical register state and an identical RSP, because the oops recovery
path (kill task -> schedule()) re-enters the same enqueue while the rq
lock is held mid-enqueue. The second fault escalates to a panic.

Flooring tg_cpus() at 1 makes it symmetric with tg_tasks() and keeps
shares_max >= tg_shares, so the MIN_SHARES floor in __calc_smp_shares()
can no longer be bypassed.

Note this only removes the division hazard. Whether cpuset_num_cpus() can
legitimately return 0 -- via the cpu hotplug/suspend path where a v2
cpuset may transiently become empty, or via an RCU race -- is a separate
question still open on the report thread.

Link: https://lore.kernel.org/all/20260818231333.1441757-1-j@metarealtyinc.ca/
Signed-off-by: Jake Steinman <j@metarealtyinc.ca>
---
 kernel/sched/fair.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4895,7 +4895,12 @@ static int tg_cpus(struct task_group *tg)
 			nr = cpuset_num_cpus(cgrp);
 	}

-	return nr;
+	/*
+	 * An empty cpuset would propagate a 0 shares_max into
+	 * __calc_smp_shares(), where clamp() yields hi when hi < lo and so
+	 * defeats the MIN_SHARES floor. Match tg_tasks(), which floors at 1.
+	 */
+	return max(nr, 1);
 }

 static inline int tg_tasks(struct task_group *tg)
--
2.55.0
