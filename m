Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4430F423EA1
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 13:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208205; cv=none; b=r7usoH0t529DMIuyGXeuiW6EjIBanDCdolWmQDFeGepFkn61JgFqrrihVUXcIZsz00bvfpwkUGNMNqdsczfYQ2XuqZsw9K1n82d6VIMEqlftrDis/AW2xCH6+0E3YqtuNYOECKXNB/Zfl7yrHbAMi52TGRwlk1FAy0A54Ao/LZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208205; c=relaxed/simple;
	bh=VH7ls6oS3JXo8rVW0MfQ99q9DKuXUysicTSoN/sq33g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LiAl1utKRdiCMozrjJzFZWeRntl0lHYpXepeItJvpBLcqlgGcroCNHveCAjG3c2JYY0usk426etuBsSnVWP7TLS2m+GKCGId0X/7k0tolgmgtGrexOeRolQO0cXOI3kHUYV7ciNXFKQ3Z8M6chhaVH7HcoJDx2heo/zeW+ZIGDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=w4Wah1Hw; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="w4Wah1Hw"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47c2b362ee2so5857198f8f.1
        for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 06:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1784208199; x=1784812999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=D6Q0MKGqIF4orx9zGR7eUo6VhJ11Sr2evJgGoyQOE4c=;
        b=w4Wah1HwFUJorSFXv3gg4YZgAdiNC9roLfvlgy4YTTqOH41y/hQ4XEL819J8MUWew6
         /sc5kQWFhjiam0dK7CXBZ/pe7iBes5+nbIxw3iAPP9fGbXfmxZ/+7H/fWkeyY5wUlphM
         fh9TQz0cv+hvWepCwM+2Xn9f12GaVZLI9VgQDcsF+m++o7bknWdGfKKPcztMwHf2tLg/
         Zh2B1d2ThM/aHk6KQDM7ozY9WWGaUNPaNaPRuOFujd1B579X3Z2m2ridqIEgFFHJ2zlr
         eX2c8z+IdhAp8RnaHai7vfX+qGd2lkTWiLjZXtQn2X971CDPywXrhTmQfmGZ3pJKYhAw
         AUvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784208199; x=1784812999;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D6Q0MKGqIF4orx9zGR7eUo6VhJ11Sr2evJgGoyQOE4c=;
        b=iIU0cJCGYm3rqp1Rw/czxAimaUxAPvVqrgOlK8BD60MKCvBv48D8fSQ1OvTk0p9ee3
         uBH1hbuDRPzkDXTxWmpxBXPQqkgORz6GWroNVp7Cyrl74nnx7ApvfkjHFXFtc7hBxJGO
         iaGWbU0hW5abNzlGH4SsMpYkB9oEQ0dkcFG40bl382euyJ1w/ElaOE0d0chc9Kp1JWpP
         pzUhcWQfxDXxM/dKCFX/zAAxXXPnnBwuA577ReEQhQ2nwwR95uoSuMdm9uLpgKf9jcvn
         mcyc1/Z+aDaLTNrwXFl03jxuxEoDCCUxmk5ghiv+TmvACPsr3VNrfDqY958vBNVQWGep
         b7qw==
X-Gm-Message-State: AOJu0Yxcn9VBU0sjlgU52qhxZjvTigbF+xZZYH1Y4rZlqd2/ZBV2qC4i
	oZEtVobyfEFg/T9eLta4gj67ikunT2xRRHlLQbp6MrDUtRKlQpFk0ILd+9XOCxOJtvg=
X-Gm-Gg: AfdE7clyTTpbg8qSNPrKwy2dsJ+XvX5ErPGlUgKGre0tognv3YQiR8asN1WfYJ6O9Pk
	VZdF5N9XA1faidZMqpGUBAVKbev+fZQnDopAfaaIE/6xL6XO/ZmGoMmWsajSjNVSeCiqbHPw4Fa
	YjFbyZWsWII+Pm55PrsPQMFkn9ALAGFwUCILigB1sDjzI8UDhYQu9t4SpCnAPiq5MKtsk0pE5Fk
	j4CPGnecyvj99oR9j39MZboJ0ev3VUf1i6BWYObpQLvHGaLnMPrQXL8ggri7/IFh/Fqfb+t7PZD
	CD4NkbQvr0zBXZn6/+wvJ0bbVc9Qb+dCNXB1b8IfXXkmFjX2Xxll7pLduxeOb6zBtxBDxu2T43s
	NsfSXJ0t7xpOyHryEvMJUFbPZolznUKiGMbhNGvMo+TiCSW0ccN7A3bTzI62VFS0XpCqF+zNgJ8
	JkngUrBYNTv18/dR5RaTVQSA==
