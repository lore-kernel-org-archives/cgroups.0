Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793790578;
	b=tMu4vkIYdz5/0gYK04qgsr7ZgT4Ot55Y5ml/gMQHIH6wRu7/UC1TdKrLhcRasj1Dhd7m
	 ck4VerSvk/HRP6DTwvb+cQeoyjbw4KibPw5TQL0NVwrYK9ZGKDgOtnNnh15SZizBe3GV5
	 ASEzU8wwFQ8gBn9minkLgW3gS54c8XrloG9FlAGpPLFWRuX23eM7akR0y9Uvn8zYoxvDI
	 UleC8h7Lb41jOgdMyc5PWotn4ZkcKlPyrNxztfO/zBwHBh1UZfrDIhctDHiCgRkgUCA64
	 jAI6UPip59fPTDUn/8Zwp1WwjcwK99KIflwKw+6x29LBZ8iFJuWSToJY9J8TeuTH+nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793790578;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Developer-Signature:X-Developer-Key:X-Scanned-By;
	bh=y/j5QPLW6jpzCD3GV5JpZq3Ngo4fRQoXZZ90Dm8OkWQ=;
	b=tK008lhM8CWBkx+ugFK97QQAlbdiRtdUi7S38FSpx9NpWadOl2fLncMNw9CIM4/sI/zt
	 5uMqzLIymfZ4N2Jlm+gmU9ynEEj1DwZ9B32lVXr74rLsZR/DVy/tLxbmrs0we/zb+H0dL
	 frbwMqU0U4cMY74nfTShWwbuOzfwoENd9W+1zWN+I4lTdxuHGDUzpdFeiz4ezC76qkslT
	 l8wq42qIUrJ7N2MkxkMvuPcQKKPmKTUsSMlt8ks2Ycuirvn7j1iSFTc/HXQ4AtpXaLao/
	 pAXl5opMLVIFHWn36fEsb3sS6bQUyhYWStPXTAxuvOlHyxHct6KeH5Yhm1lhcIvR0qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UtfNtUVo;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D650606A330
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 11:09:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D650606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UtfNtUVo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793790576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=y/j5QPLW6jpzCD3GV5JpZq3Ngo4fRQoXZZ90Dm8OkWQ=;
	b=UtfNtUVoyBpbKwmTPvZcL0Elfq6Jx3BZFKISmGOEkAeD5l4G1xvC5uKhQDT/OUGqljaetQ
	nBU6ffqbdLLrytwApuUoZQkgkzSLqj5SP25HP1ok35ve7gOmybbytcS0oywgQHUVdYxuWO
	thwGIoHcCbZVPlQqjb3abG2mOWd2EjE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-47-95zgtnEUO52YN059qEpIoQ-1; Wed,
 04 Nov 2026 06:09:30 -0500
X-MC-Unique: 95zgtnEUO52YN059qEpIoQ-1
X-Mimecast-MFC-AGG-ID: 95zgtnEUO52YN059qEpIoQ_1793790566
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8E1CA1956088;
	Wed,  4 Nov 2026 11:09:24 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 27CE0195608D;
	Wed,  4 Nov 2026 11:09:14 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Subject: [PATCH v4 0/8] memcg: dma-buf cgroup accounting and charge
 transfer
