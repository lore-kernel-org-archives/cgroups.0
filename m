Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF853B4EBC;
	Wed, 15 Jul 2026 08:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784104982; cv=none; b=DuRRe+YCgynKdIjVVW1gOsLOjEU3vTEdJowxp7cw5Rz7ts3AfONVo6oR/OmOiCmGnVWQuGgzcKMPwj7OKP/ui+jtn2BCzB7i4Zz+R6Sd8ZCA6RHkI0/O8uYEryIhuxHoLrSAF9EffIczx+nv7tHnlt3efykjzUykP/g+gs8/Vc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784104982; c=relaxed/simple;
	bh=wM6CLola6B2GFF3988xRVkSeHvzK8Am3QE6zZhvJbBg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=l5b9PS2gEG18N9dcTo1mmBWe7sdhSK1Ki3BN6mwbLCDvqkv5E+Q1w+oXCMx6jrVdDqENIN12CVLwLn7M8unGhixupN7sFHEgq+W/GEcci5IDMfzXi1YWY8hwFOlCiMNx9DQkVIlNL8uAMozGdsXvnjvFZ6coiDkt0Lw1MFLDe6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=kLF7flyU; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="kLF7flyU"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784104974; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=xfldyTNDHCFTa6fvmjV4MUiBwe8GJdvnuUp7ls7VEqg=;
	b=kLF7flyUQKyOa90P0RsgE5l5oreI5z9qCWq02jQMxY4J6Ld6tDR2jHGjzOfMZODKC7BeEbvt8bA/oEvrE2j7LzKADkmRDQqHXn9G5RnIa/bcnbmYhvMyqaqZliFiEMV7S0AEcxttpnTsRJVNZ2UkuFMt6ip5xU+bckApf6wbHVI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=lulie@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X78c-OI_1784104973;
Received: from localhost(mailfrom:lulie@linux.alibaba.com fp:SMTPD_---0X78c-OI_1784104973 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Jul 2026 16:42:54 +0800
From: Philo Lu <lulie@linux.alibaba.com>
To: stable@vger.kernel.org
Cc: tj@kernel.org,
	hannes@cmpxchg.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	eadavis@qq.com,
	surenb@google.com,
	akpm@linux-foundation.org,
	dust.li@linux.alibaba.com
Subject: [PATCH 6.1.y 0/2] sched/psi: fix race in pressure_write (CVE-2026-52991)
Date: Wed, 15 Jul 2026 16:42:51 +0800
Message-Id: <20260715084253.43276-1-lulie@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset is same as that for 6.12.y.

Backport of the CVE-2026-52991 fix.

  1/2 (94a4acfec146) clear of->priv on release, turning the UAF into an
      easier-to-detect NULL deref.
  2/2 (a5b98009f16d, the CVE fix) extend cgroup_mutex to cover all
      of->priv accesses, read ctx after taking the kn lock, and NULL-check
      of->priv. It depends on 1/2 as discussed in [0].

[0] https://lore.kernel.org/all/8a06c5c3-8f7a-4252-a3b1-0c0d812e2654@oracle.com/

Chen Ridong (1):
  cgroup/psi: Set of->priv to NULL upon file release

Edward Adam Davis (1):
  sched/psi: fix race between file release and pressure write

 kernel/cgroup/cgroup.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--
2.47.3

