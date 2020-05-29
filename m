From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: mm: mkfs.ext4 invoked oom-killer on i386 - pagecache_get_page
Date: Fri, 29 May 2020 11:49:10 +0200
Message-ID: <20200529094910.GH4406@dhcp22.suse.cz>
References: <20200520190906.GA558281@chrisdown.name>
 <20200521095515.GK6462@dhcp22.suse.cz>
 <20200521163450.GV6462@dhcp22.suse.cz>
 <CA+G9fYuDWGZx50UpD+WcsDeHX9vi3hpksvBAWbMgRZadb0Pkww@mail.gmail.com>
 <CA+G9fYs2jg-j_5fdb0OW0G-JzDjN7b8d9qnX7uuk9p4c7mVSig@mail.gmail.com>
 <20200528150310.GG27484@dhcp22.suse.cz>
 <CA+G9fYvDXiZ9E9EfU6h0gsJ+xaXY77mRu9Jg+J7C=X4gJ3qvLg@mail.gmail.com>
 <20200528164121.GA839178@chrisdown.name>
 <CALOAHbAHGOsAUUM7qn=9L1u8kAf6Gztqt=SyHSmZ9XuYZWcKmg@mail.gmail.com>
 <20200529015644.GA84588@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200529015644.GA84588-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Naresh Kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Anders Roxell <anders.roxell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Linux F2FS DEV, Mailing List" <linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Next Mailing List <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chao Yu <yuchao0-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, lkf

On Fri 29-05-20 02:56:44, Chris Down wrote:
> Yafang Shao writes:
> > Look at this patch[1] carefully you will find that it introduces the
> > same issue that I tried to fix in another patch [2]. Even more sad is
> > these two patches are in the same patchset. Although this issue isn't
> > related with the issue found by Naresh, we have to ask ourselves why
> > we always make the same mistake ?
> > One possible answer is that we always forget the lifecyle of
> > memory.emin before we read it. memory.emin doesn't have the same
> > lifecycle with the memcg, while it really has the same lifecyle with
> > the reclaimer. IOW, once a reclaimer begins the protetion value should
> > be set to 0, and after we traversal the memcg tree we calculate a
> > protection value for this reclaimer, finnaly it disapears after the
> > reclaimer stops. That is why I highly suggest to add an new protection
> > member in scan_control before.
> 
> I agree with you that the e{min,low} lifecycle is confusing for everyone --
> the only thing I've not seen confirmation of is any confirmed correlation
> with the i386 oom killer issue. If you've validated that, I'd like to see
> the data :-)

Agreed. Even if e{low,min} might still have some rough edges I am
completely puzzled how we could end up oom if none of the protection
path triggers which the additional debugging should confirm. Maybe my
debugging patch is incomplete or used incorrectly (maybe it would be
esier to use printk rather than trace_printk?).
-- 
Michal Hocko
SUSE Labs
