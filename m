Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298583C1D7F
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 18:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787165276; cv=none; b=G4k7++Q82g5TeyLksiyiPCifZCV+8FbRukiYFQZ/R5RLjLRfrFO6akJlr44stHXM6QfBzFWfZ3o9V5jVdeAGGU1gStliEBcuGAyLgC/GA6XY++Bs8aJzNMphqP9GjoZgjQ/5XTuR6B0YZaJysDPycoTjWvz2mjWfbBTrg9JqNkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787165276; c=relaxed/simple;
	bh=/7KME9Z4lqbcbER8G/dgyU3QuG+WyM8S7V/QCZPI+v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BLhc2N6KDwxHl0YUuly155VThpWuMFZuJEdzIHmSGpRpSv+JMTQKP3u06PPBSXfL3b1VN0WX45BxM5JaL+z3kLXaON2IyoU5SkUS3j/z3lwicWZjyc7uzNEsqyj7/uNaK3Lbbw+CxhTnzeU0+2huevdAK37YFRbGfi6qAPvA6IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=metarealtyinc.ca; spf=pass smtp.mailfrom=metarealtyinc.ca; dkim=pass (2048-bit key) header.d=metarealtyinc-ca.20251104.gappssmtp.com header.i=@metarealtyinc-ca.20251104.gappssmtp.com header.b=toI1fOSm; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=metarealtyinc.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=metarealtyinc.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=metarealtyinc-ca.20251104.gappssmtp.com header.i=@metarealtyinc-ca.20251104.gappssmtp.com header.b="toI1fOSm"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8efcef23d21so11054266d6.2
        for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 11:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metarealtyinc-ca.20251104.gappssmtp.com; s=20251104; t=1787165274; x=1787770074; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UAHoFyg8RAbyOumbU4jYr+HU0HwivUuE2UjIEFiAIPk=;
        b=toI1fOSmUdgffxsr5NHafpN8R1oSXkWGVIRoy1RObdYcMKr6TBs+ol3OT8DxXg1Czd
         KRCwnTzhmgaShD1/1e1JS4/9pkgdWlM0HydJbrdoBojLgrRttAN7szwoxnQoDcIVABCe
         0jGZSJkbo6IMtKlAJyTCqZPlHNGere5Lg396TY8lwtVzKIH0lh53wPO7WPdMpp9Kpqaw
         U3IGH56lXTw/C+GcnUWbaMZkdpu9iAFwdqb85mlORfu50oOtONV4gBNtdPlQTZy5/3nT
         s7KZpBi+t3cChZszC0LI63zi8f8X0MhALFGQ/yBLWJwe9q99P5ZC8QXH4c62yX9fmcuN
         XUyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787165274; x=1787770074;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UAHoFyg8RAbyOumbU4jYr+HU0HwivUuE2UjIEFiAIPk=;
        b=s3MHnKy1ykSx7dKDr7Az9ayYnDRa8QsmBMAITEtxR4w1jyuVOHlF7xamIWMr/gDBmo
         aksMFNwiRCS2lHz7fPJvk/UFOXNcNZNnf7wOOe9oUer+VpiR3QPPafEFK6fyzjJLCA5N
         0bsgP4rizhvVJf2jxSNA3XiGhEOZ7oq297/GH9q9v8tD+R7qWTurAdciQL3z9GpMfoJE
         RmHA0iDRi83RS21wYGuSuRuk5l5KIa64/qhfglyQ+qIZH4pvV8ZDai1bvXnYZ6oezAPl
         55NkJNUz8MXdMITz5Hp0WYjW8Poups2QSOZ2Rh8sD1NbSfGFwbRpOf/41re5LV0z1OMS
         /I9A==
X-Forwarded-Encrypted: i=1; AHgh+RqdUo7w1hG0aIQa6p0EFLNxVxolRZczUh8QmD7eng7Dmw2e5if5Ia3Zom1sX/Iyi0hSE/WhR47p@vger.kernel.org
X-Gm-Message-State: AFuF++nBbQSyEkkNp1F9z+ZAqVu8Qc9cgZXB4MZ2yBsRG5iok/VVngv8
	ouKKNIDqEjWaytEQAiaamB9OLfk5dw6kG7njnOiOgiryOFCp5MzBDEOaX0Zlk47S/4M=
X-Gm-Gg: AR+sD13ghJuWsjJC1AJFZKrsuJXFyKx1u3u8GSPvAPFG/77ygvzejO1O6JJ2ePxi89H
	iTCbc0kQZ1LGZWvMpN0m5Qy/Hb89YFh9EIWgMoP3mTPfQZUlEvHtK2sf5uhLNwrOt27bYBrCaWK
	m092Dc6/3mz81PC681Cf3W4DGJkEINtjQVUB0usmt9EvPpHQS/oQBJ55hOk4ySiWnbNT+A2H6vp
	4znIlJu01rIT8QVmCnGEpjTm05DqptaQA/pP5QC63Nl6rfhzy2pEjiLy/NxizWbAzVNHEWyQ5H2
	I1gnxOcb0j6LZMhfWy1PmJT/gRrknt3ybeW0G83wVsQEu7gNRHJPmX94E1TwhHW7VycO7JdQoAK
	EIw7VIgXkc9U0gwUp1jbnuq3BrjngF8Yv1cKTddPD62krBgBztZvn38Vo2CuQOvcRNt9q9K6PD2
	cu6vN+GbRkwoVpgXtObGQhIK7vhAdxPXuf0SxP6JrXUdKaiSrve6hwr5vi4raPpTMuCjL/SZx74
	lg99dgtievwJdcIUrkVuHEtY9D5Eo45nmH+dRRXiRiIRMf1hBjZp61kgDjipeFRxg4eulY9h4FW
	6Q1HBCSxUdKJ5Q3mtFxCTDlmhSIkxUtykhL9vDAxpg9y
