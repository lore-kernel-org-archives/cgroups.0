From: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC v2 1/6] gpu: rfc: Proposal for a GPU cgroup controller
Date: Fri, 11 Feb 2022 16:18:24 +0000
Message-ID: <20220211161831.3493782-2-tjmercier@google.com>
References: <20220211161831.3493782-1-tjmercier@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=kKcjEXjOeEH0mGAkUcoWrOf4L77tAlhRMN7oO+B50iM=;
        b=T9LUWLemzPZzWYno8+slJF7qkK9H6xZtLOTMdahBN5x+c0VFhJMUx8wFWEMkCbnPAF
         c49tzOGzV24vKh6ZcteeJfm3K/h9dxxJPqP4MdiFOtfB6ha8vES8N3btoQrzDj99NC6N
         NThuVzfB1W1O0Kh++ZNdvtrId5jUcr1F28amVcqkRC74pjDyEHpBeQS8e/cQfBjFt7hj
         X67UvBvdRjeJR8maJKVWPqHkmcP8r4DnFCaYNX+KPCQut2f8zjoSvF0Y11POa8xywdg4
         pNi7vTlLa3ElD0YVicbwppcwiTNNz6d3MAEHWfh4tsR1cEwGnXSja5hctDRznDh1fBfM
         Jfvg==
In-Reply-To: <20220211161831.3493782-1-tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Liam Mark <lmark-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linaro-mm-sig-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This patch adds a proposal for a new GPU cgroup controller for
accounting/limiting GPU and GPU-related memory allocations.
The proposed controller is based on the DRM cgroup controller[1] and
follows the design of the RDMA cgroup controller.

The new cgroup controller would:
* Allow setting per-cgroup limits on the total size of buffers charged
  to it.
* Allow setting per-device limits on the total size of buffers
  allocated by device within a cgroup.
* Expose a per-device/allocator breakdown of the buffers charged to a
  cgroup.

The prototype in the following patches is only for memory accounting
using the GPU cgroup controller and does not implement limit setting.

[1]: https://lore.kernel.org/amd-gfx/20210126214626.16260-1-brian.welty@int=
el.com/

From: Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Co-developed-by: T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 Documentation/gpu/rfc/gpu-cgroup.rst | 195 +++++++++++++++++++++++++++
 Documentation/gpu/rfc/index.rst      |   4 +
 2 files changed, 199 insertions(+)
 create mode 100644 Documentation/gpu/rfc/gpu-cgroup.rst

diff --git a/Documentation/gpu/rfc/gpu-cgroup.rst b/Documentation/gpu/rfc/g=
pu-cgroup.rst
new file mode 100644
index 000000000000..0bb761223b97
--- /dev/null
+++ b/Documentation/gpu/rfc/gpu-cgroup.rst
@@ -0,0 +1,195 @@
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+GPU cgroup controller
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Goals
+=3D=3D=3D=3D=3D
+This document intends to outline a plan to create a cgroup v2 controller s=
ubsystem
+for the per-cgroup accounting of device and system memory allocated by the=
 GPU
+and related subsystems.
+
+The new cgroup controller would:
+
+* Allow setting per-cgroup limits on the total size of buffers charged to =
it.
+
+* Allow setting per-device limits on the total size of buffers allocated b=
y a
+  device/allocator within a cgroup.
+
+* Expose a per-device/allocator breakdown of the buffers charged to a cgro=
up.
+
+Alternatives Considered
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+The following alternatives were considered:
+
+The memory cgroup controller
+____________________________
+
+1. As was noted in [1], memory accounting provided by the GPU cgroup
+controller is not a good fit for integration into memcg due to the
+differences in how accounting is performed. It implements a mechanism
+for the allocator attribution of GPU and GPU-related memory by
+charging each buffer to the cgroup of the process on behalf of which
+the memory was allocated. The buffer stays charged to the cgroup until
+it is freed regardless of whether the process retains any references
+to it. On the other hand, the memory cgroup controller offers a more
+fine-grained charging and uncharging behavior depending on the kind of
+page being accounted.
+
+2. Memcg performs accounting in units of pages. In the DMA-BUF buffer shar=
ing model,
+a process takes a reference to the entire buffer(hence keeping it alive) e=
ven if
+it is only accessing parts of it. Therefore, per-page memory tracking for =
DMA-BUF
+memory accounting would only introduce additional overhead without any ben=
efits.
+
+[1]: https://patchwork.kernel.org/project/dri-devel/cover/20190501140438.9=
506-1-brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/#22624705
+
+Userspace service to keep track of buffer allocations and releases
+__________________________________________________________________
+
+1. There is no way for a userspace service to intercept all allocations an=
d releases.
+2. In case the process gets killed or restarted, we lose all accounting so=
 far.
+
+UAPI
+=3D=3D=3D=3D
+When enabled, the new cgroup controller would create the following files i=
n every cgroup.
+
+::
+
+        gpu.memory.current (R)
+        gpu.memory.max (R/W)
+
+gpu.memory.current is a read-only file and would contain per-device memory=
 allocations
