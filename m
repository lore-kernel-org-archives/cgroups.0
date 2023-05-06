From: chengkaitao <chengkaitao@didiglobal.com>
Subject: [PATCH v3 0/2] memcontrol: support cgroup level OOM protection
Date: Sat, 6 May 2023 19:49:46 +0800
Message-ID: <20230506114948.6862-1-chengkaitao@didiglobal.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-doc-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, akpm@linux-foundation.org, brauner@kernel.org, muchun.song@linux.dev
Cc: viro@zeniv.linux.org.uk, zhengqi.arch@bytedance.com, ebiederm@xmission.com, Liam.Howlett@Oracle.com, chengzhihao1@huawei.com, pilgrimtao@gmail.com, haolee.swjtu@gmail.com, yuzhao@google.com, willy@infradead.org, vasily.averin@linux.dev, vbabka@suse.cz, surenb@google.com, sfr@canb.auug.org.au, mcgrof@kernel.org, sujiaxun@uniontech.com, feng.tang@intel.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, chengkaitao <chengkaitao@didiglobal.com>

Establish a new OOM score algorithm, supports the cgroup level OOM
protection mechanism. When an global/memcg oom event occurs, we treat
all processes in the cgroup as a whole, and OOM killers need to select
the process to kill based on the protection quota of the cgroup

Changelog:
v3:
  * Add "auto" option for memory.oom.protect. (patch 1)
  * Fix division errors. (patch 1)
  * Add observation indicator oom_kill_inherit. (patch 2)
v2:
  * Modify the formula of the process request memcg protection quota.
  https://lore.kernel.org/linux-mm/20221208034644.3077-1-chengkaitao@didiglobal.com/
v1:
  https://lore.kernel.org/linux-mm/20221130070158.44221-1-chengkaitao@didiglobal.com/

chengkaitao (2):
  mm: memcontrol: protect the memory in cgroup from being oom killed
  memcg: add oom_kill_inherit event indicator

 Documentation/admin-guide/cgroup-v2.rst |  29 ++++-
 fs/proc/base.c                          |  17 ++-
 include/linux/memcontrol.h              |  46 +++++++-
 include/linux/oom.h                     |   3 +-
 include/linux/page_counter.h            |   6 +
 mm/memcontrol.c                         | 199 ++++++++++++++++++++++++++++++++
 mm/oom_kill.c                           |  25 ++--
 mm/page_counter.c                       |  30 +++++
 8 files changed, 334 insertions(+), 21 deletions(-)

-- 
2.14.1

