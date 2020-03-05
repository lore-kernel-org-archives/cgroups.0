From: Daniel Xu <dxu@dxuuu.xyz>
Subject: [PATCH v2 0/4] Support user xattrs in cgroupfs
Date: Thu,  5 Mar 2020 13:16:28 -0800
Message-ID: <20200305211632.15369-1-dxu@dxuuu.xyz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm2; bh=XdQ+RswJL5NMl40GJb5WlNSbRs
        qA/OCEL8OeWLu2sac=; b=1DIq3i5Mt+pRb3sS1NWiHTIjIc5XjG+qFV/shkSg7t
        5ImiieuJc4T4WVs/zoYa7Opp1+m7pH9G1ywxke1GdTvSA0D6G96Ypqyn224PyUdS
        Dt0umj6zdkKMZ2YGrmwIAWok2NXr9Tku7MZZtrV7BF9vat0KOt2ivalobkI+wEso
        /LLMrwm9UlLUAeBQBqRUIcfQ6o83Sh+jJT+f7KkmmIRKgglgu3duqYD56XcrfG68
        wv9M2S9gYjpsDSJC90uC2Yog1ruukVZKUc4ItroCh99rAi4mD/I9mMc8Ly+b4GYP
        1wErySk6oWNXkoObGVZnuPKyPUbfTkgGwPotTBU0tczw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=XdQ+RswJL5NMl40GJ
        b5WlNSbRsqA/OCEL8OeWLu2sac=; b=0OTpwfocD7+OQI1L/9PVGL6W/rkk4lJ5y
        v1IhvdOz0k7PzDsjzl/lDBL7ZRH4VLbYmc7cy7u3SGOEvXfKEiP63tOzyLWPu270
        bbgUhagy20rsMqAc962xRxJWU5KjqJn6TPwNSh7KvCeu/EvMU5wgzXiZDMzGnapu
        286DLXK2xBiqxQAlitIsFKACqGingzdu0HEuZkA43ztVr7xD2U6ALuvefGASqIhr
        9J1fdZOLlmJacgqwjZdHv9qXxFBF5qbEZzkpRvAozkJhetGr6MWhbHXbztqnQWiq
        zbkIILNl6BCnf/PEXKGRjRSOE7gqQUHkQsl/Q7mh7y677UxS1AF0A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org
Cc: Daniel Xu <dxu@dxuuu.xyz>, shakeelb@google.com, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, kernel-team@fb.com

User extended attributes are useful as metadata storage for kernfs
consumers like cgroups. Especially in the case of cgroups, it is useful
to have a central metadata store that multiple processes/services can
use to coordinate actions.

A concrete example is for userspace out of memory killers. We want to
let delegated cgroup subtree owners (running as non-root) to be able to
say "please avoid killing this cgroup". This is especially important for
desktop linux as delegated subtrees owners are less likely to run as
root.

The first two commits set up some stuff for the third commit which
intro introduce a new flag, KERNFS_ROOT_SUPPORT_USER_XATTR,
that lets kernfs consumers enable user xattr support. The final commit
turns on user xattr support for cgroupfs.

Changes from v1:
- use kvmalloc for xattr values
- modify simple_xattr_set to return removed size
- add accounting for total user xattr size per cgroup

Daniel Xu (4):
  kernfs: kvmalloc xattr value instead of kmalloc
  kernfs: Add removed_size out param for simple_xattr_set
  kernfs: Add option to enable user xattrs
  cgroupfs: Support user xattrs

 fs/kernfs/inode.c           | 91 ++++++++++++++++++++++++++++++++++++-
 fs/kernfs/kernfs-internal.h |  2 +
 fs/xattr.c                  | 17 +++++--
 include/linux/kernfs.h      | 11 ++++-
 include/linux/xattr.h       |  3 +-
 kernel/cgroup/cgroup.c      |  3 +-
 mm/shmem.c                  |  2 +-
 7 files changed, 119 insertions(+), 10 deletions(-)

-- 
2.21.1

