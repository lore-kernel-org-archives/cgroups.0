Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242222;
	b=LFl96zNqjnrpu4gfHc6IauUNfZLpSPesow1hm8V2OxqC1b+T1VtUr7phmgjaHrK+a3gj
	 3bYeKm7W+7h4Th7IHCAw0uzTaaEykOV8wTMuUafH7Y9O48bZwdUwvFpkhza1f7l7ABFqJ
	 9WqEy/fsDvaU2782cPl3ldeHTGVI9q4J974P8tD6P1Q98GxsYbZICMhCReRGJ9ymrGNqI
	 wolSJx4p1eBVGvjWfg1ud1sFAEXV1dt8ytCS4SGqpiIeftAACkHcGOMhn3SwalMXZBe1d
	 NYUgji4kgc4d6OSHPdegPDK9n71aSOy5lHm0lkK0zpzU94ReCSUje5iKY36bo9AZKSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242222;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qdVadI1hvmNJk+awA8RHjDIqE5xUOcTcDNFSytWKlh4=;
	b=z4bxy9LaGBYtMXwHhyI7FawTkOqFyA2XSYODUNoEJXiAwqGw9grmP9/Rwpijxz/ibOV9
	 Wnv7OdkT9GmGMp8I4QKDaToXpGx4tNgBbz6S08/oGHtelyEsHbvRsQkEAmGVJBDt4NTnZ
	 rm4FQDBYL0v2Hd2rHhOQTizAAXNbfxmy7UnTd0sh30WnsjrD2BwymI+k8OMo/zyo5c29i
	 V9gHF3O4PB17O7D+HRPceekkHkd7Lv4DjEhiRkXAo9psehZS1LidQg+sd+zvb6ssILo0V
	 kbdOriXLUvRCHlgAhw0CbxMxxxGt5McbBMF0H+TfZr3Ct6U1KWqaiZy8i4VAjcKIMwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=H7gw4Nxw;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CA4606A86E
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:37:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2CA4606A86E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=H7gw4Nxw
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a35d5d4a20so13338505e9.2
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242220; x=1794847020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qdVadI1hvmNJk+awA8RHjDIqE5xUOcTcDNFSytWKlh4=;
        b=H7gw4NxwqjeiByj/7rft0z1ChCs++jbTS2SciDzDaabPD9a5JFtSMxuZU1XLiwsqRA
         akA2rBrrhIYOC0rdwsIlP61S2mJkbyxrQlkY7KM1nGz0Lq7P1AdMsod03z6tbfQ94jGY
         cC774Ps6EUsSAPLDJ/AVx6YQX7spuvAOCLywh5nrwpwaLYfrjMzf/wvvDWpNi7zcDQa9
         vK2ZaCcGY+p/aj+zRZYB6E/8Jtnbq+93G/wlWxCarjPRad3BKx6Ob/RNmE0FCCnKhsfV
         lO9eRNSlKMsLq0iIg23RCfUj63ED5wpBmylHeOFGvfHhrT/IHDWe/dx+kedwaE3GbzRI
         uyCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242220; x=1794847020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qdVadI1hvmNJk+awA8RHjDIqE5xUOcTcDNFSytWKlh4=;
        b=eTAyQVvfJjtGcvdnVw+ZN0djQLJh2fNbJKxgjEtubaBqeu7WC1Gw+yW82ewos4VNeG
         nqXFOry5HAXTXa0T82LGAG1xHG56KVdmmbPTsIUjOp6gAptFMoRniT7LkJCbHE/tHynY
         rvIl7bUk+u5zIUiw3peNmvAM0TXtvvL2T/vgMGn1wa/7xT+mx8z9qGwMsqFFRUujd3ys
         VVhD+/XqYLNwvrUuWGu//bWrMi1dK/btkJyArjQFk1F3TEmzIJIOWq7qyhaGJx1kOef9
         4IvnHbt7LpYbtTgjkkc0S+9VnTEWfuCXLz46ZAz9EKII/Yd8WK1RxnngnGfdc6fs/el/
         9bQg==
