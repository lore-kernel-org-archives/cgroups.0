From: Sage Weil <sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH V5 2/8] fs/ceph: vfs __set_page_dirty_nobuffers interface
 instead of doing it inside filesystem
Date: Fri, 2 Aug 2013 13:30:22 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1308021326080.1128@cobra.newdream.net>
References: <1375357402-9811-1-git-send-email-handai.szj@taobao.com> <1375357892-10188-1-git-send-email-handai.szj@taobao.com> <CAAM7YAmxmmA6g2WPVtGN1-42rtDBYzLhF-gvNXxcBN6dUveBYQ@mail.gmail.com> <alpine.DEB.2.00.1308011121080.22584@cobra.newdream.net>
 <CAFj3OHVXvtr5BDMrGatHZi7M9y+dh1ZKRMQZGjZmNBcg3pNQtw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFj3OHVXvtr5BDMrGatHZi7M9y+dh1ZKRMQZGjZmNBcg3pNQtw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Yan, Zheng" <ukernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ceph-devel <ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Fri, 2 Aug 2013, Sha Zhengju wrote:
> On Fri, Aug 2, 2013 at 2:27 AM, Sage Weil <sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org> wrote:
> > On Thu, 1 Aug 2013, Yan, Zheng wrote:
> >> On Thu, Aug 1, 2013 at 7:51 PM, Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> > From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> >> >
> >> > Following we will begin to add memcg dirty page accounting around
> >> __set_page_dirty_
> >> > {buffers,nobuffers} in vfs layer, so we'd better use vfs interface to
> >> avoid exporting
> >> > those details to filesystems.
> >> >
> >> > Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> >> > ---
> >> >  fs/ceph/addr.c |   13 +------------
> >> >  1 file changed, 1 insertion(+), 12 deletions(-)
> >> >
> >> > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> >> > index 3e68ac1..1445bf1 100644
> >> > --- a/fs/ceph/addr.c
> >> > +++ b/fs/ceph/addr.c
> >> > @@ -76,7 +76,7 @@ static int ceph_set_page_dirty(struct page *page)
> >> >         if (unlikely(!mapping))
> >> >                 return !TestSetPageDirty(page);
> >> >
> >> > -       if (TestSetPageDirty(page)) {
> >> > +       if (!__set_page_dirty_nobuffers(page)) {
> >> it's too early to set the radix tree tag here. We should set page's snapshot
> >> context and increase the i_wrbuffer_ref first. This is because once the tag
> >> is set, writeback thread can find and start flushing the page.
> >
> > Unfortunately I only remember being frustrated by this code.  :)  Looking
> > at it now, though, it seems like the minimum fix is to set the
> > page->private before marking the page dirty.  I don't know the locking
> > rules around that, though.  If that is potentially racy, maybe the safest
> > thing would be if __set_page_dirty_nobuffers() took a void* to set
> > page->private to atomically while holding the tree_lock.
> >
> 
> Sorry, I don't catch the point of your last sentence... Could you
> please explain it again?

It didn't make much sense.  :)  I was worried about multiple callers to 
set_page_dirty, but as understand it, this all happens under page->lock, 
right?  (There is a mention of other special cases in mm/page-writeback.c, 
but I'm hoping we don't need to worry about that.)

In any case, I suspect what we actually want is something like the below 
(untested) patch.  The snapc accounting can be ignored here because 
invalidatepage will clean it up...

sage



diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index afb2fc2..7602e46 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -76,9 +76,10 @@ static int ceph_set_page_dirty(struct page *page)
 	if (unlikely(!mapping))
 		return !TestSetPageDirty(page);
 
-	if (TestSetPageDirty(page)) {
+	if (PageDirty(page)) {
 		dout("%p set_page_dirty %p idx %lu -- already dirty\n",
 		     mapping->host, page, page->index);
+		BUG_ON(!PagePrivate(page));
 		return 0;
 	}
 
@@ -107,35 +108,16 @@ static int ceph_set_page_dirty(struct page *page)
 	     snapc, snapc->seq, snapc->num_snaps);
 	spin_unlock(&ci->i_ceph_lock);
 
-	/* now adjust page */
-	spin_lock_irq(&mapping->tree_lock);
-	if (page->mapping) {	/* Race with truncate? */
-		WARN_ON_ONCE(!PageUptodate(page));
-		account_page_dirtied(page, page->mapping);
-		radix_tree_tag_set(&mapping->page_tree,
-				page_index(page), PAGECACHE_TAG_DIRTY);
-
-		/*
-		 * Reference snap context in page->private.  Also set
-		 * PagePrivate so that we get invalidatepage callback.
-		 */
-		page->private = (unsigned long)snapc;
-		SetPagePrivate(page);
-	} else {
-		dout("ANON set_page_dirty %p (raced truncate?)\n", page);
-		undo = 1;
-	}
-
-	spin_unlock_irq(&mapping->tree_lock);
-
-	if (undo)
-		/* whoops, we failed to dirty the page */
-		ceph_put_wrbuffer_cap_refs(ci, 1, snapc);
-
-	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
+	/*
+	 * Reference snap context in page->private.  Also set
+	 * PagePrivate so that we get invalidatepage callback.
+	 */
+	BUG_ON(PagePrivate(page));
+	page->private = (unsigned long)snapc;
+	SetPagePrivate(page);
 
-	BUG_ON(!PageDirty(page));
-	return 1;
+	return __set_page_dirty_nobuffers(page);
 }
 
 /*
