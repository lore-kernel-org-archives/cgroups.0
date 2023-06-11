From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Subject: [PATCH] cgroup,freezer: hold cpu_hotplug_lock before freezer_mutex in
 freezer_css_{online,offline}()
Date: Sun, 11 Jun 2023 22:48:12 +0900
Message-ID: <69ab449f-1981-2d53-79fb-b2ac91ea9cef@I-love.SAKURA.ne.jp>
References: <000000000000bd448705fda123f5@google.com>
 <000000000000d1565005fda9cef1@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <000000000000d1565005fda9cef1-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

syzbot is again reporting circular locking dependency between
cpu_hotplug_lock and freezer_mutex. Do like what we did with
commit 57dcd64c7e036299 ("cgroup,freezer: hold cpu_hotplug_lock
before freezer_mutex").

Reported-by: syzbot <syzbot+2ab700fe1829880a2ec6-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Closes: https://syzkaller.appspot.com/bug?extid=2ab700fe1829880a2ec6
Signed-off-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Tested-by: syzbot <syzbot+2ab700fe1829880a2ec6-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
---
 kernel/cgroup/legacy_freezer.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/legacy_freezer.c b/kernel/cgroup/legacy_freezer.c
index 936473203a6b..122dacb3a443 100644
--- a/kernel/cgroup/legacy_freezer.c
+++ b/kernel/cgroup/legacy_freezer.c
@@ -108,16 +108,18 @@ static int freezer_css_online(struct cgroup_subsys_state *css)
 	struct freezer *freezer = css_freezer(css);
 	struct freezer *parent = parent_freezer(freezer);
 
+	cpus_read_lock();
 	mutex_lock(&freezer_mutex);
 
 	freezer->state |= CGROUP_FREEZER_ONLINE;
 
 	if (parent && (parent->state & CGROUP_FREEZING)) {
 		freezer->state |= CGROUP_FREEZING_PARENT | CGROUP_FROZEN;
-		static_branch_inc(&freezer_active);
+		static_branch_inc_cpuslocked(&freezer_active);
 	}
 
 	mutex_unlock(&freezer_mutex);
+	cpus_read_unlock();
 	return 0;
 }
 
@@ -132,14 +134,16 @@ static void freezer_css_offline(struct cgroup_subsys_state *css)
 {
 	struct freezer *freezer = css_freezer(css);
 
+	cpus_read_lock();
 	mutex_lock(&freezer_mutex);
 
 	if (freezer->state & CGROUP_FREEZING)
-		static_branch_dec(&freezer_active);
+		static_branch_dec_cpuslocked(&freezer_active);
 
 	freezer->state = 0;
 
 	mutex_unlock(&freezer_mutex);
+	cpus_read_unlock();
 }
 
 static void freezer_css_free(struct cgroup_subsys_state *css)
-- 
2.18.4

