From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v3.17-rc4
Date: Mon, 8 Sep 2014 10:20:25 +0900
Message-ID: <20140908012025.GF5061@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=lV1T9ivYvTwsY2OXXWOQejoBQgFrEjDpc+AdcwPyWvE=;
        b=QEIquSojzt4HlLIGgX0XyPYLkNNLUO6DMhyE+vfCkPA2gRrh2F16D9AVOb5/bXjcy9
         oA29dDs/MOMC6qGS0f7209aAIKB4VPsT8DgVtxOqsZabXtcTqHgAwKfRFUNXAoxX9kEH
         wFWvfV+0K6E6Y5jlQA1knBvPEa7erq96KTUZfZoEJzqSOknquB9+Tn9IQBnn22ucbKR8
         /fQPi3V8QPpqFZefasDwh+nNoFUHYNUGO6nscF3xnSoDJSx70MdAaI3+rc9hm9Tij2NL
         74z31rLxy2nGp7HJwpb9W4jI+5jxVpk1TAXZd26B2f6CYb9P7sB1OY8cUUChLCyiETrS
         e5Rw==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

Up until now, cgroup has allowed any character including '\n' in
cgroup names; unfortunately, as '\n' is used as the row delimiter in
/proc/$PID/cgroup, '\n' in a cgroup name makes the content of the file
ambiguous to parse.  This pull request includes Alban's patch to
disallow '\n' in cgroup names.  While this is a userland visible
behavior change, given the craziness of allowing '\n' and its
implications, I believe the change is justified.  The patch is marked
for -stable backport.

Two other patches from Li to fix a possible oops when cgroup
destruction races against other file operations and one from Vivek to
fix a unified hierarchy devel behavior.

Thanks.

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.17-fixes

for you to fetch changes up to aa32362f011c6e863132b16c1761487166a4bad2:

  cgroup: check cgroup liveliness before unbreaking kernfs (2014-09-05 01:36:19 +0900)

----------------------------------------------------------------
Alban Crequy (1):
      cgroup: reject cgroup names with '\n'

Li Zefan (2):
      cgroup: delay the clearing of cgrp->kn->priv
      cgroup: check cgroup liveliness before unbreaking kernfs

Vivek Goyal (1):
      cgroup: Display legacy cgroup files on default hierarchy

 kernel/cgroup.c | 47 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 14 deletions(-)

-- 
tejun