X-Received: by 2002:a05:6000:4b06:b0:460:2eee:4e21 with SMTP id ffacd0b85a97d-47f4fcd5592mr9318323f8f.17.1784208199021;
        Thu, 16 Jul 2026 06:23:19 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4635a9cesm24674591f8f.14.2026.07.16.06.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 06:23:18 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: linux-rdma@vger.kernel.org
Cc: cgroups@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	parav@nvidia.com,
	mbloch@nvidia.com,
	cmeiohas@nvidia.com,
	roman.gushchin@linux.dev,
	bvanassche@acm.org,
	zyjzyj2000@gmail.com,
	shuah@kernel.org,
	tj@kernel.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	wenjia@linux.ibm.com,
	yanjun.zhu@linux.dev,
	cui.tao@linux.dev
Subject: [PATCH rdma-next v3 00/14] RDMA: Make device names unique per net namespace
Date: Thu, 16 Jul 2026 15:23:01 +0200
Message-ID: <20260716132316.1495242-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiri Pirko <jiri@nvidia.com>

RDMA device names are unique system-wide today:
__ib_device_get_by_name() checks a requested name against every
registered device regardless of the network namespace it lives in.
A device in one network namespace therefore cannot use a name already
taken in another, even in exclusive netns mode (netns_mode=0) where
the two are otherwise isolated. Net devices have no such restriction -
their names only need to be unique within a network namespace.

This series makes RDMA device names unique per network namespace,
matching net device semantics, and adapts the users that assumed
system-wide unique names.

Scoping reuses the existing rdma_dev_access_netns() predicate, so
behavior only changes in exclusive mode:
  - shared mode (default): names stay unique system-wide, no change;
  - exclusive mode: names only need to be unique within a namespace;
  - CONFIG_NET_NS=n: everything is init_net, names stay system-wide
    unique.

There are two users that cannot be made per-namespace and are
documented as known limitations instead of changed:
  - the rdma_cm configfs tree: configfs has no network namespace
    support, so it cannot represent two same-named devices;
  - SELinux ibendport labelling: endports are labelled by (device
    name, port) from a global policy; distinguishing same-named
    devices would need net namespace support in the SELinux policy
    language and tooling.

Tested with the new rxe_netns_names kselftest added in the last patch.

Jiri Pirko (14):
  RDMA/core: Pass the net namespace to the device name lookups
  RDMA/core: Handle device name conflicts when changing net namespace
  RDMA/core: Support renaming a device when changing its net namespace
  RDMA/nldev: Report net namespace move errors through extack
  RDMA/nldev: Allow setting the device name while changing net namespace
  net/smc: Look up the pnetid ib device within the net namespace
  RDMA/srp: Make the SRP sysfs class net namespace aware
  RDMA/cgroup: Disambiguate devices across net namespaces
  RDMA/cma: Document that CM configfs cannot be net namespace scoped
  RDMA/core: Document the SELinux ibendport net namespace limitation
  RDMA/core: Make device names unique per net namespace
  RDMA/rxe: Allow queue VMAs to outlive ucontexts
  RDMA/rxe: Implement disassociate_ucontext callback
  RDMA/selftests: Add rxe_netns_names test

 Documentation/ABI/testing/configfs-rdma_cm    |   4 +
 Documentation/admin-guide/cgroup-v1/rdma.rst  |   8 +
 Documentation/admin-guide/cgroup-v2.rst       |  15 +-
 drivers/infiniband/core/cgroup.c              |   1 +
 drivers/infiniband/core/cma_configfs.c        |   4 +
 drivers/infiniband/core/core_priv.h           |   3 +-
 drivers/infiniband/core/device.c              | 245 +++++++++++--
 drivers/infiniband/core/nldev.c               |  26 +-
 drivers/infiniband/core/security.c            |   6 +
 drivers/infiniband/sw/rxe/rxe_mmap.c          |  35 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c         |   5 +
 drivers/infiniband/ulp/srp/ib_srp.c           |  16 +-
 include/linux/cgroup_rdma.h                   |   1 +
 include/uapi/rdma/rdma_netlink.h              |   5 +-
 kernel/cgroup/rdma.c                          |  71 +++-
 net/smc/smc_pnet.c                            |  20 +-
 tools/testing/selftests/rdma/Makefile         |   3 +-
 tools/testing/selftests/rdma/config           |   2 +
 .../testing/selftests/rdma/rxe_netns_names.sh | 334 ++++++++++++++++++
 19 files changed, 705 insertions(+), 99 deletions(-)
 create mode 100755 tools/testing/selftests/rdma/rxe_netns_names.sh

-- 
2.54.0

