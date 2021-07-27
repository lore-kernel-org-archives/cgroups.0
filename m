From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v7 04/10] memcg: enable accounting for fasync_cache
Date: Tue, 27 Jul 2021 08:33:33 +0300
Message-ID: <1b408625-d71c-0b26-b0b6-9baf00f93e69@virtuozzo.com>
References: <6f21a0e0-bd36-b6be-1ffa-0dc86c06c470@virtuozzo.com>
 <cover.1627362057.git.vvs@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=C9yDGq1DGF0qRqKlvs/XnP70DMDpJdWqT+roIArxGNw=; b=CvXCCvMZiYCq8mxvXOr
        Agp20Om2u94X+CEcSy0B/UFaTXNSBj/N+yP5icjwPBSWruFNdchRW1KZ1ErzOj77rYVmFjlVfn7Dq
        XjnnvOi/LnDag45EmLbQSpWTDsUZFP3prIONANdVnXyp91qW0N99uqryiCmovBz+fYvNaufvwSk=;
In-Reply-To: <cover.1627362057.git.vvs@virtuozzo.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

fasync_struct is used by almost all character device drivers to set up
the fasync queue, and for regular files by the file lease code.
This structure is quite small but long-living and it can be assigned
for any open file.

It makes sense to account for its allocations to restrict the host's
memory consumption from inside the memcg-limited container.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/fcntl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index f946bec..714e7c9 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -1049,7 +1049,8 @@ static int __init fcntl_init(void)
 			__FMODE_EXEC | __FMODE_NONOTIFY));
 
 	fasync_cache = kmem_cache_create("fasync_cache",
-		sizeof(struct fasync_struct), 0, SLAB_PANIC, NULL);
+					 sizeof(struct fasync_struct), 0,
+					 SLAB_PANIC | SLAB_ACCOUNT, NULL);
 	return 0;
 }
 
-- 
1.8.3.1

