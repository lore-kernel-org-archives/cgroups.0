From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup fixes for v5.2-rc4
Date: Fri, 14 Jun 2019 13:02:53 -0700
Message-ID: <20190614200253.GB657710@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=XcuM7K9cI0UVePrxFlGBexaTFIUHFIVo5KkIzm6e+gw=;
        b=hLFC2FBQl6ExeriTXWpqg+lTQLNyx7oiqJlcJtW5p7dIVpNR/713tQHUmBcEmbF50g
         EM9hlT4xym5+VrGtWzQ3zMzigjQOpdKhkdgtmh6SoFGS9voFjFKXorSiHHiA8OUp0xZY
         q5IErmOUUZV06pBOmI23oJWEpQiiQ5Gcwpd66gYyLF58q0pXzUT1vIvNlQGDPk2SYPrY
         268F7qjTDcX6v1w53n7RS9r6Cab538jFbIO8QlgZQVkX63Mme8nOe6xDBYvzXZYHRyoY
         EbkWiwjsLghYr2OPfcQriM+zAFB6cMfj7Q28AJyD+ujDl3Vpu49wXOnOSFfjcG//wVvw
         9rAw==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

Hello,

This pull request has unusually high density of tricky fixes.

* task_get_css() could deadlock when it races against a dying cgroup.

* cgroup.procs didn't list thread group leaders with live threads.
  This could mislead readers to think that a cgroup is empty when it's
  not.  Fixed by making PROCS iterator include dead tasks.  I made a
  couple mistakes making this change and this pull request contains a
  couple follow-up patches.

* When cpusets run out of online cpus, it updates cpusmasks of member
  tasks in bizarre ways.  Joel improved the behavior significantly.

Thanks.

The following changes since commit 9fb67d643f6f1892a08ee3a04ea54022d1060bb0:

  Merge tag 'pinctrl-v5.2-2' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl (2019-05-28 09:35:04 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.2-fixes

for you to fetch changes up to d477f8c202d1f0d4791ab1263ca7657bbe5cf79e:

  cpuset: restore sanity to cpuset_cpus_allowed_fallback() (2019-06-12 11:00:08 -0700)

----------------------------------------------------------------
Joel Savitz (1):
      cpuset: restore sanity to cpuset_cpus_allowed_fallback()

Odin Ugedal (1):
      docs cgroups: add another example size for hugetlb

Tejun Heo (6):
      cgroup: Use css_tryget() instead of css_tryget_online() in task_get_css()
      cgroup: Call cgroup_release() before __exit_signal()
      cgroup: Implement css_task_iter_skip()
      cgroup: Include dying leaders with live threads in PROCS iterations
      cgroup: css_task_iter_skip()'d iterators must be advanced before accessed
      cgroup: Fix css_task_iter_advance_css_set() cset skip condition

 Documentation/cgroup-v1/hugetlb.txt |  22 +++++---
 include/linux/cgroup-defs.h         |   1 +
 include/linux/cgroup.h              |  14 ++++-
 kernel/cgroup/cgroup.c              | 106 ++++++++++++++++++++++++++----------
 kernel/cgroup/cpuset.c              |  15 ++++-
 kernel/exit.c                       |   2 +-
 6 files changed, 117 insertions(+), 43 deletions(-)

-- 
tejun
