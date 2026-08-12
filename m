Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5123521D591;
	Wed, 12 Aug 2026 02:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786501596; cv=none; b=N55lXb67ZaAS3eH5BTHGXb3bljhwZrKaYm3mmGdPEvWdNS328wYVoQfimUMdsIcbbJK86yVcZUfC6v25bsa6MCXTZNk4vshkuPvFJqmxO8s5SYKdkRyroL0CQHpq3C/TMZT6QDi0SfoXapR+5ehtjWjhj6TYd7bcGr1ZPkV6qoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786501596; c=relaxed/simple;
	bh=5iPn6f3c+bQdP0S+y6fh73fMxWBoOSs1NUnL+BsvQXg=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=TwFkpeAmRPfmGd3WgHKvP5gOf7CjAwDaReZ3/GaukeLArigpj1UTO6Kd3RptqL/+uYgsDyo1i2tkYwiCu1RAzMthOzlUJ9tAii1VKGlUabT3ns/tCfWhTb6qiEXSp0lwF+Av53x1uo7F4ZbR83nzuirjxBubYCXlyNSW2MTf8cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hH8+zDr5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hH8+zDr5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2E91F000E9;
	Wed, 12 Aug 2026 02:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786501595;
	bh=F+N46jRqqu1MK/cmUEgZVM4kZACeQw3OAdbWZRgLv9k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hH8+zDr5myq/Sg9Rgvy2X9ThWzLHaMfiy/y1VfEgNAwhWChuzdBjHQMTnRYbQ6scy
	 Op/SeskZ3c7Y4gaaCekDlrDAN3msS/YPPUncBgCj3nq3tCOSa8tOOFi+0ejfN8V/Lj
	 wfKHmzs5MXi6jnwi5b63MPcSyK9Il+W8JWi3Thnzmr0lJflQE7ahPwwuUEhRs8vMm2
	 /EteK0yON4kVfK6M9tfHHK4cf3FUH7PMWXZ4NSXexWSlPEkeJK8vna755wbGQI7wSs
	 MU2pFq5Zoo9P+HTL5aAhyM4xpjh22fD4ixGES0shxg4MH8ApBhEBRFFRDLX1qsI8qj
	 W/TkUf84DMtgw==
Date: Tue, 11 Aug 2026 16:26:34 -1000
Message-ID: <39560be1e73e8736d5569a608caebe37@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Shaojie Sun <sunshaojie@kylinos.cn>
Cc: longman@redhat.com, cgroups@vger.kernel.org, hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	mkoutny@suse.com, ridong.chen@linux.dev, shuah@kernel.org
Subject: Re: [PATCH v2] cgroup/cpuset: Add test for partition root
 invalidation returning wrong CPUs
In-Reply-To: <20260811095848.365138-1-sunshaojie@kylinos.cn>
References: <20260811095848.365138-1-sunshaojie@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-7.3.

The patch was generated against a base which predates 866f587e9c70
("cgroup/cpuset: Avoid unnecessary cpus & mems update in
cpuset_hotplug_update_tasks()") and no longer applied, so I moved the
new entry to keep it with the other sibling-exclusion cases and matched
the current column alignment. The applied change follows:

diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 8e21e9fc439c..8380fd9d76bd 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -502,6 +502,12 @@ REMOTE_TEST_MATRIX=(
 	"  C1-4:P1   .   C1-2:P1  C1-3:P2  .       .  \
 	      .      .     P0      C2-3    .       .     p1:1,4|c11:1|c12:2-3 \
 							 p1:P1|c11:P0|c12:P2 2-3"
+	# Changing a sibling partition's cpuset.cpus to overlap with another
+	# sibling partition should invalidate itself and return only actually
+	# allocated CPUs (effective_xcpus) to the parent.
+	"  C1-4:P1   .   C1-2:P1  C2-4:P2  .       .  \
+	      .      .     .       C1-2    .       .     p1:3-4|c11:1-2|c12:3-4 \
+							 p1:P1|c11:P1|c12:P-2"
 	# Cpusets with empty cpuset.cpus should inherit parent's effective_cpus
 	"  C1-4:P1 C5-6   C1-2     .       C5      .  \
 	      .      P1    P1      .       .       .     p1:3-4|p2:5-6|c11:1-2|c12:3-4|c21:5|c22:5-6 \

Thanks.

--
tejun
