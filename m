From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 42/99] shmem: Convert shmem_confirm_swap to
 XArray
Date: Wed, 17 Jan 2018 12:21:06 -0800
Message-ID: <20180117202203.19756-43-willy@infradead.org>
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
 bh=qLryO9+ckcDAdADvQbQXMn1DhH2IKMDVdBwW6eaBbws=; b=d4yu5+zpwBIcpp3/MzLaClq3lU
 OVyQFTc1IbanrNjAWbbWz9UvZMRTxWqEGEH9NUyJ1+1flNWzxF4PMLSnD/liYYQPbvLB/6biXUDOm
 KpbMU5ayOlOrPgb5wioNWZQfFM94RVMOiaHcmtyTlZLn81XeCIg/y2qFaMa47nFiFiQ8=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=qLryO9+ckcDAdADvQbQXMn1DhH2IKMDVdBwW6eaBbws=; b=NdBLIVMw9mTXMu0GLDFogIzXbv
 evgk0vvswrmyi8r91Tc6DFGMHSglCzfaOpEDRJ9QQ2mH3MCvj/+mdcSXU29k+REYcPorVFcdXQFsz
 BbIyPkVUX8Sf57UU/AbMN/4z7cR8mZWDnppUadFJt8fmINW2xElOx/GceMamEvIAofDQ=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=qLryO9+ckcDAdADvQbQXMn1DhH2IKMDVdBwW6eaBbws=; b=mtqqyA7BoBPFAs0Pc0wvPUgc+
 D1cB3no+wuj6QyBHAly8aT1EpNsI1vJdnysyY5r1LjlQTaZoEADudRAgfaN0Q+T2Xl/Vkb911/jWw
 GmH3gWpfiOH58oAi2eFvzKhAdoHao/iXwAmQSMVaHTLXXEmX3UB+0GiTQ5VxIjVndF560nkdERU4z
 Fg4/RjcrzbLTCQ6vhchpIICxsbQCDYWW59CX0p+8py6Vc/+tqorVlbXCwi/Wp98Ts2V5ADM8dtevW
 FC+RwgnAe9TfFDc7t+NV4mVpsTUk5c4pXO57uxO1WB1iizW2+TCude8Y1aWAuNEdkQ7N8d5+5H47J
 R0HLwC2/w==;
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

xa_load has its own RCU locking, so we can eliminate it here.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index fad6c9e7402e..654f367aca90 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -348,12 +348,7 @@ static int shmem_xa_replace(struct address_space *mapping,
 static bool shmem_confirm_swap(struct address_space *mapping,
 			       pgoff_t index, swp_entry_t swap)
 {
-	void *item;
-
-	rcu_read_lock();
-	item = radix_tree_lookup(&mapping->pages, index);
-	rcu_read_unlock();
-	return item == swp_to_radix_entry(swap);
+	return xa_load(&mapping->pages, index) == swp_to_radix_entry(swap);
 }
 
 /*
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
