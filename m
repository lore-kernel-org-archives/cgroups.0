From: Wolfgang Bumiller <w.bumiller-YTcQvvOqK21BDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH linux] blk-cgroup: always terminate io.stat lines
Date: Mon, 10 Jan 2022 11:37:24 +0100
Message-ID: <20220110103724.11743-1-w.bumiller@proxmox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

With the removal of seq_get_buf in blkcg_print_one_stat, we
cannot make adding the newline conditional on there being
relevant stats because the name has already been written
unconditionally.
Otherwise we may end up with multiple device names in one
line which is confusing and doesn't follow the nested-keyed
file format.

Signed-off-by: Wolfgang Bumiller <w.bumiller-YTcQvvOqK21BDgjK7y7TUQ@public.gmane.org>
Fixes: 252c651a4c85 ("blk-cgroup: stop using seq_get_buf")
---
I also switched to `seq_puts` as suggested by `checkpatch.pl`

This seemed like the simplest approach, so I thought I'd
send a patch.

On my physical machine, creating a new thin lv and starting
a container on it created lines such as

    253:10 253:5 rbytes=0 wbytes=0 rios=0 wios=1 dbytes=0 dios=0
    ^~~~~~ ^~~~~

This *looks* like the devices might just happen to have the
same stats, but that's not the case (and doesn't follow the
documented format).

With this patch this becomes:

    253:10
    253:5 rbytes=0 wbytes=0 rios=0 wios=1 dbytes=0 dios=0

Let me know if you prefer a different solution. I'm not sure
a temporary buffer that can be discarded would be much
better than the previous seq_get_buf() version. Otherwise
we'd need to change the `pd_stat_fn` interface to collect
the data separately and do the formatting afterwards I
suppose?

 block/blk-cgroup.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 663aabfeba18..e3e3e826dff7 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -937,8 +937,7 @@ static void blkcg_print_one_stat(struct blkcg_gq *blkg, struct seq_file *s)
 			has_stats = true;
 	}
 
-	if (has_stats)
-		seq_printf(s, "\n");
+	seq_puts(s, "\n");
 }
 
 static int blkcg_print_stat(struct seq_file *sf, void *v)
-- 
2.30.2


