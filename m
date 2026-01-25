Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3402F3622;
	Sun, 25 Jan 2026 22:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769381306; cv=none; b=FU8utDYklHTrN9gY+8k19xm05yyJyISxSorJ3gLFiPIfMqyz3Gqhp6g/wRpNCp820FtFuX8l3sAV8nqXWJsy98KE3ct4J7SFzvSiO/4aQwbLv26b2kxft1WozCeHA+IlJLDuXtUQ2GfEaWLuzLhvtVUVnxKEpZAKP3bJxAJFWvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769381306; c=relaxed/simple;
	bh=1KNWx87QTGRb7i2dGJVg+gYyletvaK/k+GQ/bIy3PfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nO6rQf4+nocuTWF2sZ3FmXyAAtkc0Gp+jVZyzytjC5v2hcq0Zs3f65nKOfPr74lq4FqCvaSooAyDcoK8m5iI6gCypWB8ZNEImF2Y/nFuNplIqeNK1177ulJKCSe2d9g5MfVZ3QCEDXycApzPdhJeKdpKqdR+K6/yED+2WmKa8OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WiokbWY+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WiokbWY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D7DC19425;
	Sun, 25 Jan 2026 22:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381306;
	bh=1KNWx87QTGRb7i2dGJVg+gYyletvaK/k+GQ/bIy3PfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WiokbWY+u72D6ZGtYKo/OejDhCbcUqCRW/Ivk54y8e59YMvltE6LmCSSlZrvA8P3I
	 6533dVvqWDSARpKKhgZXSIH72E2CbBiqihh/IqGhW6IPa4I/961XuV77GnI9QSY3Tf
	 wNow3A9qvtm2p7ZVWY4n8JyrVrgbRLGQklV+793Dg1WHR6Pc8W6pddLNM4lAOAeZ9m
	 fLORz+IDKeCldynaM9+BMlVges/4tcKZn7jJxWhO501pASCEFErJHshoUU6sjNsv4i
	 S2abbTLmRK73kWuAb2arxixwfUPO4O7J2fCOjEHn+OAleh3vPMqvugS5gwfJIcyM7y
	 RP4+wnYr93doA==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 19/33] cpuset: Propagate cpuset isolation update to timers through housekeeping
Date: Sun, 25 Jan 2026 23:45:26 +0100
Message-ID: <20260125224541.50226-20-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Until now, cpuset would propagate isolated partition changes to
timer migration so that unbound timers don't get migrated to isolated
CPUs.

Since housekeeping now centralizes, synchronize and propagates isolation
cpumask changes, perform the work from that subsystem for consolidation
and consistency purposes.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/cgroup/cpuset.c   | 3 ---
 kernel/sched/isolation.c | 4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 6309ec5d7b2a..080fa2fb10c7 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1485,9 +1485,6 @@ static void update_isolation_cpumasks(void)
 	ret = housekeeping_update(isolated_cpus);
 	WARN_ON_ONCE(ret < 0);
 
-	ret = tmigr_isolated_exclude_cpumask(isolated_cpus);
-	WARN_ON_ONCE(ret < 0);
-
 	isolated_cpus_updating = false;
 }
 
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 5bcb6d760f20..a30d19b641f7 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -149,9 +149,13 @@ int housekeeping_update(struct cpumask *isol_mask)
 	pci_probe_flush_workqueue();
 	mem_cgroup_flush_workqueue();
 	vmstat_flush_workqueue();
+
 	err = workqueue_unbound_housekeeping_update(housekeeping_cpumask(HK_TYPE_DOMAIN));
 	WARN_ON_ONCE(err < 0);
 
+	err = tmigr_isolated_exclude_cpumask(isol_mask);
+	WARN_ON_ONCE(err < 0);
+
 	kfree(old);
 
 	return 0;
-- 
2.51.1

