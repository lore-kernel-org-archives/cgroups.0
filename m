From: quanyang.wang@windriver.com
Subject: [V2][PATCH] cgroup: fix memory leak caused by missing cgroup_bpf_offline
Date: Mon, 18 Oct 2021 15:56:23 +0800
Message-ID: <20211018075623.26884-1-quanyang.wang@windriver.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=9TVuZOiHz8mb3tbd2oqe6A5HkvbeAOX8Q/88ODx4zF8=;
 b=dEatw0dE3so/ouKyzrX0c8GDnMhHcgP3Iif1Uv/eTvViKoWm9+321STUD7pxKU85lHvc
 BjQ/NPlouLJREqWFd9IX1rdSEc8Y6kz4QiIlssVcXTYyJeXXPR9KsPJXWBLXt1a7cHz2
 W/+HkYL3RZajLnAPVPtGiInoORmA8UR7BWUX4uuGLUvn/Yv33phahsAOESTL8ZweoSI8
 bMQlL3nVS3XemUOlyr8V4RMuSnkPazD7rrigZGxpIlK/EOXeD+npnAhI43E+6eY90EJZ
 WcVCkla1QK25QRIHQytFYzEpZ+GEbOmt7TYbG/DhrZFt0zfgaKLrGxjKj805MUXoTzPj BQ== 
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, Roman Gushchin <guro@fb.com>, mkoutny@suse.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, Quanyang Wang <quanyang.wang@windriver.com>

From: Quanyang Wang <quanyang.wang@windriver.com>

When enabling CONFIG_CGROUP_BPF, kmemleak can be observed by running
the command as below:

    $mount -t cgroup -o none,name=foo cgroup cgroup/
    $umount cgroup/

unreferenced object 0xc3585c40 (size 64):
  comm "mount", pid 425, jiffies 4294959825 (age 31.990s)
  hex dump (first 32 bytes):
    01 00 00 80 84 8c 28 c0 00 00 00 00 00 00 00 00  ......(.........
    00 00 00 00 00 00 00 00 6c 43 a0 c3 00 00 00 00  ........lC......
  backtrace:
    [<e95a2f9e>] cgroup_bpf_inherit+0x44/0x24c
    [<1f03679c>] cgroup_setup_root+0x174/0x37c
    [<ed4b0ac5>] cgroup1_get_tree+0x2c0/0x4a0
    [<f85b12fd>] vfs_get_tree+0x24/0x108
    [<f55aec5c>] path_mount+0x384/0x988
    [<e2d5e9cd>] do_mount+0x64/0x9c
    [<208c9cfe>] sys_mount+0xfc/0x1f4
    [<06dd06e0>] ret_fast_syscall+0x0/0x48
    [<a8308cb3>] 0xbeb4daa8

This is because that since the commit 2b0d3d3e4fcf ("percpu_ref: reduce
memory footprint of percpu_ref in fast path") root_cgrp->bpf.refcnt.data
is allocated by the function percpu_ref_init in cgroup_bpf_inherit which
is called by cgroup_setup_root when mounting, but not freed along with
root_cgrp when umounting. Adding cgroup_bpf_offline which calls
percpu_ref_kill to cgroup_kill_sb can free root_cgrp->bpf.refcnt.data in
umount path.

This patch also fixes the commit 4bfc0bb2c60e ("bpf: decouple the lifetime
of cgroup_bpf from cgroup itself"). A cgroup_bpf_offline is needed to do a
cleanup that frees the resources which are allocated by cgroup_bpf_inherit
in cgroup_setup_root. 

And inside cgroup_bpf_offline, cgroup_get() is at the beginning and
cgroup_put is at the end of cgroup_bpf_release which is called by
cgroup_bpf_offline. So cgroup_bpf_offline can keep the balance of
cgroup's refcount.

Fixes: 2b0d3d3e4fcf ("percpu_ref: reduce memory footprint of percpu_ref in fast path")
Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself")
Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
---
V1 ---> V2:
1. As per Daniel's suggestion, add description to commit msg about the
balance of cgroup's refcount in cgroup_bpf_offline.
2. As per Michal's suggestion, add tag "Fixes: 4bfc0bb2c60e" and add
description about it.
3. Fix indentation on the percpu_ref_is_dying line.
---
 kernel/cgroup/cgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 570b0c97392a..ea08f01d0111 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2187,8 +2187,10 @@ static void cgroup_kill_sb(struct super_block *sb)
 	 * And don't kill the default root.
 	 */
 	if (list_empty(&root->cgrp.self.children) && root != &cgrp_dfl_root &&
-	    !percpu_ref_is_dying(&root->cgrp.self.refcnt))
+	    !percpu_ref_is_dying(&root->cgrp.self.refcnt)) {
+		cgroup_bpf_offline(&root->cgrp);
 		percpu_ref_kill(&root->cgrp.self.refcnt);
+	}
 	cgroup_put(&root->cgrp);
 	kernfs_kill_sb(sb);
 }
-- 
2.25.1

