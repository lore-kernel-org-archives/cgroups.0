Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.122
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793692830;
	b=X/GVheCu2tPKr7YsLPv4LlzROxyQL+hQo0HeFNfzcdCHg6ric/lKgfg6vSVxgCq7z1M2
	 bzC8EB8O35MCniftcKA0nO3Xd3S4nEsO2yDWYfCQxLFO5uk6AUqdLAE72JqCX73zekyFj
	 Dvxf3Z1S5PMlyhdxEs0OrlVSRpEMZ0469M4CSj9wQ2s/gjHxu5ZEQgQrC5Kj9g9YsxSJk
	 ZZ81pKM2HuY5Pb4AzfpCNZ6hSd633kcUa0aTnFqepYy+Z26KjfFJxfI6wdH2az4Bh65OU
	 864XTTacYsYVg7HzNtt+AlLuEm+KRlhF7/mQ8ztoYp2SC+L/sq5U4HgWF+C+RnFB/Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793692830;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ExWfLqTDEogJI0H6UanVTrI1P6KRZddzPRzGdDvI080=;
	b=y70uqegeres60ewVPbgZCTSgwIH/7PYKT1t2XjVLJ0E5rccXhkHweizmJ36apGgpuRKE
	 07Cnw06LZEOXWFSIDwjhN18Yz0vsQgfWLP0jN0B7kOVoM2uTR2oSEDCJkPUh2kyme7a53
	 mmaRSD+kEvRpeWIPvnC2hrGwXucrNkEC3E9M7IkO9xn4p3hLvnE6MR0Nsm/QRHiX4O8zc
	 ISGLy1oYcGHZm2i98cZuUJZYE6xTAlb9hcVTLafaFbkiX6bkvnARXlv8chtEQGyJ2cUlK
	 Enj61GnG5eqP1XwjV4sWrZgLHK9jIOxMar0gNoFVW7fhJZnokcXR3WvhGdtZSweH0AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=aBYDLBuS;
	arc=none smtp.remote-ip=185.125.188.122
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7671D606A33B
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 08:00:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7671D606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=aBYDLBuS
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 683843F675
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 08:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1793692822;
	bh=ExWfLqTDEogJI0H6UanVTrI1P6KRZddzPRzGdDvI080=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=aBYDLBuSl8sUkggftwsYj3VHUMlHFXed2hjvN75wWBjYKzH0BoaU2AVpdqNpPilCW
	 bog3yGHCKyLHxfKg+9N4+yw0AxJS6bVEwme1HzPvp2SseZocO3brSCp6+dJ0dQmURl
	 O1TQ7kI5BTXt19ah+PO+TlDb24fRQ5H+OWeAKvavISjn6hOoRGy1d90fI74Hz178P0
	 A6gkNbrcje98ykjprtwP4HjRY7mox1+Hzt1KJpTT6DTlP6PJLDtCwr4d7zMv857EIs
	 M5WglasMi0AZZt9G5GC9d7qggxn/idErRZ5Uhzbm/rxfktVaCfSjNJtH5QlGs104PQ
	 U5/rR1RN0hhpvp3/ijo9TWhpxMJR+MhfF5d3IK+1xLCuqsbJRQxx2CtF1k4Lls3GnK
	 iNLMHD4awaS6LAIlIAXOd53LYXWKvTc6anDZac5uYYQX8ja8Nu9fXlQbaujTciwr1/
	 u8MTPLA8WzQ+qesm/QclfXQpuqbmy6DIAx5mip4aRenwx87NhFVmFb5amm1KJThxhK
	 QalB2FVKq6WUyO5JYZhcDkqC6Sga1iTZn2XFJ0MXI3zMaNFuphmdotw1FOouQldOVP
	 7slfkC4/zhXzk9O1HnfQHmualMrRHDW+U3GMphuPYM5aMlM24+Z+JOyxpisRIabnlo
	 EvkfrgE2vE8L869UJQUJ4hHk=
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-341eff9e381so8806756eec.1
        for <cgroups@vger.kernel.org>; Tue, 03 Nov 2026 00:00:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793692821; x=1794297621;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ExWfLqTDEogJI0H6UanVTrI1P6KRZddzPRzGdDvI080=;
        b=Ric1DG3xqkeKirxFhnTXd28fGG1WqLsTET+LNV+7hCmjjJKO/yeJUp6RFnVNspRuGG
         kL3xHICYN4YAZFyo2Tc3m3jxSbaLEruZRG6GnUshxiMWIpIx732weS2toI3isvHz9p7Q
         xXjHogy4CmdPXG2U28OULz0h/d8uuDsAj+Biv7rbkp1M9brXGAkHSixDL9vBmDmuDOS+
         GTAJ1IwA+XSMehtuRnaU9RB8ECznRmRUq8cnEds2C7CvZrniSWdmzI69FCK5lStg5AhA
         u+XR9KmYZ28mEPTLMiqyirKb5qNg3LJgbOOer31Kihrk2b+6iUql0RKVm7qHUudA9pqB
         2JJw==
