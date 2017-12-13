From: Roman Gushchin <guro@fb.com>
Subject: [PATCH] cgroup, docs: document cgroup v2 device controller
Date: Wed, 13 Dec 2017 19:49:03 +0000
Message-ID: <20171213194903.1265-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=u6Lx7biRpsBaG/1hvhcLS1Syvq2zT0zV7jCPb5Wb8r8=;
 b=n0o1x9S1O1I51Qh8385yfxWvlKu4Vi6ojf31DvXNUHVUTttKFLAPfT7Q+UHYg/DAr4vq
 Cb6W0WyKYgzysjlaNxAbkJP6c8wQw21rSjiwQShqO9tmSyH4jbG7NQDfhWF0SsbEZUoC
 R8SNWjgO0ompMy68IKDk+7gc48eVMYsrIZw= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=u6Lx7biRpsBaG/1hvhcLS1Syvq2zT0zV7jCPb5Wb8r8=;
 b=Re840hKHANbQqXSUx2BPdQvLEvOErB0Q6cywo7NQJr87v1Y1vzDrwOGED7KqJyvQybaV7FZhaeIEgWqoec+EkKHPRUAqDacEIcHP2bwM3xtMNnHlibfPP/HkMX9Z3xguDtE4MmVyELyojh2FIw/swJG4PpWmh/Sr0a0DAlaYQhg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org
Cc: Roman Gushchin <guro@fb.com>, Alexei Starovoitov <ast@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Add the corresponding section in cgroup v2 documentation.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: kernel-team@fb.com
Cc: cgroups@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/cgroup-v2.txt | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index 2cddab7efb20..d6efabb487e3 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -53,10 +53,11 @@ v1 is available under Documentation/cgroup-v1/.
        5-3-2. Writeback
      5-4. PID
        5-4-1. PID Interface Files
-     5-5. RDMA
-       5-5-1. RDMA Interface Files
-     5-6. Misc
-       5-6-1. perf_event
+     5-5. Device
+     5-6. RDMA
+       5-6-1. RDMA Interface Files
+     5-7. Misc
+       5-7-1. perf_event
    6. Namespace
      6-1. Basics
      6-2. The Root and Views
@@ -1429,6 +1430,30 @@ through fork() or clone(). These will return -EAGAIN if the creation
 of a new process would cause a cgroup policy to be violated.
 
 
+Device controller
+-----------------
+
+Device controller manages access to device files. It includes both
+creation of new device files (using mknod), and access to the
+existing device files.
+
+Cgroup v2 device controller has no interface files and is implemented
+on top of cgroup BPF. To control access to device files, a user may
+create bpf programs of the BPF_CGROUP_DEVICE type and attach them
+to cgroups. On an attempt to access a device file, corresponding
+BPF programs will be executed, and depending on the return value
+the attempt will succeed or fail with -EPERM.
+
+A BPF_CGROUP_DEVICE program takes a pointer to the bpf_cgroup_dev_ctx
+structure, which describes the device access attempt: access type
+(mknod/read/write) and device (type, major and minor numbers).
+If the program returns 0, the attempt fails with -EPERM, otherwise
+it succeeds.
+
+An example of BPF_CGROUP_DEVICE program may be found in the kernel
+source tree in the tools/testing/selftests/bpf/dev_cgroup.c file.
+
+
 RDMA
 ----
 
-- 
2.14.3