X-Received: by 2002:a05:6214:246f:b0:907:dd19:fcb3 with SMTP id 6a1803df08f44-90c5eaac597mr68849796d6.24.1787165273845;
        Wed, 19 Aug 2026 11:47:53 -0700 (PDT)
Received: from jake-laptop ([2607:fea8:e5:500::95b9])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c5f2b8164sm20643566d6.48.2026.08.19.11.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 11:47:53 -0700 (PDT)
From: Jake Steinman <j@metarealtyinc.ca>
To: Peter Zijlstra <peterz@infradead.org>,
	Waiman Long <longman@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Tejun Heo <tj@kernel.org>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [BUG] sched/fair: divide error in __calc_prop_weight() from the enqueue path (flat-hierarchy series)
Date: Wed, 19 Aug 2026 14:47:50 -0400
Message-ID: <20260819184750.2237807-1-j@metarealtyinc.ca>
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

The diagnostic WARN fired. tg_cpus() does return 0 in practice, so the
cpuset route is real and not just theoretically reachable.

21.4 h into the boot, on the kernel carrying the three guards:

  sched: tg_cpus() == 0, empty cpuset
  WARNING: kernel/sched/fair.c:4904 at calc_concur_shares+0xf8/0x130, CPU#14: swapper/14/0
  CPU: 14 UID: 0 PID: 0 Comm: swapper/14
  Tainted: G     U   C OE       7.2.0-1-cachyos-rc #1 PREEMPT(full)
  Hardware name: Dell Inc. XPS 16 DA16260/0RMV2Y, BIOS 1.5.1 04/01/2026
  RIP: 0010:calc_concur_shares+0xfe/0x130
  RAX: ffffffff88eec4b0 RBX: 0000000000000000 RCX: 0000000000000000
  RDX: ffff8aedcc2379a0 RSI: 0000000000000030 RDI: ffffffff88eec4b0
  RBP: fffff3f0ff990cc0 R08: 0000000000000000 R09: 0000000000000000
  R10: 000000000000b74f R11: 0000000000000001 R12: fffff3f0ff98c5c0
  R13: 0000000000100000 R14: ffff8aed89796c00 R15: 0000000000000001
  Call Trace:
   <IRQ>
   enqueue_task_fair+0x201/0x970
   enqueue_task+0x8e/0x250
   ttwu_do_activate+0x89/0x1d0
   sched_ttwu_pending+0xce/0x1f0
   __flush_smp_call_function_queue+0x2b8/0x3e0
   __sysvec_call_function_single+0x22/0xb0
   fred_sysvec_call_function_single+0x54/0x70
   </IRQ>
   <TASK>
   fred_extint+0x4e/0x80
   asm_fred_entrypoint_kernel+0x41/0x70

Two things worth noting.

**The context is not the one that crashed.** The original oops was
bash in fork(), wake_up_new_task() -> enqueue_task_fair(). This is a
remote wakeup: an idle CPU (swapper/14) draining its pending-wakeup
queue from a CALL_FUNCTION_SINGLE IPI, in IRQ context. Same
calc_concur_shares() -> tg_cpus() == 0, reached a different way. So the
zero is a property of the task_group's cpuset at that moment, not of
either call path.

**IRQ context may matter for your RCU-race question.** You wrote:

> Now, cpuset_num_cpus() uses RCU, so perhaps there is a race somewhere.

This fired inside a hardirq, which is at least consistent with that --
though I can't distinguish "raced with an update" from "legitimately
empty at that instant" from the WARN alone. Waiman, if there is a
specific place you'd want instrumented to tell those apart, I have a
machine that reproduces it in about a day of ordinary use and I'm happy
to run whatever you want.

For completeness on what was and wasn't happening:

- Fired 21.4 h into the boot (wall clock 2026-08-19 13:24), during
  ordinary desktop use, no reproducer.
- One s2idle suspend/resume in that boot, which ended 4h20m earlier.
- No CPU hotplug events logged in the boot at all.
- No isolcpus, no domain isolation, no partition roots -- every
  cpuset.cpus.partition on the system reads "member", and no cgroup
  showed an empty cpuset.cpus.effective when I sampled afterwards.
- intel_lpmd is running and does rewrite AllowedCPUs on the top-level
  systemd slices, but logged nothing near the event, so I still can't
  pin it as the trigger. I mention it only because I raised it earlier
  and want to be clear it remains unproven.

The guard did its job: WARN_ONCE, floor to 1, machine still up 22 h
later with no divide error and no panic. That is 21 h longer than the
unguarded kernel managed on the day it crashed, though obviously one
data point.

Nothing here changes the patch I sent -- flooring tg_cpus() is still
right on symmetry grounds. It does mean the floor is load-bearing
rather than defensive, and that whatever lets a cpuset read as empty
here is a real thing worth understanding separately.

Thanks,
Jake
