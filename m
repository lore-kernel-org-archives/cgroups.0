Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B68D2D5D12;
	Tue, 29 Apr 2025 23:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745970806; cv=none; b=IItczr6gCOoEGc9YX/t6dNVgMtH4oi1h6K680Mbw0hFPF5L1PjEPXRFZQ1F06AI0I5CAV/wO4bBoSMHQQTr3Xz68hD7he15USjZ79g6YG9FGzOauKQLMX8pj8pQVk7fJwb3DglLINkpJEvBIadLZ0BEX10akAGpJ8V02fOxrXrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745970806; c=relaxed/simple;
	bh=in/YBg3OeimiyFQdWpdgoLoC3y0Tz/o5kRhFyHpGEIY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YbS6zV5aazx5lIIwae9sBGARG+4Dc4a/ZV5+hg5Gtt/5r7ED9SRz6kQBAZMaCdjoXD5GHBDDNguSW01nRsk5XRnx7vsSM7FBgVMvqmlu41SnIbURCLdaOWpa4+77Ha8Mh/MzQrq9Q2f1hMje6He1pl2APj3u0/K+DbGSpvXXA4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mH+BsWJv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mH+BsWJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE51C4CEEB;
	Tue, 29 Apr 2025 23:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745970805;
	bh=in/YBg3OeimiyFQdWpdgoLoC3y0Tz/o5kRhFyHpGEIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mH+BsWJvOA4P+9xQW0UhsODr6UN5YYFpXpuNZkQwjgnTl/LIbb/CHxVGEiHPoS8oc
	 /6AkOekv6Znq2jrQoSy8p9dqVj7Ph1AsxB/awdYhpStMrCB0/wyNTz0UmabibQqVdg
	 1QO/lKEP/FWzwXFHoAGgexH/THGDWG1QEjkPIYDpSlWANh+78yCIaLov9gkALHk5iT
	 Hl0Fl8HHPUi2qZ1RN2OvgmnFHGNyS5zPye9fMLWy+sjWx7rmwxUMx76z+4Sq2frjBz
	 kKyuK4n2q52I8Ilw4NYb1MIVSh+NxCX8UJzu6xwehnMSBi2wGYEYoYlWweCPP0CUQF
	 iq8aivcSHlwwg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: gaoxu <gaoxu2@honor.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	hannes@cmpxchg.org,
	cgroups@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 04/10] cgroup: Fix compilation issue due to cgroup_mutex not being exported
Date: Tue, 29 Apr 2025 19:53:09 -0400
Message-Id: <20250429235316.538129-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250429235316.538129-1-sashal@kernel.org>
References: <20250429235316.538129-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.135
Content-Transfer-Encoding: 8bit

From: gaoxu <gaoxu2@honor.com>

[ Upstream commit 87c259a7a359e73e6c52c68fcbec79988999b4e6 ]

When adding folio_memcg function call in the zram module for
Android16-6.12, the following error occurs during compilation:
ERROR: modpost: "cgroup_mutex" [../soc-repo/zram.ko] undefined!

This error is caused by the indirect call to lockdep_is_held(&cgroup_mutex)
within folio_memcg. The export setting for cgroup_mutex is controlled by
the CONFIG_PROVE_RCU macro. If CONFIG_LOCKDEP is enabled while
CONFIG_PROVE_RCU is not, this compilation error will occur.

To resolve this issue, add a parallel macro CONFIG_LOCKDEP control to
ensure cgroup_mutex is properly exported when needed.

Signed-off-by: gao xu <gaoxu2@honor.com>
Acked-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 6e54f0daebeff..7997c8021b62f 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -90,7 +90,7 @@
 DEFINE_MUTEX(cgroup_mutex);
 DEFINE_SPINLOCK(css_set_lock);
 
-#ifdef CONFIG_PROVE_RCU
+#if (defined CONFIG_PROVE_RCU || defined CONFIG_LOCKDEP)
 EXPORT_SYMBOL_GPL(cgroup_mutex);
 EXPORT_SYMBOL_GPL(css_set_lock);
 #endif
-- 
2.39.5

