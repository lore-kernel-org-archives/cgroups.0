From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: [PATCH v2 2/2] cgroup: export list of cgroups v2 features using sysfs
Date: Mon, 6 Nov 2017 13:30:29 -0500
Message-ID: <20171106183029.21297-2-guro@fb.com>
References: <20171106173854.GE3252168@devbig577.frc2.facebook.com>
 <20171106183029.21297-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=lvC9tfX5RPvhT66URaIaBjR88/X4gTpaQiL5L6ubYoc=;
 b=jt5b4bmf5wO9YoAHPPEADs514huwlVErRSlmW9JiNyFOA16siskJZeoMg02UergeaXI1
 Uzbq7khGVmwwKVwsGyW62uv+LKonvJ55LzWWR+zuyBDJeIQ8DCV2fx2ERT2iZbzMu5w/
 mcpE79xh8sgs5usVkIsiOstBlPs7uR/3f9c= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=lvC9tfX5RPvhT66URaIaBjR88/X4gTpaQiL5L6ubYoc=;
 b=UjMjBB7E8JtxIbv3ak7S3D5ocJhQwh5Y4gV0p7IoAvJJlmb/W1OWeGDwJjm8nGF/wC3YCBe8N1q1V+KZ/V6xvkT+pDKAYzkfcC373SfFShpBxN33qZ6xabI3w3cYPrKb8E2hHgJm6jDJRr+p/kJOUX9dRq/QlxxwyHjh2IvlNk0=
In-Reply-To: <20171106183029.21297-1-guro-b10kYP2dOMg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

The active development of cgroups v2 sometimes leads to a creation
of interfaces, which are not turned on by default (to provide
backward compatibility). It's handy to know from userspace, which
cgroup v2 features are supported without calculating it based
on the kernel version. So, let's export the list of such features
using /sys/kernel/cgroup/features pseudo-file.

The list is hardcoded and has to be extended when new functionality
is added. Each feature is printed on a new line.

Example:
  $ cat /sys/kernel/cgroup/features
  nsdelegate

Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: kernel-team-b10kYP2dOMg@public.gmane.org
---
 kernel/cgroup/cgroup.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index eed92ed624e5..69e65d28fe98 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5877,8 +5877,16 @@ static ssize_t delegate_show(struct kobject *kobj, struct kobj_attribute *attr,
 }
 static struct kobj_attribute cgroup_delegate_attr = __ATTR_RO(delegate);
 
+static ssize_t features_show(struct kobject *kobj, struct kobj_attribute *attr,
+			     char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "nsdelegate\n");
+}
+static struct kobj_attribute cgroup_features_attr = __ATTR_RO(features);
+
 static struct attribute *cgroup_sysfs_attrs[] = {
 	&cgroup_delegate_attr.attr,
+	&cgroup_features_attr.attr,
 	NULL,
 };
 
-- 
2.13.6
