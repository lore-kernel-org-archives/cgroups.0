From: Roman Gushchin <guro@fb.com>
Subject: [v6 0/4] cgroup-aware OOM killer
Date: Wed, 23 Aug 2017 17:51:58 +0100
Message-ID: <20170823165201.24086-2-guro@fb.com>
References: <20170823165201.24086-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=PxDunI+Nk/OR+xyTfpLvKHg5rjj0xZu2pFX4Pfznjmc=;
 b=dt2GlHjnIRR9EMQp4j1mW+DNHmfMk/dAEt+JVD+ctbu5SezN4gdId86KU81gzW47GItl
 ZfRYQ4WNTN30eeYTp1zgrUWi+MWMDgfa+DRkNjNwkOTSjC7zjCPbK8yo/2rUt14ZgPUu
 JSOgvUFxumYAYGjBnGlEf8neeIW7fDFx41U= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=PxDunI+Nk/OR+xyTfpLvKHg5rjj0xZu2pFX4Pfznjmc=;
 b=Bet40TOiVH8JpvHEC6gYfz7U6PUscSaqm+oFrbc/RjwoU+bQYgX2BFZiLfv5SgFW4TWQ6ykiBj+MM9QLn67Grer2dcHrdFX83lByUJA9XkY6PwAxEHuAta6dsiQHUjRLGSOnFW4lZ1XJGmSh2VmFgtd2kCF8ClIXZ+5mput+rjQ=
In-Reply-To: <20170823165201.24086-1-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

This patchset makes the OOM killer cgroup-aware.

v6:
  - Renamed oom_control.chosen to oom_control.chosen_task
  - Renamed oom_kill_all_tasks to oom_kill_all
  - Per-node NR_SLAB_UNRECLAIMABLE accounting
  - Several minor fixes and cleanups
  - Docs updated

v5:
  - Rebased on top of Michal Hocko's patches, which have changed the
    way how OOM victims becoming an access to the memory
    reserves. Dropped corresponding part of this patchset
  - Separated the oom_kill_process() splitting into a standalone commit
  - Added debug output (suggested by David Rientjes)
  - Some minor fixes

v4:
  - Reworked per-cgroup oom_score_adj into oom_priority
    (based on ideas by David Rientjes)
  - Tasks with oom_score_adj -1000 are never selected if
    oom_kill_all_tasks is not set
  - Memcg victim selection code is reworked, and
    synchronization is based on finding tasks with OOM victim marker,
    rather then on global counter
  - Debug output is dropped
  - Refactored TIF_MEMDIE usage

v3:
  - Merged commits 1-4 into 6
  - Separated oom_score_adj logic and debug output into separate commits
  - Fixed swap accounting

v2:
  - Reworked victim selection based on feedback
    from Michal Hocko, Vladimir Davydov and Johannes Weiner
  - "Kill all tasks" is now an opt-in option, by default
    only one process will be killed
  - Added per-cgroup oom_score_adj
  - Refined oom score calculations, suggested by Vladimir Davydov
  - Converted to a patchset

v1:
  https://lkml.org/lkml/2017/5/18/969


Roman Gushchin (4):
  mm, oom: refactor the oom_kill_process() function
  mm, oom: cgroup-aware OOM killer
  mm, oom: introduce oom_priority for memory cgroups
  mm, oom, docs: describe the cgroup-aware OOM killer

 Documentation/cgroup-v2.txt |  62 ++++++++++
 include/linux/memcontrol.h  |  36 ++++++
 include/linux/oom.h         |  12 +-
 mm/memcontrol.c             | 290 ++++++++++++++++++++++++++++++++++++++++++++
 mm/oom_kill.c               | 209 ++++++++++++++++++++-----------
 5 files changed, 539 insertions(+), 70 deletions(-)

-- 
2.13.5

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
