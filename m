From: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/mempolicy: fix uninit-value in mpol_rebind_policy()
Date: Wed, 18 May 2022 10:52:51 +0200
Message-ID: <CACT4Y+ZkDJmoaT5ks8cmhzaNhhgaLYAhvzx+5q3yzKQEW1LZ5A@mail.gmail.com>
References: <20220512123428.fq3wofedp6oiotd4@ppc.localdomain>
 <20220516094726.b5rrsjg7rvei2od5@ppc.localdomain> <20220517170817.94ca21558bbe035ae06bf6fa@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fBjJyFH8sXSyFWd7Z+l2eetv8x/giv4M4DnMxkIMcdI=;
        b=cezYN/54uwp401iZm2wviNOMyJq8YW8GnuhGTcKzr+80Ubn4/x8YgkkbPeybNJyGty
         Eom5EzKnHoSX8rrNyy9vABq5+8UKzIydpFBz12hOxCsUWtVcv/3nsoeXQC6oWUafmAPi
         0NQTOh1yzdwZHiEqmRECvR+1WuzibquI82nOC+PglVuN6eXSyLGUVlUfQwiqeE7bwekp
         XCjd3Lo3K3MPS8VcDUjfSCyq5yqHhNx1LnfDaojed4nLf1EykDrmNNyqv+66NULYaSss
         wYDAE/PgoYcq9hRgQd7fhs4xgwCYlJAqHb0alSfNKSWuSyEWSJrgJzcf+oVs1WFDAMEU
         stKA==
In-Reply-To: <20220517170817.94ca21558bbe035ae06bf6fa-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Wang Cheng <wanngchenng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, syzbot+ad1b8c404f0959c4bfcc-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org

On Wed, 18 May 2022 at 02:08, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
> On Mon, 16 May 2022 17:47:26 +0800 Wang Cheng <wanngchenng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> >
> > ...
> >
> > This patch seems to fix below bug too.
> > KMSAN: uninit-value in mpol_rebind_mm (2)
> > https://syzkaller.appspot.com/bug?id=f2fecd0d7013f54ec4162f60743a2b28df40926b
> >
> > The uninit-value is pol->w.cpuset_mems_allowed in mpol_rebind_policy().
> > When syzkaller reproducer runs to the beginning of mpol_new(),
> >
> >           mpol_new() mm/mempolicy.c
> >         do_mbind() mm/mempolicy.c
> >       kernel_mbind() mm/mempolicy.c
> >
> > `mode` is 1(MPOL_PREFERRED), nodes_empty(*nodes) is `true` and `flags`
> > is 0. Then
> >
> >       mode = MPOL_LOCAL;
> >       ...
> >       policy->mode = mode;
> >       policy->flags = flags;
> >
> > will be executed. So in mpol_set_nodemask(),
> >
> >           mpol_set_nodemask() mm/mempolicy.c
> >         do_mbind()
> >       kernel_mbind()
> >
> > pol->mode is 4(MPOL_LOCAL), that `nodemask` in `pol` is not initialized,
> > which will be accessed in mpol_rebind_policy().
>
> Thanks, I added the above to the changelog and I plan to import the
> result into mm-stable later this week.
>
> > IIUC, "#syz fix: mm/mempolicy: fix uninit-value in mpol_rebind_policy()"
> > could be sent to syzbot+ad1b8c404f0959c4bfcc-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
> > to attach the fixing commit to the bug. WDYT?
>
> Could be.  The "syz fix" isn't a thing I've paid much attention to.
> I'll start doing so ;)

Yes, we can send:

#syz fix: mm/mempolicy: fix uninit-value in mpol_rebind_policy()

to syzbot+ad1b8c404f0959c4bfcc-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
and now it should be reflected at:
https://syzkaller.appspot.com/bug?extid=ad1b8c404f0959c4bfcc

and the bug will be closed when the fix is merged everywhere.
