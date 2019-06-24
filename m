From: Waiman Long <longman@redhat.com>
Subject: [PATCH 0/2] mm, slab: Extend vm/drop_caches to shrink kmem slabs
Date: Mon, 24 Jun 2019 13:42:17 -0400
Message-ID: <20190624174219.25513-1-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Andrea Arcangeli <aarcange@redhat.com>, Waiman Long <longman@redhat.com>

The purpose of this patchset is to allow system administrators to have
the ability to shrink all the kmem slabs in order to free up memory
and get a more accurate picture of how many slab objects are actually
being used.

Patch 1 adds a new memcg_iterate_all() that is used by the patch 2 to
iterate on all the memory cgroups.

Waiman Long (2):
  mm, memcontrol: Add memcg_iterate_all()
  mm, slab: Extend vm/drop_caches to shrink kmem slabs

 Documentation/sysctl/vm.txt | 11 ++++++++--
 fs/drop_caches.c            |  4 ++++
 include/linux/memcontrol.h  |  3 +++
 include/linux/slab.h        |  1 +
 kernel/sysctl.c             |  4 ++--
 mm/memcontrol.c             | 13 +++++++++++
 mm/slab_common.c            | 44 +++++++++++++++++++++++++++++++++++++
 7 files changed, 76 insertions(+), 4 deletions(-)

-- 
2.18.1

