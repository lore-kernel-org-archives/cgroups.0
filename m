From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH block/for-4.5-fixes] writeback: keep superblock pinned
 during cgroup writeback association switches
Date: Tue, 16 Feb 2016 11:34:33 -0700
Message-ID: <56C36BB9.5000104@kernel.dk>
References: <CAAeU0aNCq7LGODvVGRU-oU_o-6enii5ey0p1c26D1ZzYwkDc5A@mail.gmail.com>
 <20160215210047.GN3965@htj.duckdns.org>
 <CAAeU0aNAd1Ra6LXmWwq8row4MD_BpVHiSXOwHx07m86UWREvHw@mail.gmail.com>
 <20160216182457.GO3741@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-type:content-transfer-encoding;
        bh=LG2G0AwMOS3ql6il0LBQNrNV5c854sx39VsQQsPT23E=;
        b=Q5atjd+2ew+KrkCY331Ten1C6AONeL23KXDCicjdt23Xc1Y/3XruChefJ7pYcDk91X
         aAest6rMedpFdgWq/6+JwkL3/bUdJJOQmO39fHxpUK+7shDMJo7ZR4Cf6rlQh5N1hUwk
         beBAF3r6Ldx053IPPMcqRitGCq+kyOTJGzHIlbkLrkq6G2Z4+wbWyeShM58EL8LljiHt
         mplbi0A6NtUmeWNb/srTdxHiA+bNUFJjo2zBY15KHiBVdY97ToiU8emngLigdRjvE1TR
         MrQ0WFxn7Wb8AfN/r3/HFsDjqGC4v/Uirx7W8ZvTu45sGZabLsa0dwFqWYxFRwhHCL1j
         Zzag==
In-Reply-To: <20160216182457.GO3741-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Nauman Rafique <nauman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>

On 02/16/2016 11:24 AM, Tejun Heo wrote:
>  From 586afaa034bec88934bad4eb6ab38ba07031ec5a Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Tue, 16 Feb 2016 13:14:35 -0500
>
> If cgroup writeback is in use, an inode is associated with a cgroup
> for writeback.  If the inode's main dirtier changes to another cgroup,
> the association gets updated asynchronously.  Nothing was pinning the
> superblock while such switches are in progress and superblock could go
> away while async switching is pending or in progress leading to
> crashes like the following.
>
>   kernel BUG at fs/jbd2/transaction.c:319!
>   invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
>   CPU: 1 PID: 29158 Comm: kworker/1:10 Not tainted 4.5.0-rc3 #51
>   Hardware name: Google Google, BIOS Google 01/01/2011
>   Workqueue: events inode_switch_wbs_work_fn
>   task: ffff880213dbbd40 ti: ffff880209264000 task.ti: ffff880209264000
>   RIP: 0010:[<ffffffff803e6922>]  [<ffffffff803e6922>] start_this_handle+0x382/0x3e0
>   RSP: 0018:ffff880209267c30  EFLAGS: 00010202
>   ...
>   Call Trace:
>    [<ffffffff803e6be4>] jbd2__journal_start+0xf4/0x190
>    [<ffffffff803cfc7e>] __ext4_journal_start_sb+0x4e/0x70
>    [<ffffffff803b31ec>] ext4_evict_inode+0x12c/0x3d0
>    [<ffffffff8035338b>] evict+0xbb/0x190
>    [<ffffffff80354190>] iput+0x130/0x190
>    [<ffffffff80360223>] inode_switch_wbs_work_fn+0x343/0x4c0
>    [<ffffffff80279819>] process_one_work+0x129/0x300
>    [<ffffffff80279b16>] worker_thread+0x126/0x480
>    [<ffffffff8027ed14>] kthread+0xc4/0xe0
>    [<ffffffff809771df>] ret_from_fork+0x3f/0x70
>
> Fix it by bumping s_active while cgroup association switching is in
> flight.

Added for 4.5.

-- 
Jens Axboe
