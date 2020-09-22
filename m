From: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC Patch 2/2] KVM: SVM: SEV cgroup controller documentation
Date: Mon, 21 Sep 2020 17:40:24 -0700
Message-ID: <20200922004024.3699923-3-vipinsh@google.com>
References: <20200922004024.3699923-1-vipinsh@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=kaVjY3pUnRyNkcqQ+wVStnw4aNjDpVWSIpiyJwQk3hM=;
        b=NzlEG3pMa4LAPyw5A4qMlN21mE2oVkOifW4wsp0GltmmOJdRWj73QzooJxEB84Aeh7
         dwyd04/U+wB+LB+pHb2q2J6TsMz5x9WJM3GZw3qrcdILExfo1xSoRGLpskcjOjOMiYcH
         P405BPOdXAP8cd8kT1ihZkBOWSWKE33ZM7WtagvKbUuwNk4Mr6EDeyi8M6vuAEwGrbr8
         Gk2Q266kF5ND2MP+GdfP/fwrNhKxaPgBU6Y4Tp2fI4Dt/MW4CS1aq6FnfZuBSJMVc5lG
         YyNz/thr7BtjOH8GCEu3gfy8iOI1WT9e7iUYiCk1fiIDlIofQnWlD+jKYadkPUisVbcs
         V/IA==
Sender: "vipinsh via sendgmr" <vipinsh-brn8i7wjtNULry5u5tX/RU7CuiCeIGUxQQ4Iyu8u01E@public.gmane.org>
In-Reply-To: <20200922004024.3699923-1-vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: thomas.lendacky-5C7GfCeVMHo@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, jon.grimm-5C7GfCeVMHo@public.gmane.org, eric.vantassell-5C7GfCeVMHo@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dionna Glaze <dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Erdem Aktas <erdemaktas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

SEV cgroup controller documentation.

Documentation for both cgroup versions, v1 and v2, of SEV cgroup
controller. SEV controller is used to distribute and account SEV ASIDs
usage by KVM on AMD processor.

Signed-off-by: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reviewed-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Dionna Glaze <dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Erdem Aktas <erdemaktas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v1/sev.rst | 94 +++++++++++++++++++++
 Documentation/admin-guide/cgroup-v2.rst     | 56 +++++++++++-
 2 files changed, 147 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/admin-guide/cgroup-v1/sev.rst

