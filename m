From: Sha Zhengju <handai.szj@gmail.com>
Subject: Re: [PATCH V5 2/8] fs/ceph: vfs __set_page_dirty_nobuffers interface
 instead of doing it inside filesystem
Date: Fri, 2 Aug 2013 18:04:17 +0800
Message-ID: <CAFj3OHVXvtr5BDMrGatHZi7M9y+dh1ZKRMQZGjZmNBcg3pNQtw@mail.gmail.com>
References: <1375357402-9811-1-git-send-email-handai.szj@taobao.com>
	<1375357892-10188-1-git-send-email-handai.szj@taobao.com>
	<CAAM7YAmxmmA6g2WPVtGN1-42rtDBYzLhF-gvNXxcBN6dUveBYQ@mail.gmail.com>
	<alpine.DEB.2.00.1308011121080.22584@cobra.newdream.net>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=YFdKRhn+vq2vjeJ7s0atd4lQAJ9ZRMqIU548DBIWGRM=;
        b=BnSxonD1cdTWenqozGFezIMZJLwVONhuAh+gKI8hQgaAuaS0Tglm53ksN4BwskqOyd
         iPrbAnTF+u9NB0mMjtukg7ldL2FUGQw3aq4WkTLhHg7FPewNhm9hiDsnHXEStrXLdzyE
         Y1vlD7667alXoyBmwmdraufxgGh3VlEV999xE5gaNjD+duD1QxnLdIBmB4zI0Z1c3vzD
         e/+Yn+rDnAGoC3PvxYDQZ7TaC0SDSsBgtXTZzdsRGf+Qd1a/78c3Larv4kMVJ5C/t+0U
         mtN8ZSqe2AqOuC7mB1UraJtnXYPmvvMbHy15IKQWGLYGVJ2+zwlvX15rCbjA2wh6mxME
         2lYA==
In-Reply-To: <alpine.DEB.2.00.1308011121080.22584@cobra.newdream.net>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sage Weil <sage@inktank.com>
Cc: "Yan, Zheng" <ukernel@gmail.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, ceph-devel <ceph-devel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Glauber Costa <glommer@gmail.com>, Greg Thelen <gthelen@google.com>, Wu Fengguang <fengguang.wu@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Sha Zhengju <handai.szj@taobao.com>

On Fri, Aug 2, 2013 at 2:27 AM, Sage Weil <sage@inktank.com> wrote:
> On Thu, 1 Aug 2013, Yan, Zheng wrote:
>> On Thu, Aug 1, 2013 at 7:51 PM, Sha Zhengju <handai.szj@gmail.com> wrote:
>> > From: Sha Zhengju <handai.szj@taobao.com>
>> >
>> > Following we will begin to add memcg dirty page accounting around
>> __set_page_dirty_
>> > {buffers,nobuffers} in vfs layer, so we'd better use vfs interface to
>> avoid exporting
>> > those details to filesystems.
>> >
>> > Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
>> > ---
>> >  fs/ceph/addr.c |   13 +------------
>> >  1 file changed, 1 insertion(+), 12 deletions(-)
>> >
>> > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> > index 3e68ac1..1445bf1 100644
>> > --- a/fs/ceph/addr.c
>> > +++ b/fs/ceph/addr.c
>> > @@ -76,7 +76,7 @@ static int ceph_set_page_dirty(struct page *page)
>> >         if (unlikely(!mapping))
>> >                 return !TestSetPageDirty(page);
>> >
>> > -       if (TestSetPageDirty(page)) {
>> > +       if (!__set_page_dirty_nobuffers(page)) {
>> it's too early to set the radix tree tag here. We should set page's snapshot
>> context and increase the i_wrbuffer_ref first. This is because once the tag
>> is set, writeback thread can find and start flushing the page.
>
> Unfortunately I only remember being frustrated by this code.  :)  Looking
> at it now, though, it seems like the minimum fix is to set the
> page->private before marking the page dirty.  I don't know the locking
> rules around that, though.  If that is potentially racy, maybe the safest
> thing would be if __set_page_dirty_nobuffers() took a void* to set
> page->private to atomically while holding the tree_lock.
>

Sorry, I don't catch the point of your last sentence... Could you
please explain it again?

I notice there is a check in __set_page_dirty_nobuffers():
      WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
So does it mean we can only set page->private after it? but if so the
__mark_inode_dirty is still ahead of setting snapc.


Thanks,
Sha

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
