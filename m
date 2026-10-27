Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793113401;
	b=T5Z/w3xRKJP0/v3DrBSt/UwjW6R0+F6D/XDJC2ureDCUJUIuZvD107vkC4b1aZ85gseq
	 lP2/RKNAiQjm/UdwBBd5AU3aNnqThbtcNTLQNhBwyoKXjeBP28mQKNO66/FxEGNiFPvrn
	 BhObzFQWE80ylbb+NIYhIWAlie8sXd5t9crmzFrxZIBFZYtwLTSj8Uc4e3TuCFfTKnJ0G
	 5+pNCA9YzduG+C1sFlbUz16Np30WdJKSTzude+EfKRmVfgTuQFhIDYe7XEMsDLAJqEpMG
	 Q2WK4E8rTbPZVarmoOAoitzLifTdWN50ldlQ8docQZJTXdTsEuuiL6ap8IsRsMb2CZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793113401;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Developer-Signature:X-Developer-Key:X-Scanned-By;
	bh=aOf0mUhnEWGXt/wT5adZbPR4knhMHoXNhBntHVrI1Yw=;
	b=VvpkXUJVr1nO0gZVkN6eY0XyvtSvERBwj4eHrkpegl8ttfXODCRYCGVzIpV9Og9L8gp4
	 7Rirv/Y1nhNTON2iLv8p4ZUBLb8SxinyFFYQR6Dr52kPZEEBR+h4IAuauYXPfcUIW3G+E
	 vnoSIL2vUzLAtMfo6DlpSRbaSBJc1XJfPBtxr02EE49ZknCrH8ncdjrHRuZeUxxmGDZG8
	 saTkFml706n8nhc4nW6fPnbHcDpOdfwS25WBocT4b8hy8v4fhbwSTP7YDhEVdeiIvF8FY
	 vfpaCH8MJD21z6r8yMGd1cd0R3X/gU55wEUfF9JpCczqQsrLyxP3Y3hyFU7EyT5ax6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="Otgn/Mfr";
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A01606A31F
	for <cgroups@vger.kernel.org>; Tue, 27 Oct 2026 15:03:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67A01606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Otgn/Mfr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793113400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=aOf0mUhnEWGXt/wT5adZbPR4knhMHoXNhBntHVrI1Yw=;
	b=Otgn/Mfr25iVb/sVwiz5J1aXVYH8MvhUZkXhlcusTo/NhohcoNpqmMucItUiIOrl08en3b
	tMT0gIe38frSRnIU9XsrzfId/eXfHyg/PpaUCHsnmTuODEpOJMSRQP8PzYSHPDa93BQ8QC
	LuLDa9rY3yAswEskeHTdQqLXZDVKJ2w=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-630-UjIdhJ72O6-uXk9AZAUySw-1; Tue,
 27 Oct 2026 11:03:16 -0400
X-MC-Unique: UjIdhJ72O6-uXk9AZAUySw-1
X-Mimecast-MFC-AGG-ID: UjIdhJ72O6-uXk9AZAUySw_1793113392
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DFCFA18009F0;
	Tue, 27 Oct 2026 15:03:09 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D01D018002B1;
	Tue, 27 Oct 2026 15:02:59 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Subject: [PATCH v3 0/8] memcg: dma-buf cgroup accounting and charge
 transfer
