Received: from mta1.migadu.com (out-205.mta1.migadu.com [95.215.58.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CEDE444713
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 09:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790068853; cv=none; b=LQ/BLzVVvH+Q4K5p5qvbVicmSM/dWGhgh578BW6u633SKOr9vodAAggTkUh9CQD0OdPKJqaG98IHXG7d/jcKY6CsHDzL8IypCGAgHvyfhOytaU+0yDVVCa3HfM+P5H6bjR8R6o9/P3Mhm6v7mVsNZbd66VRxNIieaQZDymEqWDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790068853; c=relaxed/simple;
	bh=tfcR+1vIe3NIrCiR3cbKx8vH9DZhm95Ra8XfKKaDhrk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WZfVDwexmwETCoubDUwyn4w9t1jAu8UpeMzeRioknAepEI9t4LqrvPAZFzFhxcA6nIv6RU0clVq28//vNBxUi73mZZ1RpwWACdib3iCXT/agk0wyOoygB/Mc7HPtGJj0A0LFMN44vcRIzA0uFVbb/BV5pZZcXQMPyogRxaqd9Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PN0NBc35; arc=none smtp.client-ip=95.215.58.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PN0NBc35"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=tfcR+1vIe3NIrCiR3cbKx8vH9DZhm95Ra8XfKKaDhrk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790068849; v=1; x=1790673649;
 b=PN0NBc35Ik/1RLL/Tpi6kz14vgblvJp5uNw9LkijgMvdHaWQLWjiOerRGV6F+b1OKw2+WioU
 pY3RHZJ/kFjNMsRbKoQiIG3nl8GDWP8O7DtpQu8HyQEnB98NqZT5vhjTj0Kl/kNfFdNjld9akaO
 zPjiiFuPnn7RUbV7mtVbK7Ac=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1845d1b952c6f2f1;
	Tue, 22 Sep 2026 09:20:49 +0000
X-Mizu-Trace-ID: 1845d1b952c6f2f1
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
Subject: [PATCH v3 0/2] docs: cgroup-v2: Correct cpuset CPU descriptions
Date: Tue, 22 Sep 2026 17:20:32 +0800
Message-ID: <20260922092034.68840-1-guopeng.zhang@linux.dev>
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

Changes since v2:
- Update the valid partition root example to show that an offline CPU
  can remain in cpuset.cpus.exclusive.effective while being excluded
  from cpuset.cpus.effective.
- Add the Reviewed-by tag to patch 2.
- Patch 1 is unchanged.

Guopeng Zhang (2):
  docs: cgroup-v2: Describe boot-isolated CPUs in cpuset.cpus.isolated
  docs: cgroup-v2: Describe effective CPUs of partition roots

 Documentation/admin-guide/cgroup-v2.rst | 62 ++++++++++++++++++++-----
 1 file changed, 51 insertions(+), 11 deletions(-)

-- 
2.43.0
