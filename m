From: Glauber Costa <glommer@parallels.com>
Subject: [PATCH 0/4] Proposed slab patches as basis for memcg
Date: Thu, 14 Jun 2012 16:17:20 +0400
Message-ID: <1339676244-27967-1-git-send-email-glommer@parallels.com>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Pekka Enberg <penberg@kernel.org>, Cristoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, cgroups@vger.kernel.org, devel@openvz.org

Hi,

These four patches are sat in my tree for kmem memcg work.
All of them are preparation patches that touch the allocators
to make them more consistent, allowing me to later use them
from common code.

In this current form, they are supposed to be applied after
Cristoph's series. They are not, however, dependent on it.

Glauber Costa (4):
  slab: rename gfpflags to allocflags
  provide a common place for initcall processing in kmem_cache
  slab: move FULL state transition to an initcall
  make CFLGS_OFF_SLAB visible for all slabs

 include/linux/slab.h     |    2 ++
 include/linux/slab_def.h |    2 +-
 mm/slab.c                |   40 +++++++++++++++++++---------------------
 mm/slab.h                |    1 +
 mm/slab_common.c         |    5 +++++
 mm/slob.c                |    5 +++++
 mm/slub.c                |    4 +---
 7 files changed, 34 insertions(+), 25 deletions(-)

-- 
1.7.10.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
