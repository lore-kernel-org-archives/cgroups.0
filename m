Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDE4396B9D
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 13:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787145740; cv=none; b=WQ/2y+MnGhlLuuZOsJac4EA5Q/4yAj7msT9wL8D2Salzb2yxyE+UBWVf3iBxIK3nqno/D9oca06xDY+VHfSInKeBf5G3ovkncEwhsFs0ZzXfWzGuH8ZOKLFHlH1GPcEaAuDTgsuAYhpM87Sp3ay1EYff7MpT8M6yq4QPJwZS+i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787145740; c=relaxed/simple;
	bh=OqXWEupomjk/a4YDz57WaB65dru+lxF67oQz5/x4HUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfiPiJfUh1JjUNq4T56S0rN/vDSxL7/b/4GqSJSFlrLMsFkqeGGC6UDb3msM6YYSMEca0GXcN7fBOcBmTZiiELEAjERrcgZir6gPGtX8yYZtnTUD6AfCYhWeEsgMmQ/PUpkgE7scuugF03VTeFMe6n/t8OitUJnLafiRLV94dz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=metarealtyinc.ca; spf=pass smtp.mailfrom=metarealtyinc.ca; dkim=pass (2048-bit key) header.d=metarealtyinc-ca.20251104.gappssmtp.com header.i=@metarealtyinc-ca.20251104.gappssmtp.com header.b=ldKLBdRC; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=metarealtyinc.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=metarealtyinc.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=metarealtyinc-ca.20251104.gappssmtp.com header.i=@metarealtyinc-ca.20251104.gappssmtp.com header.b="ldKLBdRC"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-52d8748cde5so5041341cf.0
        for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 06:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metarealtyinc-ca.20251104.gappssmtp.com; s=20251104; t=1787145731; x=1787750531; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S80AkclMqzdL0HTjNa/cN/+fUF8iAZr9z93NDZp/QlY=;
        b=ldKLBdRCHcEJ8siLgaAVWDNlCTbg8QspQAiNSdMdX/Yr6mOaT/GIEk02qrQ3FCW2q8
         sbnzC5gJz2GhiIKkc34vdupp9uiMx/T/0U8tdx872EY7BAUHWhKBTP/qQH1zhukqyEkm
         YBCzuqCPv4pDy6MzC+i0uICs0GdCL0Bo6FjocNPR/HNnIAFExlM32muTpjX+o3muFDRw
         eo7y8b94eSHVYyEITLiux6tozl9JAnQjTmSlugbvon9ei0d3cI/fNNCH+k6xeTqw+trt
         7EYZFsnHTpx1NolOMBBcib3kO/SN81txbhyULEoXB09Pe9Fbqnzyt/SQRYE7YJr6OvZn
         nZxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787145731; x=1787750531;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=S80AkclMqzdL0HTjNa/cN/+fUF8iAZr9z93NDZp/QlY=;
        b=JsNyWizbr268pmqZZdqoJL+q8DqNLUI6z3UT9qMO3gscX/5ZXOmbZN7qdw1szfDToM
         QlQJULnLPFAs6xkbdgCeFdDmtAJWM+IysPwrS+75y5FIJb+vIWx6FjFlNT/O/jn5inUB
         V/Ji4SKXbLb4pe1UYl7qZu3mre0cOg5V2BnjNrnzZ1NVibHg7q3zFi/doSL12TguX336
         uRXFWemF8X9dOy94G6b+PXEZxIYbw8FwY2VZZMCiP6G40UdUR8t42Ore+n59SzDrSvCR
         Y8NdSR8SvrjCTSKdmqQAKvMWdmmSjhb3C2GErG9TYymhouJ43dCxggDbkr9+5gZxo1OJ
         sU6Q==
X-Forwarded-Encrypted: i=1; AHgh+RorM/WSwniSTQIZ8ey5fs8XaHOb2//+zHpjmXCmf5w3iogf66VjVYP5hkeGSS/V6l+L/ZTr0inB@vger.kernel.org
X-Gm-Message-State: AOJu0YxI8HH4MZjzzWn21MMI8xI18R0iCJHzDnF66SpPrIM6BoI8YcXA
	N6TWesyRub/Du2oL7DMznoX3G/0tuSDr8p2vWprBXHWZTEsmp2FBeJbz3LHudKvzzMg=
