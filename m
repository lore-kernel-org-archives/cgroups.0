Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F0A30F542;
	Mon,  2 Feb 2026 21:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770066780; cv=none; b=bd6LURMC5agslzw8adnFXuSVWUKtDa4HnCQc3qXWWM2lEwEG3miu2/Jwdms8PP8DAvsb3p4qS+voSm160SsSUKWmRq3h4MNjYnSA5JTPuC0pNnkG+GxBcHTZA9H04MhNJxMvK2ftJZRqbTTkA1hGuMbNhdscLoMve6eAeSU8Bg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770066780; c=relaxed/simple;
	bh=45JWBDcPH1hp0NOZL2h8woaDHJCkVxiD9kfgbtpkqE0=;
	h=Date:Message-ID:From:To:Cc:Subject; b=miB/Ljge7xMEkmnkj8/h3cctaBcSLh2YBCavfSE2N1ura0XUr2zQXIz+QE+U/FPHJUqSSvgqURhbgzQ7CzWVtLWIxI6TzkuyaTpiW5eA9Ho4L7o5F2jsIv51gg4TsTknaDBJEuxwnYIut/hHr21hpMcRuwnmGAKbprogBOUSprc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uq5OaIjw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uq5OaIjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEF3C116C6;
	Mon,  2 Feb 2026 21:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770066780;
	bh=45JWBDcPH1hp0NOZL2h8woaDHJCkVxiD9kfgbtpkqE0=;
	h=Date:From:To:Cc:Subject:From;
	b=Uq5OaIjwH/2cJHpuay8bsuC8SV+TMEfvN7MWNrH7VcW6x28GownRmWwniLQ29/lNe
	 0+mDtwjc9jMHJBNIbiyeqxn76+OFVPOqKTQmdyK8g3ffwYvsa3rnz/RqMzj1zVuK8K
	 ROBX5xYLqCYY+qnlZJMqldiKi+QgXqI2D3X3AwJ0lKnjj3dLXB3jMjxo2DG9gcjGx2
	 RG1khaEJfWCYuMQS6yngF+htdoWP4vEqxvxnVTqHizHjtC/HHBcwVQxlPDc9XHjY2b
	 wmiyDnLEzyDLNgH1e/l+v00VCf9C1sCbbpOn4dXC6krOzjYyOpkODmuF0PjiL5Ycrm
	 yuANKbHzAQ8yg==
Date: Mon, 02 Feb 2026 11:12:59 -1000
Message-ID: <2fe2b534479363ab3aad3db25fa65377@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chen Ridong <chenridong@huawei.com>,
 Maarten Lankhorst <dev@lankhorst.se>,
 Maxime Ripard <mripard@kernel.org>,
 Natalie Vock <natalie.vock@gmx.de>,
 Waiman Long <longman@redhat.com>,
 cgroups@vger.kernel.org,
 dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] cgroup fixes for v6.19-rc8
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hi Linus,

Three dmem fixes. While it's late in the cycle, all changes are confined to
kernel/cgroup/dmem.c and can only affect dmem controller users.

Thanks.

The following changes since commit 84697bf5532923f70ac99ea9784fab325c560df0:

  kernel: cgroup: Add LGPL-2.1 SPDX license ID to legacy_freezer.c (2026-01-15 22:03:15 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-6.19-rc8-fixes

for you to fetch changes up to 99a2ef500906138ba58093b9893972a5c303c734:

  cgroup/dmem: avoid pool UAF (2026-02-02 06:04:13 -1000)

----------------------------------------------------------------
cgroup: Fixes for v6.19-rc8

Three dmem fixes from Chen Ridong addressing use-after-free, RCU warning,
and NULL pointer dereference issues introduced with the dmem controller.

All changes are confined to kernel/cgroup/dmem.c and can only affect dmem
controller users.

----------------------------------------------------------------
Chen Ridong (3):
      cgroup/dmem: fix NULL pointer dereference when setting max
      cgroup/dmem: avoid rcu warning when unregister region
      cgroup/dmem: avoid pool UAF

 kernel/cgroup/dmem.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 63 insertions(+), 7 deletions(-)

--
tejun
