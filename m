Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF7230F551;
	Sun, 25 Jan 2026 22:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769381249; cv=none; b=Lrv92Ejqig4b2a6+NfCmMTV8j3CapSJmxbGb6b+zgPVrYPqsE8Rdky0WMI4PtdxTb8qLCMFEHfffgmgfT9UpUNzmA3hQwGNLg6BDSwfTbZxTy570i05A7WXf3NPyPssghw6YhIzEYV1+7ooMxd+a/TUnGbAGUBoRvu9iAzgg6wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769381249; c=relaxed/simple;
	bh=v9YrBjmYoXXJcaUrCVcNEergJy1rpdNBj6w7mIgdodQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dNr/7qyv2sUSdy0QEKsM4keab5Ew7UEaW1+PHRfURBpk/wyq1BCXmZMJq+9swAX+adYbz8V2RvrBhp4M73iH63X1OBQc/Pu2eOqgqjinm6//qRPgLKedenLBhmwWg3Hz6rS50sAtiD4bUckNSmQh/lliA9p0M+Cr3xWxSu+vHVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XO3eKJpi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XO3eKJpi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEF2C19425;
	Sun, 25 Jan 2026 22:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381249;
	bh=v9YrBjmYoXXJcaUrCVcNEergJy1rpdNBj6w7mIgdodQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XO3eKJpipVP4C45Ce6EDtUhF4Kpy//JomtboPzMqwpCX/glAEuwTyQX2bUD3y/T/h
	 ocneaY8G1ia5hEL0QFOEuDorsU2gPA0eJWNU4wL+oz7Ayk8pN29ZU4VvHVPUYS/U1F
	 KdTS6T2KpyzJkoOg7eGpu59CTvWxjsPzI8vF9p+DtfMHYftoPrfWlR2xxH3RHg1RGk
	 sE65qjjQVL3HbQIBqFZU0HP6K1PRny2miLAOqs5tWpoUnIHYQzcNV80SWv/8kCRaDo
	 mKVmBnCxGTjB3HTkZSqTKg1jX98GM78mHvBVwfsf/XpfP0HLCk/MazpRhN5FugcIp/
	 Zyq/n175MmaYA==
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
Subject: [PATCH 12/33] cpuset: Provide lockdep check for cpuset lock held
Date: Sun, 25 Jan 2026 23:45:19 +0100
Message-ID: <20260125224541.50226-13-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

cpuset modifies partitions, including isolated, while holding the cpuset
mutex.

This means that holding the cpuset mutex is safe to synchronize against
housekeeping cpumask changes.

Provide a lockdep check to validate that.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/linux/cpuset.h | 2 ++
 kernel/cgroup/cpuset.c | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index a98d3330385c..1c49ffd2ca9b 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -18,6 +18,8 @@
 #include <linux/mmu_context.h>
 #include <linux/jump_label.h>
 
+extern bool lockdep_is_cpuset_held(void);
+
 #ifdef CONFIG_CPUSETS
 
 /*
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3afa72f8d579..5e2e3514c22e 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -283,6 +283,13 @@ void cpuset_full_unlock(void)
 	cpus_read_unlock();
 }
 
+#ifdef CONFIG_LOCKDEP
+bool lockdep_is_cpuset_held(void)
+{
+	return lockdep_is_held(&cpuset_mutex);
+}
+#endif
+
 static DEFINE_SPINLOCK(callback_lock);
 
 void cpuset_callback_lock_irq(void)
-- 
2.51.1

