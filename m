From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 02/19] fs: make ->kill_sb optional
Date: Wed, 13 Sep 2023 08:09:56 -0300
Message-ID: <20230913111013.77623-3-hch@lst.de>
References: <20230913111013.77623-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=OvdbcAa8gNPLTScw30C0haUonfkOP4Sq+9lSIjPBcA4=; b=BepW6GlQfs7UxJI49kYyTOBmOn
        io8rCiqoTN82fVhijBrxmh9o1TdkMXRsiAIwB5vFZMJHLLxr+CTkE5IT0bezBvw5XQkYmxJamyO7r
        VERBZCQvvADhWdAfiqojvZf61y+XfcgyFv5rOelIFAgst08ZgJMWU4IlV3C9vz/DA8lzKsDDcCi4x
        nTdjEjDz27Hb9ZI3K+FLVKG+rRX6BnVjvMb0SMmENeAYOBDB/ReOHHJhruLn67W3hQYc9BTZSJA4k
        vinBnybR1nUaX6WOMp85Fn/1tILifgOb74k8iOy2N+OpXTds6npnQN1TjbBmF5AD+WCPStHhmQgb2
        vXoPOUQw==;
In-Reply-To: <20230913111013.77623-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Call generic_shutdown_super if ->kill_sb is not provided by the file
system.  This can't currently happen but will become common soon.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/super.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/super.c b/fs/super.c
index 127a17d958a482..ab234e6af48605 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -483,7 +483,11 @@ void deactivate_locked_super(struct super_block *s)
 	}
 
 	unregister_shrinker(&s->s_shrink);
-	fs->kill_sb(s);
+
+	if (fs->kill_sb)
+		fs->kill_sb(s);
+	else
+		generic_shutdown_super(s);
 
 	kill_super_notify(s);
 
-- 
2.39.2

