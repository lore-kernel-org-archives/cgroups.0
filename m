Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1BE29553B;
	Tue, 29 Apr 2025 23:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745970716; cv=none; b=QlFsKH6gdeC7/1pXGTYJ7y2ACcsk6zbKuQVARY7tCSGZMvr5qRzXWAIu8xwvY4jMW97xXPKegBDzIPXVmAT4tt0VHhWG/qAkzrf3T4n/v8GRXpYsLj8qF8I4eTTP6JaWgRWxa1sew3gjrti0tS6LXk6gu50KgY0HeV2BzHndiuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745970716; c=relaxed/simple;
	bh=i6blEhVqxoqepcDegl9UlCJ7Hl41lGlfqNPlgAsqdCE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AMSlACdXu3LFpUHLRaYwVs89i51HLo1WhrR/BQU9KfiPYs4E1mUWTmftmSNdzj2vSqmjuk7PS/BAnbBGQhOHuLhc2M6nGsakhVVxC0jqDQ+sMFqNtM7OzE574gEHftdZjGRm2P+nTJFw2IZUaik/5G42jgSD6HR/+yiBEqgqjV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MX67Eqyf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MX67Eqyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64132C4CEEB;
	Tue, 29 Apr 2025 23:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745970716;
	bh=i6blEhVqxoqepcDegl9UlCJ7Hl41lGlfqNPlgAsqdCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MX67Eqyf5mxXheuyOU2tLlorUSGf17Ab3si2XOCagUeVzjpsavai8qhGRCN2xGreg
	 D86djpF9b1NV3QkwCpkRvwSuNY4uTjXqDi9WbytD99hzsaeB+z2ary4ICYBrCNgob0
	 SxRrxJMAfVOh9cycFhNtJ2EqgrhGwaOpn0zRd4x9WL+fQJT9qFdX63JK9JzWfipU4G
	 Lz6KuLAFjWLTAsAIosGL28dVlpc+SWpHlcgtKepsJW4M8YRoiDFIWysUorogt1n/Jy
	 OzseTOxeS81Kbf1jRhmmCMK+1J9gqKYHgA9uZMGsrPJtyklPDHt+kbO+v4gpB7tgWz
	 fEgfSMo8hl6gQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: gaoxu <gaoxu2@honor.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	hannes@cmpxchg.org,
	cgroups@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 18/37] cgroup: Fix compilation issue due to cgroup_mutex not being exported
Date: Tue, 29 Apr 2025 19:51:03 -0400
Message-Id: <20250429235122.537321-18-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250429235122.537321-1-sashal@kernel.org>
References: <20250429235122.537321-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.25
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
index 4378f3eff25d2..23098cfa2fb11 100644
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

