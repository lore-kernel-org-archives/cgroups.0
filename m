From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-next:master] [mm] 480c454ff6:
 BUG:kernel_NULL_pointer_dereference
Date: Mon, 13 Mar 2023 19:19:31 -0700
Message-ID: <20230313191931.f84776cb09dc8c4b50673a76@linux-foundation.org>
References: <202303140916.5e8e96b2-yujie.liu@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678760373;
        bh=jQhD/M7Ani+bWf3eE9KwDDKZgpO+n2YjiyMZ49M+DVU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TEy2LQY75YaxuMZ9i9d0txb/bAPwVksXWhiZdQy+Gp0ocrEuwRrFo+5Wh7rqlFeNe
         1LlrirqETNh2b1bMxwBWU+ClRS3UtSm156sFelxG38ph5FucwHNDR7Wyqo4Eq0iphr
         BLQ4sFlz8R2QZTg6FkeByENg0z1522RLRjMbOHgw=
In-Reply-To: <202303140916.5e8e96b2-yujie.liu@intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: kernel test robot <yujie.liu@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, oe-lkp@lists.linux.dev, lkp@intel.com, Linux Memory Management List <linux-mm@kvack.org>, Andreas Gruenbacher <agruenba@redhat.com>, Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>, linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, cgroups@vger.kernel.org

On Tue, 14 Mar 2023 10:10:42 +0800 kernel test robot <yujie.liu@intel.com> wrote:

> Greeting,
> 
> Previous report:
> https://lore.kernel.org/oe-lkp/202303100947.9b421b1c-yujie.liu@intel.com
> 
> FYI, we noticed BUG:kernel_NULL_pointer_dereference,address due to commit (built with gcc-11):
> 
> commit: 480c454ff64b734a35677ee4b239e32143a4235c ("mm: return an ERR_PTR from __filemap_get_folio")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> [test failed on linux-next/master 24469a0e5052ba01a35a15f104717a82b7a4798b]
> 
> in testcase: trinity
> version: trinity-x86_64-e63e4843-1_20220913
> with following parameters:
> 
> 	runtime: 300s
> 	group: group-04
> 
> test-description: Trinity is a linux system call fuzz tester.
> test-url: http://codemonkey.org.uk/projects/trinity/
> 
> on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
> 
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> 
> 
> [   29.300153][ T6430] BUG: kernel NULL pointer dereference, address: 0000000000000000

Thanks, I expect this is fixed by

commit 151dff099e8e6d9c8efcc75ad0ad3b8eead58704
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri Mar 10 08:00:23 2023 +0100

    mm-return-an-err_ptr-from-__filemap_get_folio-fix
    
    fix null-pointer deref
    
    Link: https://lkml.kernel.org/r/20230310070023.GA13563@lst.de
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reported-by: Naoya Horiguchi <naoya.horiguchi@linux.dev>
      Link: https://lkml.kernel.org/r/20230310043137.GA1624890@u2004
    Cc: Andreas Gruenbacher <agruenba@redhat.com>
    Cc: Hugh Dickins <hughd@google.com>
    Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
    Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/mm/swap_state.c b/mm/swap_state.c
index c7160070b9da..b76a65ac28b3 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -390,6 +390,8 @@ struct folio *filemap_get_incore_folio(struct address_space *mapping,
 	struct swap_info_struct *si;
 	struct folio *folio = filemap_get_entry(mapping, index);
 
+	if (!folio)
+		return ERR_PTR(-ENOENT);
 	if (!xa_is_value(folio))
 		return folio;
 	if (!shmem_mapping(mapping))



