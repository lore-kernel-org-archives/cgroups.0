From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH block/for-4.5-fixes] writeback: keep superblock pinned
 during cgroup writeback association switches
Date: Wed, 17 Feb 2016 16:07:44 -0500
Message-ID: <20160217210744.GA6479@mtj.duckdns.org>
References: <CAAeU0aNCq7LGODvVGRU-oU_o-6enii5ey0p1c26D1ZzYwkDc5A@mail.gmail.com>
 <20160215210047.GN3965@htj.duckdns.org>
 <CAAeU0aNAd1Ra6LXmWwq8row4MD_BpVHiSXOwHx07m86UWREvHw@mail.gmail.com>
 <20160216182457.GO3741@mtj.duckdns.org>
 <20160217205721.GE14140@quack.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=+tCryyjpgQYgOmaZBpVxadCE3KLyqtuYSQSbgy1JHhU=;
        b=1E5+3LSQ/L2OHhCIvAQyYwYbNYYNOTsqOm/hlXdn5iO86cltEjTTqCn2tWUa1Xw3kP
         JDUfCc5y4rZ/3FHUKxPc8dhSp3UDctK8pWsKo3594qK7rDcl+ceBN3PvP8zPOAqR/Nrh
         38tS/zsfwjSTcd8LvcsqDkLVz73EKMOh4Gb0PX6fERU8NH9vjZ0hpRDfd++KkmI8B//4
         6kYsigoqsH5IlmK5eTdfwEsdivgRY3ZDQYVJgD96zepoC5ds9T/9mBiqtazabgQVjpgT
         A9L+61+r3lWAVUigQXeDeK3k/SFNsfQwSnOqtl+CKlT2OmFz8xwoF65u/QTpeIym+D3p
         AhgQ==
Content-Disposition: inline
In-Reply-To: <20160217205721.GE14140-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Nauman Rafique <nauman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>

Hello, Jan.

On Wed, Feb 17, 2016 at 09:57:21PM +0100, Jan Kara wrote:
> Well, but this has the side-effect that trying to umount a filesystem while
> migrations are happening will result in EBUSY error. Without obvious reason
> why that happens. As an admin I would be rather upset when umount sometimes
> returns EBUSY without apparent reason and you have to basically implement a
> loop around umount to make it reliable. So a nack from me for this patch.

I see.  Can you please point me to the s_active check during umount?
I first tried s_umount but couldn't transfer its ownership to the
worker so ended up doing s_active.  I looked at how s_active is used
and couldn't find where it'd block umount.  may_umount() checks
mnt_count, not s_active, so it looked like holding s_active may delay
destruction of the superblock but not prevent umount.

> Traditionally, we have used sb->s_count and sb->s_umount semaphore to pin
> superblock while writeback code was working on it. That makes umount block
> until we can safely unmount the filesystem and thus doesn't result in these
> spurious EBUSY errors. But from a quick look this can be problematic for the
> cgroup setting.
> 
> Alternatively, you could either cancel all the switching work when
> unmounting filesystem or maybe just handle I_WB_SWITCH similarly to I_SYNC
> - don't grab inode reference when switching is going on, just make
> I_WB_SWITCH pin the inode and wait in evict() for it to be clear (similarly
> as we call inode_wait_for_writeback() there).

Yeah, this is an alternative but likely more involved.

Thanks.

-- 
tejun
