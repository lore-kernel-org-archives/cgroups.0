From: Mina Almasry <almasrymina@google.com>
Subject: [PATCH v3 3/4] mm, shmem: add tmpfs memcg= option documentation
Date: Thu, 11 Nov 2021 15:42:02 -0800
Message-ID: <20211111234203.1824138-4-almasrymina@google.com>
References: <20211111234203.1824138-1-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
        bh=QKU2zoRZAY9B8wj0r50tOlnkCOTcLxsxIw+JHt9jziI=;
        b=JocGXKO8vY/Ookh/ASf19pgzF9fbTxKzPIQc9mr3ZW9WLy37prKQp+n3wZnM/xMthM
         2KQx2QAwcupd9pCNoZfYj+6FCwVVh6Jkn9m052frBDQ15Ovd03/ja8SLsW+GW7JuTW7/
         I3epIUBB2H6nOAIkBN9Txbrt0YOYzxDhPkI1ChBp+uj1WGkwN6tJWejpY2LsYHDbTgct
         t+eExB3JvbT+XdeGFGYhdFhDmoi9K+yadiin6mJ9215TXb/QussBIvxWorlBaK7Mu5RX
         61Yl8hcta58kMpcN4IZPjM68lyv1IVyZSGpliCorVZf2XwliHcMa5DkDnOuoS1MPphyS
         L0wA==
In-Reply-To: <20211111234203.1824138-1-almasrymina@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Mina Almasry <almasrymina@google.com>, Michal Hocko <mhocko@suse.com>, Theodore Ts'o <tytso@mit.edu>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Muchun Song <songmuchun@bytedance.com>, riel@surriel.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org

Signed-off-by: Mina Almasry <almasrymina@google.com>

Cc: Michal Hocko <mhocko@suse.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Greg Thelen <gthelen@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: riel@surriel.com
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org
Cc: cgroups@vger.kernel.org

---
 Documentation/filesystems/tmpfs.rst | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/filesystems/tmpfs.rst b/Documentation/filesystems/tmpfs.rst
index 0408c245785e3..1ab04e8fa9222 100644
--- a/Documentation/filesystems/tmpfs.rst
+++ b/Documentation/filesystems/tmpfs.rst
@@ -137,6 +137,23 @@ mount options.  It can be added later, when the tmpfs is already mounted
 on MountPoint, by 'mount -o remount,mpol=Policy:NodeList MountPoint'.


+If CONFIG_MEMCG is enabled, tmpfs has a mount option to specify the memory
+cgroup to be charged for page allocations.
+
+memcg=/sys/fs/cgroup/unified/test/: data page allocations are charged to
+cgroup /sys/fs/cgroup/unified/test/.
+
+When charging memory to the remote memcg (memcg specified with memcg=) and
+hitting the limit, the oom-killer will be invoked and will attempt to kill
+a process in the remote memcg. If no such processes are found, the remote
+charging process gets an ENOMEM. If the remote charging process is in the
+pagefault path, it gets killed.
+
+Only processes that have access to /sys/fs/cgroup/unified/test/cgroup.procs can
+mount a tmpfs with memcg=/sys/fs/cgroup/unified/test. Thus, a process is able
+to charge memory to a cgroup only if it itself is able to enter that cgroup.
+
+
 To specify the initial root directory you can use the following mount
 options:

--
2.34.0.rc1.387.gb447b232ab-goog
