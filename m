From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup fixes for v5.3-rc8
Date: Thu, 12 Sep 2019 14:11:50 -0700
Message-ID: <20190912211150.GB3084169@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Ft1lXaFWyeFaR5dQq95+R6LQSsO9+rjJoCxsIQDK09Q=;
        b=ieuj2Q4AeufUufy5S/GjvLZqVEpSa2IqXOab6R7dw+TPfduNg/yvHq0tl5qtqN0aKu
         S0Fx69ForISDBKoqDSgnU+Ex84zoIn6OicdJHOOhJfaN9DpJhK8OQ8WlNWst6zNANSkE
         uz06s7IH1hnkNgtVos8xsUrtLpW1alGkANMSxzQwJikaxvOm328tMWkt5q/ckCJSeW2R
         tE8OFY85hlXCYtYKqnIT9SUAM0Pcjd+igwUe9qIHEbjEGkiPA6Q/+niXtkBsb8oQYYKh
         c97G6DGolDXJlzzSulLh/aVSPaV7e5fCXSMlHdZBsu+PHA6+WRDQMnP8v5BH1IUP6rEI
         QvQQ==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>

Hello, Linus.

Roman found and fixed a bug in the cgroup2 freezer which allows new
child cgroup to escape frozen state.

Thanks.

The following changes since commit 505a8ec7e11ae5236c4a154a1e24ef49a8349600:

  Revert "drm/i915/userptr: Acquire the page lock around set_page_dirty()" (2019-09-12 14:55:03 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.3-fixes

for you to fetch changes up to 97a61369830ab085df5aed0ff9256f35b07d425a:

  cgroup: freezer: fix frozen state inheritance (2019-09-12 14:04:45 -0700)

----------------------------------------------------------------
Roman Gushchin (2):
      kselftests: cgroup: add freezer mkdir test
      cgroup: freezer: fix frozen state inheritance

 kernel/cgroup/cgroup.c                        | 10 ++++-
 tools/testing/selftests/cgroup/test_freezer.c | 54 +++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 1 deletion(-)

-- 
tejun
