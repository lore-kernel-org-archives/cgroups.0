From: Nikolay Borisov <nikolay.borisov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH 2/2] devcg: Allow wildcard exceptions in DENY child cgroups PSBM-144033
Date: Mon, 19 Dec 2022 13:40:52 +0200
Message-ID: <20221219114052.1582992-3-nikolay.borisov@virtuozzo.com>
References: <20221219114052.1582992-1-nikolay.borisov@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221219114052.1582992-1-nikolay.borisov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Nikolay Borisov <nikolay.borisov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

In containerized environments there arise cases where we might want to
allow wildcard exceptions when the parent cg doesn't have such. This for
example arises when systemd services are being setup in containers. In
order to allow systemd to function we must allow it to write wildcard
(i.e b *:* rwm) rules in the child group. At the same time in order not
to break the fundamental invariant of the device cgroup hierarchy that
children cannot be more permissive than their parents instead of blindly
trusting those rules, simply skip them in the child cgroup and defer to
the parent's exceptions.

For example assume we have A/B, where A has default behavior 'deny' and
B was created afterwards and subsequently also has 'deny' default
behavior. With this patch it's possible to write "b *:* rwm" in B which
would also result in EPERM when trying to access any device that doesn't
contain an exception in A:

    mkdir A
    echo "a" > A/devices.deny
    mkdir A/B
    echo "c *:*" > A/B/devices.allow <-- allows to create the exception
					 but it's essentially a noop

    echo "c 1:3 rw" > A < -- now trying to open /dev/nul (matching 1:3)
			     by a process in B would succeed.

Implementing this doesn't really break the main invariant that children
shouldn't have more access than their ancestors.

Signed-off-by: Nikolay Borisov <nikolay.borisov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 security/device_cgroup.c | 44 ++++++++++++++++++++++++++++++++--------
 1 file changed, 36 insertions(+), 8 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 2d234e7c0c70..1d91c3e9aa99 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -46,6 +46,11 @@ struct dev_cgroup {
 	enum devcg_behavior behavior;
 };

+static bool is_wildcard_exception(struct dev_exception_item *ex)
+{
+	return ex->minor == ~0 || ex->major == ~0;
+}
+
 static inline struct dev_cgroup *css_to_devcgroup(struct cgroup_subsys_state *s)
 {
 	return s ? container_of(s, struct dev_cgroup, css) : NULL;
@@ -364,16 +369,20 @@ static bool match_exception_partial(struct list_head *exceptions, short type,
  * @major: device file major number, ~0 to match all
  * @minor: device file minor number, ~0 to match all
  * @access: permission mask (DEVCG_ACC_READ, DEVCG_ACC_WRITE, DEVCG_ACC_MKNOD)
+ * @check_parent: defer wild card exception checking to parent
  *
  * It is considered a complete match if an exception is found that will
  * contain the entire range of provided parameters.
  *
  * Return: true in case it matches an exception completely
  */
-static bool match_exception(struct list_head *exceptions, short type,
-			    u32 major, u32 minor, short access)
+static bool match_exception(struct dev_cgroup *devcg, short type, u32 major,
+			    u32 minor, short access, bool check_parent)
 {
+	struct list_head *exceptions = &devcg->exceptions;
 	struct dev_exception_item *ex;
+	bool wildcard_matched = false;
+	struct cgroup_subsys_state *parent = devcg->css.parent;

 	list_for_each_entry_rcu(ex, exceptions, list) {
 		if ((type & DEVCG_DEV_BLOCK) && !(ex->type & DEVCG_DEV_BLOCK))
@@ -384,11 +393,30 @@ static bool match_exception(struct list_head *exceptions, short type,
 			continue;
 		if (ex->minor != ~0 && ex->minor != minor)
 			continue;
+		if (is_wildcard_exception(ex) && parent) {
+			wildcard_matched = true;
+			continue;
+		}
 		/* provided access cannot have more than the exception rule */
 		if (access & (~ex->access))
 			continue;
 		return true;
 	}
+
+	/* We matched a wildcard rule, so let's see if the parent allows it */
+	if (wildcard_matched && check_parent) {
+		struct dev_cgroup *devcg_parent = css_to_devcgroup(parent);
+
+		if (devcg_parent->behavior == DEVCG_DEFAULT_ALLOW)
+			/* Can't match any of the exceptions, even partially */
+			return  !match_exception_partial(&devcg_parent->exceptions,
+						      type, major, minor, access);
+		else
+			/* Need to match completely one exception to be allowed */
+			return match_exception(devcg_parent, type, major, minor,
+					       access, false);
+	}
+
 	return false;
 }

@@ -441,9 +469,8 @@ static bool verify_new_ex(struct dev_cgroup *dev_cgroup,
 		 * be contained completely in an parent's exception to be
 		 * allowed
 		 */
-		match = match_exception(&dev_cgroup->exceptions, refex->type,
-					refex->major, refex->minor,
-					refex->access);
+		match = match_exception(dev_cgroup, refex->type, refex->major,
+					refex->minor, refex->access, false);

 		if (match)
 			/* parent has an exception that matches the proposed */
@@ -755,7 +782,8 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 			break;
 		}

-		if (!parent_has_perm(devcgroup, &ex))
+		if (!is_wildcard_exception(&ex) &&
+		    !parent_has_perm(devcgroup, &ex))
 			return -EPERM;
 		rc = dev_exception_add(devcgroup, &ex);
 		break;
@@ -844,8 +872,8 @@ static int devcgroup_legacy_check_permission(short type, u32 major, u32 minor,
 					      type, major, minor, access);
 	else
 		/* Need to match completely one exception to be allowed */
-		rc = match_exception(&dev_cgroup->exceptions, type, major,
-				     minor, access);
+		rc = match_exception(dev_cgroup, type, major, minor, access,
+				     true);
 	rcu_read_unlock();

 	if (!rc)