Date: Tue, 27 Oct 2026 16:02:43 +0100
Message-Id: <20261027-v2_20230123_tjmercier_google_com-v3-0-78d2c4cb8647@redhat.com>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/43NQQrCMBAF0KuUrI1kJm2srryHSKnppI3YRpISl
 NK7mxYRXOlu/nx4f2KBvKXADtnEPEUbrBtSkJuM6a4eWuK2SZmhQCUKUfKIVbqlAJTVeO3Ja0u
 +ap1rb1Rp13OT50abC6hCCpaYuydjH+vE6ZxyZ8Po/HNdjLB83zjgbzwCF1xJVDsBWqo9HD01X
 T1uU8kWPeJHBIHwh4hJJKOIsGlKXegvcZ7nF8pnAWwjAQAA
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
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, Albert Esteve <aesteve@redhat.com>, 
 echanude@redhat.com, mripard@kernel.org
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793113379; l=6757;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=SbSaiBkIq+YUC6r+fSuC8xTCAnJdm8Vr2zNeXnNL3ao=;
 b=rMh42d3K7ZdvbxPJmt30LjOl76ZkQ62Z6Ul1YgWdi/7V4axPrJSy681qwSjEcG3Y17eHAsv1y
 +LmSEK2BvnsDaNYSlWiHuv0bXrBqtI3n02cWTu6Y6kXEFNbK6b8jRpu
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Shared-memory allocator services (e.g., Android's gralloc)
allocate dma-bufs on behalf of client processes in different
cgroups. Today those allocations are charged to the allocator's
own cgroup, leaving client cgroups with no visibility into their
actual memory consumption and defeating resource limits.

This series adds memory cgroup accounting for dma-buf allocations,
building on T.J. Mercier's earlier series [1] and incorporating
feedback from previous versions and LPC discussions [2].

Patch 1 introduces the MEMCG_DMABUF stat and reserve/commit/cancel
and uncharge helpers. Rather than charging at the page level via
__GFP_ACCOUNT (which would require every dma-buf exporter to implement
charging, and makes cross-cgroup transfer impractical without access
to backing pages), we track charges externally on struct dma_buf via
a MEMCG_DMABUF stat counter and route all accounting through a single
path, removing the __GFP_ACCOUNT flag from system-heap allocations
to avoid double counting.

Patch 2 adds a charge_fd field to DMA_HEAP_IOCTL_ALLOC, accepting
either a pidfd or a cgroupfd to identify the target cgroup at
allocation time. If the target cgroup cannot accommodate the charge,
the allocation returns -ENOMEM.

Patches 3-6 add access control for cross-cgroup charging. Letting
userspace decide who to charge needs to be a privileged operation
because it has material impact on OOM decission and resource limits.
We gate it via LSM hooks for the two charge_fd flavours:
security_dma_buf_charge_task() gates the pidfd path (target
identified by task credentials) and security_dma_buf_charge_cgroup()
gates the cgroupfd path (target identified by cgroup directory label),
with SELinux implementations under a dma_buf object class.

Patch 7 adds DMA_BUF_IOCTL_XFER_CHARGE, a general ioctl on any
dma-buf fd to transfer charges post-allocation. This covers the
double-hop allocator case (SurfaceFlinger -> gralloc -> kernel)
and works for buffers from any exporter (DRM, V4L2, etc.). A new
memcg_account flag is added for dma_buf_export() to ensure that
transfer/charge is only applied for buffers backed by reclaimable
system memory. If the receiving cgroup lacks capacity for the charge,
the ioctl returns -ENOMEM and the original charge is preserved.

Patch 8 adds selftests.

Known limitations:

- Single-owner model: a dma-buf carries one memcg charge regardless
  of how many processes share it.
- Only memcg accounting. CMA heaps would additionally need dmem
  controller integration.
- If a transfer of an uncharged buffer fails, it remains uncharged.
  The allocator (userspace) is expected to handle this (retry, free, ...).
- The LSM hooks are intentionally narrow. Broader cgroup access controls
  (e.g. for the memfd/kexec handover case [2]) could be a separate effort
  reusing the same pattern.
- Only system heap sets memcg_account today. Other exporters
  (DRM, V4L2, etc.) can opt in by setting the flag, but are not
  covered by this series.

[1] https://lore.kernel.org/cgroups/20230109213809.418135-1-tjmercier@google.com/
[2] https://lpc.events/event/20/contributions/2416/

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
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
Albert Esteve (7):
      dma-heap: charge dma-buf memory via explicit memcg
      security: dma-buf: Add dma_buf_charge_task LSM hook
      security: dma-buf: Add dma_buf_charge_cgroup LSM hook
      selinux: Restrict cross-cgroup dma-buf charging
      selinux: Restrict dma-buf direct cgroup charging
      dma-buf: transfer memcg charges via DMA_BUF_IOCTL_XFER_CHARGE
      selftests/dmabuf-heaps: Add dma-buf memcg accounting tests

T.J. Mercier (1):
      memcg: Add MEMCG_DMABUF accounting infrastructure

 Documentation/admin-guide/cgroup-v2.rst            |   5 +
 drivers/dma-buf/dma-buf.c                          |  46 ++++
 drivers/dma-buf/dma-heap.c                         |  28 +-
 drivers/dma-buf/heaps/cma_heap.c                   |   3 +-
 drivers/dma-buf/heaps/system_heap.c                |  22 +-
 drivers/tee/tee_heap.c                             |   3 +-
 include/linux/dma-buf.h                            |   9 +
 include/linux/dma-heap.h                           |   3 +-
 include/linux/lsm_hook_defs.h                      |   4 +
 include/linux/memcontrol.h                         |  52 ++++
 include/linux/security.h                           |  18 ++
 include/uapi/linux/dma-buf.h                       |  26 ++
 include/uapi/linux/dma-heap.h                      |   7 +
 mm/memcontrol.c                                    | 192 ++++++++++++++
 security/security.c                                |  34 +++
 security/selinux/hooks.c                           |  44 ++++
 security/selinux/include/classmap.h                |   1 +
 tools/testing/selftests/cgroup/Makefile            |   2 +-
 tools/testing/selftests/cgroup/test_memcontrol.c   | 290 ++++++++++++++++++++-
 tools/testing/selftests/dmabuf-heaps/config        |   1 +
 tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c | 227 +++++++++++++++-
 tools/testing/selftests/dmabuf-heaps/vmtest.sh     | 226 ++++++++++++++++
 22 files changed, 1228 insertions(+), 15 deletions(-)
---
base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
change-id: 20260508-v2_20230123_tjmercier_google_com-f44fcfb16530

Best regards,
-- 
Albert Esteve <aesteve@redhat.com>