X-Forwarded-Encrypted: i=1; AKwUvBzRJPuV6HhEl6PDCzWOFD+MaDPLK7SwZIGfr2/20N6csP0gRMzq7CdqtXNzVokGR0dcOV6lNDy1@vger.kernel.org
X-Gm-Message-State: APuU4Z/uMxZGLN/sp6+cgyBC9kNEJmGzIrvZiluDKqeRQr304l7kFkqO
	6FxgiW/ZIZcfKAQ+0awB8+Q1OHiOR6oyxSdJqwqutkd0rnZYpKGd45CQXQ9WVb58DlBpK63em94
	WE96j1dIs4poby5v5xMv6CF3wXdOybjnseOIhFZfkTIKdNQQXvGPG1RVzwk6uEkIWWspdiU94c3
	E=
X-Gm-Gg: AYBFou3hcATVqiGCAnAteutrYoPYchZUKTQ2dQ3Hm8A5DdRN8D8eiah4orYolFAFcG9
	ChlQ2gE29nm3wXE6ox2yLMAJGhy+irbnwUVEFcHH9y20WM3uwElhIyvm9F/D6Y+xbJ5njuTz6Gf
	qsAwhJ5RvzgGlAe6bUIxjj7hU+g7ydv2H3HUfXeXN54y/jsNDeCn+HNhB9g3g0iv2VZzP+VVd2X
	x6ADrDGie8n4RunOJDA+FbRcDRs25nvcizPavhhhv7ZxJhv5oICWW9ozlNXeDOVkiJH43Lc5tQv
	NSldmFBYVdfGynlLSzbm00aPABM/+JTpF83SlB2Zjc95HXF2Dya8mub6f2w2pkrwceCTwxxxlXw
	osYXyPnUc7zU7MeSnsy5GMc22WTYMvZ1mmU+h3Zx53LJr93XHOFc6Ae4LIs3hZXfqGLNJWtvtBM
	r9wWlRonRLHYR4C11hcA==
X-Received: by 2002:a05:693c:8811:10b0:35e:da0a:75b0 with SMTP id 5a478bee46e88-36a423be72amr18895979eec.25.1793692820497;
        Tue, 03 Nov 2026 00:00:20 -0800 (PST)
X-Received: by 2002:a05:693c:8811:10b0:35e:da0a:75b0 with SMTP id 5a478bee46e88-36a423be72amr18895911eec.25.1793692819841;
        Tue, 03 Nov 2026 00:00:19 -0800 (PST)
