From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup fixes for v5.4-rc7
Date: Mon, 11 Nov 2019 12:22:03 -0800
Message-ID: <20191111202203.GC4163745@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Xeq2lcRUVceDqmGyTHaj5d+0Pjk/GmEvYbMYOaMNQzg=;
        b=I+isjLS5f/apV9ftRVQ09plliCCSpaqV3/UG7fSAdpU4mXCS9TaslJ2OzYYcJa+j4n
         QSq2fKk559J9ZwzNBSmRcRWOqDKtJFMut2l4D4AysPeV4nNRjuINtm0bSDdbt9IW5WqH
         fk7DBoj1Gfk75bFq/L1incchih0DAFe4toGXAMySezDb4h0C8qnQ85GO/CZmhr7Xmn2Z
         YmkIWBnZ5XrTRzEhwYSUSYhKq4/mrelNXQJIAWahBjVhyaHz09RNaDbErBL8JsSE/2Fm
         nF7x3JxoNiQc4F8UFz+deld6cUww6o5u4xPk2EwGcjDPCXrN1kQZ4MIem70TJeY2ZEmj
         Rchg==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hello, Linus.

Sorry, I sat on this for too long.

There's an inadvertent preemption point in ptrace_stop() which was
reliably triggering for a test scenario significantly slowing it down.
This pull request contains Oleg's fix to remove the unwanted
preemption point.

Thanks.

The following changes since commit 9e208aa06c2109b45eec6be049a8e47034748c20:

  Merge tag 'xfs-5.4-fixes-3' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux (2019-10-10 11:47:16 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.4-fixes

for you to fetch changes up to 937c6b27c73e02cd4114f95f5c37ba2c29fadba1:

  cgroup: freezer: call cgroup_enter_frozen() with preemption disabled in ptrace_stop() (2019-10-11 08:39:57 -0700)

----------------------------------------------------------------
Oleg Nesterov (1):
      cgroup: freezer: call cgroup_enter_frozen() with preemption disabled in ptrace_stop()

 kernel/signal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index c4da1ef56fdf..bcd46f547db3 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2205,8 +2205,8 @@ static void ptrace_stop(int exit_code, int why, int clear_code, kernel_siginfo_t
 		 */
 		preempt_disable();
 		read_unlock(&tasklist_lock);
-		preempt_enable_no_resched();
 		cgroup_enter_frozen();
+		preempt_enable_no_resched();
 		freezable_schedule();
 		cgroup_leave_frozen(true);
 	} else {

-- 
tejun
