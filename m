Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96612EEE75
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 03:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787629116; cv=none; b=txVdOSEw6qQSQ9sux9Z0oeUl/7UdVg1SJWMSjG2tiW3IHOVCnbs127MANPlbyNwjvanX30V2AhLOLQUC8FQwrCxMJT2Kt3EoD4pT/5yYBHVRNS7WWSpN8Op2Dmj82EaWRmuXay+mHa++aA9nrPsi4YX3RwcOGUq5kcxEBji8j88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787629116; c=relaxed/simple;
	bh=E+rumZ5IHlJxJjkjEZT710lc/D+oefpHKErRjwEJSMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tlnm0f8jc/HPfhptRL43s1vrvwijJwqMhl48d7X/PCU/k/tNqicm93XRZcVAlpjfc3zhubd8oU2lLf1PPsuHGjjE4ntQJaLhoh1JcBUcRwuZuUnSgMzUFUsKX8JiETVimH/w+9PmhT6Dzwu2aCxzo/aS5o3gBLjiBONr6wZr3Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=metarealtyinc.ca; spf=pass smtp.mailfrom=metarealtyinc.ca; dkim=pass (2048-bit key) header.d=metarealtyinc-ca.20251104.gappssmtp.com header.i=@metarealtyinc-ca.20251104.gappssmtp.com header.b=BKWbZjdJ; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=metarealtyinc.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=metarealtyinc.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=metarealtyinc-ca.20251104.gappssmtp.com header.i=@metarealtyinc-ca.20251104.gappssmtp.com header.b="BKWbZjdJ"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-934956bee57so435721585a.2
        for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 20:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metarealtyinc-ca.20251104.gappssmtp.com; s=20251104; t=1787629114; x=1788233914; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fP+EZyv3hwxvWRQB0kgMS5FUixvZvwf9qKXyYVHzYng=;
        b=BKWbZjdJX2hJxNABWtaTGQ/4Uq1zkue8NfVk2AA98rnJW5psevG4jZlZbij/0hKzgL
         QTBn+UYT6JSHBpf1uypD/eHoTb03iB37X/2yXGKiovHNXLKOKpqiXse6vqvun7by79aT
         3uc9mftkLtq9BpKMoekbhoiO9KY5lWZM8dGmEwosIPGB9nHl1kqH8iEwH7Y5Oq/OdiZD
         5149tLV6/O26mjfVvCjwiXEtI2cPYli+i+0rpysoT24d45/2ALyyeGrvndibwp1TNvyP
         bdrS+o8N8Yum4RcuYq7nR2d6OONWHUxYWTD+UiyaOqZ6Wiks2U8Lf6d0ZpvTZnbY70pb
         5TAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787629114; x=1788233914;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fP+EZyv3hwxvWRQB0kgMS5FUixvZvwf9qKXyYVHzYng=;
        b=cTJNkoD+762e3VDWOtmik6Bxr5qIMjylBQRNc0LAXD0tHFoWgsgBMfyVcuqu1XdCU8
         l8t41aypFioTNsctTaJ7M1khC4OcGFaItLmV43HhAbkmOYCM3hpGzWYw3UTdkm0IdYH6
         SYeJSY58VVzCMKlGgg6kYwwnS0xkSLVJf9zB/rUHi9OJRnoo4oi+nyXoYGy4KJ4MimY3
         b6HtPdk4olaiGorpGMNylfu4O9iqoU2FSf/1IwkqZ1GUT1VohPtM5VtP+yMCs+mqWK/c
         y/3JdFEMokpthQec6ta76PA8FoOTYoKewI0YEwK/HtKHKfZoeIWDH7sUfdfCYeH6sgi5
         uUXA==
X-Forwarded-Encrypted: i=1; AHgh+Ro6/mgy3qWdOzU8jj3VrGDSHGtP7aG/h5doeeSK/KFJ3GjCTG3pkOKyv2u7wTx3uK8NR2B36FhR@vger.kernel.org
X-Gm-Message-State: AFuF++k2tcrlI3Bj1mw7MgS/ynodMru0L7X3bPNvkpyU8BwiSEabnFWK
	e0k/nYRVirQoSPGqBPXAf9UJe3i8xgt05XcucQTqIqsVKHnpuqRTT4q+o+SDsmrFUeg=
