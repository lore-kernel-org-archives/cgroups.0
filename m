Received: from esa8.hc1455-7.c3s2.iphmx.com (esa8.hc1455-7.c3s2.iphmx.com [139.138.61.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A79A3D954D;
	Fri, 24 Jul 2026 09:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.61.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784886105; cv=none; b=hvu+I2GLeeUiYaJ7iisiF4tdoVjG6WIc/t349WF1gxcP8kq36DygzcSAZ6Lwgram259uv1gfGOTolLwI1qQkXwN2lk4L+FazYKLGecaGNpslBC/Kkv807jvIFdtckEbEiDeUUlLrCcmEON75aTpCGtR8VUQkTz9qcar5kPbyxcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784886105; c=relaxed/simple;
	bh=f5CcZqphHBrvD7a007cTCKmcn7WQevg0a7HgyWWOquQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j5klxaadk6vtZEhCIdKM4Wm9zjxkcFqPars9q3BrHMUU0MmE8tNs4YxTBw50SQ5zGD771+BWwtHA9tMHVnfTjoY1cdEJvC/pczlVh6FWztZznRWeQW6XdX9IR2zehDQN+5IjArF3lk9FJbu0BD+t0A2Qx9lYkuPE+4zOXEh4h4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=EFcBhAaG; arc=none smtp.client-ip=139.138.61.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="EFcBhAaG"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1784886103; x=1816422103;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=f5CcZqphHBrvD7a007cTCKmcn7WQevg0a7HgyWWOquQ=;
  b=EFcBhAaGDVtL0Yz3RAZS7GZ8Glg8c790L89CVEMYCxhiclaKdm+VPIK8
   2abeE6Yno/80rrX16d10x6YdhAOFNTnhPNp85CBsTev3NMAFKbqKXBHrh
   krJtAq+vDPYw2gsGHx9IAvKYfsMi7CcZWdthc+3hD7y3gyiYPFOEFfrd+
   xfQec+6SvlN9VQTQop1dDgcIjNuqtR9X3LQ71Em34UKMAqRhWxiKY5He0
   XVFrhREIX+YN+gQ7T9z1J0p9HDyFKdzB0mSWAX7Jzk1D0Lqb/rYSo9onf
   YzeKK2YoOg1p9st2mLxM+v2xSYoMBFyw9enM6AjD+nM9JvLOAFXfZ4dfv
   Q==;
X-CSE-ConnectionGUID: zXkrrLCkRDutnHA1PiuS2g==
X-CSE-MsgGUID: mQweJSt5TQGfAou4UhZzng==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="236443448"
X-IronPort-AV: E=Sophos;i="6.25,182,1779116400"; 
   d="scan'208";a="236443448"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa8.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2026 18:41:36 +0900
Received: from az2uksmgm1.o.css.fujitsu.com (unknown [10.151.22.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 610EF1002803;
	Fri, 24 Jul 2026 09:41:36 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 179DF82679B;
	Fri, 24 Jul 2026 09:41:36 +0000 (UTC)
Received: from sm-arm-grace07.ssoft.mng.com (unknown [10.124.178.20])
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTP id 53FB7405A97;
	Fri, 24 Jul 2026 09:41:30 +0000 (UTC)
From: Kohei Enju <enju.kohei@fujitsu.com>
To: linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	cgroups@vger.kernel.org,
	linux-coco@lists.linux.dev
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Steven Price <steven.price@arm.com>,
	Kohei Enju <enju.kohei@fujitsu.com>
Subject: [RFC PATCH v1 0/2] KVM: arm64: CCA: Add MEC policy support for CCA Realms
Date: Fri, 24 Jul 2026 18:40:54 +0900
Message-ID: <20260724094120.166536-1-enju.kohei@fujitsu.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds basic support for configuring the Memory Encryption
Context (MEC) policy for Arm CCA Realms.

Patch 1 introduces a new Realm VM ioctl, KVM_ARM_RMI_CONFIG, and uses it
to let userspace select the shared or private MEC policy before the
Realm is created. The default remains the shared MEC policy.

Patch 2 adds a misc cgroup resource for CCA MECIDs and charges one unit
for each Realm using the private MEC policy.

Feedback on the proposed KVM ABI and on using misc cgroup for MECID
accounting would be appreciated.

This series is based on Steven Price's CCA host series [0] [1]. I am
sending it as an RFC while the CCA host series is not yet upstreamed,
and plan to update it as needed to track future revisions of the host
series. Once the host series is merged, I plan to post a non-RFC
version.

[0] https://lore.kernel.org/all/20260715142841.80544-1-steven.price@arm.com/ 
[1] https://gitlab.arm.com/linux-arm/linux-cca  cca-host/v15

Kohei Enju (2):
  KVM: arm64: CCA: Add support for configuring the Realm MEC policy
  cgroup/misc: Add support for Arm CCA MECIDs

 Documentation/virt/kvm/api.rst   | 29 +++++++++++++
 arch/arm64/include/asm/kvm_rmi.h |  6 +++
 arch/arm64/kvm/arm.c             |  9 ++++
 arch/arm64/kvm/rmi.c             | 73 +++++++++++++++++++++++++++++++-
 drivers/firmware/arm_rmm/rmi.c   | 12 +++++-
 include/linux/arm-rmi-cmds.h     |  1 +
 include/linux/misc_cgroup.h      |  4 ++
 include/uapi/linux/kvm.h         | 17 ++++++++
 kernel/cgroup/misc.c             |  4 ++
 9 files changed, 152 insertions(+), 3 deletions(-)

-- 
2.43.0

