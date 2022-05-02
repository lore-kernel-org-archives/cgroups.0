From: "T.J. Mercier" <tjmercier@google.com>
Subject: [PATCH v6 1/6] gpu: rfc: Proposal for a GPU cgroup controller
Date: Mon,  2 May 2022 23:19:35 +0000
Message-ID: <20220502231944.3891435-2-tjmercier@google.com>
References: <20220502231944.3891435-1-tjmercier@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UH1XfZjmWNrGFAlQeXLr7/Tn9jAIkuGUATe4oOI798U=;
        b=K8lxNnVJV2nNNR2bjZTLTTcJNcIHJUYlXV6GRGSPb8mpVwpTE0uDSNxLJ37x7XdIkA
         7c4g/6g48Saj5gUCrRd/3Rj8gGG9lWI/O30Oaj8OQnaKge5pU6gilhErbJ/1s3dhWTTj
         jVCB8aMopODYlzr7OoBjNgPRmFnZDh+5d8ajLa880AXO4pyzxsodEQd4NJ7drByormN6
         YGPn3oYgwfJssilvhWGtvms7zgucKbDBq1EPnJIA8+eEhhqyOgwnB3l2jfuSuLSXkhN+
         YSWLfr2xN4rx4KVNnu/lUGJt9jJlXjy9Hak6wJQVWFZyNM/nKUiEzyp1TZEQ4CnSowMe
         231w==
In-Reply-To: <20220502231944.3891435-1-tjmercier@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tjmercier@google.com, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>
Cc: daniel@ffwll.ch, hridya@google.com, christian.koenig@amd.com, jstultz@google.com, tkjos@android.com, cmllamas@google.com, surenb@google.com, kaleshsingh@google.com, Kenny.Ho@amd.com, mkoutny@suse.com, skhan@linuxfoundation.org, kernel-team@android.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

From: Hridya Valsaraju <hridya@google.com>

This patch adds a proposal for a new GPU cgroup controller for
accounting/limiting GPU and GPU-related memory allocations.
The proposed controller is based on the DRM cgroup controller[1] and
follows the design of the RDMA cgroup controller.

The new cgroup controller would:
* Allow setting per-device limits on the total size of buffers
  allocated by device within a cgroup.
* Expose a per-device/allocator breakdown of the buffers charged to a
  cgroup.

The prototype in the following patches is only for memory accounting
using the GPU cgroup controller and does not implement limit setting.

[1]: https://lore.kernel.org/amd-gfx/20210126214626.16260-1-brian.welty@intel.com/

Signed-off-by: Hridya Valsaraju <hridya@google.com>
Signed-off-by: T.J. Mercier <tjmercier@google.com>

---
v6 changes
Move documentation into cgroup-v2.rst per Tejun Heo.

v5 changes
Drop the global GPU cgroup "total" (sum of all device totals) portion
of the design since there is no currently known use for this per
Tejun Heo.

Update for renamed functions/variables.

v3 changes
Remove Upstreaming Plan from gpu-cgroup.rst per John Stultz.

Use more common dual author commit message format per John Stultz.
---
 Documentation/admin-guide/cgroup-v2.rst | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 69d7a6983f78..baeec096f1d8 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2352,6 +2352,30 @@ first, and stays charged to that cgroup until that resource is freed. Migrating
 a process to a different cgroup does not move the charge to the destination
 cgroup where the process has moved.
 
+
+GPU
+---
+
+The GPU controller accounts for device and system memory allocated by the GPU
+and related subsystems for graphics use. Resource limits are not currently
+supported.
+
+GPU Interface Files
+~~~~~~~~~~~~~~~~~~~~
+
+  gpu.memory.current
+	A read-only file containing memory allocations in flat-keyed format. The key
+	is a string representing the device name. The value is the size of the memory
+	charged to the device in bytes. The device names are globally unique.::
+
+	  $ cat /sys/kernel/fs/cgroup1/gpu.memory.current
+	  dev1 4194304
+	  dev2 104857600
+
+	The device name string is set by a device driver when it registers with the
+	GPU cgroup controller to participate in resource accounting. Non-unique names
+	will be rejected at the point of registration.
+
 Others
 ------
 
-- 
2.36.0.464.gb9c8b46e94-goog

