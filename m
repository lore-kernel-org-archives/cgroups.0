Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2280C30F53E;
	Sun, 25 Jan 2026 22:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769381331; cv=none; b=E6J45m3C+6crnE8kU+GNT2RxecELB5mAeF5Nk3q2jSZ414a9I3Qbxwh+UTtT0Q+vun3Zvezt7pZdbBh/IXcAdR6LinVvP+O5Q38j5iufz/OOJ2QQymm3NFZDWoaIi3e3AWY/+kduk4ypEOck7o2IeZ6ySlPje5UY/HPLguHVwk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769381331; c=relaxed/simple;
	bh=97q8vd09m+nJzodwGZsfdaDvcrqWHJSN7XyvoB2eWkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUATO/j/FXIZS6TUPsdFsHCCi3M471euwGQARcsB1lxyoUPbH5P6wiwk+pddvdSwCKPp8N6pCjyqZslyqGCXFT9Eqno6Ik001glgKe0S56akImLZcmOT+8nh+MMWZzlLmJcZz2Zql6GzwuEJdpoRVikL8OVrWNqQpX50NpGrmHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iWzxMvwP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iWzxMvwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A44C2BC87;
	Sun, 25 Jan 2026 22:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381331;
	bh=97q8vd09m+nJzodwGZsfdaDvcrqWHJSN7XyvoB2eWkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWzxMvwPS1SK8km3fkUM3KgJIRikD7FClNxi0QRWA5JrZfgoAG74mwdpsj77nQw7W
	 pS+cblqrXwGcEsssKQkPukfkT8uGiTsqgSu+22HsHe4DVh85FGH00kq2D7pa1DxYEH
	 3KYGi+/nHiOvpcakIiLZcJpmeXLgnPPfK6QTjgIuYcRznlaAEkzvcG1T9xHmLiE6gW
	 VhoV0F6r3pRrttIteAXMq8adrmOLmzsmN152Dd46Ig++lgee4RGIOmvFVu6kyCJL7j
	 sthW3q5UKNvsici9viFfBwMpf++h32gi9Utw5uqLE3nA9hfyEqCrVZLa3kB3gzWwBh
	 u3g2L4UmLlXyg==
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
Subject: [PATCH 22/33] sched/isolation: Remove HK_TYPE_TICK test from cpu_is_isolated()
Date: Sun, 25 Jan 2026 23:45:29 +0100
Message-ID: <20260125224541.50226-23-frederic@kernel.org>
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

It doesn't make sense to use nohz_full without also isolating the
related CPUs from the domain topology, either through the use of
isolcpus= or cpuset isolated partitions.

And now HK_TYPE_DOMAIN includes all kinds of domain isolated CPUs.

This means that HK_TYPE_DOMAIN should always be a subset of
HK_TYPE_KERNEL_NOISE (of which HK_TYPE_TICK is only an alias).

Therefore if a CPU is not HK_TYPE_DOMAIN, it shouldn't be
HK_TYPE_KERNEL_NOISE either. Testing the former is then enough.

Simplify cpu_is_isolated() accordingly.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Acked-by: Waiman Long <longman@redhat.com>
---
 include/linux/sched/isolation.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index d0fb0f647318..dc3975ff1b2e 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -82,8 +82,7 @@ static inline bool housekeeping_cpu(int cpu, enum hk_type type)
 
 static inline bool cpu_is_isolated(int cpu)
 {
-	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN) ||
-	       !housekeeping_test_cpu(cpu, HK_TYPE_TICK);
+	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN);
 }
 
 #endif /* _LINUX_SCHED_ISOLATION_H */
-- 
2.51.1

