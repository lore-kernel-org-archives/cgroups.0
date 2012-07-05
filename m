From: Sha Zhengju <handai.szj@gmail.com>
Subject: Re: [PATCH 4/7] Use vfs __set_page_dirty interface instead of doing
 it inside filesystem
Date: Thu, 5 Jul 2012 23:40:07 +0800
Message-ID: <CAFj3OHUeMv_eQDVT3nOeY8t87VBRwcj7i9xsgO_6v9v7mu33HQ@mail.gmail.com>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com>
	<1340881423-5703-1-git-send-email-handai.szj@taobao.com>
	<Pine.LNX.4.64.1206282218260.18049@cobra.newdream.net>
	<4FF15782.5090807@gmail.com>
	<Pine.LNX.4.64.1207020745180.23342@cobra.newdream.net>
	<4FF3FAC4.1000005@gmail.com>
	<Pine.LNX.4.64.1207050813520.18685@cobra.newdream.net>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=AKDLSKP7ObQBE8wnYUb57j/12/H3yJaOs1g0Xv2xzV4=;
        b=Yp0KGOBtKlIU56CSUmzET5KCmCUKk0S574bBg0EQXEdkaAHbM4I9zkJbY+/AwRaW7T
         nCZNaxL6onbXBmlUPtGuXH/xlcDqh4a+hGti5CjUha5QfsYmNhOCoEDzBdiF2XTjqZ/P
         y96NE/AJnFHmUkfHwjTQlJW0AncIc31lw2U4UwA61hbpzpukodq4hAvaUtYAE0XTMgwm
         NcpW42US7ZCGy27s9xa7jxpBdSEPtcfDhO8JTKpqDK7Gperq/kP0pJ1W/E62BnP2dknH
         C2Wxpc81KgmJTDJmzUro1L5jYZN7ucWu4tpCx7h3GPMJ9dVcBxRTbQ+STx1BxX8YjYWC
         XOsg==
In-Reply-To: <Pine.LNX.4.64.1207050813520.18685@cobra.newdream.net>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sage Weil <sage@inktank.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, yinghan@google.com, akpm@linux-foundation.org, mhocko@suse.cz, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, sage@newdream.net, ceph-devel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>

On Thu, Jul 5, 2012 at 11:20 PM, Sage Weil <sage@inktank.com> wrote:
> On Wed, 4 Jul 2012, Sha Zhengju wrote:
>> On 07/02/2012 10:49 PM, Sage Weil wrote:
>> > On Mon, 2 Jul 2012, Sha Zhengju wrote:
>> > > On 06/29/2012 01:21 PM, Sage Weil wrote:
>> > > > On Thu, 28 Jun 2012, Sha Zhengju wrote:
>> > > >
>> > > > > From: Sha Zhengju<handai.szj@taobao.com>
>> > > > >
>> > > > > Following we will treat SetPageDirty and dirty page accounting as an
>> > > > > integrated
>> > > > > operation. Filesystems had better use vfs interface directly to avoid
>> > > > > those details.
>> > > > >
>> > > > > Signed-off-by: Sha Zhengju<handai.szj@taobao.com>
>> > > > > ---
>> > > > >    fs/buffer.c                 |    2 +-
>> > > > >    fs/ceph/addr.c              |   20 ++------------------
>> > > > >    include/linux/buffer_head.h |    2 ++
>> > > > >    3 files changed, 5 insertions(+), 19 deletions(-)
>> > > > >
>> > > > > diff --git a/fs/buffer.c b/fs/buffer.c
>> > > > > index e8d96b8..55522dd 100644
>> > > > > --- a/fs/buffer.c
>> > > > > +++ b/fs/buffer.c
>> > > > > @@ -610,7 +610,7 @@ EXPORT_SYMBOL(mark_buffer_dirty_inode);
>> > > > >     * If warn is true, then emit a warning if the page is not uptodate
>> > > > > and
>> > > > > has
>> > > > >     * not been truncated.
>> > > > >     */
>> > > > > -static int __set_page_dirty(struct page *page,
>> > > > > +int __set_page_dirty(struct page *page,
>> > > > >               struct address_space *mapping, int warn)
>> > > > >    {
>> > > > >       if (unlikely(!mapping))
>> > > > This also needs an EXPORT_SYMBOL(__set_page_dirty) to allow ceph to
>> > > > continue to build as a module.
>> > > >
>> > > > With that fixed, the ceph bits are a welcome cleanup!
>> > > >
>> > > > Acked-by: Sage Weil<sage@inktank.com>
>> > > Further, I check the path again and may it be reworked as follows to avoid
>> > > undo?
>> > >
>> > > __set_page_dirty();
>> > > __set_page_dirty();
>> > > ceph operations;                ==>                     if (page->mapping)
>> > > if (page->mapping)                                            ceph
>> > > operations;
>> > >      ;
>> > > else
>> > >      undo = 1;
>> > > if (undo)
>> > >      xxx;
>> > Yep.  Taking another look at the original code, though, I'm worried that
>> > one reason the __set_page_dirty() actions were spread out the way they are
>> > is because we wanted to ensure that the ceph operations were always
>> > performed when PagePrivate was set.
>> >
>>
>> Sorry, I've lost something:
>>
>> __set_page_dirty();                        __set_page_dirty();
>> ceph operations;
>> if(page->mapping)         ==>      if(page->mapping) {
>>        SetPagePrivate;                            SetPagePrivate;
>> else                                                      ceph operations;
>>     undo = 1;                                  }
>>
>> if (undo)
>>     XXX;
>>
>> I think this can ensure that ceph operations are performed together with
>> SetPagePrivate.
>
> Yeah, that looks right, as long as the ceph accounting operations happen
> before SetPagePrivate.  I think it's no more or less racy than before, at
> least.
>
> The patch doesn't apply without the previous ones in the series, it looks
> like.  Do you want to prepare a new version or should I?
>

Good. I'm doing some test then I'll send out a new version patchset, please
wait a bit. : )


Thanks,
Sha

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
