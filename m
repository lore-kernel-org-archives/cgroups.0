From: Andreas Ziegler <andreas.ziegler@fau.de>
Subject: [PATCH] cgroup: Fix misspelling of CONFIG_SOCK_CGROUP_DATA in comments
Date: Tue, 26 Jan 2016 15:39:18 +0100
Message-ID: <1453819158-25380-1-git-send-email-andreas.ziegler@fau.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Andreas Ziegler <andreas.ziegler@fau.de>

Commit bd1060a1d671 ("sock, cgroup: add sock->sk_cgroup") added new
code guarded by an #ifdef CONFIG_SOCK_CGROUP_DATA to
include/linux/cgroup.h.

In the comments for the corresponding #else and #endifs, however,
the option is misspelled as CONFIG_CGROUP_DATA. Fix those comments.

Signed-off-by: Andreas Ziegler <andreas.ziegler@fau.de>
---
 include/linux/cgroup.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 2162dca..48ce12f 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -604,11 +604,11 @@ static inline struct cgroup *sock_cgroup_ptr(struct sock_cgroup_data *skcd)
 #endif
 }
 
-#else	/* CONFIG_CGROUP_DATA */
+#else	/* CONFIG_SOCK_CGROUP_DATA */
 
 static inline void cgroup_sk_alloc(struct sock_cgroup_data *skcd) {}
 static inline void cgroup_sk_free(struct sock_cgroup_data *skcd) {}
 
-#endif	/* CONFIG_CGROUP_DATA */
+#endif	/* CONFIG_SOCK_CGROUP_DATA */
 
 #endif /* _LINUX_CGROUP_H */
-- 
1.9.1

