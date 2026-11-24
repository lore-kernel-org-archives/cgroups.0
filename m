Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525462;
	b=hvymmIgKBFpHoQmxJSirZMrbCI/BSPtprk7Gc61exrfBxZ5jUac3Mx1m3BU16yf9Jzgc
	 V/xfuqN5FSdaxaAL0WaOoRJhY+huP5mJjrlmfpU00bgUHRO0YdbrIBm2w8hcsF+zzZO9y
	 rWP1uNnJG96Odp553c7GDMsSNorXPruPcqCxbN+V2gZgpvz2x6jVaiY7rWBUkjeJAc8fk
	 S7Rtny1MLk/Oii+uoGizzm/63GIJJIpet/BeoFoUxSV19PUpcDuOzlTo4iedMkY7dLKFo
	 wMGrpCcVoYdkaoRSe8cQLAr4kq7jq3+xYFQdcXGPyrfePiDwQh1loOd0H0kPLti9kKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525462;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Developer-Signature:X-Developer-Key:X-Scanned-By;
	bh=1VGhrilOrIVUd7NQcN6hWODsfVyfTY1/1MG6x6kIma0=;
	b=biNzbaBwjz9AkfCPNcYcwxIKwXG+H7zs4OAOXCAA7+tog6xIN8SilmN2uADYnJlYQUs8
	 l9DQVznroP4vxkhwwck5wnBdLCbSB+lMlaUifRWOYYwKJcNGBsm+n9nypT4jgSyksYkS3
	 xjuMU6XWDuq3s60DP0dP2KEoTPya7qf+V/BKEoZF8NS9iMtxZKd/ATH4y9sH/kf1rU+Vi
	 eNKmjnVDDP1t2pvIPNdoDV2b+S5Vjg4rYytOug6XNV41kLvBI5+rZQFoyKJAZXPbdLssk
	 YvFE1sRJTVfRWOvCxt76QgWDpu33/EfMRED5g9WKcRStrkS8aWGIVcqmTn61oHoJ2rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iYA78xEB;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67823606A321
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 13:04:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67823606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iYA78xEB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795525460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1VGhrilOrIVUd7NQcN6hWODsfVyfTY1/1MG6x6kIma0=;
	b=iYA78xEBTLwFu/juY1o991mIqkTESiN3rrcxrEuLhnRpr6lpmHJiuzZlemXQX14O/AioVX
	F9GEd+dnTWSy0IzHNFjORHOBl0L6xvjNqI9BwkcBq5F/bNk/9CuOm4Zm74uN2xXcc0viH7
	g3b0EpuHN1NYEuFo424DbqPN36X2u5A=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-692-K65r4GWQN3uUAcKHjQCkKA-1; Tue,
 24 Nov 2026 13:04:15 +0000
X-MC-Unique: K65r4GWQN3uUAcKHjQCkKA-1
X-Mimecast-MFC-AGG-ID: K65r4GWQN3uUAcKHjQCkKA_1795525450
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D38B51944B1C;
	Tue, 24 Nov 2026 13:03:57 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F8AF1956087;
	Tue, 24 Nov 2026 13:03:46 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Subject: [PATCH v6 0/7] memcg: dma-buf cgroup accounting and charge
 transfer
Date: Tue, 24 Nov 2026 14:03:34 +0100
Message-Id: <20261124-v2_20230123_tjmercier_google_com-v6-0-dce12fa03ad6@redhat.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/43O3WrDMAwF4Fcpvl6GJP8lvdp7lBISW0481mY4I
 WyUvPucMraOXCx3OhJ8Rzcxcoo8iuPhJhLPcYzDNQfzdBCub64dF9HnLAjIgIaymKnOswQkWU+
 vF04ucqq7YejeuHbDpQhKBRdaNFqCyMx74hA/7hWnc859HKchfd4bZ1y33zjS//iMBRRGkrGAT
 poKXxL7vpme81Gs+kw/IgLhDpGyyMEwk/el024jykfR7hBlFm3pySnXlkbZjah+RQS1Q1RZxBK
 rBtACQLsR9YOIe37Uq+i4sjpQUzX+j7gsyxcDO6a/GQIAAA==
