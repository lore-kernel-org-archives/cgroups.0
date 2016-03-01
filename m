From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 block/for-linus] writeback: flush inode cgroup wb
 switches instead of pinning super_block
Date: Tue, 1 Mar 2016 10:46:58 -0700
Message-ID: <56D5D592.2020800@kernel.dk>
References: <CAAeU0aNCq7LGODvVGRU-oU_o-6enii5ey0p1c26D1ZzYwkDc5A@mail.gmail.com>
 <20160215210047.GN3965@htj.duckdns.org>
 <CAAeU0aNAd1Ra6LXmWwq8row4MD_BpVHiSXOwHx07m86UWREvHw@mail.gmail.com>
 <20160216182457.GO3741@mtj.duckdns.org>
 <20160217205721.GE14140@quack.suse.cz>
 <20160217210744.GA6479@mtj.duckdns.org>
 <20160217223009.GN14140@quack.suse.cz>
 <CAAeU0aOvSwPbLPU0=20D1RExNj8VsbB38hUnyso2L8xNSQC0XA@mail.gmail.com>
 <20160217230231.GC6479@mtj.duckdns.org>
 <20160229204724.GV3965@htj.duckdns.org>
 <20160229232853.GD3965@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=JHtGBpeERRKprRrV0/ajwarCu9aQL95IdWxSg7ERntk=;
        b=ko5+3ggqi5vDpuqopxC7q68lh8ST87SS2BtyUEH36+PN4hKWE4qE/cJNNJrRsHgN1h
         nSWW+0/WqKBv4Z43DZMDG5oYS9PJwcQWYX6cRSazhOzgLuLCJacRcOT5JS5Le7V9yeuF
         TNUyRoGU/12R8BTYvk2+o469FsgVtDnM8gl5AQoOTaW7tWgP7OjUNKr30D3j1z/0p12z
         NA2Ubj8NPh34oTP6DcD1HA4meW7zBbx6Y757zHsVcLMEEdcuVMEuHtI8t2SCVCu0V9rF
         EE7PcjyYw4++qF6RwlNkDwTYhjR9B2EcQD4r4jLM/Rv3Q8nZqz8K4cx4r4GVrVPTMA2m
         YRPw==
In-Reply-To: <20160229232853.GD3965@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Tahsin Erdogan <tahsin@google.com>
Cc: Jan Kara <jack@suse.cz>, cgroups@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Nauman Rafique <nauman@google.com>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, Al Viro <viro@ZenIV.linux.org.uk>

On 02/29/2016 04:28 PM, Tejun Heo wrote:
> If cgroup writeback is in use, inodes can be scheduled for
> asynchronous wb switching.  Before 5ff8eaac1636 ("writeback: keep
> superblock pinned during cgroup writeback association switches"), this
> could race with umount leading to super_block being destroyed while
> inodes are pinned for wb switching.  5ff8eaac1636 fixed it by bumping
> s_active while wb switches are in flight; however, this allowed
> in-flight wb switches to make umounts asynchronous when the userland
> expected synchronosity - e.g. fsck immediately following umount may
> fail because the device is still busy.
>
> This patch removes the problematic super_block pinning and instead
> makes generic_shutdown_super() flush in-flight wb switches.  wb
> switches are now executed on a dedicated isw_wq so that they can be
> flushed and isw_nr_in_flight keeps track of the number of in-flight wb
> switches so that flushing can be avoided in most cases.
>
> v2: Move cgroup_writeback_umount() further below and add MS_ACTIVE
>      check in inode_switch_wbs() as Jan an Al suggested.

I queued this up for 4.5, but I'm feeling a bit uneasy about it. But 
it's either that, or revert 5ff8eaac1636 and fix it for real in 4.6. 
Jan/Tejun, what do you think?

-- 
Jens Axboe

