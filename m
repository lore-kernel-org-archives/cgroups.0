From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: __blkg_lookup oops with 4.2-rcX
Date: Sat, 5 Sep 2015 14:38:01 -0400
Message-ID: <20150905183801.GA8231@mtj.duckdns.org>
References: <CA+5PVA5rzQ0s4723n5rHBcxQa9t0cW8BPPBekr_9aMRoWt2aYg@mail.gmail.com>
 <20150902145307.GG22326@mtj.duckdns.org>
 <20150902153255.GH22326@mtj.duckdns.org>
 <20150904104602.GN29283@redhat.com>
 <20150904171302.GE25329@mtj.duckdns.org>
 <20150904204244.GQ29283@redhat.com>
 <20150905153439.GA18461@redhat.com>
 <20150905154840.GA19460@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=xcPlwuW9x3OehAXLK7JU80d2Xs/Q5vsIBGqMFa+zIfo=;
        b=fldXaISgrAd64woVq3awEDPIhmRDgu6OttHGv+MzBveWujCLBUBPBUdX6s9/qDNAcc
         NnODHL41UmVXJSzOY/H6dzbFhGd0HeXFKI0LNOvOySSHWt6I8u8JELfB5Qmv2VE+Vu8r
         xcc9MdrQfrWfZWkP7BTeCgpde0MXiKSMRnMp+KkEG0xiseg4gbXKXVktxC2c+r31wfhT
         /SFeycC6c6r0iLwJe87DZuzhZ2oo/oevYj4Jq9M+uXAZEqOR3kljXw97Zm4ver54RaMm
         vUw4ZZAwkEnVLS9NgWQRKxzSc8MQ/+1E+SEwtTjmI4vgCr5eDei/JCV7StN8ikwT0N43
         NXdA==
Content-Disposition: inline
In-Reply-To: <20150905154840.GA19460-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Richard W.M. Jones" <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, msnitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sat, Sep 05, 2015 at 04:48:40PM +0100, Richard W.M. Jones wrote:
> On Sat, Sep 05, 2015 at 04:34:39PM +0100, Richard W.M. Jones wrote:
> > [   52.259269] BUG: unable to handle kernel NULL pointer dereference at 00000000000009c8
> > [   52.259269] IP: [<ffffffff813f8b10>] __blkg_lookup+0x40/0xe0
> 
> And also:
> 
> $ addr2line -e /usr/lib/debug/lib/modules/4.3.0-0.rc0.git7.1.rwmj3.fc24.x86_64/vmlinux ffffffff813f8b10
> /usr/src/debug/kernel-4.2.fc24/linux-4.3.0-0.rc0.git7.1.rwmj3.fc24.x86_64/block/blk-cgroup.c:158
> 
>     152         /*
>     153          * Hint didn't match.  Look up from the radix tree.  Note that the
>     154          * hint can only be updated under queue_lock as otherwise @blkg
>     155          * could have already been removed from blkg_tree.  The caller is
>     156          * responsible for grabbing queue_lock if @update_hint.
>     157          */
>     158         blkg = radix_tree_lookup(&blkcg->blkg_tree, q->id);

Okay, found the bug.  It was an existing problem which got exposed by
the recent bypass change.  Will soon post a patch.

Thanks a lot!

-- 
tejun
