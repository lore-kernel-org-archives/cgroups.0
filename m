Received: from mta1.migadu.com (out-203.mta1.migadu.com [95.215.58.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9333B0597
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 03:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790047342; cv=none; b=NjQRzJSn2abAuiC+7xAlxTnh51ailL65SDHTlCaY+X5yuDukwsQ4wCd0a53D3GJgF0pxc91b4h8C9R2XLOfVp+QOLGP4ZcriYD21C1CRlBQLwxRmRSkoY40khvCCfvcG31tiZorFchUxAWsZ07n961rRIuJymDfJ0Jktbxk9vTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790047342; c=relaxed/simple;
	bh=D6xp+DQw2/JOLv/xyLpiYWzZgQK22tQnX4ABmanyYO8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GhgkO/RmaPXGd2eaGeYFxtSkn0WtBSzNWiPKX54gtWsiNRsJ2xnIWCOu6SfyUdkZrXhKJUrI9MarreX6n1V1vEKspSo6D9+aWBxwPnlYhOLp+jwLHp9DgB5roKAwcKos72yhFQ4m8UnbM3nZk042f+uGGKL4dCnFff5ewrgeNeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PpArhTp0; arc=none smtp.client-ip=95.215.58.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PpArhTp0"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=D6xp+DQw2/JOLv/xyLpiYWzZgQK22tQnX4ABmanyYO8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790047337; v=1; x=1790652137;
 b=PpArhTp0zGXteX0eGj7GdprIMBe/qJfluR7VxfAO8MnEdXzqarPeiSrFppWaHOMBgtMgPW6v
 DdcpYGu8ZnswjcLwKCs+Rk9WP8GIAMK8CmUAIGlOLUQOIXqcjxy5iM8G5QbeeEVFEwOdFmjAi3r
 rjqagDhZGL7uUgySx6dp3Y2A=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id de3b09413563fae3;
	Tue, 22 Sep 2026 03:22:17 +0000
X-Mizu-Trace-ID: de3b09413563fae3
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v2 0/2] docs: cgroup-v2: Correct cpuset CPU descriptions
Date: Tue, 22 Sep 2026 11:21:28 +0800
Message-ID: <20260922032130.33777-1-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

The cpuset interface documentation says cpuset.cpus.isolated is empty
unless an isolated partition exists, omitting CPUs isolated at boot with
isolcpus=domain. Its cpuset.cpus.effective description also assumes CPUs
come from the immediate parent and are normally a subset of
cpuset.cpus, which is not always true for valid non-root partition roots.

Update both descriptions to match the existing behavior.

Changes since v1:
- Reword the cpuset.cpus.isolated description as suggested, while
  specifying the domain flag of isolcpus.
- Add examples of the cpuset.cpus.effective relationship for member or
  invalid partition roots and for valid partition roots.
- Add the Suggested-by tags and the Reviewed-by tag.

Guopeng Zhang (2):
  docs: cgroup-v2: Describe boot-isolated CPUs in cpuset.cpus.isolated
  docs: cgroup-v2: Describe effective CPUs of partition roots

 Documentation/admin-guide/cgroup-v2.rst | 59 ++++++++++++++++++++-----
 1 file changed, 48 insertions(+), 11 deletions(-)

-- 
2.43.0
