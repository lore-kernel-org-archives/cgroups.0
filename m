Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783854B5123;
	Tue, 15 Sep 2026 17:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789493555; cv=none; b=uQelzG6TTeCKHxOCfpxN6D/QLS5WZXkbfE2GickMRNraGro/i8hZCzKgy9L4wRSG/UZdlHxpS9je9ai+jn27oAjW+czyRqaSpZd5uqcR4bnOOBed2KsXuCcqhhbeHf9+2QNff3dNxKHNwgWWphti7EiFSz0G4tJ0XSgKEVy0g7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789493555; c=relaxed/simple;
	bh=9kkiwSPnvNAOobiPD7FEP5gMvP4p7meaDrbhYpNNldc=;
	h=Date:Message-ID:From:To:Cc:Subject; b=h+VtSh6j7K32m1ZrjQh2/MaPmLJSrWcGWZb5sJo5RDQ/zboOOv5jUCqBQx+kdCxpgbK95ERdD4YojCTq6fvaVsRMGqyhHr/DX2cRBJByaYwxNLwR4ODG4wQG5b8BbAGe1Es/LsyoZoHDJH0Aofua06lUxfyQDaAwVJUCUUTBDfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AK2anTkK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AK2anTkK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F0A1F000FF;
	Tue, 15 Sep 2026 17:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789493554;
	bh=lTPls9lkC/qqeHTu/0Ymodq8EF8MdjA/go8shGk7H9Q=;
	h=Date:From:To:Cc:Subject;
	b=AK2anTkKPZ5ylr4eJ0mCZjRH9fYtgRdxKO6C5AqPdd0rRPUQG2XRTHqkyWWdJmW0B
	 8FFDt/rldt7ktVj/pV12W4d6ZNol+ikb/seBlsKpj+pjtMYbICmwnH4qhCzOS7UBWA
	 JAIQlZ97v1tMQsQHcwY4Qzck5AwFAX/I0dkfeGE4TTF1Ur3f/5fFMFb3sugGnElkIo
	 eP6aenPjjnMsdXrSvW4F8OT8mnaHJi17mpgo1Y32htwAtOuYe5BCDYY5pLGT3NdFyK
	 MIlBxJsPCiJKY7Fm/MAW+ry2iqFAo/rGXs956JSlqosQltp1ganrt2tK/FZ+Wj8OUo
	 AYwsvsD9GnCVg==
Date: Tue, 15 Sep 2026 07:32:33 -1000
Message-ID: <f2f2c870036c471d557bf1a3859a23a2@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutny <mkoutny@suse.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] cgroup: Fixes for v7.3-rc3
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

The following changes since commit 3f4b7d1a49c5c826f3be9b684313eea5b83ac232:

  selftests/cgroup: test clone3() into a previously killed cgroup (2026-08-31 06:19:53 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.3-rc3-fixes

for you to fetch changes up to 057dac23d329d5c5ed62352f2659a39fd46c6d4a:

  cgroup: Avoid iteration of dying tasks with zero refcount (2026-09-14 12:43:50 -1000)

----------------------------------------------------------------
cgroup: Fixes for v7.3-rc3

- The task iterator could pick up a dying task whose refcount had already
  dropped to zero and resurrect it, leading to a use-after-free when
  reading cgroup.procs. Skip such tasks.

----------------------------------------------------------------
Michal Koutný (1):
      cgroup: Avoid iteration of dying tasks with zero refcount

 kernel/cgroup/cgroup.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--
tejun
