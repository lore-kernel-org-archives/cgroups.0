From: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH linux-next] cgroup: fix suspicious rcu_dereference_check() usage warning
Date: Sat,  5 Mar 2022 11:41:03 +0800
Message-ID: <20220305034103.57123-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g3T8Wrd1J7uGYe15NcawUAYKxW858bm+7idoDqUxKYI=;
        b=MyaYOjbzKClchfYsPyWtaapwj4xAq3tSb4HBkNNsRnhNYZTuEomnmeMB4qHMTVEYLf
         u7IYfAxFrljMrpJ5U148gK8VLJL8mZSazH5MslieGV4nb3kyeUTiGa7Le9jFztpUzjPK
         /hFELLvBajcg0wrFpUDLEEcuWt67POL2MCKy4HISQ5W20yghK4E1lQto1s/O6WhNLUml
         x2J/ZSdWA4XoA655TSnAWldBccQGT4aQZt8nvqrNXarkACbhsq73irzwEX68lHfzexAs
         UfWnSYy8uEi56AwIIHiEHgvVM2lzs7CBRtb0eAmi3EwVdwpMJSA6Xu5kZ53n6czbV3An
         tJ3w==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Linux Kernel Functional Testing <lkft-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, syzbot+16e3f2c77e7c5a0113f9-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org, Zhouyi Zhou <zhouzhouyi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

task_css_set_check() will use rcu_dereference_check() to check for
rcu_read_lock_held() on the read-side, which is not true after commit
dc6e0818bc9a ("sched/cpuacct: Optimize away RCU read lock"). This
commit drop explicit rcu_read_lock(), change to RCU-sched read-side
critical section. So fix the RCU warning by adding check for
rcu_read_lock_sched_held().

Fixes: dc6e0818bc9a ("sched/cpuacct: Optimize away RCU read lock")
Reported-by: Linux Kernel Functional Testing <lkft-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Reported-by: syzbot+16e3f2c77e7c5a0113f9-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Tested-by: Zhouyi Zhou <zhouzhouyi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 include/linux/cgroup.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 1e356c222756..0d1ada8968d7 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -450,6 +450,7 @@ extern struct mutex cgroup_mutex;
 extern spinlock_t css_set_lock;
 #define task_css_set_check(task, __c)					\
 	rcu_dereference_check((task)->cgroups,				\
+		rcu_read_lock_sched_held() ||				\
 		lockdep_is_held(&cgroup_mutex) ||			\
 		lockdep_is_held(&css_set_lock) ||			\
 		((task)->flags & PF_EXITING) || (__c))
-- 
2.20.1

