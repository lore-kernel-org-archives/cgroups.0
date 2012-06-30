From: Masanari Iida <standby24x7@gmail.com>
Subject: Re: [PATCH] cgroup: fix dentry still in use bug when dropping css
 refs after umount
Date: Sat, 30 Jun 2012 23:34:02 +0900
Message-ID: <CALLJCT3xMMi=CCjuE=KmWa9Xo9419zGSyWw-xufxF8_Hhy6_AQ@mail.gmail.com>
References: <4FEEA5CB.8070809@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=weyxOZ+HuP4n9PCGP8Is7ytHXyo1Rdu6loKtaRavSWI=;
        b=wueUFcT8wgMzJFcFScoJ42ErFpiDpgCQRBvsPQk26LVfsGKjBAWSn24S+o0Fq8XFUc
         Y4cPqTgXfsM1CL9m6vLEZ92fqHrKlZzaaLQwsKEjtZBCH09TI+RvrKTvEoI78WWZkNYK
         ffcIPH0HExwxKx1Raly8cHSnbRb0zaIEpWaTgrvDVaVLC61oDADT/SJefHbss28NMXi1
         Wjay93twUKJOdoZ2qz9QYlvubL0zHQKYT4or1Wku3kUFEd+7clBSu8IXICNzSqD6wfgT
         GEZT3sQnIFvAJ1znyya/tSZKUPBKMma0h16aEnKkhZ42q6qwMIkLyWMLBfOhHZAKkidM
         UPsA==
In-Reply-To: <4FEEA5CB.8070809@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, shyju pv <shyju.pv@huawei.com>, Sanil kumar <sanil.kumar@huawei.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, viro@zeniv.linux.org.uk

Hello

Apply the patch on top of 3.5-rc4, and confirmed
the symptom has fixed by your patch.
Thank you!

Tested-by: Masanari Iida <standby24x7@gmail.com>

Masanari

On Sat, Jun 30, 2012 at 4:07 PM, Li Zefan <lizefan@huawei.com> wrote:
> To avoid rmdir hang, now we won't drain css references at rmdir, but
> rmdir will proceed regardless of css refs. We still have to wait till
> all css refs have been released before destroying cgroup, and this is
> achieved by holding an extra dentry refcnt for each css, which leads =
to
> this bug:
>
> BUG: Dentry ffff8801164db490{i=3D491b,n=3D/} still in use (1) [unmoun=
t of cgroup cgroup]
> ------------[ cut here ]------------
> kernel BUG at fs/dcache.c:965!
> ...
> Call Trace:
> =A0[<ffffffff811ec19a>] shrink_dcache_for_umount+0x4a/0x90
> =A0[<ffffffff811cc3c7>] generic_shutdown_super+0x37/0x160
> =A0[<ffffffff811cc5d9>] kill_anon_super+0x19/0x40
> =A0[<ffffffff811cc63a>] kill_litter_super+0x3a/0x50
> =A0[<ffffffff810fb65a>] cgroup_kill_sb+0x20a/0x280
> =A0[<ffffffff811ccdc5>] deactivate_locked_super+0x65/0xb0
> =A0[<ffffffff811ce339>] deactivate_super+0x89/0xe0
> =A0[<ffffffff810f7734>] cgroup_d_release+0x34/0x40
> =A0[<ffffffff811eb258>] d_free+0x58/0xc0
> =A0[<ffffffff811ee5f0>] dput+0x220/0x350
> =A0[<ffffffff810f7429>] css_dput_fn+0x19/0x30
> =A0[<ffffffff8107b4d9>] process_one_work+0x239/0x800
> =A0[<ffffffff8107eba3>] worker_thread+0x2e3/0x710
> =A0[<ffffffff81087e46>] kthread+0xd6/0xf0
>
> If there's a css ref dangling after umount, when the ref goes down
> to 0, dput will drop the cgroup's dentry and then drop the root
> dentry. But kill_sb will be called inbetween, as dropping cgroup dent=
ry
> unpinned sb, and now vfs will find the root dentry's refcnt is not 0.
>
> To fix this, we make css pin cgroup instead of cgroup dentry.
>
> Reported-by: Shyju P V <shyju.pv@huawei.com>
> Reported-by: Masanari Iida <standby24x7@gmail.com>
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
