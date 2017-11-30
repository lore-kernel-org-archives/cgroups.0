From: Roman Gushchin <guro@fb.com>
Subject: [PATCH v13 7/7] cgroup: list groupoom in cgroup features
Date: Thu, 30 Nov 2017 15:28:24 +0000
Message-ID: <20171130152824.1591-8-guro@fb.com>
References: <20171130152824.1591-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=CilNoItv+E81l8m51tTeEGvZP9AD3N+pubOpXmnqMMA=;
 b=YljOeAFXyuLLGaPRyv6KgAonEjJw7EXXPKtUOzyuf0mwb8D/C+MuDocj7Yv32ue/JBHq
 ylGZpU2V/R39uRRu9xPqmglXQuTP68NSYrbkrTyc+uKKWgqVq5hYx6y1QCTZErPiU8UO
 3k/v1wY82bbWgXs/H2nLa7Xtbozk1x4zGMY= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=CilNoItv+E81l8m51tTeEGvZP9AD3N+pubOpXmnqMMA=;
 b=Wir5HHsauWPGeThfO+jQXcMlm0S7cAdwGODjDRlKN2Lz/Nx9Zz0dOI9MPGWLWLLvRACt+xnI+iB7ns4udwV9Mrzk/M/LxQyGwGpGKy5FdaLFLls0Jxw7NxMlqrkNERopgDa6sotizuUCSNJJRjYAsnKYb/torFyDTEZD+QZxG9A=
In-Reply-To: <20171130152824.1591-1-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@vger.kernel.org
Cc: Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

List groupoom in cgroup features list (exported via
/sys/kernel/cgroup/features), which can be used by a userspace
apps (most likely, systemd) to get an idea which cgroup features
are supported by kernel.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-team@fb.com
Cc: cgroups@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 kernel/cgroup/cgroup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 7338e12979e1..693443282fc1 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5922,7 +5922,8 @@ static struct kobj_attribute cgroup_delegate_attr = __ATTR_RO(delegate);
 static ssize_t features_show(struct kobject *kobj, struct kobj_attribute *attr,
 			     char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "nsdelegate\n");
+	return snprintf(buf, PAGE_SIZE, "nsdelegate\n"
+					"groupoom\n");
 }
 static struct kobj_attribute cgroup_features_attr = __ATTR_RO(features);
 
-- 
2.14.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
