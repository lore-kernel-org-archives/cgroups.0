From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: WARNING in cgroup_finalize_control
Date: Mon, 11 May 2020 15:31:27 -0300
Message-ID: <20200511183127.GI2688@localhost.localdomain>
References: <000000000000e79ab005a56292f5@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W9v2pHHx1D7eBpE4o9IR/Rkokec9q6VQtmrv8BGwFy4=;
        b=lFOPBOSgjwrfiEYsJxmcOzBtU3TsnFrsX0SanpVq7AKWi2aS5+Bo/6BGkHZpI0IMZ7
         3fAUoCSbaSTRT536jeiyZv/QsHiRJGHOyCi3o1u9AP2ju+gebzBz/3MXLDDmKtwWm8kQ
         C0I/4Z7fZg8cqqhwNoaVehtMaIqGEMPuiix89bMdfM7iK00GHOt0tPje0IzEsn6LXLmz
         /f4+qc5JJiZ/xI5HFJ+io+Thzm8ykSFwGfmhdFi/LL+JcFfFRQLnuh3uAd2rkpFpAqEk
         DZ/IE2VVS/80XerfS4EgEL0cQgsCY+RTrUJSNJwl4TiuJbW35v5/vyd/Y6nooFDCi2Tq
         0V/g==
Content-Disposition: inline
In-Reply-To: <000000000000e79ab005a56292f5@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+9c08aaa363ca5784c9e9@syzkaller.appspotmail.com>
Cc: andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, christian@brauner.io, coreteam@netfilter.org, daniel@iogearbox.net, davem@davemloft.net, hannes@cmpxchg.org, john.fastabend@gmail.com, kaber@trash.net, kadlec@blackhole.kfki.hu, kafai@fb.com, kpsingh@chromium.org, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, lizefan@huawei.com, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, nhorman@tuxdriver.com, pablo@netfilter.org, songliubraving@fb.com, syzkaller-bugs@googlegroups.com, tj@kernel.org, vyasevich@gmail.com, yhs@fb.com

On Mon, May 11, 2020 at 10:21:13AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    a811c1fa Merge git://git.kernel.org/pub/scm/linux/kernel/g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16ad1d70100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=43badbd0e7e1137e
> dashboard link: https://syzkaller.appspot.com/bug?extid=9c08aaa363ca5784c9e9
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10d3c588100000
> 
> The bug was bisected to:
> 
> commit eab59075d3cd7f3535aa2dbbc19a198dfee58892
> Author: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Date:   Wed Dec 28 11:26:31 2016 +0000
> 
>     sctp: reduce indent level at sctp_sf_tabort_8_4_8

The reproducer is not touching any sctp code and the commit above
didn't have any functional change. Not sure how the bisect ended up on
it, but this isn't triggered by sctp.
