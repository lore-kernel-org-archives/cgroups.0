From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2] device_cgroup: add lockdep asserts
Date: Tue, 6 Nov 2012 09:16:53 -0800
Message-ID: <20121106171653.GI30069@mtj.dyndns.org>
References: <20121106171612.GH30069@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=nceBspheB8/jHRx+8ovFYiOT12mlvcbg6u6Wk42U29s=;
        b=iEeqNlEr4SrHNDB2dUkGem1Djf71tXfN8LthOE7W5KkyKSi7V5eOLKWehMjY9mog6T
         fDUhh/yPWGnA2NtCaKlDd+MapwjuSBuGK6psSlvikBzkDBEJGc7AA+WwtEv73jGbQ/Ou
         /DrloeC/no8Tmwp57TKq8jm2j/TFJ1AR9FvJgG8EHQ8TM4oXdQ4gWgezfC2GDqSqsp3X
         ai3RtsG5wna6otksiv6xxdsjL8Vo6XUPKEhx9F+TC5rDxJ9HDMSFvwEwDxG8zNtVjEks
         2pWKOwzUuOyDa77W0u6T0iPRSGGa8HU7ZKgi33SOrC3y4pQ3JiwC4kweMgGuESaf+vXv
         /V/Q==
Content-Disposition: inline
In-Reply-To: <20121106171612.GH30069-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

device_cgroup uses RCU safe ->exceptions list which is write-protected
by devcgroup_mutex and has had some issues using locking correctly.
Add lockdep asserts to utility functions so that future errors can be
easily detected.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
And this one through cgroup/for-3.8.

Thanks.

 security/device_cgroup.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -82,6 +82,8 @@ static int dev_exceptions_copy(struct li
 {
 	struct dev_exception_item *ex, *tmp, *new;
 
+	lockdep_assert_held(&devcgroup_mutex);
+
 	list_for_each_entry(ex, orig, list) {
 		new = kmemdup(ex, sizeof(*ex), GFP_KERNEL);
 		if (!new)
@@ -107,6 +109,8 @@ static int dev_exception_add(struct dev_
 {
 	struct dev_exception_item *excopy, *walk;
 
+	lockdep_assert_held(&devcgroup_mutex);
+
 	excopy = kmemdup(ex, sizeof(*ex), GFP_KERNEL);
 	if (!excopy)
 		return -ENOMEM;
@@ -137,6 +141,8 @@ static void dev_exception_rm(struct dev_
 {
 	struct dev_exception_item *walk, *tmp;
 
+	lockdep_assert_held(&devcgroup_mutex);
+
 	list_for_each_entry_safe(walk, tmp, &dev_cgroup->exceptions, list) {
 		if (walk->type != ex->type)
 			continue;
@@ -163,6 +169,8 @@ static void dev_exception_clean(struct d
 {
 	struct dev_exception_item *ex, *tmp;
 
+	lockdep_assert_held(&devcgroup_mutex);
+
 	list_for_each_entry_safe(ex, tmp, &dev_cgroup->exceptions, list) {
 		list_del_rcu(&ex->list);
 		kfree_rcu(ex, rcu);
@@ -298,6 +306,10 @@ static int may_access(struct dev_cgroup
 	struct dev_exception_item *ex;
 	bool match = false;
 
+	rcu_lockdep_assert(rcu_read_lock_held() ||
+			   lockdep_is_held(&devcgroup_mutex),
+			   "device_cgroup::may_access() called without proper synchronization");
+
 	list_for_each_entry_rcu(ex, &dev_cgroup->exceptions, list) {
 		if ((refex->type & DEV_BLOCK) && !(ex->type & DEV_BLOCK))
 			continue;
