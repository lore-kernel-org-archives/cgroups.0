From: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH] cgroup/cpuset: Fix a race condition when reading cpuset.*
Date: Tue, 11 Feb 2020 14:15:54 +0000
Message-ID: <20200211141554.24181-1-qais.yousef@arm.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>

LTP cpuset_hotplug_test.sh was failing with the following error message

	cpuset_hotplug 1 TFAIL: root group's cpus isn't expected(Result: 0-5, Expect: 0,2-5).

Which is due to a race condition between cpu hotplug operation and
reading cpuset.cpus file.

When a cpu is onlined/offlined, cpuset schedules a workqueue to sync its
internal data structures with the new values. If a read happens during
this window, the user will read a stale value, hence triggering the
failure above.

To fix the issue make sure cpuset_wait_for_hotplug() is called before
allowing any value to be read, hence forcing the synchronization to
happen before the read.

I ran 500 iterations with this fix applied with no failure triggered.

Signed-off-by: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>
---

I think it's okay to flush the workqueue from the read context? We do it on the
write, so I assumed it's okay on the read too. But it'd be good to confirm it
doesn't break any rule I'm not aware of.

 kernel/cgroup/cpuset.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 58f5073acff7..593055522626 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2405,6 +2405,9 @@ static int cpuset_common_seq_show(struct seq_file *sf, void *v)
 	cpuset_filetype_t type = seq_cft(sf)->private;
 	int ret = 0;
 
+	/* Ensure all hotplug ops were done before reading any value */
+	cpuset_wait_for_hotplug();
+
 	spin_lock_irq(&callback_lock);
 
 	switch (type) {
-- 
2.17.1

