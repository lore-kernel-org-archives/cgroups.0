From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mm: mkfs.ext4 invoked oom-killer on i386 - pagecache_get_page
Date: Thu, 18 Jun 2020 22:59:28 +0800
Message-ID: <CALOAHbCPd407z45e809VE5c8vP6ewqwkDkY9nrMP5TyP5cjG+A@mail.gmail.com>
References: <20200521095515.GK6462@dhcp22.suse.cz> <20200521163450.GV6462@dhcp22.suse.cz>
 <CA+G9fYsdsgRmwLtSKJSzB1eWcUQ1z-_aaU+BNcQpker34XT6_w@mail.gmail.com>
 <20200617135758.GA548179@chrisdown.name> <20200617141155.GQ9499@dhcp22.suse.cz>
 <CA+G9fYu+FB1PE0AMmE-9MrHpayE9kChwTyc3zfM6V83uQ0zcQA@mail.gmail.com>
 <20200617160624.GS9499@dhcp22.suse.cz> <CA+G9fYtCXrVGVtRTwxiqgfFNDDf_H4aNH=VpWLhsV4n_mCTLGg@mail.gmail.com>
 <20200617210935.GA578452@chrisdown.name> <CALOAHbBp7Ytd-Hta9NH-_HJtVTAsR5Pw2RYrVScp7PPezCEv2w@mail.gmail.com>
 <20200618123743.GA694719@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NtwtfirPIaj3hQKqt5NnTqLzfoXadlYH6xaXhH3mB+s=;
        b=kYwPKZdp0pHLg9nzSkXLUjXIWhhGSDK+lUsX3kvZKhpx/abFTtNYjkojW4sVVt7bHm
         qZGTxARuFd3WI6EfU1eBN6+4gj/yCc7G3VU2n21gea6aS3fkUz/uMmbZ6zjhs6dF/ctG
         mtQLDzrh6EKtHb9OSOEmMjo3N7fWi8hwmYyXXXcwlEWheXzJEY46FsRDyYJ/YXapbZEL
         GAjWeoKd6sh4vm2KkDp99cfVll6l6Xz1jcMVSif5RsT91SxuUdRKKCZShkXiMxJfDPO2
         mEQ03gbiIGbBmN1vxaEfCsHPJle351uahP3BtuY+Amj/uplhgSOrlPpU1WHGNLMkS4iC
         lVIw==
In-Reply-To: <20200618123743.GA694719-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Naresh Kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Anders Roxell <anders.roxell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Linux F2FS DEV, Mailing List" <linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Next Mailing List <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chao Yu <yuchao0-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, lkf

On Thu, Jun 18, 2020 at 8:37 PM Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org> wrote:
>
> Yafang Shao writes:
> >On Thu, Jun 18, 2020 at 5:09 AM Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org> wrote:
> >>
> >> Naresh Kamboju writes:
> >> >After this patch applied the reported issue got fixed.
> >>
> >> Great! Thank you Naresh and Michal for helping to get to the bottom of this :-)
> >>
> >> I'll send out a new version tomorrow with the fixes applied and both of you
> >> credited in the changelog for the detection and fix.
> >
> >As we have already found that the usage around memory.{emin, elow} has
> >many limitations, I think memory.{emin, elow} should be used for
> >memcg-tree internally only, that means they can only be used to
> >calculate the protection of a memcg in a specified memcg-tree but
> >should not be exposed to other MM parts.
>
> I agree that the current semantics are mentally taxing and we should generally
> avoid exposing the implementation details outside of memcg where possible. Do
> you have a suggested rework? :-)

Keeping the mem_cgroup_protected() as-is is my suggestion. Anyway I
think it is bad to put memory.{emin, elow} here and there.
If we don't have any better idea by now, just putting all the
references of memory.{emin, elow}  into one
wrapper(mem_cgroup_protected()) is the reasonable solution.

-- 
Thanks
Yafang
