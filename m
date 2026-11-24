Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795491355;
	b=rVN8tJIpJh/+SqbPsCnZaxJs+w3A8M74tSFJBpvj6w/qiY+M8Sa+sE5Y60SQHA2Tpkzz
	 doPCGjV5xplGt1FyyW0JlxuuO+OnM5Ha3VtecCv7fA4p/s1ofPFEZz3GSprruaeNCEHJL
	 uGt9q7zi/eeyo8U8wtJ644vIOI7mGs6TL8yE2bN7k4FiEUylHIEJ/N0GEhX7odb1HaDyZ
	 685ptPBH1UUz+1kWDnSwU6LeLUr6AiIYEyub4jmtz7lKuM7jXP48s6gRTcx1x97C5cQe0
	 LdBOCxFV9oJx0ekNAp/k4hEpmVXxsMVL1wYg81GRtEOlpUfe0zVEGhjTXpLf8ck0nkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795491355;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=gz8mETMe7bzy47y43VlHpH3dB3FxR9QPUjmLcoANy4w=;
	b=5gfdUH/lrvwBDaLM5bfchnLvWLWjLIkIJNN+/bnqx4tavVody1pPTwLWXhpMVtBEhFd/
	 qrMoWW56nTawTZBRiI94tJlcpM5eww4wTNf6ZKVAxr6PZGQSQL4iqEvQ9L7+wxuLa6HSv
	 9BPkKITERq5eS+Ap9VajLoF11+aNwwTakwMNh+xf/bK9w4iLg0S/0sT+NvRvPw8x+i8g0
	 mfeVAx8cGQv4BXsTGnXQN4LGFg4UYerxWL1hBvuCU7dgJRNgl0R6zRvA5S3Nlc+CZDMjk
	 TqK/7z/RwEDA2O9kQxq+OE06Ln+vLAlNP42R/5ynJLCf0ElYQJLnrdCzi14VLvaP5Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PE43Uzh7;
	arc=none smtp.remote-ip=209.85.215.180
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C69606A31E
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 03:35:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1C69606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PE43Uzh7
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cc758830601so3111334a12.2
        for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 19:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795491354; x=1796096154; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gz8mETMe7bzy47y43VlHpH3dB3FxR9QPUjmLcoANy4w=;
        b=PE43Uzh7k6AT+LlkkhBA0JuS+GfcHh7cjdJLi1eV9S/sBX4rDZmUksEJsDT5X2A5Mt
         vTDs9iIN4zLrYMaNALsbLErxH+UEfWcVf7NbdGLJ/Ktcc9icy4sT9Y0QXFduGesdL+Oi
         0LtZj89ZqckwxxdbZZKB5ednKVePeZJCW42Y7Za8jaooj5DdR7a2p3M5s2o1ytmQoKOt
         DwyVBFJ/Cf466eFUO7rRgm4wTzCcx1Jl0hB/319KECUGPmov4OqQ4LM7F+XbawIGo+Bx
         Y2ZuJh2xaDBmHqNrCdh2FU6s7AMnAtiptWRZf7TTAGI3EwgKdk5sWLn8c+bKaUTr3KAp
         9U0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795491354; x=1796096154;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gz8mETMe7bzy47y43VlHpH3dB3FxR9QPUjmLcoANy4w=;
        b=yv08cBdYypbR5dEX6BDB7DH4XD3pEe+mNOrLp+M9oyszcejlSLislrgGhcD1UAnIMe
         lxvGFgQPODNlFuImZaVjDnxTEg7VTLZYkQ4iUJdpNp/mxUQKMKKYct64uB/60uq3j4Eu
         1O6ARSLt845AbZMVb6CT3BDK+VmJ59CT/NLTND84aN7b663dsYmyJlPwzSZuer3B9OwZ
         Zm8HbVKeJtncSiKf/Nn/qRansbpnoOxbUaJDgiJzhE3+HjMbE9sOqKjPNMTJSn+hReOM
         J1zr71p5YLY1PsSydlI3dfSTQEl7TafkxPVvXLslbJeSIERYZ7ybh56Ws3g0wREEGqx7
         2eqQ==
X-Forwarded-Encrypted: i=1; AL+hErEjijpyX6P6ovGIUW3slpkNvjHZ5ZcN87Ky9SWTmPf4NXlxexGPoydaOOPjU0Tkt00X5IYCUjGb@vger.kernel.org
X-Gm-Message-State: APuU4Z+NxfABe/jjbcdHuB4Cx5y7BgBRDRckJSy1M9AuhXiJ5fYbgG8r
	2aa4BdINjPop4VotWFl4677Bm68a4ZLKluWJ9IJxngSxQ0weLDDvTXbv
