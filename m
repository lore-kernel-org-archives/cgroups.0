Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949802DFA5E;
	Tue, 29 Apr 2025 23:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745970829; cv=none; b=Y7XTrzOIWZl5N4nKwprFtRQiP2/QN4wShuDrR4CliTZROhh0aEv1ng6rxIPzY/7aHCxQngTQu2rIJlj9b3oR5luqFM5AdNTt44JtVXCumwvmC6EUR0smZzpuJDmx70HgwUVGMiiT15gNnvnKoKKDQ8y+4iGOx8OZUzaORcLOuXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745970829; c=relaxed/simple;
	bh=L1DXBN/ZIWGkfyY4/8zCa24buJIdqykH1WWhCW9C04c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QpIMzG5QnY2wPT7YPeyh0+uNhuEGvIwxo23qQekSCtgm6y19TqwvnEIhjFRpRC5i2u3E+gkt5dXhGU3cBP2+MCHEKoKdLtCCNbwSkPSEFEYQsyDBrECTL+Mryz6yzimHaCFjl6+qg0vjqhpzT8tPPIsE8BzFYSwb7SJswJPCqhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eUA83+6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eUA83+6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81EF2C4CEEE;
	Tue, 29 Apr 2025 23:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745970829;
	bh=L1DXBN/ZIWGkfyY4/8zCa24buJIdqykH1WWhCW9C04c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eUA83+6Fw3ViOnNnoaIP9MG4f2IV2Jl7SCkaFmDLT/yu9voLCSlp5O3ijGqah02C4
	 ipZtLjufhy0SVOgmdvdQlMmBW0AEltNLz0gNMiJdQUs3C4SzGus5XKyqF4H/DnshHI
	 wKACNVWRu0871+OvwXxi8jhRyLzmKSnXO2njdeuiDBgt/LNZUf+mSmuJCqGxew9g6n
	 gtHWeTHFbW77zZLiZbphgafoERaMM3eyUHvZC6O78xRqxF2kUBmZVQ7F/g2Z2QHSR+
	 ftsUHg+ygtIVJwf/cjr0U64t0VRdbAt3BKsfkQEGGtsgSW0gihQl8tZrq6fh/bRI6F
	 Ew2TFDDVMQY0g==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: gaoxu <gaoxu2@honor.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	hannes@cmpxchg.org,
	cgroups@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 4/7] cgroup: Fix compilation issue due to cgroup_mutex not being exported
Date: Tue, 29 Apr 2025 19:53:35 -0400
Message-Id: <20250429235339.538269-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250429235339.538269-1-sashal@kernel.org>
References: <20250429235339.538269-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.180
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
index 1e87257fe4692..1a3b2e1436db0 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -89,7 +89,7 @@
 DEFINE_MUTEX(cgroup_mutex);
 DEFINE_SPINLOCK(css_set_lock);
 
-#ifdef CONFIG_PROVE_RCU
+#if (defined CONFIG_PROVE_RCU || defined CONFIG_LOCKDEP)
 EXPORT_SYMBOL_GPL(cgroup_mutex);
 EXPORT_SYMBOL_GPL(css_set_lock);
 #endif
-- 
2.39.5

