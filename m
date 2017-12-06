From: xuejiufei <xuejiufei-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [bug report] writeback: sync returns with dirty pages exist
Date: Wed, 6 Dec 2017 09:37:03 +0800
Message-ID: <8844b550-d91c-38d5-997a-a899d1e4aa42@gmail.com>
References: <dc694ae2-f07f-61e1-7097-7c8411cee12d@gmail.com>
 <20171205182007.GV2421075@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hyQ3QN9cenIjPtmOwQjEGyHIIFUSUSYZT4y34pHJgwY=;
        b=LIfdPx8OijOtUlx7npSkXUkkjNRVpdkjrmjrMAd54CiRcRllJP9ia/8DRKq2m/rEQk
         j6hPd6N6udc2QBGAI3hM23QEl1z1LJZkUTAtD7sujXEsFft3/wzij3T0xav2jn+VaiFe
         /LsWpTyrDEwsjSNRD0wx7wUJ/gIMXhW1SW8oap7fr+i7C8oYnaSZdYbuHv3lSiXUSvQi
         zxL2qs4W8whd6r8NQV+PmA5qFiuQczHI0NY4299+sqH5Rk92uhp14F9W3mNm42Gd1cNJ
         9FFub8MrFSsm6Gg8CBJL736oxaGCGc8KeDvpTavLjeKbCxe6LaUEyvM/6SMIwJJolIvV
         OMmw==
In-Reply-To: <20171205182007.GV2421075-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Tejun,

On 2017/12/6 上午2:20, Tejun Heo wrote:
> Hello, Xuejiufei.
> 
> On Mon, Dec 04, 2017 at 03:13:34PM +0800, xuejiufei wrote:
>> I have found that system call sync may return even if dirty pages still
>> exist. This is caused by the following case:
>>
>> sync
>> -> sync_inodes_sb()
>>   -> bdi_split_work_to_wbs() queue works for each wb
>>   -> wb_wait_for_completions() wait for these works to complete.
>>
>>>>>>>> race window. Writeback thread found it should switch to another
>> new wb while doing foreign cgroup detect. So a new wb is created, and
>> the inodes are move from old wb to the new one. The writeback work for
>> old wb is done, so the sync process is woken while the inodes with dirty
>> pages are still queued in new wb.
> 
> So, wb_wait_for_completion() may end up returning earlier than
> expected but data integrity is waited by wait_sb_inodes() which isn't
> affected by inode cgroup wb migrations.  Have you actually seen this
> happening?
> 
Yes， I have seen it actually happening. I think wait_sb_inodes() only
wait for pages tagged with PAGECACHE_TAG_WRITEBACK, that means it wait the
pages written before. The pages are not written are still tagged with
PAGECACHE_TAG_DIRTY and wait_sb_inodes() will not wait for them.

Thanks 
> Thanks.
> 
