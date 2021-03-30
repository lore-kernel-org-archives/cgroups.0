From: Vipin Sharma <vipinsh@google.com>
Subject: [PATCH v4 2/3] cgroup: Miscellaneous cgroup documentation.
Date: Mon, 29 Mar 2021 21:42:05 -0700
Message-ID: <20210330044206.2864329-3-vipinsh@google.com>
References: <20210330044206.2864329-1-vipinsh@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZG5QUoyChvalUArlsvwS9b7o5aZFFyWCCkEpBVXhtkU=;
        b=T1kmeXfP5qGSZ6kep4Ip7I39cg7FJgeB41AxNkyrCF1cJOe35DF0q4XjnSJgpguGuy
         MIoPDeLDnLnIJW92Cs5ZAcj34Gq5hVBp9CMY0asY9O9KXi8o7g1giMP0E+N45eZbeAcI
         r/cVavsl8GOUfUmhABHZ72n+l3pqapmOQyqs7EL31QmWDr0rbfxsXUBlbg/DmsKC/Fg6
         OmTWkIykKglteesDu67g4eIeqmQaVa+LnyNv27knRfRh97w7A4Oa43EUO/IyQESpep+m
         aHhc9lCqpU01mrSoMpZPtkljauQYWkiFbo1Zb29x3QJyFgN3T40x0t2dxtlR0+s3dlK0
         xrUw==
In-Reply-To: <20210330044206.2864329-1-vipinsh@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, mkoutny@suse.com, jacob.jun.pan@intel.com, rdunlap@infradead.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com
Cc: corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>

Documentation of miscellaneous cgroup controller. This new controller is
used to track and limit the usage of scalar resources.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Reviewed-by: David Rientjes <rientjes@google.com>
---
 Documentation/admin-guide/cgroup-v1/index.rst |  1 +
 Documentation/admin-guide/cgroup-v1/misc.rst  |  4 +
 Documentation/admin-guide/cgroup-v2.rst       | 73 ++++++++++++++++++-
 3 files changed, 76 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/admin-guide/cgroup-v1/misc.rst

diff --git a/Documentation/admin-guide/cgroup-v1/index.rst b/Documentation/admin-guide/cgroup-v1/index.rst
index 226f64473e8e..99fbc8a64ba9 100644
--- a/Documentation/admin-guide/cgroup-v1/index.rst
+++ b/Documentation/admin-guide/cgroup-v1/index.rst
@@ -17,6 +17,7 @@ Control Groups version 1
     hugetlb
     memcg_test
     memory
+    misc
     net_cls
     net_prio
     pids
diff --git a/Documentation/admin-guide/cgroup-v1/misc.rst b/Documentation/admin-guide/cgroup-v1/misc.rst
new file mode 100644
index 000000000000..661614c24df3
--- /dev/null
+++ b/Documentation/admin-guide/cgroup-v1/misc.rst
@@ -0,0 +1,4 @@
+===============
+Misc controller
+===============
+Please refer "Misc" documentation in Documentation/admin-guide/cgroup-v2.rst
diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 64c62b979f2f..b1e81aa8598a 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -65,8 +65,11 @@ v1 is available under :ref:`Documentation/admin-guide/cgroup-v1/index.rst <cgrou
        5-7-1. RDMA Interface Files
      5-8. HugeTLB
        5.8-1. HugeTLB Interface Files
-     5-8. Misc
-       5-8-1. perf_event
+     5-9. Misc
+       5.9-1 Miscellaneous cgroup Interface Files
+       5.9-2 Migration and Ownership
+     5-10. Others
+       5-10-1. perf_event
      5-N. Non-normative information
        5-N-1. CPU controller root cgroup process behaviour
        5-N-2. IO controller root cgroup process behaviour
@@ -2171,6 +2174,72 @@ HugeTLB Interface Files
 Misc
 ----
 
+The Miscellaneous cgroup provides the resource limiting and tracking
+mechanism for the scalar resources which cannot be abstracted like the other
+cgroup resources. Controller is enabled by the CONFIG_CGROUP_MISC config
+option.
+
+A resource can be added to the controller via enum misc_res_type{} in the
+include/linux/misc_cgroup.h file and the corresponding name via misc_res_name[]
+in the kernel/cgroup/misc.c file. Provider of the resource must set its
+capacity prior to using the resource by calling misc_cg_set_capacity().
+
+Once a capacity is set then the resource usage can be updated using charge and
+uncharge APIs. All of the APIs to interact with misc controller are in
+include/linux/misc_cgroup.h.
+
+Misc Interface Files
+~~~~~~~~~~~~~~~~~~~~
+
+Miscellaneous controller provides 3 interface files. If two misc resources (res_a and res_b) are registered then:
+
+  misc.capacity
+        A read-only flat-keyed file shown only in the root cgroup.  It shows
+        miscellaneous scalar resources available on the platform along with
+        their quantities::
+
+	  $ cat misc.capacity
+	  res_a 50
+	  res_b 10
+
+  misc.current
+        A read-only flat-keyed file shown in the non-root cgroups.  It shows
+        the current usage of the resources in the cgroup and its children.::
+
+	  $ cat misc.current
+	  res_a 3
+	  res_b 0
+
+  misc.max
+        A read-write flat-keyed file shown in the non root cgroups. Allowed
+        maximum usage of the resources in the cgroup and its children.::
+
+	  $ cat misc.max
+	  res_a max
+	  res_b 4
+
+	Limit can be set by::
+
+	  # echo res_a 1 > misc.max
+
+	Limit can be set to max by::
+
+	  # echo res_a max > misc.max
+
+        Limits can be set higher than the capacity value in the misc.capacity
+        file.
+
+Migration and Ownership
+~~~~~~~~~~~~~~~~~~~~~~~
+
+A miscellaneous scalar resource is charged to the cgroup in which it is used
+first, and stays charged to that cgroup until that resource is freed. Migrating
+a process to a different cgroup does not move the charge to the destination
+cgroup where the process has moved.
+
+Others
+------
+
 perf_event
 ~~~~~~~~~~
 
-- 
2.31.0.291.g576ba9dcdaf-goog

