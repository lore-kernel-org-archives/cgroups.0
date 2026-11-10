Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.142.43.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794332143;
	b=ImzpCzJAX3SJX3CMRMVLvhnbAMMoyjMweVbTupIL6If35KIle1Wh5U7xcNm0yw8O7qvN
	 OdOuyLuMKgl3AA546YsR2rl22OjRp/SfHZbbloeBbZ08cGGjS97ub4/xSI7iRpB5cRI40
	 OKn7fKRnyWypLH6CPXFT/dYE3PgJzFlekPzSwqkMu7twoiKal2tepgjoVImUHfXFFeCDW
	 Gk9v8SnsThCUMi0/ZYL4fDTd1zaDzvri5Lgo7099l3vlAyC1NTjkaP18wlcY6TrIYS93s
	 bhvt8sKm5ZwCE1WSexmKFEzOPrBordM3vEwcp9ZARJUoJctTDOUMz6E6Ne6wd5ZqC5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794332143;
	h=DMARC-Filter:From:DKIM-Signature:DKIM-Signature:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Type:X-Change-ID:
	 Content-Transfer-Encoding;
	bh=lJCysJP6dPhJVgiT7W4LzYstHZpICtrOkT+9H+h9uKA=;
	b=bDJrIO6RmZNlUMih1HbNG6y5875wQl85MlmDZ7Dhl7BylT6k90t8/biObRmNtBJZPhyL
	 mqow/OfZzCYG/xlHGT0g+1SqpQtImwXIwROFgU3Yoi9toHatK3BwiI28maMkRtqImQFxt
	 fxRK2aS+w3g2Ys6FRJntxJOQSagIZ1O87vkrD+s9TJfkE7f4Shn/HCONBgAvaiDiSfyda
	 iuEpBlXQIx38AmQt+t59G4N/Ra0m3rJJzbs9tjaOWbmUzKHXKTIwo+xhrarAjU/pKb0z1
	 EkR0vD0FGCHx6pWo6fe/6Tj2u1+VSedj9NCVfYauG+QpXlUaUobd3M24y0dqIT+BatQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linutronix.de;
	spf=pass smtp.mailfrom=linutronix.de;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=nrKi431Q;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=TGcoEEDd;
	arc=none smtp.remote-ip=193.142.43.55
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446CF60A2600;
	Tue, 10 Nov 2026 17:35:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 446CF60A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=nrKi431Q;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=TGcoEEDd
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1794332139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lJCysJP6dPhJVgiT7W4LzYstHZpICtrOkT+9H+h9uKA=;
	b=nrKi431QoIQw1F8VjMzNNtO8sRXalWE4P6llH5Ib55VeFLt5qDrPfUPWko8/fTxFfAq3iw
	1WvFi+/KTj0ce2N8wXQTkqW2v2fJx+r1GptKY8b5Z3mqd4M9WommOm6maOPr/K+L8LT0Kk
	tyfrpWJY1/QgIBgLGumIsHB07Hai0G2r3t8hEtaIpc5WJ9kV90WVMHBBQfLtWDAtJ3nxgz
	MnyxRfeQVsTBt9EWlk38r4vHJuDNQv9LvLnz22ynG9hs2TKqexSHX++rx8rdEkkSK2pR54
	//D7ja+7Rjr6nBXio4jZZLJUMYwN3UgdIIaPCkrsG0ghfakkLTHW6ZzmiI4CMw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1794332139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lJCysJP6dPhJVgiT7W4LzYstHZpICtrOkT+9H+h9uKA=;
	b=TGcoEEDd+gNuqYwEWlY03xnhZS6r/QOKJIrCA0tlZUHmQQhzVheLaCPf5URUWrzDKXrJ2E
	u/KTEKsxCp0zlVBA==
To: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: John Ogness <john.ogness@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	luca abeni <luca.abeni@santannapisa.it>,
	Yuri Andriaccio <yurand2000@gmail.com>,
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
	Qais Yousef <qyousef@layalina.io>
Subject: [PATCH v2 0/7] sched: RT throttling cleanup and a bit of documentation
Date: Tue, 10 Nov 2026 18:34:42 +0100
Message-ID: <20261110-sched_dl-v2-0-cc9399f7aeb1@linutronix.de>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20261110-sched_dl-a9727787112f
Content-Transfer-Encoding: quoted-printable

