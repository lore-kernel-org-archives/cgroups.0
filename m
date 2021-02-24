From: Antonio Terceiro <antonio.terceiro@linaro.org>
Subject: [PATCH] Documentation: cgroup-v2: fix path to example BPF program
Date: Wed, 24 Feb 2021 10:16:31 -0300
Message-ID: <20210224131631.349287-1-antonio.terceiro@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2QMkH64M8As4l+KSDTQdK+u4M5qrIN7PaZOHlR51wic=;
        b=QmN0FsJYiPxmCNa2Tha1APhsUK8o/7UaZLHeTlgpjASwj19luMRyZbWjrLxbXnOWSq
         QX3Widqm0McOoSM3HTXHxcQmOE55BROws/lIjp65Idz5F6TUFsQCip3AEZUVrDi4802W
         a1DgYxiomsD1lW1EmR4QuPaF4FxC5XnzYOdkw7NhBJMriRHA9/xsyO/aNXKB4gX+Akwl
         XZDq3lTBz1baGF2HPr2Zj2AtovQtHjgyajNkzw0upFslmhr/BtBhrG2tOL3fl4ZgMHp+
         eyKWP2uXQHTgp4Q/AvKzKs1YWSL4aGdSzROSCh8GqzzcYz7IiSTyQg3cPlVOLhACAypy
         MH3g==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Jiong Wang <jiong.wang@netronome.com>

This file has been moved into the "progs" subdirectory in
bd4aed0ee73ca873bef3cb3ec746dd796f03df28, together with all test BPF
programs.

Signed-off-by: Antonio Terceiro <antonio.terceiro@linaro.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jiong Wang <jiong.wang@netronome.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index c513eafaddea..befe9425d028 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2094,7 +2094,7 @@ If the program returns 0, the attempt fails with -EPERM, otherwise
 it succeeds.
 
 An example of BPF_CGROUP_DEVICE program may be found in the kernel
-source tree in the tools/testing/selftests/bpf/dev_cgroup.c file.
+source tree in the tools/testing/selftests/bpf/progs/dev_cgroup.c file.
 
 
 RDMA
-- 
2.30.1

