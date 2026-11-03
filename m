Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793729362;
	b=0o2up9vWaFmMbs72rIytnMJQWoSuD0VgNQM0cMVtsU1qsIubXDCLEQ7Qst08Lilj4ACQ
	 ffdD+BhOLo4t+zfVa28xCc6zZdwGvwjdEUvC+G8XapvUZJcvRe1/+d4siFuGdsO9hTiQl
	 0DYQiO89Pw1CpSeuEj4lEku3Z8NqMPaw1+4+OGEheVaUyaw7MK2xi79iVxSBHbeXfbFt/
	 MfWc4lRsR5yoYPeerEWydlMHZLTLt3rW+pBvErWgFPSMtjsbLw1bibwad99GNbd3idDwK
	 xyagF/gzB0wg01UY2kHB4Ntzh/eRXMMHNk1sMAY9ycxqC2wYxbWaXqFUSBroe1j/CoA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793729362;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Yim4+xjFSL3rrvzkKn7LXdVgRhB+1jTYxkhUigaCIes=;
	b=oGXsOL+ccmk9JUpwGxkvOJzirj5kBpaZG/9sgIgLzrWZevZ6emzFuVMsL1zSWZ7XKLcy
	 bEylENU7rXXXA3yXnTtziZWfNftbfON6pbIe+dqQRDXI2YFXuzkuXTVunHxQtk9jOoSgl
	 cyDSVCTE/nOahERD2z158VDn8OQ5JyjpWK1KAB9nWLsoR+hpc9eZXaFqUqk2DFZzz5y0Q
	 PyfBQ4j8wRjTd6PZCrawQZ2ZSoIiWvJ3wo8VAxQQ0XAkSaT69ffVDco6bJ7IHr7FQvANO
	 hWpFDUZKDGNoCBW/SRC8tKd+mm4FKPm88iyPI/6CIS9qrpBeatPh3FYiy9knJkU5Dqg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fqOS5RlT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6C4606A329;
	Tue,  3 Nov 2026 18:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fqOS5RlT
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793729362;
	b=DiRQx7WCtdPKlSimEi/lCSfRptMxGVd2XpoEokkLCLWJB9fNHodEH8gqWj2DY7uflLbg
	 CtAN5YrFYVlCcrEAbvctlor4AbNwPizNxccaWqyu4HKxVrccwI1fv/4Q/bcDwxsMnlBcf
	 Um3AWlckP3VovhBXmdQnKNyXBUE7JNf4LvtGZjTR1HNjDXvbH76FfeX5WvK4iw0V4fpvX
	 NIWqV4xFQWNAZyw/drxzQ16rWZ1CuWoFY/iFks7r8d11fpkQmQ698zb8un8UuYJ0AqL2T
	 e4uX1GFitGDYMhdzbI/XDivkjj4cc7LNhnklZq60ptM3gHAeT5kLdakrZ6KOm5CTnkg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793729362;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Yim4+xjFSL3rrvzkKn7LXdVgRhB+1jTYxkhUigaCIes=;
	b=zort7V+wikGI0O4vBys+Kt2uaapHHR/Fr5+2P1q3VkrEXprtGeobeiEa0ef7bNgrkQsz
	 SsfG4IKbU5smlEMw9xCAkvUFVHQXNmWw2OwUXwFvEZ7hSE63pv/Tf9no7eJdnOjLflAxw
	 OM1Z2F5Rl9YfLG3HGwWyz/wG+kyDKPzgwKrVXmAWLoeMSan5i8b/GgGbH3/b6tIgVTqFj
	 nA5IqPyZ3YVXzG5nkRHvqwJnlkItsQXG9dEB1ays2omTtmiDw6uq7FW9XfNIYlzG2ht+s
	 aCDZFfDE3ixUO23xHnJ5LM5Ayg3a+zLWvmRYV3xP5kj7QmsFk3gw5+cCslIdn5Yh04g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5EDCE1F000C1;
	Tue,  3 Nov 2026 18:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793729361;
	bh=Yim4+xjFSL3rrvzkKn7LXdVgRhB+1jTYxkhUigaCIes=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=fqOS5RlTgteUHXEnSu+JKU5LlW4VRu+a++526Ulfj8C0WvDXfmftzrNjxFZTL+VKg
	 0MmExkUVcnEubTEP5KTZsATcPeB4yc9zACPHMltoFFMFesgTrkc76be7/sYbL8NG4Y
	 bMXBCp38DpIQzpLNT0SQyEl94tvh5rsV/i9dp0w2R7f0VMgasnODd4BiXIoXW+osrU
	 UT1gq81cckzzL+d4BKEtiNmjpi6p+Xb2tNavpaA8uK+zEJ1BQk23RDoFZcbKBOXIuX
	 rmeocVStjRRR3nQvwWL3zaxUtoFMtXxxP9Jx/ngFw9jl5qySrfbF8ZnIl55bsBkslz
	 xx9iZO36uHAgA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id B0FA346A69;
	Tue,  3 Nov 2026 18:09:20 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Date: Tue, 03 Nov 2026 13:09:20 -0500