X-Gm-Gg: AR+sD13IGBa529riVouRQ61r+2UjtAXlSbFgSQokQe94xT9AMhSgMM9uzRVyrSvoCjb
	iyYVY8SsrVo8Kx0ydGUE1jlSviAK2xqGZsDOE4hRBdixtrvLKDlzpMNfGj0aSl5R6rpY4awpW3t
	MAFnt7jH/eUtMwyz1haCvbmlukpoxXgcydCGGQfO7wxDrpDAeyU65eRAqigII78IXwCHgZ+qlw3
	L6Ub0Mraza2q8njTwr472J3eZwUZdu8UZOXbC8VmonmGlo08W0uy0twJw83NWzaSZJa4fgsto1p
	N+908MD+ocQXZ/H1+HFDxUQLaT7YlpQ4dZreBMlvkw2tBFpHZrsLpUufwiYr2FowR8xa7TQyncb
	VbX2wNns7/7gTepRJoQ3psuIWH5TODHWLJrEmYMPzl7viV4hG13CWXfo/5WtEVmH2o+3wLS/bV4
	eqhZ8pLaUyvEc/put3/MKEs5hcGNLC+B+aTflN9lsaXe66IA8n1waWEQ5Yx/RCQbFKDEfFIGuXY
	zDL/igkq8sjRymYDMU3A09L05CXzEt/sHQdQBZ6Pp17hIvXxloPzcfJhN1XhQs9zvvo0lmra5fA
	7mKTxQuygS9nrO/2rAEFpG+nRx5Vs+9JHf7KlQ0632s=
X-Received: by 2002:ac8:6909:0:b0:52d:8256:ac33 with SMTP id d75a77b69052e-52dd5c8b620mr41901041cf.28.1787145731031;
        Wed, 19 Aug 2026 06:22:11 -0700 (PDT)
Received: from jake-laptop ([2607:fea8:e5:500::95b9])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52dd859cebasm10571201cf.11.2026.08.19.06.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 06:22:10 -0700 (PDT)
From: Jake Steinman <j@metarealtyinc.ca>
To: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [BUG] sched/fair: divide error in __calc_prop_weight() from the enqueue path (flat-hierarchy series)
Date: Wed, 19 Aug 2026 09:22:07 -0400
Message-ID: <20260819132207.2149185-1-j@metarealtyinc.ca>
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

Hi Prateek,

> Was your laptop suspended at that point?

No -- awake, but it had been through a suspend/resume cycle earlier in
the same boot. From the journal of the boot that died:

  15:32:43  Lid closed
  15:32:44  PM: suspend entry (s2idle)
  16:25:55  Lid opened
  16:25:55  PM: suspend exit
  16:42:54  Lid closed
  20:17:49  Lid opened
  20:31:59  Lid closed
  21:10:16  <last log line -- crash>

So the s2idle cycle ended 4h44m before the fault. At 21:10 the lid had
been shut for ~38 minutes, but the machine was on AC with
LidAction=TurnOffScreen, so it was awake with the display off, not
suspended -- the wallpaper daemon was still rendering once a minute
right up to the final log line, and the fork that tripped the divide
happened then.

Also relevant to the freeze_secondary_cpus() angle: that boot logged
zero CPU hotplug events. No smpboot lines, no "Disabling non-boot CPUs".
Caveat: s2idle's freeze path may not log at my loglevel, so I would not
read that as proof it never happened -- only that nothing surfaced.

> I think your current instrumentation from "Proposed guard" is good
> enough to tell where the problem is if it reproduces. Are you running
> with it on your setup currently?

Yes. All three hunks have been in the running kernel since 2026-08-18,
now on 7.2.0. Current status:

  7.2.0-1, 17.3 h uptime with the guards in
  "sched: tg_cpus() == 0, empty cpuset"        -- 0 hits
  "sched: cfs_rq->load.weight == 0"            -- 0 hits

So nothing has reproduced yet. Given the original took 11.7 h of mostly
idle uptime to hit once and has not recurred in the days since, I read
17 h of silence as "not yet", not as evidence against the cpuset route.
I will report either way -- and if the tg_cpus() WARN is the one that
fires, that settles the mechanism on the spot.

I have sent the tg_cpus() floor as a separate patch per Peter's request.
I deliberately kept it to that one hunk: with tg_cpus() floored and
tg_tasks() already flooring at 1, nr >= 1, so shares_max >= tg_shares
and the inverted clamp in __calc_smp_shares() becomes unreachable. The
other two hunks are belt-and-braces and I did not want to bundle them
into something Peter offered to take on symmetry grounds.

@Guopeng: thanks, the isolcpus=domain reproducer is interesting. I am
not using isolcpus here and have no domain isolation configured, so my
case is not that exact path, but if you want a second machine to test
either of your series on I am happy to run them -- this box reproduces
suspend/resume cycles all day and has 16 CPUs with a P/E/LP-E split,
which may be a useful shape for hotplug edge cases.

Thanks,
Jake
