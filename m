Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.139.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794454643;
	b=11z4J6mkp3mxkNmm6yVbvBRTsBCyB1Igdjc4PcZtaYwn0LhPZIdBJsBfz72wRXCGQwjD
	 ZIl6SZhwztDXHwdkSnTl09JN6gY4alcxmELG1UoHToiMRE34tLHTI42WkeOxydG6KGnnh
	 9Jw+v4TPGdXs/ui9d7J5Dv1wCkPhvqtu11Vaqz4P4f6OKihRplwFTXKHL8B8bS6kHFbbs
	 gJW5Gim5ukmtWlklLzWJEflo49WxZyF2IiHJ9SwOM6i8J+hbc+Vswi3Z/CXrGAcodTT6m
	 t4Br8j9lukbM0YE7jBZIZcLNJ4vKAxJXyftyGx2HPK7hNNlpiqNnZmxi52sc7fv5Kfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794454643;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:From:
	 Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer;
	bh=7sClOyXc5DYkp7gT7ltCBjv+6uzNG2TAXlQo0+7BqYo=;
	b=h7Cj+rn7GCTB7GGw70NlAqugzLiKHFMQPW4EychHoVvVHJqrPO+K5mPsdVhJEsqVRwG3
	 dVP6cWPIjjBg9T8LGy+/UmjE0xuC2wPs1YbbtIyFtaQZzohaxd7cM5y6dvowNz798GRK7
	 7rVnTsuPEupdPaZWjHA9r2E+L7Wf9hoxoD/IPesSFgvMXqBBnQSLIHHvaGE1nhkNa4sev
	 ZBS6nUXQa4UdrbAvOCuYXJxec+NbbQwDddrg76B4xHblCzvlqrhA/dGOqjnIi8mCwsZMv
	 nrMe23luKMFEKh0TjTySkCfAszJqhQcyKBVh2HomrYRgdPFT7TngkQ9o+nswqsIEyKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=bMo2DfS4;
	arc=none smtp.remote-ip=68.232.139.139
Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82ECC606A886;
	Thu, 12 Nov 2026 03:37:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82ECC606A886
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=bMo2DfS4
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1794454642; x=1825990642;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=03RedrnDsUkMfaAlXP5THfn6nEFN+a+p8i1kpiQJYtU=;
  b=bMo2DfS4uCpov5A2vl5cToXk2RUXFpGjy6PH+pH5tdcIVk+XDn9CYBA8
   dDIF1pgKSowwgoRsF4rliEYJKLC41qBwyfXSod/xLCxTh+sNQ4nhGsJk0
   5pqaWsmyLGNP5AIbW3IYiJosIUIYQVlCdvEgy0EEVawWJOQkCJwDOv6re
   ziC68kFN/DnRToJwK+hkMgMATjXXAwQKzlRw1n8UmdffjFWacQ/RPcohd
   nG4H5hryjeLJnCr6vq7VEdoC2HdOLxPhq2AcHQ9nQpI7pTlAavL6+LSJg
   maHkSV5sML1o9AB17rPAUjb1gDU9Y/aziRwMhTp8u1x1udjf65szo9q3a
   A==;
X-CSE-ConnectionGUID: KP/aVEA1To+ik+c+DB93NQ==
X-CSE-MsgGUID: 4rtNSXPERTCwdx8cyxSRIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="265537743"
X-IronPort-AV: E=Sophos;i="6.27,208,1786978800"; 
   d="scan'208";a="265537743"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 12:37:10 +0900
Received: from az2nlsmgm1.o.css.fujitsu.com (unknown [10.150.26.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 862631C04FB1;
	Thu, 12 Nov 2026 03:37:10 +0000 (UTC)
Received: from az2nlsmom2.o.css.fujitsu.com (unknown [10.150.26.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 3B26FC0128E;
	Thu, 12 Nov 2026 03:37:10 +0000 (UTC)
Received: from [127.0.1.1] (unknown [10.124.178.20])
	by az2nlsmom2.o.css.fujitsu.com (Postfix) with ESMTP id 2D4CF1801928;
	Thu, 12 Nov 2026 03:37:03 +0000 (UTC)
From: Kohei Enju <enju.kohei@fujitsu.com>
Subject: [PATCH RFC v2 0/2] KVM: arm64: CCA: Add MEC policy support for CCA
 Realms
Date: Thu, 12 Nov 2026 12:36:20 +0900
Message-Id: <20261112-mm-v1-mec-v2-0-0d1dd260a588@fujitsu.com>
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
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADU09WoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyjHQUlJIzE
 vPSU3UzU4B8JSMDIzNDQ0Mj3dxc3TJD3dzUZF2LZFMDc6MUs2RjY0MloPqCotS0zAqwWdFKQW7
 OSrEQweLSpKzU5BKQKUq1tQDZmoSfcgAAAA==
X-Change-ID: 20261112-mm-v1-mec-8c5072d6c331
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Steven Price <steven.price@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 cgroups@vger.kernel.org, Kohei Enju <enju.kohei@fujitsu.com>
X-Mailer: b4 0.16.0

This series adds basic support for configuring the Memory Encryption
Context (MEC) policy for Arm CCA Realms.

Patch 1 introduces the KVM_ARM_VM_RMI_CTRL device attribute group to
allow userspace to configure Realm VM parameters before the Realm is
created using KVM_SET_DEVICE_ATTR, and uses it to let userspace select
the MEC policy before the Realm is created.

Patch 2 adds a misc cgroup resource for CCA MECIDs and charges one unit
for each Realm using the private MEC policy.

Feedback on the proposed KVM ABI and on using misc cgroup for MECID
accounting would be appreciated.

This series is based on Steven and Suzuki's CCA host series [1]. I am
sending it as an RFC while the CCA host series is not yet upstreamed,
and plan to update it as needed to track future revisions of the host
series. Once the host series is merged, I plan to post a non-RFC
version.

Since the base series is not yet upstream, some CI systems may not be
able to test this series successfully. This is expected for this RFC.

Changes
- RFC v2:
  - Use kvm_device_attr instead of a dedicated ioctl.
  - Rebase onto the CCA host series branch listed in [1].
- RFC v1: https://lore.kernel.org/all/20260724094120.166536-1-enju.kohei@fujitsu.com/

[1]
 https://gitlab.arm.com/linux-arm/linux-cca
 branch: cca-host-mm/v1/integration

Signed-off-by: Kohei Enju <enju.kohei@fujitsu.com>
---
Kohei Enju (2):
      KVM: arm64: CCA: Add support for configuring the Realm MEC policy
      cgroup/misc: Add support for Arm CCA MECIDs

 Documentation/virt/kvm/devices/vm.rst   |  25 ++++++++
 arch/arm64/include/asm/kvm_rmi.h        |   7 +++
 arch/arm64/include/uapi/asm/kvm.h       |   4 ++
 arch/arm64/kvm/arm.c                    |   4 ++
 arch/arm64/kvm/rmi.c                    | 101 +++++++++++++++++++++++++++++++-
 drivers/firmware/arm_rmm/rmi.c          |  10 ++++
 include/linux/arm-rmi-cmds.h            |   1 +
 include/linux/misc_cgroup.h             |   4 ++
 kernel/cgroup/misc.c                    |   4 ++
 tools/arch/arm64/include/uapi/asm/kvm.h |   4 ++
 10 files changed, 163 insertions(+), 1 deletion(-)
---
base-commit: a7644e0425de41ed0338cb73eebe5d14baf6be95
change-id: 20261112-mm-v1-mec-8c5072d6c331

Best regards,
--  
Kohei Enju <enju.kohei@fujitsu.com>

