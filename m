From: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Subject: [RFC v0 3/4] net: Move in_interrupt() check one function call up
Date: Mon, 16 Apr 2012 17:35:05 +0200
Message-ID: <1334590506-19462-4-git-send-email-wagi@monom.org>
References: <1334590506-19462-1-git-send-email-wagi@monom.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334590506-19462-1-git-send-email-wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, Thomas Graf <tgraf-G/eBtMaohhA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

From: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>

task_cls_classid() will return 0 when in_interrupt() is true. This
means the caller can not destinguish between the real classid 0 and
the in_interrupt() case.

Signed-off-by: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
CC: Thomas Graf <tgraf-G/eBtMaohhA@public.gmane.org>
CC: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CC: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/net/cls_cgroup.h |    6 ------
 net/core/sock.c          |    3 +++
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/net/cls_cgroup.h b/include/net/cls_cgroup.h
index a4dc5b0..152b0eb 100644
--- a/include/net/cls_cgroup.h
+++ b/include/net/cls_cgroup.h
@@ -29,9 +29,6 @@ static inline u32 task_cls_classid(struct task_struct *p)
 {
 	int classid;
 
-	if (in_interrupt())
-		return 0;
-
 	rcu_read_lock();
 	classid = container_of(task_subsys_state(p, net_cls_subsys_id),
 			       struct cgroup_cls_state, css)->classid;
@@ -47,9 +44,6 @@ static inline u32 task_cls_classid(struct task_struct *p)
 	int id;
 	u32 classid = 0;
 
-	if (in_interrupt())
-		return 0;
-
 	rcu_read_lock();
 	id = rcu_dereference_index_check(net_cls_subsys_id,
 					 rcu_read_lock_held());
diff --git a/net/core/sock.c b/net/core/sock.c
index 50c9d02..03dfaac 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1180,6 +1180,9 @@ void sock_update_classid(struct sock *sk)
 {
 	u32 classid;
 
+	if (in_interrupt())
+		return;
+
 	classid = task_cls_classid(current);
 	if (classid && classid != sk->sk_classid)
 		sk->sk_classid = classid;
-- 
1.7.10.130.g36e6c
