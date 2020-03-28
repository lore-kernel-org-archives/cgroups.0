From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] docs: cgroup-v1: Document the cpuset_v2_mode mount option
Date: Fri, 27 Mar 2020 21:47:48 -0400
Message-ID: <20200328014748.24140-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585360084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=R6EnIywgtvf71A2eQ8RWwmDn7nSMDNR47JwHxvv8GsI=;
        b=JLVCN+FaHNlj63PuPY4EzSZ5/CsZMtCettThVTi2QIAkVeYa3kI76OsGCagi0AvTv2cE2+
        djSy97izBSIXZ1jCkCpTCN8L0f6Yb1QXWrS+TxQYzmD2MfrzlUZR7oJeFIidrehy72F0g5
        +sByiJ1niCpcor4HJSZh2WTAw4F+ZKc=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

The cpuset in cgroup v1 accepts a special "cpuset_v2_mode" mount
option that make cpuset.cpus and cpuset.mems behave more like those in
cgroup v2.  Document it to make other people more aware of this feature
that can be useful in some circumstances.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v1/cpusets.rst | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v1/cpusets.rst b/Documentation/admin-guide/cgroup-v1/cpusets.rst
index 86a6ae995d54..7ade3abd342a 100644
--- a/Documentation/admin-guide/cgroup-v1/cpusets.rst
+++ b/Documentation/admin-guide/cgroup-v1/cpusets.rst
@@ -223,6 +223,17 @@ cpu_online_mask using a CPU hotplug notifier, and the mems file
 automatically tracks the value of node_states[N_MEMORY]--i.e.,
 nodes with memory--using the cpuset_track_online_nodes() hook.
 
+The cpuset.effective_cpus and cpuset.effective_mems files are
+normally read-only copies of cpuset.cpus and cpuset.mems files
+respectively.  If the cpuset cgroup filesystem is mounted with the
+special "cpuset_v2_mode" option, the behavior of these files will become
+similar to the corresponding files in cpuset v2.  In other words, hotplug
+events will not change cpuset.cpus and cpuset.mems.  Those events will
+only affect cpuset.effective_cpus and cpuset.effective_mems which show
+the actual cpus and memory nodes that are currently used by this cpuset.
+See Documentation/admin-guide/cgroup-v2.rst for more information about
+cpuset v2 behavior.
+
 
 1.4 What are exclusive cpusets ?
 --------------------------------
-- 
2.18.1

