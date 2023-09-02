From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Subject: mainline build failure due to d1d4ff5d11a5 ("cgroup: put
 cgroup_tryget_css() inside CONFIG_CGROUP_SCHED")
Date: Sat, 2 Sep 2023 12:32:28 +0100
Message-ID: <ZPMdTJ7zwrCkdMTu@debian>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693654351; x=1694259151; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8iUJUPxov9O7zxFefQw4YzTRyz6MbPYWWecwL9vIvnM=;
        b=g9FkVRxIaVqqzJSoWbK4CTrwNeh/oQsNE7WKVNhTwR2PL13PPCmCvtnr4D1L4qnld4
         r54kqdVFva6Z4qnzU9bTjUIl/kDuqRVGbEvBH0AnISJwlm3tNt2d3BuVMOny8RNlsOK4
         ZPj0D1dUgpRnsUUnHyutz2/wyoTtzBpfatNOZFRk4V/+0zKY1EC34VV7LYr7b2f7wi6N
         ZvJCD570pp5qZxEsIE0WFuk7kwSgVEiRcKvkFGjoCsz3T0N1+QMcbm1fIlDi8dNWEf+u
         qSgj0tuT9rW3Uksle010kvQK5t5EJ7x93aSteknzWzJhGsn8W/EGX2N0jmZG8u6fvxGO
         l59w==
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe@huawei.com>, Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, regressions@lists.linux.dev

Hi All,

The latest mainline kernel branch fails to build mips sb1250_swarm_defconfig with
the error:

kernel/cgroup/cgroup.c: In function 'cgroup_local_stat_show':
kernel/cgroup/cgroup.c:3699:15: error: implicit declaration of function 'cgroup_tryget_css'; did you mean 'cgroup_tryget'? [-Werror=implicit-function-declaration]
 3699 |         css = cgroup_tryget_css(cgrp, ss);
      |               ^~~~~~~~~~~~~~~~~
      |               cgroup_tryget
kernel/cgroup/cgroup.c:3699:13: warning: assignment to 'struct cgroup_subsys_state *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
 3699 |         css = cgroup_tryget_css(cgrp, ss);
      |             ^


git bisect pointed to d1d4ff5d11a5 ("cgroup: put cgroup_tryget_css() inside CONFIG_CGROUP_SCHED").

Reverting the commit has fixed the build failure.

I will be happy to test any patch or provide any extra log if needed.

#regzbot introduced: d1d4ff5d11a5887a9c4cfc00294bc68ba03e7c16

-- 
Regards
Sudip