People used to disable the RT throttling mechanism by writing -1 to=0D
/proc/sys/kernel/sched_rt_runtime_us. Since v6.12 they can still do this=0D
but they don't disable RT throttling anymore. Instead this throttling=0D
mechanism has been taken over by the fair_server which can be configured=0D
via debugfs.=0D
This is not really documented by a hint appeared a few cycles later in=0D
Documentation/scheduler/sched-rt-group.rst. This can be found once you=0D
know what you are looking for because this document describes the RT=0D
group scheduling (CONFIG_RT_GROUP_SCHED). The fair_server is used even=0D
without it.=0D
The then there is global DL resource control which also shares this=0D
file proc file (which is stuck if CONFIG_RT_GROUP_SCHED is enabled).=0D
=0D
This little series:=0D
- Marks CONFIG_RT_GROUP_SCHED as broken because I was not allowed to=0D
  remove it.=0D
=0D
- Untangles DL usage of sched_rt_runtime_us and moves it to=0D
    /sys/kernel/sched/dl_period_us=0D
    /sys/kernel/sched/dl_runtime_us=0D
=0D
  This keeps the _us sematic that we used to have /proc. It _could_ be=0D
  changed to ns instead.=0D
=0D
- Moves rcutorture away from the procfs interface since it tries to=0D
  shutdown the fair_server for its testing.=0D
=0D
- Adds sysfs interface under /sys/kernel/sched/cpuX to represent the=0D
  runqueues. The only knob for now is fair_server_{period|runtime}=0D
  representing the fair_server parameters. If all goes well, debugfs=0D
  could be removed. The ext server could be moved, too.=0D
=0D
- I tried to correct/ update documentation while at it. I added the -doc=0D
  folks on Cc so they are aware. I can drop them in the next posting, I=0D
  expect that this gets routed via the sched/-tip.=0D
=0D
v1=E2=80=A6v2: https://lore.kernel.org/all/20261105164724.yxONBd03@linutron=
ix.de/=0D
  - Tejun and PeterZ asked for marking CONFIG_RT_GROUP_SCHED broken=0D
    first.=0D
  - Everything after patch #1 that got queued up.=0D
=0D
RFC=E2=80=A6v1: https://lore.kernel.org/all/20261023161348.t3lpPLQZ@linutro=
nix.de/=0D
  - Try to remove RT-GROUP-sched after figuring out that it is useless.=0D
=0D
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>=0D
---=0D
Sebastian Andrzej Siewior (7):=0D
      sched: Mark RT_GROUP_SCHED broken=0D
      rcutorture: Don't try to disable to RT throttling.=0D
      sched: rcutorture: Allow to disable DL fair_server=0D
      sched: Move DL's admission control to sysfs=0D
      sched: Limit sysctl sched_rt_{period|runtime}_us to RT_GROUP_SCHED=0D
      sched: Add sysfs files for the per-CPU fair_server knobs=0D
      Documentation/sched: Add fairserver to sched-deadline=0D
=0D
 Documentation/arch/arm64/asymmetric-32bit.rst |   2 +-=0D
 Documentation/scheduler/sched-deadline.rst    |  36 ++-=0D
 Documentation/scheduler/sched-rt-group.rst    |   7 +-=0D
 init/Kconfig                                  |   2 +-=0D
 kernel/rcu/rcu.h                              |   2 -=0D
 kernel/rcu/rcutorture.c                       |  37 +--=0D
 kernel/sched/deadline.c                       | 338 ++++++++++++++++++++++=
+++-=0D
 kernel/sched/debug.c                          |  56 +----=0D
 kernel/sched/features.h                       |   2 +=0D
 kernel/sched/rt.c                             |  61 ++---=0D
 kernel/sched/sched.h                          |  55 +++--=0D
 11 files changed, 423 insertions(+), 175 deletions(-)=0D
---=0D
base-commit: fd9230005e85472b81c1c7c16afe93dd878996b1=0D
change-id: 20261110-sched_dl-a9727787112f=0D
=0D
Best regards,=0D
--  =0D
Sebastian Andrzej Siewior <bigeasy@linutronix.de>=0D