X-Gm-Message-State: APuU4Z9Oc08dQP/8bHULqfeonjR3n6yl7nZIlSlwc5V/CkZRid/yzIX/
	J4NllCP7ln4Q/e+nrh4ZH4SWdBQncyh7XhX883QDolqvLijmTal4TXDG
X-Gm-Gg: AYBFou1WiIYxRAcH+ZaeOFZML65rAuwG8t4RzDxue7x9JaK012yyUgFNNig4GvnQBi3
	uzetwM9hVEVfD0W+W4J2f/ogKLqd5jFezXxMQIXRsShcYq6pj+y0ITTQP7Q06IN5HfJFFnbtxvb
	yUfxGugLwUeKekrWXX8eNbpeudarkQopmcTZt2/UUBQKJm9/vMbw7n1WkaME2GG7yyEgHpSYvRw
	qtqME1ipq0dup+hsMYi9PnZWJ1fgGX4gxibonuJNR1jBLqVj2WIBOgj6qEN+7qTy83wjAUeDVgn
	5J0FDE2tB/6GT2VmIi7Uz+11UJAZhmXzdmuUocyFJL/x2X7H80BLgYbA1EeSzMcGEr6ULV51lZR
	/YmeUTaoeeaOh4TXuq33I8TI/saFcK6LBumQ2/XlFg93G3X6OTGqXo0AXFzZBsuzr9z2aYUZDKJ
	JcXY+AcFloIrVeubA4KKGRK25JTJuJBpC/Npy9mkPypzGdmIR8J25xZShDfig6eoPKckeUW58jf
	bFCvBKm0CJZ3QB8OT9Xc1NxPyFcPI78vfRPP0vYrGuOoDACq1Qmn52+NVJ4UBxg2ohHMZH1+1X0
	ajKiPyuwBb9uOFCLdXzCQ0kFZg==
X-Received: by 2002:a05:600c:4e4e:b0:4a0:23f:8b0d with SMTP id 5b1f17b1804b1-4b94d763141mr82297085e9.2.1794242220166;
        Mon, 09 Nov 2026 08:37:00 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:36:59 -0800 (PST)
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
Subject: [RFC PATCH v7 24/29] sched/syscalls: Allow unpriviledged tasks to set RT priority inside cgroups.
Date: Mon,  9 Nov 2026 17:36:10 +0100
Message-ID: <20261109163616.195264-25-yurand2000@gmail.com>
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

Signed-off-by: Yuri Andriaccio <yurand2000@gmail.com>
---
 kernel/sched/syscalls.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index f1e9de478e1d..36bb07b10d41 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -444,15 +444,27 @@ static int user_check_sched_setscheduler(struct task_struct *p,

 	if (rt_policy(policy)) {
 		unsigned long rlim_rtprio = task_rlimit(p, RLIMIT_RTPRIO);
+		struct task_group *active_context;

-		/* Can't set/change the rt policy: */
-		if (policy != p->policy && !rlim_rtprio)
-			goto req_priv;
+		if (!rt_group_sched_enabled())
+			goto root_cgroup_checks;

-		/* Can't increase priority: */
-		if (attr->sched_priority > p->rt_priority &&
-		    attr->sched_priority > rlim_rtprio)
-			goto req_priv;
+		scoped_guard(raw_spinlock_irq, dl_bw_lock_of_tg(p->sched_task_group)) {
+			active_context = dl_bandwidth_read(p->sched_task_group)->active_context;
+		}
+
+		/* Allow changing to the rt policy when not in the root cgroup */
+		if (active_context == &root_task_group) {
+root_cgroup_checks:
+			/* Can't set/change the rt policy: */
+			if (policy != p->policy && !rlim_rtprio)
+				goto req_priv;
+
+			/* Can't increase priority: */
+			if (attr->sched_priority > p->rt_priority &&
+			    attr->sched_priority > rlim_rtprio)
+				goto req_priv;
+		}
 	}

 	/*
--
2.56.0

