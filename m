From: Aleksa Sarai <asarai@suse.de>
Subject: [PATCH 2/2] docs: cgroup/pids: update documentation to include pids.events
Date: Fri, 24 Jun 2016 13:00:49 +1000
Message-ID: <20160624030049.13341-3-asarai@suse.de>
References: <20160624030049.13341-1-asarai@suse.de>
 <20160624030049.13341-2-asarai@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160624030049.13341-2-asarai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jonathan Corbet <corbet@lwn.net>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Kenny Yu <kennyyu@fb.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Aleksa Sarai <asarai@suse.de>

So that users know what the interface and meaning of the keyed values
are. In addition, mention that the only time that since=0 is when the
limit was changed.

Signed-off-by: Aleksa Sarai <asarai@suse.de>
---
 Documentation/cgroup-v1/pids.txt | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/cgroup-v1/pids.txt b/Documentation/cgroup-v1/pids.txt
index 1a078b5d281a..a9bb7b964c6f 100644
--- a/Documentation/cgroup-v1/pids.txt
+++ b/Documentation/cgroup-v1/pids.txt
@@ -33,6 +33,11 @@ limit in the hierarchy is followed).
 pids.current tracks all child cgroup hierarchies, so parent/pids.current is a
 superset of parent/child/pids.current.
 
+pids.events shows information about the number of failed forks in a particular
+cgroup, both overall (since the cgroup was created) and recently (since the
+last limit reset). Userspace is notified of each time a process failed to fork
+in a cgroup.
+
 Example
 -------
 
@@ -83,3 +88,16 @@ sh: fork: Resource temporary unavailable
 # /bin/echo "We can't even spawn a single process now."
 sh: fork: Resource temporary unavailable
 #
+
+We can also see how many times a particular cgroup has failed to fork. For an
+example cgroup:
+
+# cat /sys/fs/cgroup/pids/some_cgroup/pids.events
+since	1
+total	12
+#
+
+This cgroup has had 12 associated process fail to fork throughout its lifetime,
+and has had 1 process fail to fork since the limit was last set. On setting the
+limit, the since counter becomes 0 and userspace is notified (this is the only
+case where since will be 0 and userspace will get a notification).
-- 
2.8.4