+in a key-value format where key is a string representing the device name
+and the value is the size of memory charged to the device in the cgroup in=
 bytes.
+
+For example:
+
+::
+
+        cat /sys/kernel/fs/cgroup1/gpu.memory.current
+        dev1 4194304
+        dev2 4194304
+
+The string key for each device is set by the device driver when the device=
 registers
+with the GPU cgroup controller to participate in resource accounting(see s=
ection
+'Design and Implementation' for more details).
+
+gpu.memory.max is a read/write file. It would show the current total
+size limits on memory usage for the cgroup and the limits on total memory =
usage
+for each allocator/device.
+
+Setting a total limit for a cgroup can be done as follows:
+
+::
+
+        echo =E2=80=9Ctotal 41943040=E2=80=9D > /sys/kernel/fs/cgroup1/gpu=
.memory.max
+
+Setting a total limit for a particular device/allocator can be done as fol=
lows:
+
+::
+
+        echo =E2=80=9Cdev1 4194304=E2=80=9D >  /sys/kernel/fs/cgroup1/gpu.=
memory.max
+
+In this example, 'dev1' is the string key set by the device driver during
+registration.
+
+Design and Implementation
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
+
+The cgroup controller would closely follow the design of the RDMA cgroup c=
ontroller
+subsystem where each cgroup maintains a list of resource pools.
+Each resource pool contains a struct device and the counter to track curre=
nt total,
+and the maximum limit set for the device.
+
+The below code block is a preliminary estimation on how the core kernel da=
ta structures
+and APIs would look like.
+
+.. code-block:: c
+
+        /**
+         * The GPU cgroup controller data structure.
+         */
+        struct gpucg {
+                struct cgroup_subsys_state css;
+
+                /* list of all resource pools that belong to this cgroup *=
/
+                struct list_head rpools;
+        };
+
+        struct gpucg_device {
+                /*
+                 * list  of various resource pools in various cgroups that=
 the device is
+                 * part of.
+                 */
+                struct list_head rpools;
+
+                /* list of all devices registered for GPU cgroup accountin=
g */
+                struct list_head dev_node;
+
+                /* name to be used as identifier for accounting and limit =
setting */
+                const char *name;
+        };
+
+        struct gpucg_resource_pool {
+                /* The device whose resource usage is tracked by this reso=
urce pool */
+                struct gpucg_device *device;
+
+                /* list of all resource pools for the cgroup */
+                struct list_head cg_node;
+
+                /*
+                 * list maintained by the gpucg_device to keep track of it=
s
+                 * resource pools
+                 */
+                struct list_head dev_node;
+
+                /* tracks memory usage of the resource pool */
+                struct page_counter total;
+        };
+
+        /**
+         * gpucg_register_device - Registers a device for memory accountin=
g using the
+         * GPU cgroup controller.
+         *
+         * @device: The device to register for memory accounting. Must rem=
ain valid
+         * after registration.
+         * @name: Pointer to a string literal to denote the name of the de=
vice.
+         */
+        void gpucg_register_device(struct gpucg_device *gpucg_dev, const c=
har *name);
+
+        /**
+         * gpucg_try_charge - charge memory to the specified gpucg and gpu=
cg_device.
+         *
+         * @gpucg: The gpu cgroup to charge the memory to.
+         * @device: The device to charge the memory to.
+         * @usage: size of memory to charge in bytes.
+         *
+         * Return: returns 0 if the charging is successful and otherwise r=
eturns an
+         * error code.
+         */
+        int gpucg_try_charge(struct gpucg *gpucg, struct gpucg_device *dev=
ice, u64 usage);
+
+        /**
+         * gpucg_uncharge - uncharge memory from the specified gpucg and g=
pucg_device.
+         *
+         * @gpucg: The gpu cgroup to uncharge the memory from.
+         * @device: The device to charge the memory from.
+         * @usage: size of memory to uncharge in bytes.
+         */
+        void gpucg_uncharge(struct gpucg *gpucg, struct gpucg_device *devi=
ce, u64 usage);
+
+Future Work
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+Additional GPU resources can be supported by adding new controller files.
+
+Upstreaming Plan
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+* Decide on a UAPI that accommodates all use-cases for the upstream GPU ec=
osystem
+  as well as for Android.
+
+* Prototype the GPU cgroup controller and integrate its usage into the DMA=
-BUF
+  system heap.
+
+* Demonstrate its usage from userspace in the Android Open Space Project.
+
+* Send out RFCs to LKML for the GPU cgroup controller and iterate.
diff --git a/Documentation/gpu/rfc/index.rst b/Documentation/gpu/rfc/index.=
rst
index 91e93a705230..0a9bcd94e95d 100644
--- a/Documentation/gpu/rfc/index.rst
+++ b/Documentation/gpu/rfc/index.rst
@@ -23,3 +23,7 @@ host such documentation:
 .. toctree::
=20
     i915_scheduler.rst
+
+.. toctree::
+
+    gpu-cgroup.rst
--=20
2.35.1.265.g69c8d7142f-goog

