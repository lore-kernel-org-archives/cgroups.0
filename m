From: Sage Weil <sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 4/7] Use vfs __set_page_dirty interface instead of doing
 it inside filesystem
Date: Thu, 28 Jun 2012 22:21:48 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1206282218260.18049@cobra.newdream.net>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com>
 <1340881423-5703-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340881423-5703-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Thu, 28 Jun 2012, Sha Zhengju wrote:

> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> 
> Following we will treat SetPageDirty and dirty page accounting as an integrated
> operation. Filesystems had better use vfs interface directly to avoid those details.
> 
> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/buffer.c                 |    2 +-
>  fs/ceph/addr.c              |   20 ++------------------
>  include/linux/buffer_head.h |    2 ++
>  3 files changed, 5 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index e8d96b8..55522dd 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -610,7 +610,7 @@ EXPORT_SYMBOL(mark_buffer_dirty_inode);
>   * If warn is true, then emit a warning if the page is not uptodate and has
>   * not been truncated.
>   */
> -static int __set_page_dirty(struct page *page,
> +int __set_page_dirty(struct page *page,
>  		struct address_space *mapping, int warn)
>  {
>  	if (unlikely(!mapping))

This also needs an EXPORT_SYMBOL(__set_page_dirty) to allow ceph to 
continue to build as a module.

With that fixed, the ceph bits are a welcome cleanup!

Acked-by: Sage Weil <sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org>

> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 8b67304..d028fbe 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -5,6 +5,7 @@
>  #include <linux/mm.h>
>  #include <linux/pagemap.h>
>  #include <linux/writeback.h>	/* generic_writepages */
> +#include <linux/buffer_head.h>
>  #include <linux/slab.h>
>  #include <linux/pagevec.h>
>  #include <linux/task_io_accounting_ops.h>
> @@ -73,14 +74,8 @@ static int ceph_set_page_dirty(struct page *page)
>  	int undo = 0;
>  	struct ceph_snap_context *snapc;
>  
> -	if (unlikely(!mapping))
> -		return !TestSetPageDirty(page);
> -
> -	if (TestSetPageDirty(page)) {
> -		dout("%p set_page_dirty %p idx %lu -- already dirty\n",
> -		     mapping->host, page, page->index);
> +	if (!__set_page_dirty(page, mapping, 1))
>  		return 0;
> -	}
>  
>  	inode = mapping->host;
>  	ci = ceph_inode(inode);
> @@ -107,14 +102,7 @@ static int ceph_set_page_dirty(struct page *page)
>  	     snapc, snapc->seq, snapc->num_snaps);
>  	spin_unlock(&ci->i_ceph_lock);
>  
> -	/* now adjust page */
> -	spin_lock_irq(&mapping->tree_lock);
>  	if (page->mapping) {	/* Race with truncate? */
> -		WARN_ON_ONCE(!PageUptodate(page));
> -		account_page_dirtied(page, page->mapping);
> -		radix_tree_tag_set(&mapping->page_tree,
> -				page_index(page), PAGECACHE_TAG_DIRTY);
> -
>  		/*
>  		 * Reference snap context in page->private.  Also set
>  		 * PagePrivate so that we get invalidatepage callback.
> @@ -126,14 +114,10 @@ static int ceph_set_page_dirty(struct page *page)
>  		undo = 1;
>  	}
>  
> -	spin_unlock_irq(&mapping->tree_lock);
> -
>  	if (undo)
>  		/* whoops, we failed to dirty the page */
>  		ceph_put_wrbuffer_cap_refs(ci, 1, snapc);
>  
> -	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> -
>  	BUG_ON(!PageDirty(page));
>  	return 1;
>  }
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index 458f497..0a331a8 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -336,6 +336,8 @@ static inline void lock_buffer(struct buffer_head *bh)
>  }
>  
>  extern int __set_page_dirty_buffers(struct page *page);
> +extern int __set_page_dirty(struct page *page,
> +		struct address_space *mapping, int warn);
>  
>  #else /* CONFIG_BLOCK */
>  
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