X-Change-ID: 20260508-v2_20230123_tjmercier_google_com-f44fcfb16530
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 Christian Brauner <brauner@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Shuah Khan <shuah@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>, 
 Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
 Philipp Stanner <phasta@kernel.org>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: airlied@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, Albert Esteve <aesteve@redhat.com>, 
 echanude@redhat.com, mripard@kernel.org
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795525424; l=9579;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=si3R7b0kcAGLEUfejc/PsZKusnANP7SCv7uuLauSWDw=;
 b=tJGGA22KuFlVrI5rdm5SUwjA4Gc4/fTVuyvaq/v/YYF5DA/eXjf40+QU/bS9kCDYD82+zs2Hm
 Dxn5Vd7+N1LC5MIaX9NH1jtOk0iod58Bz11JySE6hKyVamsSmtm8lMS
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Shared-memory allocator services (e.g., Android's gralloc)
allocate dma-bufs on behalf of client processes in different
cgroups. Today those allocations are charged to the allocator's
own cgroup, leaving client cgroups with no visibility into their
actual memory consumption and defeating resource limits.

This series adds memory cgroup accounting for dma-buf allocations,
building on T.J. Mercier's earlier series [1] and incorporating
feedback from previous versions and LPC discussions [2].

Patch 1 introduces the MEMCG_DMABUF stat and the
obj_cgroup_reserve_dmabuf()/obj_cgroup_cancel_dmabuf() and
mem_cgroup_commit_dmabuf()/mem_cgroup_uncharge_dmabuf() helpers
in mm/memcontrol.c

Patch 2 wires up the charging policy: dma_buf_export() stores
exp_info.objcg and updates the stat, a new charge_fd field in
DMA_HEAP_IOCTL_ALLOC accepts a pidfd or cgroupfd to identify
the target cgroup, and __GFP_ACCOUNT is removed from system-heap
allocations to avoid double counting.

Patch 3 adds DMA_BUF_IOCTL_XFER_CHARGE, a general ioctl on any
dma-buf fd to transfer charges post-allocation. This covers the
double-hop allocator case (SurfaceFlinger -> gralloc -> kernel)
and works for buffers from any exporter that opts in. Charging
is gated by dmabuf->objcg being set at export time, ensuring that
transfer is only applied for buffers backed by system memory where
size reflects actual bytes. If the receiving cgroup lacks capacity
for the charge, the ioctl returns -ENOMEM and the original charge
is preserved.

Patches 4-6 add access control for cross-cgroup charging. Letting
userspace decide who to charge needs to be a privileged operation
because it has material impact on OOM decisions and resource limits.
Charging outside the caller's own memcg subtree requires
CAP_SYS_RESOURCE. On top of that, LSM hooks gate the two charge_fd
flavours: security_current_memcg_charge_task() for the pidfd path
and security_current_memcg_charge_cgroup() for the cgroupfd path.

Both flavours ultimately charge a cgroup, so the SELinux
implementation gates the two with a single cgroup:charge_to
permission. The target type keeps the distinction.
The checks run at target resolution, before the CAP_SYS_RESOURCE
baseline, and cover the caller's own subtree, so policy needs
a rule even for self-charging. The SELinux controls are covered
by new selinux-testsuite tests [4].

Patch 7 adds selftests. The tests and vmtest script were mostly
written by an LLM, closely following the style of the surrounding
tests and the virtme-ng setup. All code has been reviewed and tested.

Known limitations:

- Single-owner model: a dma-buf carries one memcg charge regardless
  of how many processes share it. The owner is deterministic, set
  at allocation time and moved only by an explicit XFER_CHARGE.
- Only memcg accounting. CMA heaps would additionally need dmem
  controller integration.
- If a transfer fails (e.g., the receiving cgroup is at its limit),
  the buffer remains charged to the original cgroup. The allocator
  (userspace) is expected to handle failures (retry, free, ...).
- The LSM hooks are intentionally narrow. Broader cgroup access
  controls (e.g., for the memfd/kexec handover case [2]) could be
  a separate effort reusing the same pattern.
- Only system heap sets exp_info.objcg today. Other exporters
  (DRM, V4L2, etc.) can opt in by setting it, but are not
  covered by this series.
- Related to the above: lazy backing-store allocation is not supported.
  This can be extended later, e.g., by adding a flag on the dma-buf
  struct for explicitly marking when memory is committed.

Note on TTM/GPU accounting [3]: that effort charges system memory
allocated for GPU buffers per page, with its own stats (gpu_active
and gpu_reclaim). This series charges at the dma-buf level, for
memory with no memory.stat category of its own; exporters whose
memory is already charged by their allocator must not opt in, so
the two do not overlap.

[1] https://lore.kernel.org/cgroups/20230109213809.418135-1-tjmercier@google.com/
[2] https://lpc.events/event/20/contributions/2416/
[3] https://lore.kernel.org/all/20260706052330.1110909-1-airlied@gmail.com/
[4] https://github.com/SELinuxProject/selinux-testsuite/pull/111

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
Changes in v6:
- Unify SELinux perms into cgroup:charge_to
- Drop the current cred argument from the LSM hooks
  and rename signatures to security_current_memcg_charge_*
- Add selinux-testsuite coverage for the charge_to controls
- Rebased to v7.4-rc4
- Link to v5: https://patch.msgid.link/20261117-v2_20230123_tjmercier_google_com-v5-0-1ce975f2a9ad@redhat.com

Changes in v5:
- Reject dma-buf reservations above INT_MAX pages to avoid
  nr_pages truncation (Sashiko)
- Require CAP_SYS_RESOURCE for charge requests targeting outside
  caller's own memcg subtree (Sashiko)
- Hold an obj_cgroup instead of a memcg in the dma-buf struct (Thomas Hellström)
- Restore mem_cgroup_commit_dmabuf() so dma_buf_export() does not
  reach into memcg stat internals
- Resolve the cgroup and run the LSM check against the same file
  in get_obj_cgroup_from_fd()
- The cgroupfd hook now takes the file and checks the inode SID,
  so genfscon-labeled cgroups are covered
- Rename the LSM hooks to security_memcg_charge_{task,cgroup}()
- Replace dma_buf object class in SELinux with process2:charge_to
  and cgroup:charge_to
- Link to v4: https://lore.kernel.org/r/20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com

Changes in v4:
- Remove memcg_account flag; exp_info.memcg != NULL is the opt-in
- Centralize memcg bookkeeping in dma_buf_export()
- Drop mem_cgroup_commit_dmabuf()
- Make mem_cgroup_transfer_charge() generic (not dma-buf specific)
- Add EXPORT_SYMBOL_GPL for reserve/cancel (system_heap is tristate)
- Reorder: move xfer ioctl before LSM patches
- Serialize dmabuf->memcg updates with the dma-buf resv lock instead of cmpxchg
- Link to v3: https://lore.kernel.org/r/20261027-v2_20230123_tjmercier_google_com-v3-0-78d2c4cb8647@redhat.com

Changes in v3:
- Split mem_cgroup_charge_dmabuf() into reserve/commit/cancel three-phase API
- Extract mem_cgroup_get_from_fd() helper shared by allocate and xfer paths
- Rename __padding to flags in struct dma_buf_transfer_charge
- Fix UAF race: move mod_memcg_state() before cmpxchg in transfer
- Add memcg_account opt-in flag; xfer returns -EOPNOTSUPP if unset
- Wrap dma_buf_charge_cgroup hook in #ifdef CONFIG_CGROUPS
- Fix TOCTOU in SELinux charge_cgroup xattr length handling
- Link to v2: https://lore.kernel.org/r/20261021-v2_20230123_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com

Changes in v2:
- Move charge_pid_fd to charge_fd, accepting cgroupfd in addition
  to pidfd per Christian König.
- New DMA_BUF_IOCTL_XFER_CHARGE ioctl for post-allocation charge
  transfer on any dma-buf, not just dma-heap buffers per Christian König
  and T.J. Mercier.
- Moved __GFP_ACCOUNT removal to patch 1 per Barry Song.
- dma-buf charge/uncharge helpers take struct dma_buf * directly
  to avoid the need for caller to manage size calculations.
- Added test_xfer_charge_cgroupfd_self to dmabuf-heap selftests.
- Added LSM and SELinux hooks for cgroupfd-based charging.
- Rebased to v7.3-rc7.
- Link to v1: https://lore.kernel.org/r/20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com

---
Albert Esteve (6):
      dma-heap: charge dma-buf memory via explicit memcg
      dma-buf: transfer objcg charges via DMA_BUF_IOCTL_XFER_CHARGE
      lsm: Add memcg_charge_task LSM hook
      lsm: Add memcg_charge_cgroup LSM hook
      selinux: Restrict cross-cgroup memcg charging
      selftests/dmabuf-heaps: Add dma-buf memcg accounting tests

T.J. Mercier (1):
      memcg: Add MEMCG_DMABUF accounting infrastructure

 Documentation/admin-guide/cgroup-v2.rst            |   6 +
 drivers/dma-buf/dma-buf.c                          |  45 +++
 drivers/dma-buf/dma-heap.c                         |  27 +-
 drivers/dma-buf/heaps/cma_heap.c                   |   3 +-
 drivers/dma-buf/heaps/system_heap.c                |  19 +-
 drivers/tee/tee_heap.c                             |   3 +-
 include/linux/dma-buf.h                            |  10 +
 include/linux/dma-heap.h                           |   4 +-
 include/linux/lsm_hook_defs.h                      |   2 +
 include/linux/memcontrol.h                         |  56 +++
 include/linux/security.h                           |  12 +
 include/uapi/linux/dma-buf.h                       |  26 ++
 include/uapi/linux/dma-heap.h                      |   7 +
 mm/memcontrol.c                                    | 271 +++++++++++++
 security/security.c                                |  31 ++
 security/selinux/hooks.c                           |  19 +
 security/selinux/include/classmap.h                |   1 +
 tools/testing/selftests/cgroup/Makefile            |   2 +-
 tools/testing/selftests/cgroup/test_memcontrol.c   | 447 ++++++++++++++++++++-
 tools/testing/selftests/dmabuf-heaps/config        |   1 +
 tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c | 237 ++++++++++-
 tools/testing/selftests/dmabuf-heaps/vmtest.sh     | 226 +++++++++++
 22 files changed, 1440 insertions(+), 15 deletions(-)
---
base-commit: 8d7fe9885c62fc9a95bf55d9db244d9672a8aadc
change-id: 20260508-v2_20230123_tjmercier_google_com-f44fcfb16530

Best regards,
--  
Albert Esteve <aesteve@redhat.com>

