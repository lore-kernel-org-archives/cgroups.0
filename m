Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75022E3387;
	Tue, 29 Apr 2025 23:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745970845; cv=none; b=bmgtUpjNq0OKhfO462dYjux+a/lG+iB41lMLQE2HT4R6E17QfbASMfLZy8tzuAMGvAm9a4soAC7qLecAOYzHbMTXS8XvRBOUm5FODCn7/DBTIxFEQVIu5OFuzIz4hHc8eoTp3wXSqQwv9G6P70FJsM4fgtkvYIV7+6wJXv1iMIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745970845; c=relaxed/simple;
	bh=HZSbn6lwmddM6i2oPV4a8YWV5KFx60U21kwWIdpteYA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bLjsGMxSTj9vw07VrwR6yNAqSSmKhe22xuJ+hxnGktlotQGm/Iyt10Fn+XIcGYRhIXtrAkMmjb0ViYMhQOmW3ErI31jjKRynsR11yLkOpEknabdaoPIu4KOwExtwcamdKEXMP3JsfRAclXdtABxzZNOwTEugnUIjBpRDqSfKoHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RfhwsY6d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RfhwsY6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC27C4CEEB;
	Tue, 29 Apr 2025 23:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745970844;
	bh=HZSbn6lwmddM6i2oPV4a8YWV5KFx60U21kwWIdpteYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RfhwsY6d9Uj2vVAeKkJ+7IXG9z4zCjZJdTC024nr/CfIYU/KnWlZSuHp/ZTjLl/MS
	 SIIBQ+qnNwqB8C4LHLTitKW7zwf/Yh1Rpfs+dr61+a1AxpYF/KaI7+6xri3XlU/UcR
	 E0LCyc2tPhxh6Uvrc3q9B8yoa5S7ly1hx+eb/HpyCxX1ZMxBIsiqNPeOSBD+NRVDNA
	 xWlhRkRglyJ0KVHedwkUENfvhF5+pn9xWLXtjHoZ96QgqR5y0JVvX9eo+TMGGoT+0E
	 x8kRz+MK0VFGD65SCPXfLCOM6I+gRRD0g+/IGUTfFjUcxvFyk64ttqLhc4qJAeTjzO
	 70rRJhHRdaaHA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: gaoxu <gaoxu2@honor.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	hannes@cmpxchg.org,
	cgroups@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 3/3] cgroup: Fix compilation issue due to cgroup_mutex not being exported
Date: Tue, 29 Apr 2025 19:53:55 -0400
Message-Id: <20250429235356.538413-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250429235356.538413-1-sashal@kernel.org>
References: <20250429235356.538413-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.236
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
index efeb0b7427501..37d7a99be8f01 100644
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

