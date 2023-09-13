From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 01/19] fs: reflow deactivate_locked_super
Date: Wed, 13 Sep 2023 08:09:55 -0300
Message-ID: <20230913111013.77623-2-hch@lst.de>
References: <20230913111013.77623-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=b6JdnhwIl1taCSuc4/dqYhKrJWm6XSMnTzKFUhXDk90=; b=EAZIGMEQGDmVc5b4HFMpBvbTk1
        a87xB+v+1aNqp3SxQeGpV9pGzF8zADYqluGyqlFQa8NzUIiR/aTufGkixUmKR0TmyhHOKTVIssNrI
        oOFCpHLiXMlmAN3iof2pWDUzqstnEJxit+dtb2dVuyYZxuftmoWr5Wuyb6w7M1b9q23kwkDHhoToo
        1htP/cypd4seEz9gHuu1jV1u0S7HxglRFy5nb0rOrPWEZZMb1lIVKnbtY/e3M85d25kUSW3oQL2RU
        laGeZfjve9WXYmBB4d0uFgGBFR8aDayeP5agpFwnAbORmgapveVNx3bXY8WLLNsnARaFCeGJDPCln
        /4p8NMPw==;
In-Reply-To: <20230913111013.77623-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Return early for the case where the super block isn't cleaned up to
reduce level of indentation.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/super.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 2d762ce67f6e6c..127a17d958a482 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -476,27 +476,28 @@ static void kill_super_notify(struct super_block *sb)
 void deactivate_locked_super(struct super_block *s)
 {
 	struct file_system_type *fs = s->s_type;
-	if (atomic_dec_and_test(&s->s_active)) {
-		unregister_shrinker(&s->s_shrink);
-		fs->kill_sb(s);
 
-		kill_super_notify(s);
-
-		/*
-		 * Since list_lru_destroy() may sleep, we cannot call it from
-		 * put_super(), where we hold the sb_lock. Therefore we destroy
-		 * the lru lists right now.
-		 */
-		list_lru_destroy(&s->s_dentry_lru);
-		list_lru_destroy(&s->s_inode_lru);
-
-		put_filesystem(fs);
-		put_super(s);
-	} else {
+	if (!atomic_dec_and_test(&s->s_active)) {
 		super_unlock_excl(s);
+		return;
 	}
-}
 
+	unregister_shrinker(&s->s_shrink);
+	fs->kill_sb(s);
+
+	kill_super_notify(s);
+
+	/*
+	 * Since list_lru_destroy() may sleep, we cannot call it from
+	 * put_super(), where we hold the sb_lock. Therefore we destroy
+	 * the lru lists right now.
+	 */
+	list_lru_destroy(&s->s_dentry_lru);
+	list_lru_destroy(&s->s_inode_lru);
+
+	put_filesystem(fs);
+	put_super(s);
+}
 EXPORT_SYMBOL(deactivate_locked_super);
 
 /**
-- 
2.39.2

