From: Juri Lelli <juri.lelli@redhat.com>
Subject: [PATCH v7 6/7] cgroup/cpuset: Use cpuset_mutex to protect seq_show operations
Date: Wed,  3 Apr 2019 10:46:49 +0200
Message-ID: <20190403084650.4414-7-juri.lelli@redhat.com>
References: <20190403084650.4414-1-juri.lelli@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190403084650.4414-1-juri.lelli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz@infradead.org, mingo@redhat.com, rostedt@goodmis.org, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>

cpuset_common_seq_show operations atomicity is currently guarded by
callback_lock. Since these operations are initiated by userspace holding
a raw_spin_lock is not wise.

Convert the function to use cpuset_mutex to fix the problem.

Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
---
 kernel/cgroup/cpuset.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index cb5ff6ca5d2c..91ef48bbc08d 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2444,7 +2444,7 @@ static int cpuset_common_seq_show(struct seq_file *sf, void *v)
 	cpuset_filetype_t type = seq_cft(sf)->private;
 	int ret = 0;
 
-	raw_spin_lock_irq(&callback_lock);
+	mutex_lock(&cpuset_mutex);
 
 	switch (type) {
 	case FILE_CPULIST:
@@ -2466,7 +2466,7 @@ static int cpuset_common_seq_show(struct seq_file *sf, void *v)
 		ret = -EINVAL;
 	}
 
-	raw_spin_unlock_irq(&callback_lock);
+	mutex_unlock(&cpuset_mutex);
 	return ret;
 }
 
-- 
2.17.2