Date: Wed, 04 Nov 2026 12:09:09 +0100
Message-Id: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/43N0YrCMBAF0F+RPBvJTNK0+uR/iJQ6mbRZViNpC
 buU/rtRlkXZh/Vt7lw4dxYjp8Cj2K1mkTiHMcRLCWa9EjR0l55lcCULVGhVpRqZsS23VoC6nT7
 OnChwavsY+09uKZ6lN8aTP4GttBKFuSb24esxcTiWPIRxiun7sZjh/v3BAf/HM0glrUZbKyBtt
 7BP7IZu2pRS3PWMvyIohDdELCJ7y4zONVTRH1E/i/Uboi5i3TgkQ6fGmvpFXJblBjmZGH11AQA
 A
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
 op-tee@lists.trustedfirmware.org, Albert Esteve <aesteve@redhat.com>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793790554; l=7204;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=X4BZFXAHZjeZ5G+n6xJuzSu1l1U0TCSBOdNO5egLRKM=;
 b=Km+AqlhWRTv/KXXv4GRbT2llTohKS+mIBYai0uvK0MKieulAtBqFdb+ot4kS5rHtLOoLqnwgW
 ykX9usEkQGUD0PWls5MHmfgY0UQayrDXDRMYunnztg3zl598W8CS8z6
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Shared-memory allocator services (e.g., Android's gralloc)
allocate dma-bufs on behalf of client processes in different
cgroups. Today those allocations are charged to the allocator's
own cgroup, leaving client cgroups with no visibility into their
actual memory consumption and defeating resource limits.

This series adds memory cgroup accounting for dma-buf allocations,
building on T.J. Mercier's earlier series [1] and incorporating
feedback from previous versions and LPC discussions [2].

Patch 1 introduces the MEMCG_DMABUF stat and reserve/cancel
and uncharge helpers in mm/memcontrol.c

Patch 2 wires up the charging policy: dma_buf_export() stores
exp_info.memcg and updates the stat, a new charge_fd field in
DMA_HEAP_IOCTL_ALLOC accepts a pidfd or cgroupfd to identify
the target cgroup, and __GFP_ACCOUNT is removed from system-heap
allocations to avoid double counting.

Patch 3 adds DMA_BUF_IOCTL_XFER_CHARGE, a general ioctl on any
dma-buf fd to transfer charges post-allocation. This covers the
double-hop allocator case (SurfaceFlinger -> gralloc -> kernel)
and works for buffers from any exporter (DRM, V4L2, etc.). Charging
is gated by dmabuf->memcg being set at export time, ensuring that
transfer is only applied for buffers backed by system memory where
size reflects actual bytes. If the receiving cgroup lacks capacity
for the charge, the ioctl returns -ENOMEM and the original charge
is preserved.

Patches 4-7 add access control for cross-cgroup charging. Letting
userspace decide who to charge needs to be a privileged operation
because it has material impact on OOM decission and resource limits.
We gate it via LSM hooks for the two charge_fd flavours:
security_dma_buf_charge_task() gates the pidfd path (target
identified by task credentials) and security_dma_buf_charge_cgroup()
gates the cgroupfd path (target identified by cgroup directory label),
with SELinux implementations under a dma_buf object class.

Patch 8 adds selftests.

Known limitations:

- Single-owner model: a dma-buf carries one memcg charge regardless
  of how many processes share it.
- Only memcg accounting. CMA heaps would additionally need dmem
  controller integration.
- If a transfer of an uncharged buffer fails, the buffer remains
  charged to the original cgroup. The allocator (userspace) is
  expected to handle this (retry, free, ...).
- The LSM hooks are intentionally narrow. Broader cgroup access controls
  (e.g. for the memfd/kexec handover case [2]) could be a separate effort
  reusing the same pattern.
- Only system heap sets exp_info.memcg today. Other exporters
  (DRM, V4L2, etc.) can opt in by setting it, but are not
  covered by this series.
- Related to the above: lazy backing-store allocation is not supported.
  This can be extended later, e.g., by adding a flag on the dma-buf
  struct for explicitly marking when memory is committed.

[1] https://lore.kernel.org/cgroups/20230109213809.418135-1-tjmercier@google.com/
[2] https://lpc.events/event/20/contributions/2416/

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
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
Albert Esteve (7):
      dma-heap: charge dma-buf memory via explicit memcg
      dma-buf: transfer memcg charges via DMA_BUF_IOCTL_XFER_CHARGE
      security: dma-buf: Add dma_buf_charge_task LSM hook
      security: dma-buf: Add dma_buf_charge_cgroup LSM hook
      selinux: Restrict cross-cgroup dma-buf charging
      selinux: Restrict dma-buf direct cgroup charging
      selftests/dmabuf-heaps: Add dma-buf memcg accounting tests

T.J. Mercier (1):
      memcg: Add MEMCG_DMABUF accounting infrastructure

 Documentation/admin-guide/cgroup-v2.rst            |   5 +
 drivers/dma-buf/dma-buf.c                          |  50 ++++
 drivers/dma-buf/dma-heap.c                         |  28 +-
 drivers/dma-buf/heaps/cma_heap.c                   |   3 +-
 drivers/dma-buf/heaps/system_heap.c                |  21 +-
 drivers/tee/tee_heap.c                             |   3 +-
 include/linux/dma-buf.h                            |   9 +
 include/linux/dma-heap.h                           |   3 +-
 include/linux/lsm_hook_defs.h                      |   4 +
 include/linux/memcontrol.h                         |  47 ++++
 include/linux/security.h                           |  18 ++
 include/uapi/linux/dma-buf.h                       |  26 ++
 include/uapi/linux/dma-heap.h                      |   7 +
 mm/memcontrol.c                                    | 176 +++++++++++++
 security/security.c                                |  34 +++
 security/selinux/hooks.c                           |  44 ++++
 security/selinux/include/classmap.h                |   1 +
 tools/testing/selftests/cgroup/Makefile            |   2 +-
 tools/testing/selftests/cgroup/test_memcontrol.c   | 290 ++++++++++++++++++++-
 tools/testing/selftests/dmabuf-heaps/config        |   1 +
 tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c | 227 +++++++++++++++-
 tools/testing/selftests/dmabuf-heaps/vmtest.sh     | 226 ++++++++++++++++
 22 files changed, 1210 insertions(+), 15 deletions(-)
---
base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
change-id: 20260508-v2_20230123_tjmercier_google_com-f44fcfb16530

Best regards,
-- 
Albert Esteve <aesteve@redhat.com>

