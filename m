From: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup, doc: make cgroup_disable doc accurater
Date: Sat, 31 Aug 2013 14:34:11 +0800
Message-ID: <52218E63.4060302@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

In doc, it said that 'Currently supported controllers - "memory"',
but actually we can use cgroup_disable=cpu,cpuset and all other
controllers, so this is confusing for cgroup users without much
cgroup knowledge. We need to make it clear.

[some comments copied from Paul Menage's original patch 8bab8dded]

Signed-off-by: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 Documentation/kernel-parameters.txt | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 2fe6e76..14bb96e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -460,7 +460,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.

 	cgroup_disable= [KNL] Disable a particular controller
 			Format: {name of the controller(s) to disable}
-				{Currently supported controllers - "memory"}
+			The effects of cgroup_disable=foo are:
+			- foo isn't auto-mounted if you mount all cgroups in
+			  a single hierarchy
+			- foo isn't visible as an individually mountable
+			  subsystem
+			{Currently only "memory" controller deal with this and
+			cut the overhead, others just disable the usage. So
+			only cgroup_disable=memory is actually worthy}

 	checkreqprot	[SELINUX] Set initial checkreqprot flag value.
 			Format: { "0" | "1" }
-- 
1.8.3
