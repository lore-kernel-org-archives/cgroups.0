From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 85/99] btrfs: Remove unused spinlock
Date: Wed, 17 Jan 2018 12:21:49 -0800
Message-ID: <20180117202203.19756-86-willy@infradead.org>
References: <20180117202203.19756-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:
 To:From:Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=ST3oTGdl+3N6u/3qxgZPIz0xOSpk4XtWJXC63mJuiMw=; b=HCbFp/BflYIPK/p2GwMeLvDlMG
 P17/qyBbyarc6/8WcwMTIKfbl30lRW9t+aeJXxhzc6NAlHWWfD3draF9Ty+inxuc9xzm939J+0gCk
 QUdr0wtun/mR8hng8lG46unPlLK0eWQmBTJ2qFvETNvNgj/vtZc0mWRznbtWa8z6mymo=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=ST3oTGdl+3N6u/3qxgZPIz0xOSpk4XtWJXC63mJuiMw=; b=C+6rnu5HnhEpewq6eYW5tU1Mf6
 hlhE+zFJmBwDWvE2xyv++qCC9wgyeJehm3LE4PdM8T9pE6IA/Yk5mXFwjG2FcAWSXxcAeYnNv06+f
 LhCHY8au6EjWUkURsdWQuSk6u6lwMXF7dVmpMvUYXdXGqdatZGMorPJc2ccqzlO7a1BA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=ST3oTGdl+3N6u/3qxgZPIz0xOSpk4XtWJXC63mJuiMw=; b=USgQ/shJNUPVelDVZuUsPCdR7
 oHhm9bUZywsyZWJnJRd0+u2GKOAljN5YDQcvf1a9+5Fg7aCF6dqvTo/fZO/Td/g0xavvvUYNgt8rI
 ro7n2LSTK8F7TOVxX5W5JIKPP2Tr8q2LGaIIN0udfUPLSUvEhtqpjn3repT6wlVY9GKzDc79Q1xIc
 APo73fIc2q8u8zxgv4JkzXF1XAz/HZuGtJU30Z0tBjnWGQGpkKNnBdDFPzSd/BBszYF+8b3lmREru
 l6+A9nd7mVoyCwF1s3hu5x28UrWKhgSAVy2t9NztXicmKQyRGP3dc+WiX/IOsCl8NWZ1uGWnyF2Oo
 OKF6/3wIw==;
In-Reply-To: <20180117202203.19756-1-willy@infradead.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-nilfs@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-sh@vger.kernel.org, intel-gfx@lists.freedesktop.org, linux-usb@vger.kernel.org, linux-remoteproc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Stefano Stabellini <sstabellini@kernel.org>, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

The reada_lock in struct btrfs_device was only initialised, and not
actually used.  That's good because there's another lock also called
reada_lock in the btrfs_fs_info that was quite heavily used.  Remove
this one.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/btrfs/volumes.c | 1 -
 fs/btrfs/volumes.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a25684287501..cba286183ff9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -244,7 +244,6 @@ static struct btrfs_device *__alloc_device(void)
 
 	spin_lock_init(&dev->io_lock);
 
-	spin_lock_init(&dev->reada_lock);
 	atomic_set(&dev->reada_in_flight, 0);
 	atomic_set(&dev->dev_stats_ccnt, 0);
 	btrfs_device_data_ordered_init(dev);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index ff15208344a7..335fd1590458 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -136,7 +136,6 @@ struct btrfs_device {
 	struct work_struct rcu_work;
 
 	/* readahead state */
-	spinlock_t reada_lock;
 	atomic_t reada_in_flight;
 	u64 reada_next;
 	struct reada_zone *reada_curr_zone;
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
