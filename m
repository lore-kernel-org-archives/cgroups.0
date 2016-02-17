From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH block/for-4.5-fixes] writeback: keep superblock pinned
 during cgroup writeback association switches
Date: Wed, 17 Feb 2016 14:41:25 -0800
Message-ID: <CAAeU0aOvSwPbLPU0=20D1RExNj8VsbB38hUnyso2L8xNSQC0XA@mail.gmail.com>
References: <CAAeU0aNCq7LGODvVGRU-oU_o-6enii5ey0p1c26D1ZzYwkDc5A@mail.gmail.com>
	<20160215210047.GN3965@htj.duckdns.org>
	<CAAeU0aNAd1Ra6LXmWwq8row4MD_BpVHiSXOwHx07m86UWREvHw@mail.gmail.com>
	<20160216182457.GO3741@mtj.duckdns.org>
	<20160217205721.GE14140@quack.suse.cz>
	<20160217210744.GA6479@mtj.duckdns.org>
	<20160217223009.GN14140@quack.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=Jy5Hi1hTzM5rWiVr5nYCIX/CC7gQlTIkQb+1TbneZTQ=;
        b=dSHM3SEHMYlZNINx86ua8j+A8aaiT4hg2pWlGCM0Y0Z06m6Z7PVJdp1+IC1WinjQ13
         YLMjzujEUTp9epAwZrPOAk8weD0w+bkoK/B13C5J26X6S4onmx8aS9XX+07g/ItE+8q2
         ugRmFLhQr4WeLMK5wnzNDuzGpvt0KVLAwv69pUGsAtKcvyiqyxsXbEOCW4zgPXQNwvSO
         IFG3xinJ/qu+cYYABwPBB4kQ47rZ6Fka+chB1jcEq4awH96G8AnP3xjw3ZRmGRifWZlk
         8dyEm7010ryxFiLT50tuiWG0PBYZztRdkD2Z8wsLtPqCIii9I4lLJVCUCk0A+k2tOMHu
         rU3w==
In-Reply-To: <20160217223009.GN14140@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Nauman Rafique <nauman@google.com>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>

With this patch, I am starting to have issues running fsck immediately
after umount.

*** fsck.ext4 output ***
fsck from util-linux-ng 2.17.2
e2fsck 1.42.12-gg3 (9-Sep-2014)
Warning!  /dev/sdb3 is in use.
Pass 1: Checking inodes, blocks, and sizes
Deleted inode 62346243 has zero dtime.  Fix? no


On Wed, Feb 17, 2016 at 2:30 PM, Jan Kara <jack@suse.cz> wrote:
> On Wed 17-02-16 16:07:44, Tejun Heo wrote:
>> Hello, Jan.
>>
>> On Wed, Feb 17, 2016 at 09:57:21PM +0100, Jan Kara wrote:
>> > Well, but this has the side-effect that trying to umount a filesystem while
>> > migrations are happening will result in EBUSY error. Without obvious reason
>> > why that happens. As an admin I would be rather upset when umount sometimes
>> > returns EBUSY without apparent reason and you have to basically implement a
>> > loop around umount to make it reliable. So a nack from me for this patch.
>>
>> I see.  Can you please point me to the s_active check during umount?
>> I first tried s_umount but couldn't transfer its ownership to the
>> worker so ended up doing s_active.  I looked at how s_active is used
>> and couldn't find where it'd block umount.  may_umount() checks
>> mnt_count, not s_active, so it looked like holding s_active may delay
>> destruction of the superblock but not prevent umount.
>
> Bah, sorry. It's too late here. You are right that s_active will just delay
> destruction of the superblock until the reference is dropped. So I don't
> see obvious issues with what you do and I retract my nack. I still feel
> somewhat uneasy about postponing fs shutdown to a workqueue like this but
> hopefully there's no hidden catch.
>
>                                                                 Honza
>
>
>> > Traditionally, we have used sb->s_count and sb->s_umount semaphore to pin
>> > superblock while writeback code was working on it. That makes umount block
>> > until we can safely unmount the filesystem and thus doesn't result in these
>> > spurious EBUSY errors. But from a quick look this can be problematic for the
>> > cgroup setting.
>> >
>> > Alternatively, you could either cancel all the switching work when
>> > unmounting filesystem or maybe just handle I_WB_SWITCH similarly to I_SYNC
>> > - don't grab inode reference when switching is going on, just make
>> > I_WB_SWITCH pin the inode and wait in evict() for it to be clear (similarly
>> > as we call inode_wait_for_writeback() there).
>>
>> Yeah, this is an alternative but likely more involved.
>>
>> Thanks.
>>
>> --
>> tejun
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
