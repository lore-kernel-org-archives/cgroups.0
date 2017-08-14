From: Roman Gushchin <guro@fb.com>
Subject: [v5 0/4] cgroup-aware OOM killer
Date: Mon, 14 Aug 2017 19:32:10 +0100
Message-ID: <20170814183213.12319-2-guro@fb.com>
References: <20170814183213.12319-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=PMnZSWFSZiTO5jLASiw2myT24IrR9+rWdgGHVt6lYdE=;
 b=XNKBfKCHRpObluzQAZxeRQ1FP1IAuCpHJXOF2dtCknDEEDRRlPrQN/42A0VbTQ0cjY7F
 JtiJeXue4fTbvcJAbTR2Ymmx7MeQmk2WoJ9N7ar/o4h7F0TZPtTaHAepO6bAdlaAFhaJ
 i2JC4so98r6bno7+1CqzwqayOTQ7evTB6tk= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=PMnZSWFSZiTO5jLASiw2myT24IrR9+rWdgGHVt6lYdE=;
 b=TAhOrIrUU4i8QRfi45odgaAEjTm9P8xwGp9x8DEMPKOGAA0qwtu7O5TKBJ90Ol63t9eUox4QYZy4CuSZ7rY3rNSALrBgeAkAF6qvn877cdEKvKAtjk5EuEmbJzx96ZJKgSMhqEPoB6qD8KlypzMvwmRaNUP08QCvumy2jimXaoI=
In-Reply-To: <20170814183213.12319-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

This patchset makes the OOM killer cgroup-aware.

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

 Documentation/cgroup-v2.txt |  62 +++++++++++
 include/linux/memcontrol.h  |  36 ++++++
 include/linux/oom.h         |   3 +
 mm/memcontrol.c             | 259 ++++++++++++++++++++++++++++++++++++++++++++
 mm/oom_kill.c               | 181 +++++++++++++++++++++----------
 5 files changed, 484 insertions(+), 57 deletions(-)

-- 
2.13.5

