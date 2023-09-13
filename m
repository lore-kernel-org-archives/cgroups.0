From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 10/19] USB: gadget/legacy: remove sb_mutex
Date: Wed, 13 Sep 2023 08:10:04 -0300
Message-ID: <20230913111013.77623-11-hch@lst.de>
References: <20230913111013.77623-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=jhauY3/jneyf5WN9+Nuds+kBzVHdIqfAGUjcFJu8Bb0=; b=fUrXbSzYYwvk+a7iZ04b7uqo6O
        yMFzj0Gftg1cPI8xK6HOS5/2t5pgeno2tGYPOgwsJz/081bsx4S+hNeEiOj/9JPYM9Yjh8pEPvIg2
        Wrp5GU4bcSIB4btcue4uQ/lOMQxCDrtTXQFGbsyz+e+Q/sq/NLIyVUnKS5kh30g1tvkUo+WWLbVI6
        iV88O2PyuhopSrHum84IdH5rZrmRR5W3S1uhaN1V/StJdm9zQvhM3SCODI7SYCP057DWJJXxpllGa
        KmxajivmHPrvJKEQo0Mi/kfLGWHMHeQkzHNpZklea/6faKeUB06rySel8D+8dQfJ9GqlEYiIOG6Bi
        iwOUmqVA==;
In-Reply-To: <20230913111013.77623-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Creating new a new super_block vs freeing the old one for single instance
file systems is serialized by the wait for SB_DEAD.

Remove the superfluous sb_mutex.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/usb/gadget/legacy/inode.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index ce9e31f3d26bcc..a203266bc0dc82 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -229,7 +229,6 @@ static void put_ep (struct ep_data *data)
  */
 
 static const char *CHIP;
-static DEFINE_MUTEX(sb_mutex);		/* Serialize superblock operations */
 
 /*----------------------------------------------------------------------*/
 
@@ -2012,8 +2011,6 @@ gadgetfs_fill_super (struct super_block *sb, struct fs_context *fc)
 	struct dev_data	*dev;
 	int		rc;
 
-	mutex_lock(&sb_mutex);
-
 	if (the_device) {
 		rc = -ESRCH;
 		goto Done;
@@ -2069,7 +2066,6 @@ gadgetfs_fill_super (struct super_block *sb, struct fs_context *fc)
 	rc = -ENOMEM;
 
  Done:
-	mutex_unlock(&sb_mutex);
 	return rc;
 }
 
@@ -2092,7 +2088,6 @@ static int gadgetfs_init_fs_context(struct fs_context *fc)
 static void
 gadgetfs_kill_sb (struct super_block *sb)
 {
-	mutex_lock(&sb_mutex);
 	kill_litter_super (sb);
 	if (the_device) {
 		put_dev (the_device);
@@ -2100,7 +2095,6 @@ gadgetfs_kill_sb (struct super_block *sb)
 	}
 	kfree(CHIP);
 	CHIP = NULL;
-	mutex_unlock(&sb_mutex);
 }
 
 /*----------------------------------------------------------------------*/
-- 
2.39.2

