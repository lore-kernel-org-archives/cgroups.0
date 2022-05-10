From: "T.J. Mercier" <tjmercier@google.com>
Subject: [PATCH v7 1/6] gpu: rfc: Proposal for a GPU cgroup controller
Date: Tue, 10 May 2022 23:56:45 +0000
Message-ID: <20220510235653.933868-2-tjmercier@google.com>
References: <20220510235653.933868-1-tjmercier@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=4KvDBY92RR8WKuUjzgohCsuZSchRL19v0jjqGuoq0no=;
        b=EVnDMIpZB27MCIXhHatilUnRYlxARdcdAd7PK1rHIXFEB09aYu4tovCAvBFw8cZxyT
         gXDSSt3iUIN/1CO3fml62gvLZRGE+EMeeeLDQuSX7c4jbLENEPCC9PDIZujw5VNhH0q0
         FNlArlRA5Ob2e7UO2kZWZMCqvsuYh5DB5yxiuRlqYM4K6p8fNfkF+nvk4AffdLlQoCVj
         Iow7SxlzmL5Vq+/E0YXhlhfw88NjMLlc65QX53QBUS8PoggN6lNR+09aPb47Qcif87k3
         deyEJ4awwrFwdjAObdu51OKvcIO1OpNdSGWxV/SAb3A5rkBNGUpnsa8mp82Pi0LrZ+EP
         djEA==
In-Reply-To: <20220510235653.933868-1-tjmercier@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
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

[1]: https://lore.kernel.org/amd-gfx/20210126214626.16260-1-brian.welty@int=
el.com/

Signed-off-by: Hridya Valsaraju <hridya@google.com>
Signed-off-by: T.J. Mercier <tjmercier@google.com>

---
v7 changes
Remove comment about duplicate name rejection which is not relevant to
cgroups users per Michal Koutn=C3=BD.

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
 Documentation/admin-guide/cgroup-v2.rst | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-=
guide/cgroup-v2.rst
index 69d7a6983f78..2e1d26e327c7 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2352,6 +2352,29 @@ first, and stays charged to that cgroup until that r=
esource is freed. Migrating
 a process to a different cgroup does not move the charge to the destinatio=
n
 cgroup where the process has moved.
=20
+
+GPU
+---
+
+The GPU controller accounts for device and system memory allocated by the =
GPU
+and related subsystems for graphics use. Resource limits are not currently
+supported.
+
+GPU Interface Files
+~~~~~~~~~~~~~~~~~~~~
+
+  gpu.memory.current
+	A read-only file containing memory allocations in flat-keyed format. The =
key
+	is a string representing the device name. The value is the size of the me=
mory
+	charged to the device in bytes. The device names are globally unique.::
+
+	  $ cat /sys/kernel/fs/cgroup1/gpu.memory.current
+	  dev1 4194304
+	  dev2 104857600
+
+	The device name string is set by a device driver when it registers with t=
he
+	GPU cgroup controller to participate in resource accounting.
+
 Others
 ------
=20
--=20
2.36.0.512.ge40c2bad7a-goog

