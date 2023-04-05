From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Subject: [PATCH] cgroup,freezer: hold cpu_hotplug_lock before freezer_mutex
Date: Wed, 5 Apr 2023 22:15:32 +0900
Message-ID: <695b8d1c-6b7a-91b1-6941-c459cab038b0@I-love.SAKURA.ne.jp>
References: <00000000000009483d05ec7a6b93@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <00000000000009483d05ec7a6b93-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, syzbot <syzbot+c39682e86c9d84152f93-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, syzkaller-bugs <syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>

syzbot is reporting circular locking dependency between cpu_hotplug_lock
and freezer_mutex, for commit f5d39b020809 ("freezer,sched: Rewrite core
freezer logic") replaced atomic_inc() in freezer_apply_state() with
static_branch_inc() which holds cpu_hotplug_lock.

cpu_hotplug_lock => cgroup_threadgroup_rwsem => freezer_mutex

  cgroup_file_write() {
    cgroup_procs_write() {
      __cgroup_procs_write() {
        cgroup_procs_write_start() {
          cgroup_attach_lock() {
            cpus_read_lock() {
              percpu_down_read(&cpu_hotplug_lock);
            }
            percpu_down_write(&cgroup_threadgroup_rwsem);
          }
        }
        cgroup_attach_task() {
          cgroup_migrate() {
            cgroup_migrate_execute() {
              freezer_attach() {
                mutex_lock(&freezer_mutex);
                (...snipped...)
              }
            }
          }
        }
        (...snipped...)
      }
    }
  }

freezer_mutex => cpu_hotplug_lock

  cgroup_file_write() {
    freezer_write() {
      freezer_change_state() {
        mutex_lock(&freezer_mutex);
        freezer_apply_state() {
          static_branch_inc(&freezer_active) {
            static_key_slow_inc() {
              cpus_read_lock();
              static_key_slow_inc_cpuslocked();
              cpus_read_unlock();
            }
          }
        }
        mutex_unlock(&freezer_mutex);
      }
    }
  }

Swap locking order by moving cpus_read_lock() in freezer_apply_state()
to before mutex_lock(&freezer_mutex) in freezer_change_state().

Reported-by: syzbot <syzbot+c39682e86c9d84152f93-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Link: https://syzkaller.appspot.com/bug?extid=c39682e86c9d84152f93
Suggested-by: Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>
Fixes: f5d39b020809 ("freezer,sched: Rewrite core freezer logic")
Signed-off-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
---
 kernel/cgroup/legacy_freezer.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/legacy_freezer.c b/kernel/cgroup/legacy_freezer.c
index 1b6b21851e9d..936473203a6b 100644
--- a/kernel/cgroup/legacy_freezer.c
+++ b/kernel/cgroup/legacy_freezer.c
@@ -22,6 +22,7 @@
 #include <linux/freezer.h>
 #include <linux/seq_file.h>
 #include <linux/mutex.h>
+#include <linux/cpu.h>
 
 /*
  * A cgroup is freezing if any FREEZING flags are set.  FREEZING_SELF is
@@ -350,7 +351,7 @@ static void freezer_apply_state(struct freezer *freezer, bool freeze,
 
 	if (freeze) {
 		if (!(freezer->state & CGROUP_FREEZING))
-			static_branch_inc(&freezer_active);
+			static_branch_inc_cpuslocked(&freezer_active);
 		freezer->state |= state;
 		freeze_cgroup(freezer);
 	} else {
@@ -361,7 +362,7 @@ static void freezer_apply_state(struct freezer *freezer, bool freeze,
 		if (!(freezer->state & CGROUP_FREEZING)) {
 			freezer->state &= ~CGROUP_FROZEN;
 			if (was_freezing)
-				static_branch_dec(&freezer_active);
+				static_branch_dec_cpuslocked(&freezer_active);
 			unfreeze_cgroup(freezer);
 		}
 	}
@@ -379,6 +380,7 @@ static void freezer_change_state(struct freezer *freezer, bool freeze)
 {
 	struct cgroup_subsys_state *pos;
 
+	cpus_read_lock();
 	/*
 	 * Update all its descendants in pre-order traversal.  Each
 	 * descendant will try to inherit its parent's FREEZING state as
@@ -407,6 +409,7 @@ static void freezer_change_state(struct freezer *freezer, bool freeze)
 	}
 	rcu_read_unlock();
 	mutex_unlock(&freezer_mutex);
+	cpus_read_unlock();
 }
 
 static ssize_t freezer_write(struct kernfs_open_file *of,
-- 
2.34.1

