Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030D3440A2D;
	Wed,  2 Sep 2026 23:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788390196; cv=none; b=OKfaC9u/4Ig5OTEIzL/Gs8Mk9zto7OAz0NHNkSzdRhfjE7/2c2EKY9vZX2INAYOEp+wkm9XnBkx+9qcRmO+as+HL71pliEUolbf2U2eBZiEKJyCdHlxxygI8+AmQ3vkpAyX0MBZ5MkXwspqpDPPMS5+OkuH4WJHunsAKMrMSrAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788390196; c=relaxed/simple;
	bh=fndp4qv/QeXRr/XfnaC89r8d9bcdhYgfAKmLjgG7/+U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EryGdMYa5qwKHsiXiVQBbg4V/W7kSfcWt8VWJSUAgpZSkxYEuLcWRbp5JXj37/EQt0k28JlAz9nZqjQILcWpYK3MLK7+PaYB99Tjk1DUUsIPvnEuhsSVdcfTfKq+6ytRbjQwjtyElDTk+olFTpt8OcmVIvptfVyAM/YXZXC07ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lMyY+NqE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lMyY+NqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A52B1F000E9;
	Wed,  2 Sep 2026 23:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788390194;
	bh=3aWPiCKKoMG8UqUXpL5MtBg9mZadrWPfR0OxNr9nT7k=;
	h=From:To:Cc:Subject:Date;
	b=lMyY+NqEWPsfJYa84MO3Ldtr0TUudUL0usWfKAQsZ8hrA1AJPF3EWt+J3gdUHfMKK
	 9XiwrLmpGkpy/LYnLfp7zooTD9+h/3KPHdPo5Ivv98RA4yZfL+iv4GJkZs6ZJ9M0cJ
	 XC3L8ShSCWfaMHX/OhBO5uep5bxjs4vpZYfmWufGmUtkvyM/Ldyu+1jiMH0yXIXDcw
	 qJC/HoyaleskhB4Oh7Ek1bUj9/mTmQmqHBwvdPSif4fRZXQ/XE91HSLN6izR7rHpCV
	 JvsnV73JNAf2WdVNWeFqs7vxyLXzWiTqAoKM3dIVk4IE9CbQleyS5JJ55sf5uqXhse
	 Or8Lw/OxMKKAw==
From: Tejun Heo <tj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+bb2e19a1190a556c01b1@syzkaller.appspotmail.com,
	Tao Yu <tao1.yu@intel.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCHSET cgroup/for-7.4] cgroup: Make the offline drain interruptible
Date: Wed,  2 Sep 2026 13:03:10 -1000
Message-ID: <20260902230313.530839-1-tj@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

syzbot has been reporting "task hung in cgroup_subtree_control_write".

The underlying problem is an indefinite wait in a place where indefinite
waits should not happen. A task past exit_signals() can block in its exit
path for as long as, say, a FUSE daemon takes to answer a flush.

That wait is interruptible in name only. Once a thread group is exiting,
prepare_signal() drops every signal sent to it, so nothing can wake the
task. It still shows as TASK_INTERRUPTIBLE, and the hung task detector only
looks at TASK_UNINTERRUPTIBLE, so the stuck task never appears in any
report.

Since 1dffd95575eb ("cgroup: Defer kill_css_finish() in
cgroup_apply_control_disable()"), a disabled css offlines only after every
such task pinning it has exited, and the re-enable path waits for that
offline in TASK_UNINTERRUPTIBLE. The writer inherits the unkillable wait,
sits in D state, and is the only thing the hung task report shows.

This patchset makes the drain interruptible so that the writer can be
killed. The wait in the exit path remains a separate problem.

Tao Yu posted a patch that rejects the re-enable with -EBUSY while csses are
dying:

 https://lore.kernel.org/all/20260901012342.855056-1-tao1.yu@intel.com/

That fails re-enables that would have succeeded and keys off a counter that
also covers removed cgroups and offlined-but-pinned csses, so this takes the
interruptible wait instead.

 0001-cgroup-Return-ENODEV-consistently-for-a-dead-cgroup.patch
 0002-cgroup-Return-ERR_PTR-from-cgroup_kn_lock_live.patch
 0003-cgroup-Make-the-offline-drain-interruptible.patch

0001 unifies the errno the interface file writers return for a removed
cgroup. 0002 makes cgroup_kn_lock_live() return ERR_PTR so that it can
report the interrupted drain. 0003 is the actual change.

This is against v7.3-rc1 (cee9395acd80) and also available in the following
git branch:

 https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git cgroup-drain-interruptible

diffstat follows.

 kernel/cgroup/cgroup-internal.h |  2 +-
 kernel/cgroup/cgroup-v1.c       | 16 ++++---
 kernel/cgroup/cgroup.c          | 98 ++++++++++++++++++++++++-----------------
 kernel/cgroup/debug.c           | 10 ++---
 4 files changed, 74 insertions(+), 52 deletions(-)

--
tejun
