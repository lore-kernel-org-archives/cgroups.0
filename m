From: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH 4/4] devcg: try to reapply local settings
Date: Thu, 15 Aug 2013 11:34:14 -0400
Message-ID: <1376580854-30929-5-git-send-email-aris@redhat.com>
References: <1376580854-30929-1-git-send-email-aris@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376580854-30929-1-git-send-email-aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

From: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Whenever there's a change in parent's rules, try to apply the locally
set rules. For now, local and parent's behavior must match.

Signed-off-by: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 security/device_cgroup.c |   83 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 82 insertions(+), 1 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 7f55bb7..5996888 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -497,7 +497,7 @@ static int propagate_exception(struct dev_cgroup *devcg_root,
 		    active_behavior(devcg) == DEVCG_DEFAULT_ALLOW) {
 			rc = dev_exception_add(active_exceptions(devcg), ex);
 			if (rc)
-				break;
+				goto out;
 		} else {
 			/*
 			 * in the other possible cases:
@@ -513,6 +513,73 @@ static int propagate_exception(struct dev_cgroup *devcg_root,
 	}
 
 	rcu_read_unlock();
+
+out:
+	return rc;
+}
+
+/**
+ * apply_local_rules - apply locally set rules if permitted by parent's rules
+ * @devcg: cgroup which local rules will be exceptions will be checked
+ * returns: 0 in case of success or error code
+ */
+static int apply_local_rules(struct dev_cgroup *devcg)
+{
+	struct dev_exception_item *ex;
+	struct list_head *this, *tmp;
+	int rc = 0;
+
+	if (active_behavior(devcg) != local_behavior(devcg))
+		return rc;
+
+	list_for_each_safe(this, tmp, local_exceptions(devcg)) {
+		ex = container_of(this, struct dev_exception_item, list);
+		if (parent_has_perm(devcg, ex)) {
+			rc = dev_exception_add(active_exceptions(devcg), ex);
+			if (rc)
+				break;
+		}
+	}
+
+	return rc;
+}
+
+/**
+ * apply_local_rules_tree - scans a dev_cgroup and its descendents for local
+ * 			    rules that might be used. This is called after
+ * 			    devcg gets access to more devices.
+ * @devcg_root: the first cgroup to be checked
+ * returns: 0 in case of success or error code
+ */
+static int apply_local_rules_tree(struct dev_cgroup *devcg_root)
+{
+	struct cgroup_subsys_state *pos;
+	int rc = 0;
+
+	rcu_read_lock();
+
+	css_for_each_descendant_pre(pos, &devcg_root->css) {
+		struct dev_cgroup *devcg = css_to_devcgroup(pos);
+
+		/*
+		 * Because devcgroup_mutex is held, no devcg will become
+		 * online or offline during the tree walk (see on/offline
+		 * methods), and online ones are safe to access outside RCU
+		 * read lock without bumping refcnt.
+		 */
+		if (pos == &devcg_root->css || !is_devcg_online(devcg))
+			continue;
+
+		rcu_read_unlock();
+
+		rc = apply_local_rules(devcg);
+		if (rc)
+			goto out;
+
+		rcu_read_lock();
+	}
+	rcu_read_unlock();
+out:
 	return rc;
 }
 
@@ -676,7 +743,17 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 			return 0;
 		}
 		rc = dev_exception_add(active_exceptions(devcgroup), &ex);
+		if (rc)
+			break;
+		if (local_behavior(devcgroup) == DEVCG_DEFAULT_NONE)
+			local_behavior(devcgroup) = active_behavior(devcgroup);
 		rc = dev_exception_add(local_exceptions(devcgroup), &ex);
+		if (rc)
+			break;
+		/* whenever a cgroup gains access to something else, it's time
+		 * to re-evaluate if it's possible to apply any new local
+		 * settings that aren't in effect */
+		rc = apply_local_rules_tree(devcgroup);
 		break;
 	case DEVCG_DENY:
 		/*
@@ -689,6 +766,10 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 			dev_exception_rm(local_exceptions(devcgroup), &ex);
 		} else {
 			rc = dev_exception_add(active_exceptions(devcgroup), &ex);
+			if (rc)
+				break;
+			if (local_behavior(devcgroup) == DEVCG_DEFAULT_NONE)
+				local_behavior(devcgroup) = active_behavior(devcgroup);
 			rc = dev_exception_add(local_exceptions(devcgroup), &ex);
 		}
 
-- 
1.7.1
