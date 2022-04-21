From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v4 0/4] memcg: introduce per-memcg proactive reclaim
Date: Thu, 21 Apr 2022 23:44:22 +0000
Message-ID: <20220421234426.3494842-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=5O0kxWZmLwFRE//70CU4SnK5FsmrfXu8oMUA9u7C7Og=;
        b=EEuRmGT5N/AhXYspmngFDGUt6HR2mHaVhu/fczoNdkx1S+Tiw4e5ODeE/h0GtPvaG2
         bvqoiL5mnjZ/aduPS9JOdCT/WFHetjHQ/fFxUMLwUz2iHstQGYdLFY9nEc3RGO/pFRId
         m0WQO8I7VArJ1uX3NbmYYEA88ykvSfC0OpSqsvj5vs/DO49GYszGs0S7tk5R8f4jxym8
         I2h1Y/p24TBtaEZqcwGkSWTlCVdJnfbO6lXa5S28c65m4gPlKPQoodGuay5Lob9zUCDG
         714Wv7IzMi+PqiG7UTFB2mdWmfKUmZO1+0ChdhKc8za/syH6jJBY1fE/GNCPODAwzk8P
         Nyvw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>
Cc: David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>, Chen Wandun <chenwandun@huawei.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Tim Chen <tim.c.chen@linux.intel.com>, Dan Schatzberg <schatzberg.dan@gmail.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

This patch series adds a memory.reclaim proactive reclaim interface.
The rationale behind the interface and how it works are in the first
patch.

---

Changes in V4:
mm/memcontrol.c:
- Return -EINTR on signal_pending().
- On the final retry, drain percpu lru caches hoping that it might
  introduce some evictable pages for reclaim.
- Simplified the retry loop as suggested by Dan Schatzberg.

selftests:
- Always return -errno on failure from cg_write() (whether open() or
  write() fail), also update cg_read() and read_text() to return -errno
  as well for consistency. Also make sure to correctly check that the
  whole buffer was written in cg_write().
- Added a maximum number of retries for the reclaim selftest.

Changes in V3:
- Fix cg_write() (in patch 2) to properly return -1 if open() fails
  and not fail if len == errno.
- Remove debug printf() in patch 3.

Changes in V2:
- Add the interface to root as well.
- Added a selftest.
- Documented the interface as a nested-keyed interface, which makes
  adding optional arguments in the future easier (see doc updates in the
  first patch).
- Modified the commit message to reflect changes and added a timeout
  argument as a suggested possible extension
- Return -EAGAIN if the kernel fails to reclaim the full requested
  amount.

---

Shakeel Butt (1):
  memcg: introduce per-memcg reclaim interface

Yosry Ahmed (3):
  selftests: cgroup: return -errno from cg_read()/cg_write() on failure
  selftests: cgroup: fix alloc_anon_noexit() instantly freeing memory
  selftests: cgroup: add a selftest for memory.reclaim

 Documentation/admin-guide/cgroup-v2.rst       | 21 +++++
 mm/memcontrol.c                               | 44 +++++++++
 tools/testing/selftests/cgroup/cgroup_util.c  | 44 ++++-----
 .../selftests/cgroup/test_memcontrol.c        | 94 ++++++++++++++++++-
 4 files changed, 176 insertions(+), 27 deletions(-)

-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

