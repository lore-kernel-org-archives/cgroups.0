From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/14] device_cgroup: use css_has_online_children() instead of has_children()
Date: Fri,  9 May 2014 17:31:30 -0400
Message-ID: <1399671091-23867-14-git-send-email-tj@kernel.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xwX+SW6CMneekRj5U56s/MDVLUsFmmXsH8lSBX/dOgk=;
        b=hI+AzWeFQ57jFHinUyPQ/M2StDjPncTkfQnrYreHM9FyGTJbUzpURVnF60p7ziir+q
         xmN99Q6ipx89Fas8yML1JZwGQSRMP9jS4S/467EnJVnHrQPBygZSsE4OK0+1wgvOYQEF
         pqZuDteKxNVbLTBR3nQ4Uo5I67ytRomULbK//KPO8BIklFd4DqNrUUymg64iJ8KwaGDv
         cbtHCpRdbjegxEmNBdHgfcJlR6+QsbFHPRGcJZ1mb3Xj79q5O6oKh/MzxBj3edCUChAV
         lAKKsxacVF5s8Sx9GM5Ol5el9PCtAHq69kHmyNb6Fft6xIziL2F4djbFu0CW0bjpRpKq
         hz8Q==
In-Reply-To: <1399671091-23867-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org, Tejun Heo <tj@kernel.org>, Aristeu Rozanski <aris@redhat.com>, Serge Hallyn <serge.hallyn@ubuntu.com>

devcgroup_update_access() wants to know whether there are child
cgroups which are online and visible to userland and has_children()
may return false positive.  Replace it with css_has_online_children().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Aristeu Rozanski <aris@redhat.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>
---
 security/device_cgroup.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 75b4b18..22de334 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -475,21 +475,6 @@ static int propagate_exception(struct dev_cgroup *devcg_root,
 	return rc;
 }
 
-static inline bool has_children(struct dev_cgroup *devcgroup)
-{
-	bool ret;
-
-	/*
-	 * FIXME: There may be lingering offline csses and this function
-	 * may return %true when there isn't any userland-visible child
-	 * which is incorrect for our purposes.
-	 */
-	rcu_read_lock();
-	ret = css_next_child(NULL, &devcgroup->css);
-	rcu_read_unlock();
-	return ret;
-}
-
 /*
  * Modify the exception list using allow/deny rules.
  * CAP_SYS_ADMIN is needed for this.  It's at least separate from CAP_MKNOD
@@ -522,7 +507,7 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 	case 'a':
 		switch (filetype) {
 		case DEVCG_ALLOW:
-			if (has_children(devcgroup))
+			if (css_has_online_children(&devcgroup->css))
 				return -EINVAL;
 
 			if (!may_allow_all(parent))
@@ -538,7 +523,7 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 				return rc;
 			break;
 		case DEVCG_DENY:
-			if (has_children(devcgroup))
+			if (css_has_online_children(&devcgroup->css))
 				return -EINVAL;
 
 			dev_exception_clean(devcgroup);
-- 
1.9.0
