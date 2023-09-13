From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 17/19] NFS: move nfs_kill_super to fs_context.c
Date: Wed, 13 Sep 2023 08:10:11 -0300
Message-ID: <20230913111013.77623-18-hch@lst.de>
References: <20230913111013.77623-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=uLf6h1RfKslNP20U1IGrQ445JsmzxP5A7l/7KbuT/rI=; b=jv3yC3+tBEO2gEO8hI8aiTv3mm
        C4RIrY6VwCIz+0Kd8HLQh0zUXapoHexrxrsQcpmK0edlC0uwqv6xRJMamtim2fxT0yCH0LdJ9gBrQ
        J93a1HenbqTLi2h0MAndK/r51S78zkIX89N5rrF/UEH5rU97J3g6oW/jig2X7WzEwTLFoBSPMMJXG
        +DyzLXFhchmuRLnOF4kJA9SpMGR7ZzWCefk5x52awHnBs0GgmjqVUh4fv+FKIALK2M0srMPen9L38
        O6MequqmNpU1rb2i3bikKfRqEoLW8mu85hD7Mdr01uEfOQMdqn21zw3hqR99nuSg5OOW53ykwaIwp
        bP2wyvIg==;
In-Reply-To: <20230913111013.77623-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

nfs_kill_super is only used in fs_context, so move it there.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/nfs/fs_context.c | 13 +++++++++++++
 fs/nfs/internal.h   |  1 -
 fs/nfs/super.c      | 16 ----------------
 fs/nfs/sysfs.h      |  2 ++
 4 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/fs/nfs/fs_context.c b/fs/nfs/fs_context.c
index 853e8d609bb3bc..ee82e4cfb38bb5 100644
--- a/fs/nfs/fs_context.c
+++ b/fs/nfs/fs_context.c
@@ -21,8 +21,10 @@
 
 #include <net/handshake.h>
 
+#include "fscache.h"
 #include "nfs.h"
 #include "internal.h"
+#include "sysfs.h"
 
 #include "nfstrace.h"
 
@@ -1644,6 +1646,17 @@ static int nfs_init_fs_context(struct fs_context *fc)
 	return 0;
 }
 
+static void nfs_kill_super(struct super_block *s)
+{
+	struct nfs_server *server = NFS_SB(s);
+
+	nfs_sysfs_move_sb_to_server(server);
+	generic_shutdown_super(s);
+
+	nfs_fscache_release_super_cookie(s);
+	nfs_free_server(server);
+}
+
 struct file_system_type nfs_fs_type = {
 	.owner			= THIS_MODULE,
 	.name			= "nfs",
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 9c9cf764f6000d..49d5b03176c02d 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -447,7 +447,6 @@ extern const struct super_operations nfs_sops;
 bool nfs_auth_info_match(const struct nfs_auth_info *, rpc_authflavor_t);
 int nfs_try_get_tree(struct fs_context *);
 int nfs_get_tree_common(struct fs_context *);
-void nfs_kill_super(struct super_block *);
 
 extern struct rpc_stat nfs_rpcstat;
 
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 89131e855e1393..5ba793e7f262d4 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1329,22 +1329,6 @@ int nfs_get_tree_common(struct fs_context *fc)
 	goto out;
 }
 
-/*
- * Destroy an NFS superblock
- */
-void nfs_kill_super(struct super_block *s)
-{
-	struct nfs_server *server = NFS_SB(s);
-
-	nfs_sysfs_move_sb_to_server(server);
-	generic_shutdown_super(s);
-
-	nfs_fscache_release_super_cookie(s);
-
-	nfs_free_server(server);
-}
-EXPORT_SYMBOL_GPL(nfs_kill_super);
-
 #if IS_ENABLED(CONFIG_NFS_V4)
 
 /*
diff --git a/fs/nfs/sysfs.h b/fs/nfs/sysfs.h
index c5d1990cade50a..44c8a1712149c2 100644
--- a/fs/nfs/sysfs.h
+++ b/fs/nfs/sysfs.h
@@ -8,6 +8,8 @@
 
 #define CONTAINER_ID_MAXLEN (64)
 
+struct nfs_net;
+
 struct nfs_netns_client {
 	struct kobject kobject;
 	struct kobject nfs_net_kobj;
-- 
2.39.2