Received: from Garunix (122-58-163-222-fibre.sparkbb.co.nz. [122.58.163.222])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af4e6sm37885274eec.4.2026.11.03.00.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 00:00:19 -0800 (PST)
From: Matthew Ruffell <matthew.ruffell@canonical.com>
To: Waiman Long <longman@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Caron Wills <caron.wills@pulsar.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [PATCH 1/6] sched/isolation: Consider nohz_full CPUs isolated in cpu_is_isolated() again
Date: Tue,  3 Nov 2026 20:59:35 +1300
Message-ID: <20261103075940.110308-2-matthew.ruffell@canonical.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103075940.110308-1-matthew.ruffell@canonical.com>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
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

From: Caron Wills <caron.wills@pulsar.com>

Commit 1c3329df409b ("sched/isolation: Remove HK_TYPE_TICK test from
cpu_is_isolated()") reduced cpu_is_isolated() to a HK_TYPE_DOMAIN test on
the assumption that "it doesn't make sense to use nohz_full without also
isolating the related CPUs from the domain topology", i.e. that every
nohz_full CPU is also domain isolated.

The kernel does not enforce that assumption. "nohz_full=<list>" and
"isolcpus=nohz,<list>" are accepted and documented on their own, and
deployments exist that deliberately keep the nohz_full CPUs inside the
scheduler domains, for example the AWS c8a.metal-48xl systems of
LP: #2165410, booted with

  isolcpus=nohz,18-95,108-178 nohz_full=18-95,108-178 rcu_nocbs=18-95,108-178

On such a system cpu_is_isolated() is now false for every CPU and all of
its users silently lost their isolation awareness compared to v6.8, which
also tested HK_TYPE_TICK:

  - fs/buffer.c bh_lru_install() caches buffer_heads on the nohz_full
    CPUs again, so has_bh_in_lru() makes __lru_add_drain_all() queue
    drain work on them;
  - mm/vmstat.c vmstat_shepherd() queues vmstat_update on them again;
  - mm/memcontrol.c schedule_drain_work() queues memcg stock drains on
    them again;
  - block/blk-mq.c keeps them in hctx->cpumask.

Per-CPU work queued on a nohz_full CPU that runs a SCHED_FIFO busy loop
never executes, and the flush_work() callers hang behind it. This is one
half of the PID 1 D-state stall described in LP: #2165410.

Test HK_TYPE_KERNEL_NOISE (the housekeeping type set by nohz_full= and
isolcpus=nohz, of which HK_TYPE_TICK is an alias) in addition to
HK_TYPE_DOMAIN, and use the housekeeping_cpu() wrapper so that systems
without any CPU isolation keep paying nothing but a patched-out static
branch. On systems where the nohz_full CPUs are also domain isolated
nothing changes.

Fixes: 1c3329df409b ("sched/isolation: Remove HK_TYPE_TICK test from cpu_is_isolated()")
Link: https://bugs.launchpad.net/bugs/2165410
Signed-off-by: Caron Wills <caron.wills@pulsar.com>
Signed-off-by: Matthew Ruffell <matthew.ruffell@canonical.com>
---
 include/linux/sched/isolation.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index cf0fd03dd7a2..294c508b0018 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -84,9 +84,17 @@ static inline bool housekeeping_cpu(int cpu, enum hk_type type)
 	return true;
 }
 
+/*
+ * A CPU is isolated if it has been taken out of the scheduler domains
+ * (isolcpus=domain or a cpuset isolated partition) or out of kernel noise
+ * (nohz_full= or isolcpus=nohz). The latter does not imply the former:
+ * the kernel accepts nohz_full CPUs that are still part of the scheduler
+ * domains, and deferred per-CPU work must not target those CPUs either.
+ */
 static inline bool cpu_is_isolated(int cpu)
 {
-	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN);
+	return !housekeeping_cpu(cpu, HK_TYPE_DOMAIN) ||
+	       !housekeeping_cpu(cpu, HK_TYPE_KERNEL_NOISE);
 }
 
 #endif /* _LINUX_SCHED_ISOLATION_H */
-- 
2.55.0

