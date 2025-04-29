Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1592DC772;
	Tue, 29 Apr 2025 23:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745970854; cv=none; b=nByamxn+mCqLyxpYhREZEm/hKJMv5ePEsAV5a35yEx00nh2FuSKmjXcEfJ2Lq9T+ro5TCZoIm/aE9GRPmo73vqSjY8mHPl/pB2/xTOAt4aGI2VysLyf3ggWZauzRzldy/f9nrCoCTLJ6Amtl5XsjxathcZgeinSWR/4g0FtdZCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745970854; c=relaxed/simple;
	bh=hu61zk39HGnTSOOhtJqBedDlmunQ/OaaqH7RANdatyc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hpPjABXg6Gkgte2QUUSIkC15cpb+T1IQSgZInSobCEUGfppta/vYi3dNLucxn3x562H8uaxDuYJ7jGEcSH7h/c3+UIHkK9GAIJcjvoKJ62XjPFbLuC7N0UK3Dami3zLIEW4/s7o8tc/7At7gFfQaXny3/1ieOfqXZl+MgPJd/Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O8BgAZvJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O8BgAZvJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE34C4CEED;
	Tue, 29 Apr 2025 23:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745970854;
	bh=hu61zk39HGnTSOOhtJqBedDlmunQ/OaaqH7RANdatyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8BgAZvJUg9Jaehew9+Ir0NecHoydsf8T/21LFS+8q9pX8Bl/uTHe1EQUBHKUJVjN
	 MdUHXAL6yvWPycxkJ0zx7l/MpunSWMsQR9vWqlCtFWPOjzdSdJS9rix0JBUtXYbDMz
	 /w8rxlmCXzrO/BicIcrYKxZcTa5LGmOaYf+XhqpVGMWL1Wt6b1LkfQFIaOdecwxAo5
	 0HOZjjuqb8lTKqgRUueFUZ5rIeRfaLIlv1xjfrGcK1Cafx2iAtDpxlein2yXcsCgp6
	 IZWjLX3a0qvuTHwhcHCnreFdWs7+KVWIunaPjOJxSRq7UswtCDO3oF/p3kneazX3QL
	 ZIkN9loTrcrSw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: gaoxu <gaoxu2@honor.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	hannes@cmpxchg.org,
	cgroups@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 3/3] cgroup: Fix compilation issue due to cgroup_mutex not being exported
Date: Tue, 29 Apr 2025 19:54:05 -0400
Message-Id: <20250429235406.538466-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250429235406.538466-1-sashal@kernel.org>
References: <20250429235406.538466-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.292
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
index 273a8a42cb721..801022a8899b5 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -81,7 +81,7 @@
 DEFINE_MUTEX(cgroup_mutex);
 DEFINE_SPINLOCK(css_set_lock);
 
-#ifdef CONFIG_PROVE_RCU
+#if (defined CONFIG_PROVE_RCU || defined CONFIG_LOCKDEP)
 EXPORT_SYMBOL_GPL(cgroup_mutex);
 EXPORT_SYMBOL_GPL(css_set_lock);
 #endif
-- 
2.39.5