diff --git a/Documentation/admin-guide/cgroup-v1/sev.rst b/Documentation/admin-guide/cgroup-v1/sev.rst
new file mode 100644
index 000000000000..04d0024360a1
--- /dev/null
+++ b/Documentation/admin-guide/cgroup-v1/sev.rst
@@ -0,0 +1,94 @@
+==============
+SEV Controller
+==============
+
+Overview
+========
+
+The SEV controller regulates the distribution of SEV ASIDs. SEV ASIDs are used
+in creating encrypted VMs on AMD processors. SEV ASIDs are stateful and one
+ASID is only used in one KVM object at a time. It cannot be used with other KVM
+before unbinding it from the previous KVM.
+
+All SEV ASIDs are tracked by this controller and it allows for accounting and
+distribution of this resource.
+
+How to Enable Controller
+========================
+
+- Enable memory encryption on AMD platform::
+
+        CONFIG_KVM_AMD_SEV=y
+
+- Enable SEV controller::
+
+        CONFIG_CGROUP_SEV=y
+
+- Above options will build SEV controller support in the kernel.
+  To mount sev controller::
+
+        mount -t cgroup -o sev none /sys/fs/cgroup/sev
+
+Interface Files
+==============
+
+  sev.current
+        A read-only single value file which exists on non-root cgroups.
+
+        The total number of SEV ASIDs currently in use by the cgroup and its
+        descendants.
+
+  sev.max
+        A read-write single value file which exists on non-root cgroups. The
+        default is "max".
+
+        SEV ASIDs usage hard limit. If the cgroup's current SEV ASIDs usage
+        reach this limit then the new SEV VMs creation will return error
+        -EBUSY.  This limit cannot be set lower than sev.current.
+
+  sev.events
+        A read-only flat-keyed single value file which exists on non-root
+        cgroups. A value change in this file generates a file modified event.
+
+          max
+                 The number of times the cgroup's SEV ASIDs usage was about to
+                 go over the max limit. This is a tally of SEV VM creation
+                 failures in the cgroup.
+
+Hierarchy
+=========
+
+SEV controller supports hierarchical accounting. It supports following
+features:
+
+1. SEV ASID usage in the cgroup includes itself and its descendent cgroups.
+2. SEV ASID usage can never exceed the max limit set in the cgroup and its
+   ancestor's chain up to the root.
+3. SEV events keep a tally of SEV VM creation failures in the cgroup and not in
+   its child subtree.
+
+Suppose the following example hierarchy::
+
+                        root
+                        /  \
+                       A    B
+                       |
+                       C
+
+1. A will show the count of SEV ASID used in A and C.
+2. C's SEV ASID usage may not exceed any of the max limits set in C, A, or
+   root.
+3. A's event file lists only SEV VM creation failed in A, and not the ones in
+   C.
+
+Migration and SEV ASID ownership
+================================
+
+An SEV ASID is charged to the cgroup which instantiated it, and stays charged
+to that cgroup until that SEV ASID is freed. Migrating a process to a different
+cgroup do not move the SEV ASID charge to the destination cgroup where the
+process has moved.
+
+Deletion of a cgroup with existing ASIDs charges will migrate those ASIDs to
+the parent cgroup.
+
diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 6be43781ec7f..66b8bdee8ff3 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -63,8 +63,11 @@ v1 is available under :ref:`Documentation/admin-guide/cgroup-v1/index.rst <cgrou
        5-7-1. RDMA Interface Files
      5-8. HugeTLB
        5.8-1. HugeTLB Interface Files
-     5-8. Misc
-       5-8-1. perf_event
+     5-9 SEV
+       5-9-1 SEV Interface Files
+       5-9-2 SEV ASIDs Ownership
+     5-10. Misc
+       5-10-1. perf_event
      5-N. Non-normative information
        5-N-1. CPU controller root cgroup process behaviour
        5-N-2. IO controller root cgroup process behaviour
@@ -2109,6 +2112,54 @@ HugeTLB Interface Files
 	are local to the cgroup i.e. not hierarchical. The file modified event
 	generated on this file reflects only the local events.
 
+SEV
+---
+
+The SEV controller regulates the distribution of SEV ASIDs. SEV ASIDs are used
+in creating encrypted VMs on AMD processors. SEV ASIDs are stateful and one
+ASID is only used in one KVM object at a time. It cannot be used with other KVM
+before unbinding it from the previous KVM.
+
+All SEV ASIDs are tracked by this controller and it allows for accounting and
+distribution of this resource.
+
+SEV Interface Files
+~~~~~~~~~~~~~~~~~~~
+
+  sev.current
+        A read-only single value file which exists on non-root cgroups.
+
+        The total number of SEV ASIDs currently in use by the cgroup and its
+        descendants.
+
+  sev.max
+        A read-write single value file which exists on non-root cgroups. The
+        default is "max".
+
+        SEV ASIDs usage hard limit. If the cgroup's current SEV ASIDs usage
+        reach this limit then the new SEV VMs creation will return error
+        -EBUSY.  This limit cannot be set lower than sev.current.
+
+  sev.events
+        A read-only flat-keyed single value file which exists on non-root
+        cgroups. A value change in this file generates a file modified event.
+
+          max
+                 The number of times the cgroup's SEV ASIDs usage was about to
+                 go over the max limit. This is a tally of SEV VM creation
+                 failures in the cgroup.
+
+SEV ASIDs Ownership
+~~~~~~~~~~~~~~~~~~~
+
+An SEV ASID is charged to the cgroup which instantiated it, and stays charged
+to the cgroup until the ASID is freed. Migrating a process to a different
+cgroup do not move the SEV ASID charge to the destination cgroup where the
+process has moved.
+
+Deletion of a cgroup with existing ASIDs charges will migrate those ASIDs to
+the parent cgroup.
+
 Misc
 ----
 
@@ -2120,7 +2171,6 @@ automatically enabled on the v2 hierarchy so that perf events can
 always be filtered by cgroup v2 path.  The controller can still be
 moved to a legacy hierarchy after v2 hierarchy is populated.
 
-
 Non-normative information
 -------------------------
 
-- 
2.28.0.681.g6f77f65b4e-goog

