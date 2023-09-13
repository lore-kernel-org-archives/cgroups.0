From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 04/19] NFS: remove the s_dev field from struct nfs_server
Date: Wed, 13 Sep 2023 08:09:58 -0300
Message-ID: <20230913111013.77623-5-hch@lst.de>
References: <20230913111013.77623-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=bX4iGfr0tDcuYF5EDBEIAqxef+8miCseN1a4MmuC19c=; b=g4OcufcLBW19o88tMTLEGrn/2M
        CLpqezXLQzOk/PYicTrYmwexiyk2JYuPbmISbHvegprAO28vD6/ovEfXYs0ZLIoR055SfeBNgbdjN
        veGb+NyDJ0TjumaKDjj04voay+g2iyGNDKkbHzas9ZSGb+Y5FjtoWgarnLhOBIz72Nykc/DZOau9I
        bNLLDErOdBxZbTTYG+HAPqeLOwTS2539I2l8NSiXnhbRm5hM6ZZsxCpOZsdn773njAtNPb1oabubo
        UEDBVo4lHgfnRUX6J2p6FtG40LeHJ0zURd1riXEq/Fw5RqsdMIGqe0EyYlKahq+W1lpCsWNjHdvOd
        inndOPjw==;
In-Reply-To: <20230913111013.77623-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Don't duplicate the dev_t in the nfs_server structure given that it can
be trivially retrieved from the super_block.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/nfs/client.c           |  2 +-
 fs/nfs/nfs4proc.c         |  8 ++++----
 fs/nfs/nfs4trace.h        |  6 +++---
 fs/nfs/nfs4xdr.c          |  2 +-
 fs/nfs/super.c            | 10 +++-------
 include/linux/nfs_fs_sb.h |  1 -
 6 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 44eca51b28085d..039fd67ac17c82 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -1337,7 +1337,7 @@ static int nfs_volume_list_show(struct seq_file *m, void *v)
 	clp = server->nfs_client;
 
 	snprintf(dev, sizeof(dev), "%u:%u",
-		 MAJOR(server->s_dev), MINOR(server->s_dev));
+		 MAJOR(server->super->s_dev), MINOR(server->super->s_dev));
 
 	snprintf(fsid, sizeof(fsid), "%llx:%llx",
 		 (unsigned long long) server->fsid.major,
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 794343790ea8bb..4d002cc514983c 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6763,7 +6763,7 @@ static int _nfs4_proc_getlk(struct nfs4_state *state, int cmd, struct file_lock
 		goto out;
 	lsp = request->fl_u.nfs4_fl.owner;
 	arg.lock_owner.id = lsp->ls_seqid.owner_id;
-	arg.lock_owner.s_dev = server->s_dev;
+	arg.lock_owner.s_dev = server->super->s_dev;
 	status = nfs4_call_sync(server->client, server, &msg, &arg.seq_args, &res.seq_res, 1);
 	switch (status) {
 		case 0:
@@ -7088,7 +7088,7 @@ static struct nfs4_lockdata *nfs4_alloc_lockdata(struct file_lock *fl,
 		goto out_free_seqid;
 	p->arg.lock_owner.clientid = server->nfs_client->cl_clientid;
 	p->arg.lock_owner.id = lsp->ls_seqid.owner_id;
-	p->arg.lock_owner.s_dev = server->s_dev;
+	p->arg.lock_owner.s_dev = server->super->s_dev;
 	p->res.lock_seqid = p->arg.lock_seqid;
 	p->lsp = lsp;
 	p->server = server;
@@ -7475,7 +7475,7 @@ nfs4_retry_setlk(struct nfs4_state *state, int cmd, struct file_lock *request)
 		.inode = state->inode,
 		.owner = { .clientid = clp->cl_clientid,
 			   .id = lsp->ls_seqid.owner_id,
-			   .s_dev = server->s_dev },
+			   .s_dev = server->super->s_dev },
 	};
 	int status;
 
@@ -7689,7 +7689,7 @@ nfs4_release_lockowner(struct nfs_server *server, struct nfs4_lock_state *lsp)
 	data->server = server;
 	data->args.lock_owner.clientid = server->nfs_client->cl_clientid;
 	data->args.lock_owner.id = lsp->ls_seqid.owner_id;
-	data->args.lock_owner.s_dev = server->s_dev;
+	data->args.lock_owner.s_dev = server->super->s_dev;
 
 	msg.rpc_argp = &data->args;
 	msg.rpc_resp = &data->res;
diff --git a/fs/nfs/nfs4trace.h b/fs/nfs/nfs4trace.h
index d27919d7241d38..13a602c675ddb2 100644
--- a/fs/nfs/nfs4trace.h
+++ b/fs/nfs/nfs4trace.h
@@ -945,7 +945,7 @@ TRACE_EVENT(nfs4_delegreturn_exit,
 		),
 
 		TP_fast_assign(
-			__entry->dev = res->server->s_dev;
+			__entry->dev = res->server->super->s_dev;
 			__entry->fhandle = nfs_fhandle_hash(args->fhandle);
 			__entry->error = error < 0 ? -error : 0;
 			__entry->stateid_seq =
@@ -1269,7 +1269,7 @@ DECLARE_EVENT_CLASS(nfs4_getattr_event,
 		),
 
 		TP_fast_assign(
-			__entry->dev = server->s_dev;
+			__entry->dev = server->super->s_dev;
 			__entry->valid = fattr->valid;
 			__entry->fhandle = nfs_fhandle_hash(fhandle);
 			__entry->fileid = (fattr->valid & NFS_ATTR_FATTR_FILEID) ? fattr->fileid : 0;
@@ -1966,7 +1966,7 @@ DECLARE_EVENT_CLASS(nfs4_deviceid_status,
 		),
 
 		TP_fast_assign(
-			__entry->dev = server->s_dev;
+			__entry->dev = server->super->s_dev;
 			__entry->status = status;
 			__assign_str(dstaddr, server->nfs_client->cl_hostname);
 			memcpy(__entry->deviceid, deviceid->data,
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index deec76cf5afeaf..9767c5e2ed1a9a 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -1420,7 +1420,7 @@ static inline void encode_openhdr(struct xdr_stream *xdr, const struct nfs_opena
 	p = xdr_encode_hyper(p, arg->clientid);
 	*p++ = cpu_to_be32(24);
 	p = xdr_encode_opaque_fixed(p, "open id:", 8);
-	*p++ = cpu_to_be32(arg->server->s_dev);
+	*p++ = cpu_to_be32(arg->server->super->s_dev);
 	*p++ = cpu_to_be32(arg->id.uniquifier);
 	xdr_encode_hyper(p, arg->id.create_time);
 }
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 29d6a55b9d400d..561221a87b02a6 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1130,13 +1130,9 @@ static int nfs_compare_mount_options(const struct super_block *s, const struct n
 static int nfs_set_super(struct super_block *s, struct fs_context *fc)
 {
 	struct nfs_server *server = fc->s_fs_info;
-	int ret;
 
 	s->s_d_op = server->nfs_client->rpc_ops->dentry_ops;
-	ret = set_anon_super(s, server);
-	if (ret == 0)
-		server->s_dev = s->s_dev;
-	return ret;
+	return set_anon_super(s, server);
 }
 
 static int nfs_compare_super_address(struct nfs_server *server1,
@@ -1292,8 +1288,8 @@ int nfs_get_tree_common(struct fs_context *fc)
 		nfs_free_server(server);
 		server = NULL;
 	} else {
-		error = super_setup_bdi_name(s, "%u:%u", MAJOR(server->s_dev),
-					     MINOR(server->s_dev));
+		error = super_setup_bdi_name(s, "%u:%u", MAJOR(s->s_dev),
+					     MINOR(s->s_dev));
 		if (error)
 			goto error_splat_super;
 		s->s_bdi->io_pages = server->rpages;
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index 20eeba8b009df1..9c71af0e3516fa 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -190,7 +190,6 @@ struct nfs_server {
 	struct timespec64	time_delta;	/* smallest time granularity */
 	unsigned long		mount_time;	/* when this fs was mounted */
 	struct super_block	*super;		/* VFS super block */
-	dev_t			s_dev;		/* superblock dev numbers */
 	struct nfs_auth_info	auth_info;	/* parsed auth flavors */
 
 #ifdef CONFIG_NFS_FSCACHE
-- 
2.39.2

