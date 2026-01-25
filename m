Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7C92F362A;
	Sun, 25 Jan 2026 22:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769381314; cv=none; b=d69r0w0zynyMz1LJCF9stQkqyoqb74P3mAsWglOXsaX6Jqml19Wcte7ZcsjVJ5Rrp7B53jpx1yko7KB46ZyvFUC4HoU1IGymyvG5uQKnHOrUXr14gUD6qndlH1hUxxoY7VIxQ1EiWBqRY6iZe0PFZl82PgPlKQXCDs2m8Nw6HAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769381314; c=relaxed/simple;
	bh=xcMcLXp9lSxfZhVrsREHiMXj3hvNw6ylCQ2N03wRKM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rI+Y8KlxuHvYwQJU80SwKeXyGIKkmeqcteTAOmiedpUnzVdgGIBJAeWFuLrDRy0QrAeWyxGcPp6UvtpvMx3zpkB7tSpLknWWgKxDAHlJf8K5T+HyRkn3p6l1HYwScrb1Zu0RTYP7hak4dHhEn62urynnqycuRNMEPLP8/TjGiQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QmeExAOs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QmeExAOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC069C2BC87;
	Sun, 25 Jan 2026 22:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381314;
	bh=xcMcLXp9lSxfZhVrsREHiMXj3hvNw6ylCQ2N03wRKM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmeExAOsPNVoad+FjY6nF+vUq/CT43QF/yEuMh6eHWpIhuE6ZhsTyd5DgYVaFdhRA
	 KSrOxbUrqW5spLkd02FS+St8WkGKBIm+v3PMxvJLp1CI21bHFT5B83sW9aoEvZd7EZ
	 wLGM69jCyrsM0H58qDzzf0R8iRbdcsrDdiowQ99KVna6CUb5V2fJVSJxg5AUF6Qw9u
	 FAWcSRhFRJXdqspv5nZhIU/oCRP5Wf0+b2FMOnlohs0YeAWa9QzyeMxmiuo5sfIrrr
	 3ETdzmebs0OLqjVcHCp0rHJFMPuaSujPyR7DCLDzl/Lv+WMKVs8eZVXX99M8M05ujn
	 feLcLjAzWadHg==
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
Subject: [PATCH 20/33] timers/migration: Remove superfluous cpuset isolation test
Date: Sun, 25 Jan 2026 23:45:27 +0100
Message-ID: <20260125224541.50226-21-frederic@kernel.org>
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

Cpuset isolated partitions are now included in HK_TYPE_DOMAIN. Testing
if a CPU is part of an isolated partition alone is now useless.

Remove the superflous test.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Waiman Long <longman@redhat.com>
---
 kernel/time/timer_migration.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/time/timer_migration.c b/kernel/time/timer_migration.c
index 3879575a4975..6da9cd562b20 100644
--- a/kernel/time/timer_migration.c
+++ b/kernel/time/timer_migration.c
@@ -466,9 +466,8 @@ static inline bool tmigr_is_isolated(int cpu)
 {
 	if (!static_branch_unlikely(&tmigr_exclude_isolated))
 		return false;
-	return (!housekeeping_cpu(cpu, HK_TYPE_DOMAIN) ||
-		cpuset_cpu_is_isolated(cpu)) &&
-	       housekeeping_cpu(cpu, HK_TYPE_KERNEL_NOISE);
+	return (!housekeeping_cpu(cpu, HK_TYPE_DOMAIN) &&
+		housekeeping_cpu(cpu, HK_TYPE_KERNEL_NOISE));
 }
 
 /*
-- 
2.51.1

