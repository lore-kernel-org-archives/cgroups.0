From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V3 2/8] Make TestSetPageDirty and dirty page accounting in
 one func
Date: Sat, 5 Jan 2013 10:49:00 +0800
Message-ID: <CAFj3OHUCQkqB2+ky9wxFpkNYcn2=6t9Qd7XFf3RBY0F4Wxyqcg@mail.gmail.com>
References: <1356455919-14445-1-git-send-email-handai.szj@taobao.com>
	<1356456156-14535-1-git-send-email-handai.szj@taobao.com>
	<20130102090803.GB22160@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=m1FySzd1DYfEabyvIS0Wg/slS/EQKmVp+shlVRPCmMc=;
        b=QUrU7vxUYc06Huug9rrjMxerRPU8lH3suKrLuzSp80FQ86F0Ugj9eAF4vWWBWSoLaG
         EG3QE1hxxgFy9aPDlpslJPUMotqGgTHoVWY7fQ9pDQMx8h26tV+dwhgV3L8tR9rnJDPf
         rQsNP7WUdxLx5+iRXSAfYgAeSr61wiKKXTvGp3xVYfVZxN8r7NkgwOltpXmeGhEWrwyY
         hjUc1KwbuGd7n5iVMHBpfrTalgTUfVqa0fMXIRYyjYdxM9gNnASO+IVBjJmThi5cr2vf
         hKexHUtxBXftrVHDcNAxvp8yGMaw7uJKScttj59ffKFabb4djpcmOZ+Saok+FgaRSBud
         dlhg==
In-Reply-To: <20130102090803.GB22160-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Hi Michal,

Sorry for my late response, I'm just back from vocation. : )

On Wed, Jan 2, 2013 at 5:08 PM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> On Wed 26-12-12 01:22:36, Sha Zhengju wrote:
>> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>>
>> Commit a8e7d49a(Fix race in create_empty_buffers() vs __set_page_dirty_buffers())
>> extracts TestSetPageDirty from __set_page_dirty and is far away from
>> account_page_dirtied. But it's better to make the two operations in one single
>> function to keep modular. So in order to avoid the potential race mentioned in
>> commit a8e7d49a, we can hold private_lock until __set_page_dirty completes.
>> There's no deadlock between ->private_lock and ->tree_lock after confirmation.
>
> Could you be more specific here? E.g. quote mm/filemap.c comment I have
> mentioned during the first round of review?
>

Okay, sorry for forgetting the comment. I'll add it next round.

>> It's a prepare patch for following memcg dirty page accounting patches.
>>
>>
>> Here is some test numbers that before/after this patch:
>> Test steps(Mem-4g, ext4):
>> drop_cache; sync
>> fio (ioengine=sync/write/buffered/bs=4k/size=1g/numjobs=2/group_reporting/thread)
>
> Could also add some rationale why you think this test is relevant?
>

The test is aiming at finding the impact of performance due to lock
contention by writing parallel
to the same file. I'll add the reason next version too.

Thanks for reviewing!


Regards,
Sha

>> We test it for 10 times and get the average numbers:
>> Before:
>> write: io=2048.0MB, bw=254117KB/s, iops=63528.9 , runt=  8279msec
>> lat (usec): min=1 , max=742361 , avg=30.918, stdev=1601.02
>> After:
>> write: io=2048.0MB, bw=254044KB/s, iops=63510.3 , runt=  8274.4msec
>> lat (usec): min=1 , max=856333 , avg=31.043, stdev=1769.32
>>
>> Note that the impact is little(<1%).
>>
>>
>> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>> Reviewed-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
>> ---
>>  fs/buffer.c |   24 ++++++++++++------------
>>  1 file changed, 12 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/buffer.c b/fs/buffer.c
>> index c017a2d..3b032b9 100644
>> --- a/fs/buffer.c
>> +++ b/fs/buffer.c
>> @@ -609,9 +609,15 @@ EXPORT_SYMBOL(mark_buffer_dirty_inode);
>>   * If warn is true, then emit a warning if the page is not uptodate and has
>>   * not been truncated.
>>   */
>> -static void __set_page_dirty(struct page *page,
>> +static int __set_page_dirty(struct page *page,
>>               struct address_space *mapping, int warn)
>>  {
>> +     if (unlikely(!mapping))
>> +             return !TestSetPageDirty(page);
>> +
>> +     if (TestSetPageDirty(page))
>> +             return 0;
>> +
>>       spin_lock_irq(&mapping->tree_lock);
>>       if (page->mapping) {    /* Race with truncate? */
>>               WARN_ON_ONCE(warn && !PageUptodate(page));
>> @@ -621,6 +627,8 @@ static void __set_page_dirty(struct page *page,
>>       }
>>       spin_unlock_irq(&mapping->tree_lock);
>>       __mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
>> +
>> +     return 1;
>>  }
>>
>>  /*
>> @@ -666,11 +674,9 @@ int __set_page_dirty_buffers(struct page *page)
>>                       bh = bh->b_this_page;
>>               } while (bh != head);
>>       }
>> -     newly_dirty = !TestSetPageDirty(page);
>> +     newly_dirty = __set_page_dirty(page, mapping, 1);
>>       spin_unlock(&mapping->private_lock);
>>
>> -     if (newly_dirty)
>> -             __set_page_dirty(page, mapping, 1);
>>       return newly_dirty;
>>  }
>>  EXPORT_SYMBOL(__set_page_dirty_buffers);
>> @@ -1125,14 +1131,8 @@ void mark_buffer_dirty(struct buffer_head *bh)
>>                       return;
>>       }
>>
>> -     if (!test_set_buffer_dirty(bh)) {
>> -             struct page *page = bh->b_page;
>> -             if (!TestSetPageDirty(page)) {
>> -                     struct address_space *mapping = page_mapping(page);
>> -                     if (mapping)
>> -                             __set_page_dirty(page, mapping, 0);
>> -             }
>> -     }
>> +     if (!test_set_buffer_dirty(bh))
>> +             __set_page_dirty(bh->b_page, page_mapping(bh->b_page), 0);
>>  }
>>  EXPORT_SYMBOL(mark_buffer_dirty);
>>
>> --
>> 1.7.9.5
>>
>
> --
> Michal Hocko
> SUSE Labs
