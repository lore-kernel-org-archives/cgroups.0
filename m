Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00B02D1105;
	Tue, 29 Apr 2025 23:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745970777; cv=none; b=uY/vhIY8wqRJuGbnwrkUB6utSKHW2VC4TTuhw0hTAWWEGarAK+Hq3+psOnypG/LVosc9+RG5bTFa6kEiRgnY+RyzhiFbEPXg1y3QxGlJrOXJV+QmeBEfaXpz9stK9x7lMJLg9cahXgT4gKOX3fZ6F9JRJu4PwZM00koUGj81Z7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745970777; c=relaxed/simple;
	bh=lYO/Gq8uLAbwQcpJ9QV4HsIzvvt0sYaJinIwMBIkZuU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aJZ5UwAe7urqB8KCAgaL5S90UlYeO5Eorbv+5g3scQLFJFwJotqK9wpYKizVTwPfcPVIa2N2KQe4HcZg0q1QF5zTHU3gmVbolZatrMzdItvSuHoMBIFNiociQJfN8jfh4V/c0XRoidQipLeaQQ47fOhrltMIbDMwn0LPse1rj9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uoSjNA0m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uoSjNA0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02C7C4CEE3;
	Tue, 29 Apr 2025 23:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745970777;
	bh=lYO/Gq8uLAbwQcpJ9QV4HsIzvvt0sYaJinIwMBIkZuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uoSjNA0mk/XD05/ndrWAiGdT21oIKt+ol3L2/VpHAuLQauLnN5pq0+Qr+P/RTFIuT
	 B1wNyfGgqyugeVaMzqWyoR/fbxWkfOKP8PDw2xMoI24aYgsz5oFYXw9QR7wDNEKhYI
	 OM1OUMk9C3XHKt93dCVhci90J23xdkN6fy/a6NzuPOirv5SNt8VPp3hWlEaiWtaZKz
	 /5pYOxibRHm60yCCAwagun3//SXd0NpxxFhlgbxpJpDNpQsf6yahA1CWExSvs739bO
	 uBZ+h5jamGD/jH/+3mExinlH2sReUk/2n+WTShwpSI6TqbmGsuPeifr+0av+J6PnaI
	 Uj4Wq3aH1zkGg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: gaoxu <gaoxu2@honor.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	hannes@cmpxchg.org,
	cgroups@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 12/21] cgroup: Fix compilation issue due to cgroup_mutex not being exported
Date: Tue, 29 Apr 2025 19:52:24 -0400
Message-Id: <20250429235233.537828-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250429235233.537828-1-sashal@kernel.org>
References: <20250429235233.537828-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.88
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
index 3ccf80dfa587a..e8ef062f6ca05 100644
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

