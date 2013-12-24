From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v3.13-rc5
Date: Tue, 24 Dec 2013 09:29:23 -0500
Message-ID: <20131224142923.GC3512@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
	:content-disposition:user-agent;
	bh=GoB99YdQNL21OhZLFVC3ikaSA6ypEeBIkYI0vkoKn3E=;
	b=RDQHYl/AYGgjQP48UKkDHYdknhYFkySLRjAha3J2D9DVwdl44Drg8BbfFeNWN+pEmI
	dfFCTp5/YChKAyITbn4BkOPBuHIKbqI/4ikgzjmuLjip+Drf0WTWdUag+sLf9HytUqqP
	JP5j9GTMQI49l6vADTmNrYikzfeQvdnAWhMTcFySlPEv5rtqUgY2BSmOsIkaxY/a1rnJ
	zkpshUovsD0sZLB3iehEDjV2p14BmhHtJaB0f/P+NtkuEkIvQHM9jQkkTTc6WX2VEB40
	fdWdG/IVxCDtUyCTRDNv6X8gEX/gt3DcCcV8Qk8McSte3qomdQN6+0IyKY767uqM+Us/
	SOXg==
Content-Disposition: inline
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hey, Linus.

Two fixes.  One fixes a bug in the error path of cgroup_create().  The
other changes cgrp->id lifetime rule so that the id doesn't get
recycled before all controller states are destroyed.  This premature
id recycling made memcg malfunction.

The following changes since commit e605b36575e896edd8161534550c9ea021b03bc0:

  cgroup: fix cgroup_subsys_state leak for seq_files (2013-11-27 18:16:21 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.13-fixes

for you to fetch changes up to c1a71504e9715812a2d15e7c03b5aa147ae70ded:

  cgroup: don't recycle cgroup id until all csses' have been destroyed (2013-12-17 08:11:52 -0500)

Thanks.
----------------------------------------------------------------
Li Zefan (1):
      cgroup: don't recycle cgroup id until all csses' have been destroyed

Tejun Heo (1):
      cgroup: fix cgroup_create() error handling path

 kernel/cgroup.c | 50 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 18 deletions(-)

-- 
tejun