X-Gm-Gg: AR+sD12OqT4EBA3Bt/XkMQq/2PQhnoqyuG3zj82p8mZTi7HPeXEMImOCE4q0egds9Pg
	2wG/sqrwdP7mFGp0U+VDcLjlZ3JXVEt0/9bCkSX6+1kEWDX2qKK/bbiFRisc7dCzW7e03YIa0tL
	kDkxmMj3fmfoVscnYddypDRJc4zUZX3UR9iAX/DD5x5RNklzwihZvF1tcrQEaCnO1pA3o2+njie
	IJ0wDCVrsjo49HOt+9DWrSpek/W1Oh1swd8Y+InE5FHBcHWJ1QSivD15WiThiX9ubdSion+sEdw
	qZCxDmcdxm2NXSysb+wBX1G4Namr77n1ML1T66fLzHnhJ4X50BaiINc3nBm6pop9CYsp6yLOlTh
	gRYh4sJP63U3JZ+tbP+aQ7+n74EoKIzyaP8iy9kYlt90WasZq3kSVZX6JUTbyK7oFifi/tp5J+m
	P9lAEUdij+UU+wU+f2rxXlXn0StZqdIYaF1XO9wmN4FVfruStJMTQLmatQCp+o8HmmX09l0dzut
	d1Q3u2SN4NYfZJt5f3PqprBQRYEPAxLYUyy0Nl33IazHsPZpHFw8oJRfOu0juOYJKMjScQ90mJw
	XugYp2y9rrmOoF5rkKmNIrWQtMIVyRhJ29BMRFQjEnU=
X-Received: by 2002:a05:620a:3bd2:b0:92b:8a7c:f71e with SMTP id af79cd13be357-937468bb96emr1905480085a.15.1787629113779;
        Mon, 24 Aug 2026 20:38:33 -0700 (PDT)
Received: from jake-laptop ([2607:fea8:e5:500::fa4c])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93749eb4240sm640377085a.47.2026.08.24.20.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 20:38:33 -0700 (PDT)
From: Jake Steinman <j@metarealtyinc.ca>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [BUG] sched/fair: divide error in __calc_prop_weight() from the enqueue path (flat-hierarchy series)
Date: Mon, 24 Aug 2026 23:38:31 -0400
Message-ID: <20260825033831.3006196-1-j@metarealtyinc.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260818231333.1441757-1-j@metarealtyinc.ca>
References: <20260818231333.1441757-1-j@metarealtyinc.ca>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Another report of this, same divide but reached from the idle path rather
than fork. https://github.com/CachyOS/linux-cachyos/issues/985

  Oops: divide error: 0000 [#1] SMP NOPTI
  CPU: 7 UID: 0 PID: 0 Comm: swapper/7 Tainted: G         C          7.2.0-1-cachyos #1
  RIP: 0010:enqueue_task_fair+0x87c/0x2150
  Call Trace:
   <TASK>
   sched_ttwu_pending+0x204/0x590
   flush_smp_call_function_queue+0x169/0x250
   ? cpuidle_enter_state+0xc2/0x230
   cpu_startup_entry+0x2f6/0x3d0
   start_secondary+0x9a/0xa0
   common_startup_64+0x13e/0x150
   </TASK>
  Kernel panic - not syncing: Attempted to kill the idle task!

An idle CPU takes a wakeup IPI and faults enqueuing the woken task. In
swapper there is nothing to kill, so it panics immediately instead of
oopsing first.

Symbolised against linux-cachyos-dbg it lands where mine did:

  __calc_prop_weight   fair.c:4728:10
    inlined at enqueue_hierarchy  fair.c:7891:12
    inlined at enqueue_task_fair  fair.c:7949:11

Still nothing on what empties the cpuset. Their machine looks like mine —
concur mode, no empty effective masks, no partitions.

They have offered to run the tg_cpus() floor or a debug build with
WARN_ON_ONCE(!cfs_rq->load.weight). They reproduce more readily than I do,
so that is probably the machine to instrument.

Thanks,
Jake
