From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: KASAN: slab-out-of-bounds Read in cgroup_file_notify
Date: Fri, 13 Mar 2020 15:43:08 -0700
Message-ID: <CAHS8izMpBXsv_fvy5Qw8CcjBivpfgec+r39+aFScgNDtUTdSqA@mail.gmail.com>
References: <00000000000041c6c205a08225dc@google.com> <20200312182826.GG79873@mtj.duckdns.org>
 <CAHS8izPySSO07dHi3OZ_1uXjmMCGnNMWey+o-qwFM7GnD7oSHw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MFjCvufz4qYwDEr+hp+Lr4gi77q6/a3rGxqdBQ0RGh0=;
        b=hXcW2YUeO7771pgMZQkpwWmDZERH1p2Fm3PKienj099vaUMe3Qcl+GfrrGnyRTugmy
         hOnPmmf61cOuY/9YM1n1YJDgIF/bzZkQ/SKe2ooZAlXOFVBwIbdf8NnqTwiRIUPwuyDu
         gq3dsr7QjFlNCbKk0FVRt2dnIYW73J+gylAUjLTdaMQSAQ/34Wi3jetakzQOmExGLLbw
         8OEa3IZy8OX7Im6ZIDSkOYCwptISjIO0eg7A4GLNypa3yVBcCLvJb7t8YlEPeGHfRL5j
         ldPvDbHUiWlCrcDekAFVZa0WqguFkec5Hxe/880sV0TtxrYvDnRso7ck3UIuBr42iaBG
         4qsA==
In-Reply-To: <CAHS8izPySSO07dHi3OZ_1uXjmMCGnNMWey+o-qwFM7GnD7oSHw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Giuseppe Scrivano <gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: syzbot <syzbot+cac0c4e204952cf449b1-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, andriin-b10kYP2dOMg@public.gmane.org, ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kafai-b10kYP2dOMg@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org

On Thu, Mar 12, 2020 at 2:06 PM Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Thu, Mar 12, 2020 at 11:28 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Tue, Mar 10, 2020 at 08:55:14AM -0700, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following crash on:
> > >
> > > HEAD commit:    c99b17ac Add linux-next specific files for 20200225
> > > git tree:       linux-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=1610d70de00000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=6b7ebe4bd0931c45
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=cac0c4e204952cf449b1
> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1242e1fde00000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1110d70de00000
> > >
> > > The bug was bisected to:
> > >
> > > commit 6863de00e5400b534cd4e3869ffbc8f94da41dfc
> > > Author: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > Date:   Thu Feb 20 03:55:30 2020 +0000
> > >
> > >     hugetlb_cgroup: add accounting for shared mappings
> >
> > Mina, can you please take a look at this?
> >
>
> Gah, I missed the original syzbot email but I just saw this. I'll take a look.
>

This was easy enough to track down, I just sent out a fix:
https://lore.kernel.org/linux-mm/20200313223920.124230-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

BTW, even though this was bisected to my patch, the root cause seems
to be a mistake in commit faced7e0806cf ("mm: hugetlb controller for
cgroups v2"), which is not only in linux-next but also in linus's tree
(I did not check if it's in stable). If my fix is reviewed, the patch
should be sent there as well. I'll make the same comment on the above
thread as well.
