From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/2] ext4: implement cgroup writeback support
Date: Tue, 16 Jun 2015 18:53:13 -0400
Message-ID: <1434495193-31182-3-git-send-email-tj@kernel.org>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4Ew/mWGf8qEeupGhtnQ/nPWyHZuwitMF1r4cMhExrpo=;
        b=e4hzLxRMqw2GPIhz/J6ghayP4hqiYWR6heq4/sZCb74MsBO6FY74GjlAJrTZMxLcVX
         jZ9sLjusH3zcp7RTaDE6UJiYyG7C6KPG5Fv4wzmNV3Ctbg2gcIasYVCLq/oGW9OTWmsf
         l/LnbdANA+1CmRsZrh19yaTyTuFvUs/CU6EjFdX7IAcSfAZDbWPPnhKzKJ2UQecagapx
         IyIk3M+wcpoOFa4a4ZR5EbZ04XorkmXs5aAEWKXZyhj1QiESWCNoDCtYCNv+cVXm3Ohp
         jlgigjrvRJDSRfhn5ZwspPeNMj0kRyKexZ56a/i51EFWqBYIy+GduZkDV2tV2ugCwvIC
         gSvw==
In-Reply-To: <1434495193-31182-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, hannes@cmpxchg.org, kernel-team@fb.com, tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, Tejun Heo <tj@kernel.org>

For ordered and writeback data modes, all data IOs go through
ext4_io_submit.  This patch adds cgroup writeback support by invoking
wbc_init_bio() from io_submit_init_bio() and wbc_account_io() in
io_submit_add_bh().  Journal data which is written by jbd2 worker is
left alone by this patch and will always be written out from the root
cgroup.

ext4_fill_super() is updated to set MS_CGROUPWB when data mode is
either ordered or writeback.  In journaled data mode, most IOs become
synchronous through the journal and enabling cgroup writeback support
doesn't make much sense or difference.  Journaled data mode is left
alone.

Lightly tested with sequential data write workload.  Behaves as
expected.

v2: Updated for MS_CGROUPWB -> SB_I_CGROUPWB.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext4/page-io.c | 2 ++
 fs/ext4/super.c   | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 3f80cb2..c56ba7b 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -383,6 +383,7 @@ static int io_submit_init_bio(struct ext4_io_submit *io,
 	bio = bio_alloc(GFP_NOIO, min(nvecs, BIO_MAX_PAGES));
 	if (!bio)
 		return -ENOMEM;
+	wbc_init_bio(io->io_wbc, bio);
 	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio->bi_bdev = bh->b_bdev;
 	bio->bi_end_io = ext4_end_bio;
@@ -411,6 +412,7 @@ static int io_submit_add_bh(struct ext4_io_submit *io,
 	ret = bio_add_page(io->io_bio, page, bh->b_size, bh_offset(bh));
 	if (ret != bh->b_size)
 		goto submit_and_retry;
+	wbc_account_io(io->io_wbc, page, bh->b_size);
 	io->io_next_block++;
 	return 0;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 56b8bb7..3ad1eb4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3623,6 +3623,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		}
 		if (test_opt(sb, DELALLOC))
 			clear_opt(sb, DELALLOC);
+	} else {
+		sb->s_iflags |= SB_I_CGROUPWB;
 	}
 
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
-- 
2.4.3
