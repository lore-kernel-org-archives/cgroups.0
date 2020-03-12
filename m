From: Tejun Heo <tj@kernel.org>
Subject: Re: KASAN: slab-out-of-bounds Read in cgroup_file_notify
Date: Thu, 12 Mar 2020 14:28:26 -0400
Message-ID: <20200312182826.GG79873@mtj.duckdns.org>
References: <00000000000041c6c205a08225dc@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z1+jrFk0l780LY82KtgQMlOjuOPnOSNUeBpKHT6Qy6g=;
        b=Im3J3CT7QT/G7DEOXBPU5qa5NpzXZfgFk285tuuYBMicpySswnkSvESZnO6jErqFRd
         UPjDpp+0r/vIODgW1k2ShKCiqBy9MmTZB95AFcHg6b7GeSpKBLUrNugoVoATGkaO79DP
         mcRtqwQ/zX3X63/A+7p6exSokHYdR7eIJBUgv5B5sY+P2DtU9pohuGZNPHsQfo0VFSI2
         VxQkQ/6aIBCgeOjZES4EHfdnoV985yMvsQIIreKQVnp8LIh6qsdqDWBCyvkBNnEKbegw
         eLunF7LsF0q/MWSdI3ei6mjKA8959FeSB1VKEpCNXBnaDb99LSD6iiIueYU9p8geMzQv
         814Q==
Content-Disposition: inline
In-Reply-To: <00000000000041c6c205a08225dc@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: almasrymina@google.com, syzbot <syzbot+cac0c4e204952cf449b1@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, christian@brauner.io, daniel@iogearbox.net, hannes@cmpxchg.org, kafai@fb.com, linux-kernel@vger.kernel.org, lizefan@huawei.com, netdev@vger.kernel.org, sfr@canb.auug.org.au, songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com

On Tue, Mar 10, 2020 at 08:55:14AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    c99b17ac Add linux-next specific files for 20200225
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1610d70de00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6b7ebe4bd0931c45
> dashboard link: https://syzkaller.appspot.com/bug?extid=cac0c4e204952cf449b1
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1242e1fde00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1110d70de00000
> 
> The bug was bisected to:
> 
> commit 6863de00e5400b534cd4e3869ffbc8f94da41dfc
> Author: Mina Almasry <almasrymina@google.com>
> Date:   Thu Feb 20 03:55:30 2020 +0000
> 
>     hugetlb_cgroup: add accounting for shared mappings

Mina, can you please take a look at this?

Thanks.

-- 
tejun
