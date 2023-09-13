From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 08/19] pstore: shrink the pstore_sb_lock critical section in pstore_kill_sb
Date: Wed, 13 Sep 2023 08:10:02 -0300
Message-ID: <20230913111013.77623-9-hch@lst.de>
References: <20230913111013.77623-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Xklao4KHcROHR/8WDTUTeOE5QrsYvb1TOynYxxAM1IY=; b=0av/5m717cplc+QOcwl88ZZhkv
        YQM9yzvQDx1wwNM1F4FN/+TZdcZakCPUB9tpX7qIKXviEYJGNiKL7nM6wzdoFpXYUwE8dRlxYP85n
        AheRdG3C68ZFMu0glT+SSrQiXRTWdZz1OA6HzM3aCxLykdLie2/UAUNYXAUOU8LULnl7dF85H1y3I
        bfHoOdc64/KYRLDOL+/ElcKMIOyRVN8LF7dTQpsazJCGbzefGXOUpSfMlN8KQMxT5w6XrbKzELime
        Ut1U2f7WzU7RHmh/n7g+ZCkfXpAq547wD8l7r+0tUECJw5acUGSocQEMGdzdnjGO/bAAnIc7s4T9b
        hrVh7h5Q==;
In-Reply-To: <20230913111013.77623-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

->kill_sb can't race with creating ->fill_super because pstore is a
_single file system that only ever has a single sb instance, and we wait
for the previous one to go away before creating a new one.  Reduce
the critical section so that is is not held over generic_shutdown_super.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/pstore/inode.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 585360706b335f..fd1d24b47160d0 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -467,10 +467,9 @@ static struct dentry *pstore_mount(struct file_system_type *fs_type,
 
 static void pstore_kill_sb(struct super_block *sb)
 {
-	mutex_lock(&pstore_sb_lock);
-	WARN_ON(pstore_sb && pstore_sb != sb);
-
 	kill_litter_super(sb);
+
+	mutex_lock(&pstore_sb_lock);
 	pstore_sb = NULL;
 
 	mutex_lock(&records_list_lock);
-- 
2.39.2

