From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [syzbot] INFO: rcu detected stall in net_tx_action
Date: Thu, 28 Jul 2022 00:00:07 +0800
Message-ID: <YuFhB2FaEacNI26/@T590>
References: <00000000000026864605c611cc51@google.com>
 <0000000000004bee3605e4b74106@google.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658937624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XNYAzpbrdFeqkLd/QeiydKTf4ZkAUvL844eMUk9c+qI=;
        b=YMQl+9Q6D7Q/wdxyWyzlRh9PVPpZxiQxR7l68lRtGx9VgVQNpAorrIAr1F/vbqM6k5x4eb
        Tb9PE45mhXl3iDE6JxyL7d6iKULK4N2ugDeAlXVJIS6FEQKj8tTq5olFLOTtvooYjwVJnO
        pjhmqpkvDR8T23Pzz+oJ3WKOI5bITX8=
Content-Disposition: inline
In-Reply-To: <0000000000004bee3605e4b74106@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+3ba0493d523d007b3819@syzkaller.appspotmail.com>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, fweisbec@gmail.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@kernel.org, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, tj@kernel.org

On Tue, Jul 26, 2022 at 08:50:09AM -0700, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit 0a9a25ca78437b39e691bcc3dc8240455b803d8d
> Author: Ming Lei <ming.lei@redhat.com>
> Date:   Fri Mar 18 13:01:43 2022 +0000
> 
>     block: let blkcg_gq grab request queue's refcnt
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1004f05a080000
> start commit:   d6765985a42a Revert "be2net: disable bh with spin_lock in ..
> git tree:       net
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7ca96a2d153c74b0
> dashboard link: https://syzkaller.appspot.com/bug?extid=3ba0493d523d007b3819
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c9edc8300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=172463c8300000
> 

The bad commit has been fixed by the following patch:

d578c770c852 block: avoid calling blkg_free() in atomic context



Thanks, 
Ming

