From: Tejun Heo <tj@kernel.org>
Subject: Re: __blkg_lookup oops with 4.2-rcX
Date: Wed, 2 Sep 2015 10:53:07 -0400
Message-ID: <20150902145307.GG22326@mtj.duckdns.org>
References: <CA+5PVA5rzQ0s4723n5rHBcxQa9t0cW8BPPBekr_9aMRoWt2aYg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=mFZ/yKC7cE88UfTCt4M2i4K4S4wqSdRG3tL4hot+Rls=;
        b=A9xawHST28A6IifbQFRXw5j5OSHF+zycHUWo8R9C7/xiIiYpxOV5rTL/KGHPtClw8W
         ulacgIdrdx3o1JLr9WP8qR1nFMnB2wPN6N3ih6vyBBD1dTJgAv3/UVsYxYbHA0kg6mjh
         JiYYwZs95MrsZn+PlaSaCwc97SOL1DVvWPGVaym5UermhcgkcSkV1zeIbBjAQHeY1qHq
         phAnXyh24q0i2Iwu7PYD35zxdIxHdCIxHvOuFq5m4mhro5oovoE2e1TFb8F1u4oUrJ5G
         1KwiEV0mc745D8c8E49BmM3bvx/azB0P1Rz6kZeT1xCa32nHqSCfNHVF2v2wv2VQabwj
         4HgQ==
Content-Disposition: inline
In-Reply-To: <CA+5PVA5rzQ0s4723n5rHBcxQa9t0cW8BPPBekr_9aMRoWt2aYg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, msnitzer@redhat.com, "Richard W.M. Jones" <rjones@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>

Hello,

On Sun, Aug 30, 2015 at 08:30:41AM -0400, Josh Boyer wrote:
> Mike and Jeff suggested you be informed of the oops one of our
> community members is hitting in Fedora with 4.2-rcX.  I thought they
> had already sent this upstream to you, but apparently they didn't.
> 
> The latest oops is below.  That is with 4.2-rc8.  I believe the first
> report was against a merge window 4.2 kernel.  The full bug report is
> here: https://bugzilla.redhat.com/show_bug.cgi?id=1237136
> 
> I believe Mike and Jeff suspected the cgroup writeback patches.
> 
> josh
> 
> lvm vgchange -a n
>   /run/lvm/lvmetad.socket: connect failed: No such file or directory
>   WARNING: Failed to connect to lvmetad. Falling back to internal scanning.
> [   36.157672] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000558
> [   36.157672] IP: [<ffffffff81389746>] __blkg_lookup+0x26/0x70
...
> [   36.157672]  [<ffffffff8138d14a>] blk_throtl_drain+0x5a/0x110
> [   36.157672]  [<ffffffff8138a108>] blkcg_drain_queue+0x18/0x20
> [   36.157672]  [<ffffffff81369a70>] __blk_drain_queue+0xc0/0x170
> [   36.157672]  [<ffffffff8136a101>] blk_queue_bypass_start+0x61/0x80
> [   36.157672]  [<ffffffff81388c59>] blkcg_deactivate_policy+0x39/0x100
> [   36.157672]  [<ffffffff8138d328>] blk_throtl_exit+0x38/0x50
> [   36.157672]  [<ffffffff8138a14e>] blkcg_exit_queue+0x3e/0x50
> [   36.157672]  [<ffffffff8137016e>] blk_release_queue+0x1e/0xc0
> [   36.157672]  [<ffffffff8139bcba>] kobject_release+0x7a/0x190
> [   36.157672]  [<ffffffff8139bb6f>] kobject_put+0x2f/0x60
> [   36.157672]  [<ffffffff8136a2b1>] blk_cleanup_queue+0x111/0x140
> [   36.157672]  [<ffffffff815f13fc>] cleanup_mapped_device+0xdc/0x100
> [   36.157672]  [<ffffffff815f2311>] __dm_destroy+0x161/0x260
> [   36.157672]  [<ffffffff815f45d3>] dm_destroy+0x13/0x20
> [   36.157672]  [<ffffffff815f9ebd>] dev_remove+0x10d/0x170
> [   36.157672]  [<ffffffff815fa572>] ctl_ioctl+0x232/0x4d0
> [   36.157672]  [<ffffffff815fa823>] dm_ctl_ioctl+0x13/0x20
> [   36.157672]  [<ffffffff8122ebd5>] do_vfs_ioctl+0x295/0x470
> [   36.157672]  [<ffffffff8122ee29>] SyS_ioctl+0x79/0x90
> [   36.157672]  [<ffffffff817750ae>] entry_SYSCALL_64_fastpath+0x12/0x71

I think the offending commit is 776687bce42b ("block, blk-mq: draining
can't be skipped even if bypass_depth was non-zero").  It looks like
the patch makes shutdown path travel data structure which is already
destroyed.  Will post the fix soon.

Thanks.

-- 
tejun
