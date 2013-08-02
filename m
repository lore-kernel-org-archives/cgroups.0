From: Sha Zhengju <handai.szj@gmail.com>
Subject: Re: [PATCH V5 2/8] fs/ceph: vfs __set_page_dirty_nobuffers interface
 instead of doing it inside filesystem
Date: Fri, 2 Aug 2013 17:04:33 +0800
Message-ID: <CAFj3OHXR=PqHwLcXCub8YezcGFF7kbKX3X2dV=6FQM78K__D8g@mail.gmail.com>
References: <1375357402-9811-1-git-send-email-handai.szj@taobao.com>
	<1375357892-10188-1-git-send-email-handai.szj@taobao.com>
	<CAAM7YAmxmmA6g2WPVtGN1-42rtDBYzLhF-gvNXxcBN6dUveBYQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <ceph-devel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=OATLO2d1Hs4WF9jLeuM8ELPuLR0BzeCuA5DZ8+gvGqE=;
        b=Tk/X2GaZuhBOfuK3T2JqkErpiCBoB1eA7iMv7z5fgMXFDvq59iWb4wpAsM/pPZIi2c
         jDmUPp1DGAD/uxgOJfq25VpoY5ES3ZKeqqM31a4AJeW1nnHqEgDyzSMxhbHulJIyPqj6
         CzuqSt8T/A/CUIOP9xQHs0qA/GYiILjl93xmABAnntJvIjVZhXsbZ3tL+EDNAFWISDlP
         9Y3fKU+4EdKEIr+J0uVWHS8kH2h0MIIh6NkfjC1BXViyi79az6a7OMDCIcn6O+rgWqxk
         C2cjrefEJRWrFjU+YjQYnNLBZa5uIdhXBNLfy6/+TT+GJYCAQgFPuTzBooO15Api75TM
         nm8w==
In-Reply-To: <CAAM7YAmxmmA6g2WPVtGN1-42rtDBYzLhF-gvNXxcBN6dUveBYQ@mail.gmail.com>
Sender: ceph-devel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Yan, Zheng" <ukernel@gmail.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, ceph-devel <ceph-devel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, Sage Weil <sage@inktank.com>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Glauber Costa <glommer@gmail.com>, Greg Thelen <gthelen@google.com>, Wu Fengguang <fengguang.wu@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Sha Zhengju <handai.szj@taobao.com>

On Thu, Aug 1, 2013 at 11:19 PM, Yan, Zheng <ukernel@gmail.com> wrote:
> On Thu, Aug 1, 2013 at 7:51 PM, Sha Zhengju <handai.szj@gmail.com> wrote:
>> From: Sha Zhengju <handai.szj@taobao.com>
>>
>> Following we will begin to add memcg dirty page accounting around
>> __set_page_dirty_
>> {buffers,nobuffers} in vfs layer, so we'd better use vfs interface to
>> avoid exporting
>> those details to filesystems.
>>
>> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
>> ---
>>  fs/ceph/addr.c |   13 +------------
>>  1 file changed, 1 insertion(+), 12 deletions(-)
>>
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index 3e68ac1..1445bf1 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -76,7 +76,7 @@ static int ceph_set_page_dirty(struct page *page)
>>         if (unlikely(!mapping))
>>                 return !TestSetPageDirty(page);
>>
>> -       if (TestSetPageDirty(page)) {
>> +       if (!__set_page_dirty_nobuffers(page)) {
>
> it's too early to set the radix tree tag here. We should set page's snapshot
> context and increase the i_wrbuffer_ref first. This is because once the tag
> is set, writeback thread can find and start flushing the page.

OK, thanks for pointing it out.

>
>
>>                 dout("%p set_page_dirty %p idx %lu -- already dirty\n",
>>                      mapping->host, page, page->index);
>>                 return 0;
>> @@ -107,14 +107,7 @@ static int ceph_set_page_dirty(struct page *page)
>>              snapc, snapc->seq, snapc->num_snaps);
>>         spin_unlock(&ci->i_ceph_lock);
>>
>> -       /* now adjust page */
>> -       spin_lock_irq(&mapping->tree_lock);
>>         if (page->mapping) {    /* Race with truncate? */
>> -               WARN_ON_ONCE(!PageUptodate(page));
>> -               account_page_dirtied(page, page->mapping);
>> -               radix_tree_tag_set(&mapping->page_tree,
>> -                               page_index(page), PAGECACHE_TAG_DIRTY);
>> -
>
> this code was coped from __set_page_dirty_nobuffers(). I think the reason
> Sage did this is to handle the race described in
> __set_page_dirty_nobuffers()'s comment. But I'm wonder if "page->mapping ==
> NULL" can still happen here. Because truncate_inode_page() unmap page from
> processes's address spaces first, then delete page from page cache.

But in non-mmap case, doesn't it has no relation to 'unmap page from
address spaces'?
The check is exactly avoiding racy with delete_from_page_cache(),
since the two both need to hold mapping->tree_lock, and if truncate
goes first then __set_page_dirty_nobuffers() may have NULL mapping.


Thanks,
Sha
