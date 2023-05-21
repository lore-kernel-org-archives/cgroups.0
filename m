From: John Sperbeck <jsperbeck-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: always put cset in cgroup_css_set_put_fork
Date: Sun, 21 May 2023 19:29:53 +0000
Message-ID: <20230521192953.229715-1-jsperbeck@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684697418; x=1687289418;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QsimBcbFkkOqpywwSH5EJmOyk1K46aweYARqzOVnpbQ=;
        b=AwAik3WBbsct7NHTK6mPHFMdHYq0nx82//vVz1V6opRw5i8IPg0Ue9Coqr0iV4/bk+
         SD6HHE9uIf5r3eg6/MKyA7eUk8I3MrANEz+hkV7gQhVeURby/SVKQW7nV6gOc+y9lHLJ
         RscGr1/QqfmQMCRw7KydEfjk4FTpyhkfgP/XVgY0tXk+VgTH4yy7+98lBP5r3iFKoCty
         YOtb/qJ71FZIuoLQEP6DhJRGVOiVLDob2y2gMupeXKSi0qwe3K1IW/NHW9plCPo/jRfI
         4J5Qyf6tlrDYkWoIKf+67HIDR+H14iGWbAx4tRshmD8zE50IlDQDS3OttxBrWj3+YGQL
         V50w==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Sperbeck <jsperbeck-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

A successful call to cgroup_css_set_fork() will always have taken
a ref on kargs->cset (regardless of CLONE_INTO_CGROUP), so always
do a corresponding put in cgroup_css_set_put_fork().

Without this, a cset and its contained css structures will be
leaked for some fork failures.  The following script reproduces
the leak for a fork failure due to exceeding pids.max in the
pids controller.  A similar thing can happen if we jump to the
bad_fork_cancel_cgroup label in copy_process().

[ -z "$1" ] && echo "Usage $0 pids-root" && exit 1
PID_ROOT=$1
CGROUP=$PID_ROOT/foo

[ -e $CGROUP ] && rmdir -f $CGROUP
mkdir $CGROUP
echo 5 > $CGROUP/pids.max
echo $$ > $CGROUP/cgroup.procs

fork_bomb()
{
	set -e
	for i in $(seq 10); do
		/bin/sleep 3600 &
	done
}

(fork_bomb) &
wait
echo $$ > $PID_ROOT/cgroup.procs
kill $(cat $CGROUP/cgroup.procs)
rmdir $CGROUP

Fixes: ef2c41cf38a7 ("clone3: allow spawning processes into cgroups")
Signed-off-by: John Sperbeck <jsperbeck-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 625d7483951c..245cf62ce85a 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6486,19 +6486,18 @@ static int cgroup_css_set_fork(struct kernel_clone_args *kargs)
 static void cgroup_css_set_put_fork(struct kernel_clone_args *kargs)
 	__releases(&cgroup_threadgroup_rwsem) __releases(&cgroup_mutex)
 {
+	struct cgroup *cgrp = kargs->cgrp;
+	struct css_set *cset = kargs->cset;
+
 	cgroup_threadgroup_change_end(current);
 
-	if (kargs->flags & CLONE_INTO_CGROUP) {
-		struct cgroup *cgrp = kargs->cgrp;
-		struct css_set *cset = kargs->cset;
+	if (cset) {
+		put_css_set(cset);
+		kargs->cset = NULL;
+	}
 
+	if (kargs->flags & CLONE_INTO_CGROUP) {
 		cgroup_unlock();
-
-		if (cset) {
-			put_css_set(cset);
-			kargs->cset = NULL;
-		}
-
 		if (cgrp) {
 			cgroup_put(cgrp);
 			kargs->cgrp = NULL;
-- 
2.40.1.698.g37aff9b760-goog