X-Gm-Gg: AZFdTZe0slhgghXxx+sAcQUcUMDoo0AHkGSIGbMmYY8Uj9i1YYrzajCpP1e2PJtDdCE
	PvJDPbRl1IoT4atIzzWO0kx6NiHmJ4aHFW9ve61YIdTTK2gVz+iOBmzhOhQWEsdh+oxPl32hUif
	L3H+7Bl4q+ZXyZuRjgz0MiU0iZVwtzfFHXTIdaQNEQbd64C5K3Q0HepIIcC9xrqtDL/p2WBTIR0
	gKy3Zg1/sK3D0DbKlW5nUME7+IhvpmEFRTaE6rF68qxQ2N+SF1Q013HM8mYBahPtaEXOmjQ/X7z
	hdJVXVKLxX3qHDHiLKgwIX+9JoRFaIChbfsD/jQlS4GtEStFOQJF95pBcE2bsgRVlxbkwlYmmGt
	TmLCZtxqv6Zy8lBxvM276Eo7mlt5EKwzoRlXO8OjUlqKGa0dOGrQUkAwfQm3CyAzIPWS/zm95O/
	gFLxpVnI+EmjX+eX8T/gnLhesNZ5BcJIx6UHhJ9BMcBZn6ALyz6Fb7ZhIGorXuTsairpvSxdX3J
	WYJcwiXTwQEAdIzn1dWK3gn0wjQJPoHoVw+lI/oMxQTxD4VFh7lDVELyBF773cb6A/Ji194QGPJ
	wVaGj8ceCWDrk/Y8T84pU5us3olBpuddw9ID/TbQmkdjjw==
X-Received: by 2002:a17:90b:2c84:b0:3b4:1220:36fe with SMTP id 98e67ed59e1d1-3b41c7d0ddfmr11532752a91.9.1795491354119;
        Mon, 23 Nov 2026 19:35:54 -0800 (PST)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405ecb486sm23397939a91.16.2026.11.23.19.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 19:35:53 -0800 (PST)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: tj@kernel.org
Cc: hannes@cmpxchg.org,
	mkoutny@suse.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	kolyshkin@gmail.com,
	chris@chrisdown.name,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: [PATCH 0/2] cgroup: list processes whose leader has exited where their threads are
Date: Tue, 24 Nov 2026 11:35:45 +0800
Message-ID: <20261124033547.2373352-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
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

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

This implements Tejun's suggestion in [1].  Patch 1 makes PROCS walks
visit an exited leader left behind by a cgroup.procs migration at the
first live thread of its process.  Patch 2 makes the memcg OOM group
lookup do the same.

Unlike [1], the leader does not record the destination css_set at
migration time.  The walk looks up the css_set of the first live thread
instead, because a recorded css_set goes stale when the threads move
without a cgroup.procs write.  With a version that recorded it, writing
"+pids" to the parent's cgroup.subtree_control moved the threads to a
new css_set, and dst's cgroup.procs was empty again.

/proc/$PID/cgroup still shows the leader's cgroup, so for such a
process it now differs from the cgroup whose cgroup.procs lists it.
/proc/$PID/task/$TID/cgroup of a live thread shows the new cgroup, as
before.

Tested in a 2-CPU QEMU guest with KASAN and lockdep on for-7.4-fixes
acec9637e03c.  The process has an exited leader and two live threads,
and one thread ID is written to dst/cgroup.procs:

                                   base        1/2         1/2+2/2
  dst/cgroup.procs                 empty       pid         pid
  OOM in dst                       no kill     killed      killed
  OOM in src                       moved       not killed  not killed
                                   process
                                   killed
  OOM in dst with oom.group and    other       moved       both
  another process in dst           process     process     killed
                                   killed      killed
  test_kill, 5 runs                5 failures  pass        pass

test_core, test_freezer, test_pids and test_memcontrol give the same
results as base.  Patch 2 also applies to mm-hotfixes-unstable and
mm-new.

[1] https://lore.kernel.org/all/305c5803b904a57c188b505d6ed9e1e4@kernel.org/

Zhan Xusheng (2):
  cgroup: list a process whose leader has exited where its threads are
  mm: memcontrol: find the OOM group of a process where its threads are

 include/linux/cgroup.h                     | 18 ++++++
 include/linux/sched.h                      |  2 +
 kernel/cgroup/cgroup.c                     | 66 +++++++++++++++++++++-
 mm/memcontrol.c                            |  2 +-
 tools/testing/selftests/cgroup/test_kill.c | 16 ++++--
 5 files changed, 96 insertions(+), 8 deletions(-)


base-commit: acec9637e03ca54bd3c3a0c1a6ad5c6dfa07c0df
-- 
2.43.0

