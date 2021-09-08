From: ArthurChiao <sjtuyananzhao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RESEND] cgroupv2, docs: fix misinformation in "device controller" section
Date: Wed,  8 Sep 2021 16:08:15 +0800
Message-ID: <20210908080815.130952-1-arthurchiao@hotmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y+Q+aEeekHfF1o1bJCRwVNKDlh1bJxhJjIkMXUIhHF8=;
        b=VpWYEJ2o4h481bAFIQ5qyBeYNfgFYaJLk+dCVV0gzxsAsUFZtIphsslnx9UiWQiAFu
         1FjXww2jU/tAdltUiT83KbiCXks5DsJgVc8aOS4Uit2qf774Np8ZHOJIn9cFc+aeZgOL
         VzHyAPqtEM0eKlZztGvC5JxEPZIAQqurzu06+/THFGdXluUo+goGHbgptXxFBaiHM7rx
         MLSpMngYM9VDUUaBX4zK0N0ni0EU7TXXHfa/9EeNhmM1LOPkPjNex0FtOcaHRRM8a5FM
         65+UyXxeel4G9bOwbNpujyP3R8G20vTYLKcXEqwaNAilpmPK6jlaIyMSC/5gInI2T3SJ
         AmBQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ArthurChiao <arthurchiao-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>

Hotmail was rejected by the mailing list, switched to gmail to resend.

1. Clarify cgroup BPF program type and attach type;
2. Fix file path broken.

Signed-off-by: ArthurChiao <arthurchiao-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 26 ++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 5c7377b5bd3e..ad83f87a042c 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2159,19 +2159,19 @@ existing device files.
 
 Cgroup v2 device controller has no interface files and is implemented
 on top of cgroup BPF. To control access to device files, a user may
-create bpf programs of the BPF_CGROUP_DEVICE type and attach them
-to cgroups. On an attempt to access a device file, corresponding
-BPF programs will be executed, and depending on the return value
-the attempt will succeed or fail with -EPERM.
-
-A BPF_CGROUP_DEVICE program takes a pointer to the bpf_cgroup_dev_ctx
-structure, which describes the device access attempt: access type
-(mknod/read/write) and device (type, major and minor numbers).
-If the program returns 0, the attempt fails with -EPERM, otherwise
-it succeeds.
-
-An example of BPF_CGROUP_DEVICE program may be found in the kernel
-source tree in the tools/testing/selftests/bpf/progs/dev_cgroup.c file.
+create bpf programs of type BPF_PROG_TYPE_CGROUP_DEVICE and attach
+them to cgroups with BPF_CGROUP_DEVICE flag. On an attempt to access a
+device file, corresponding BPF programs will be executed, and depending
+on the return value the attempt will succeed or fail with -EPERM.
+
+A BPF_PROG_TYPE_CGROUP_DEVICE program takes a pointer to the
+bpf_cgroup_dev_ctx structure, which describes the device access attempt:
+access type (mknod/read/write) and device (type, major and minor numbers).
+If the program returns 0, the attempt fails with -EPERM, otherwise it
+succeeds.
+
+An example of BPF_PROG_TYPE_CGROUP_DEVICE program may be found in
+tools/testing/selftests/bpf/progs/dev_cgroup.c in the kernel source tree.
 
 
 RDMA
-- 
2.25.1