Subject: [PATCH] cgroup/freezer: walk exiting tasks in the v1 freezer
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261103-cgroup-freezer-exiting-v1-1-00d43b443747@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMMQ7CMAxG4atUnrHkBFQkroIYwPwJZkgrp0UVV
 e9OgPEb3lupwg2VTt1KjpdVG0pD2HWkj2vJYLs3U5TYhyCRNfswj5wceMMZi01WMusx9YKD7qM
 ItXh0JFt+4/Pl7zrfntDpe6Nt+wAsaXPhegAAAA==
X-Change-ID: 20261102-cgroup-freezer-exiting-c7f60e4c3200
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, tz2294@columbia.edu, 
 stable@vger.kernel.org, Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793729360; l=3795;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=KM/MnDxFBAC+sHs8ZYIfu9PpFh912v0OKBTiwLZBXTs=;
 b=1kmrrNgSRj3B7olIMU2INLso9M0fRHp0YmplSCHp+8t7YB5hBjT1nV0u0MqY2E+m8lzO1Cm9Y
 Z75ryOfyQFtCv4tOtkiqG9jzOFrSmMPf2JNi7dBlcze4KBym1pfyMJ4
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu
Content-Transfer-Encoding: 7bit

From: Mani Tofigh <mt4022@columbia.edu>

An exiting task can stay frozen after its v1 freezer cgroup is thawed.
Since commit a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup")
the css task walk hides an exiting task once its process has no live
threads left.  That count drops when another thread of the process
exits, which can happen between the freeze and the thaw walk.  A pid
namespace init hits this easily since it waits freezably in
zap_pid_ns_processes() after commit 81933038f5e2 ("pid_namespace: make
zap_pid_ns_processes() freezable"):

  Task A (pid ns init)      Task B (A's thread)      Task C
                            do_exit()
                              exit_signals()
  do_exit()
    zap_pid_ns_processes()
                                                     write FROZEN
                                                       /* A frozen */
                              /* live count 0 */
                                                     write THAWED
                                                       /* A skipped */

A then stays frozen even after SIGKILL:

  [   10.775155] task:fz-init         state:D stack:28152 pid:65    tgid:65    ppid:1      task_flags:0xc0004c flags:0x00080000
  [   10.775176] Call Trace:
  [   10.775180]  <TASK>
  [   10.775188]  __schedule+0x10f1/0x4760
  [   10.775252]  schedule+0xd7/0x2c0
  [   10.775265]  zap_pid_ns_processes+0x2c7/0x5f0
  [   10.775346]  do_exit+0x1bf4/0x2560
  [   10.775403]  __x64_sys_exit+0x3d/0x50
  [   10.775414]  x64_sys_call+0x156c/0x1570
  [   10.775425]  do_syscall_64+0xfb/0x590
  [   10.775450]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
  [   10.775529]  </TASK>

Use CSS_TASK_ITER_WITH_DEAD in the three v1 freezer walks so they all
see the same tasks, as commit 60f21a264930 ("cgroup, sched_ext: Include
exiting tasks in cgroup iter") did for sched_ext.  With the fix, A is
thawed and exits.

This bug was identified and confirmed with the help of a deterministic
hypervisor currently under development.  The C reproducer below however
hits it within about 10s.

Fixes: a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup")
Cc: stable@vger.kernel.org
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
---
Reproducer: https://github.com/manitofigh/files/blob/main/linux-repros/freezev1.c
---
 kernel/cgroup/legacy_freezer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/legacy_freezer.c b/kernel/cgroup/legacy_freezer.c
index 8545e0d1ba3d..bd11047f2311 100644
--- a/kernel/cgroup/legacy_freezer.c
+++ b/kernel/cgroup/legacy_freezer.c
@@ -265,7 +265,7 @@ static void update_if_frozen(struct cgroup_subsys_state *css)
 	rcu_read_unlock();
 
 	/* are all tasks frozen? */
-	css_task_iter_start(css, 0, &it);
+	css_task_iter_start(css, CSS_TASK_ITER_WITH_DEAD, &it);
 
 	while ((task = css_task_iter_next(&it))) {
 		if (freezing(task) && !frozen(task))
@@ -309,7 +309,7 @@ static void freeze_cgroup(struct freezer *freezer)
 	struct css_task_iter it;
 	struct task_struct *task;
 
-	css_task_iter_start(&freezer->css, 0, &it);
+	css_task_iter_start(&freezer->css, CSS_TASK_ITER_WITH_DEAD, &it);
 	while ((task = css_task_iter_next(&it)))
 		freeze_task(task);
 	css_task_iter_end(&it);
@@ -320,7 +320,7 @@ static void unfreeze_cgroup(struct freezer *freezer)
 	struct css_task_iter it;
 	struct task_struct *task;
 
-	css_task_iter_start(&freezer->css, 0, &it);
+	css_task_iter_start(&freezer->css, CSS_TASK_ITER_WITH_DEAD, &it);
 	while ((task = css_task_iter_next(&it)))
 		__thaw_task(task);
 	css_task_iter_end(&it);

---
base-commit: fffbdad76a57eed26cff1be19f4cbb407f0b6e7c
change-id: 20261102-cgroup-freezer-exiting-c7f60e4c3200

Best regards,
--  
Mani Tofigh <mt4022@columbia.edu>


