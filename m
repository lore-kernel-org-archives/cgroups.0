From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/14] fs: remove the unused SB_I_MULTIROOT flag
Date: Sun, 26 Jul 2020 17:03:20 +0200
Message-ID: <20200726150333.305527-2-hch@lst.de>
References: <20200726150333.305527-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=SQdEEUbS15XfNOnvBJj0vCvV6+m0XV9g2xcYAZ+hMD4=; b=YxnU7xECKgDZ4LqJfdWMsIcxEA
        yCfUcE3gTRygR1OvjtYJrDU3Bz1paMjy6nh9aMctdrc9x02/AF0mTDzlfwRI/UIdNsA0DGuyhGxG+
        awRyoFbpxtSm3feI5LlsKLA8kZcUNh15jh+lTmOEMsJcmDjBTMdOr7ZbCZMeoWcRgcrxsl4VbVdnw
        yyrL6nGsYfdC8zf3Xt7LFsoZCMj5AvtvctzOQxWqy3xwMuxs8ssFmU8lyS8xkNG0dKqBf08p7UVI1
        Cwf8EsgAfBAuY5/yvO+nJBZFfQrdydTuhw8kfer1VpDvEBbb2fuSox1nVc5xOWmW8Tk2knXuA9jg3
        GH9QgDZQ==;
In-Reply-To: <20200726150333.305527-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Johannes Thumshirn <johannes.thumshirn@wdc.com>

The last user of SB_I_MULTIROOT is disappeared with commit f2aedb713c28
("NFS: Add fs_context support.")

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/namei.c         | 4 ++--
 include/linux/fs.h | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 72d4219c93acb7..e9ff0d54a110a7 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -568,8 +568,8 @@ static bool path_connected(struct vfsmount *mnt, struct dentry *dentry)
 {
 	struct super_block *sb = mnt->mnt_sb;
 
-	/* Bind mounts and multi-root filesystems can have disconnected paths */
-	if (!(sb->s_iflags & SB_I_MULTIROOT) && (mnt->mnt_root == sb->s_root))
+	/* Bind mounts can have disconnected paths */
+	if (mnt->mnt_root == sb->s_root)
 		return true;
 
 	return is_subdir(dentry, mnt->mnt_root);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 41cd993ec0f686..236543605dd118 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1366,7 +1366,6 @@ extern int send_sigurg(struct fown_struct *fown);
 #define SB_I_CGROUPWB	0x00000001	/* cgroup-aware writeback enabled */
 #define SB_I_NOEXEC	0x00000002	/* Ignore executables on this fs */
 #define SB_I_NODEV	0x00000004	/* Ignore devices on this fs */
-#define SB_I_MULTIROOT	0x00000008	/* Multiple roots to the dentry tree */
 
 /* sb->s_iflags to limit user namespace mounts */
 #define SB_I_USERNS_VISIBLE		0x00000010 /* fstype already mounted */
-- 
2.27.0

