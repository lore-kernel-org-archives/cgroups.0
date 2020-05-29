From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mm: mkfs.ext4 invoked oom-killer on i386 - pagecache_get_page
Date: Fri, 29 May 2020 09:50:33 +0800
Message-ID: <CALOAHbAHGOsAUUM7qn=9L1u8kAf6Gztqt=SyHSmZ9XuYZWcKmg@mail.gmail.com>
References: <20200519084535.GG32497@dhcp22.suse.cz> <CA+G9fYvzLm7n1BE7AJXd8_49fOgPgWWTiQ7sXkVre_zoERjQKg@mail.gmail.com>
 <CA+G9fYsXnwyGetj-vztAKPt8=jXrkY8QWe74u5EEA3XPW7aikQ@mail.gmail.com>
 <20200520190906.GA558281@chrisdown.name> <20200521095515.GK6462@dhcp22.suse.cz>
 <20200521163450.GV6462@dhcp22.suse.cz> <CA+G9fYuDWGZx50UpD+WcsDeHX9vi3hpksvBAWbMgRZadb0Pkww@mail.gmail.com>
 <CA+G9fYs2jg-j_5fdb0OW0G-JzDjN7b8d9qnX7uuk9p4c7mVSig@mail.gmail.com>
 <20200528150310.GG27484@dhcp22.suse.cz> <CA+G9fYvDXiZ9E9EfU6h0gsJ+xaXY77mRu9Jg+J7C=X4gJ3qvLg@mail.gmail.com>
 <20200528164121.GA839178@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H3h/KKWXDUeQOc5C3bt+8FTDd7C+ZKV4cv02x2eGUM0=;
        b=hv3Ro80UVyre+PN/oxyCxv5Wj3U9Miq4RcYmwn7Wer3m5lna+secRy/iNZy1XU5vs6
         DwjrNtSLHZt3BxA7cIhF92ENeQKAwPhXRCSqVVVGdfZEG1vXKe2rTqhNQ5Hvrpi2UFjd
         LXRB+yKNrnG7mdAT8gMmN500gmHD5X41hEKBe0ZSg81bWVcCF0wDSjdIsr/DX4GRWgtn
         jcsGk9dGIRwLlEPEmqwg9TjN0k2usiunSA7X//YLVJEyZx8FK26kMVPXHvJZ+cbDD4ho
         dfy41JIPsQje/uQaXQhSJnK2rs1lAoB5dKeFYnuDrG4bDMDOculzn8iblXX+9y2QjMdX
         sHpA==
In-Reply-To: <20200528164121.GA839178-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Naresh Kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Anders Roxell <anders.roxell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Linux F2FS DEV, Mailing List" <linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Next Mailing List <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chao Yu <yuchao0-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, lkf

On Fri, May 29, 2020 at 12:41 AM Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org> wrote:
>
> Naresh Kamboju writes:
> >On Thu, 28 May 2020 at 20:33, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >>
> >> On Fri 22-05-20 02:23:09, Naresh Kamboju wrote:
> >> > My apology !
> >> > As per the test results history this problem started happening from
> >> > Bad : next-20200430 (still reproducible on next-20200519)
> >> > Good : next-20200429
> >> >
> >> > The git tree / tag used for testing is from linux next-20200430 tag and reverted
> >> > following three patches and oom-killer problem fixed.
> >> >
> >> > Revert "mm, memcg: avoid stale protection values when cgroup is above
> >> > protection"
> >> > Revert "mm, memcg: decouple e{low,min} state mutations from protectinn checks"
> >> > Revert "mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix"
> >>
> >> The discussion has fragmented and I got lost TBH.
> >> In http://lkml.kernel.org/r/CA+G9fYuDWGZx50UpD+WcsDeHX9vi3hpksvBAWbMgRZadb0Pkww-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
> >> you have said that none of the added tracing output has triggered. Does
> >> this still hold? Because I still have a hard time to understand how
> >> those three patches could have the observed effects.
> >
> >On the other email thread [1] this issue is concluded.
> >
> >Yafang wrote on May 22 2020,
> >
> >Regarding the root cause, my guess is it makes a similar mistake that
> >I tried to fix in the previous patch that the direct reclaimer read a
> >stale protection value.  But I don't think it is worth to add another
> >fix. The best way is to revert this commit.
>
> This isn't a conclusion, just a guess (and one I think is unlikely). For this
> to reliably happen, it implies that the same race happens the same way each
> time.


Hi Chris,

Look at this patch[1] carefully you will find that it introduces the
same issue that I tried to fix in another patch [2]. Even more sad is
these two patches are in the same patchset. Although this issue isn't
related with the issue found by Naresh, we have to ask ourselves why
we always make the same mistake ?
One possible answer is that we always forget the lifecyle of
memory.emin before we read it. memory.emin doesn't have the same
lifecycle with the memcg, while it really has the same lifecyle with
the reclaimer. IOW, once a reclaimer begins the protetion value should
be set to 0, and after we traversal the memcg tree we calculate a
protection value for this reclaimer, finnaly it disapears after the
reclaimer stops. That is why I highly suggest to add an new protection
member in scan_control before.

[1]. https://lore.kernel.org/linux-mm/20200505084127.12923-3-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org/
[2]. https://lore.kernel.org/linux-mm/20200505084127.12923-2-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org/

-- 
Thanks
Yafang
