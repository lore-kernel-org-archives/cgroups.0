From: Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: mm: mkfs.ext4 invoked oom-killer on i386 - pagecache_get_page
Date: Thu, 28 May 2020 21:47:00 +0530
Message-ID: <CA+G9fYvDXiZ9E9EfU6h0gsJ+xaXY77mRu9Jg+J7C=X4gJ3qvLg@mail.gmail.com>
References: <20200519075213.GF32497@dhcp22.suse.cz> <CAK8P3a2T_j-Ynvhsqe_FCqS2-ZdLbo0oMbHhHChzMbryE0izAQ@mail.gmail.com>
 <20200519084535.GG32497@dhcp22.suse.cz> <CA+G9fYvzLm7n1BE7AJXd8_49fOgPgWWTiQ7sXkVre_zoERjQKg@mail.gmail.com>
 <CA+G9fYsXnwyGetj-vztAKPt8=jXrkY8QWe74u5EEA3XPW7aikQ@mail.gmail.com>
 <20200520190906.GA558281@chrisdown.name> <20200521095515.GK6462@dhcp22.suse.cz>
 <20200521163450.GV6462@dhcp22.suse.cz> <CA+G9fYuDWGZx50UpD+WcsDeHX9vi3hpksvBAWbMgRZadb0Pkww@mail.gmail.com>
 <CA+G9fYs2jg-j_5fdb0OW0G-JzDjN7b8d9qnX7uuk9p4c7mVSig@mail.gmail.com> <20200528150310.GG27484@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IuyHwLJRnB6jxTc1IB7c0ys/rrbHpiCHBZYkZOd5+aA=;
        b=dnY861HISlW7Skc3gzpG3vW0s3QiWx9O4snM0Q63YTXMKM+DTDIREHzF4vRDxhIvbZ
         dYi7yQdeWR7/U7kdlDUHwOi9DdY7WbtDafHbadPk2OPyvMhIIkEiiUHeUss1TwcHy759
         AkF2Q3ZVo/VG5Bdc4OEnX9FsUtb9Iw0ZFZ7YKTkSRlM9J0Gonu/ZDOEK5W9Y3RZ86gJk
         S1HLfVmE5rjKgkr2zLBllzghwb3k4F7KnbS94qnb1iZAADxYXmu+D8Da7yx7DAEi6qD0
         X7sm5OjbS/W1CtcsJY4DpGOA0rwpitIt381IGnI44rO6i4hfyMb9laFfBPVIGGQELoEg
         Iv3w==
In-Reply-To: <20200528150310.GG27484@dhcp22.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>, Yafang Shao <laoar.shao@gmail.com>
Cc: Chris Down <chris@chrisdown.name>, Anders Roxell <anders.roxell@linaro.org>, "Linux F2FS DEV, Mailing List" <linux-f2fs-devel@lists.sourceforge.net>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, open list <linux-kernel@vger.kernel.org>, Linux-Next Mailing List <linux-next@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Arnd Bergmann <arnd@arndb.de>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Chao Yu <chao@kernel.org>, Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>, Matthew Wilcox <willy@infradead.org>, Chao Yu <yuchao0@huawei.com>, lkft-triage@lists.linaro.org, Johannes

On Thu, 28 May 2020 at 20:33, Michal Hocko <mhocko@kernel.org> wrote:
>
> On Fri 22-05-20 02:23:09, Naresh Kamboju wrote:
> > My apology !
> > As per the test results history this problem started happening from
> > Bad : next-20200430 (still reproducible on next-20200519)
> > Good : next-20200429
> >
> > The git tree / tag used for testing is from linux next-20200430 tag and reverted
> > following three patches and oom-killer problem fixed.
> >
> > Revert "mm, memcg: avoid stale protection values when cgroup is above
> > protection"
> > Revert "mm, memcg: decouple e{low,min} state mutations from protectinn checks"
> > Revert "mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix"
>
> The discussion has fragmented and I got lost TBH.
> In http://lkml.kernel.org/r/CA+G9fYuDWGZx50UpD+WcsDeHX9vi3hpksvBAWbMgRZadb0Pkww@mail.gmail.com
> you have said that none of the added tracing output has triggered. Does
> this still hold? Because I still have a hard time to understand how
> those three patches could have the observed effects.

On the other email thread [1] this issue is concluded.

Yafang wrote on May 22 2020,

Regarding the root cause, my guess is it makes a similar mistake that
I tried to fix in the previous patch that the direct reclaimer read a
stale protection value.  But I don't think it is worth to add another
fix. The best way is to revert this commit.


[1]  [PATCH v3 2/2] mm, memcg: Decouple e{low,min} state mutations
from protection checks
https://lore.kernel.org/linux-mm/CALOAHbArZ3NsuR3mCnx_kbSF8ktpjhUF2kaaTa7Mb7ocJajsQg@mail.gmail.com/

- Naresh

> --
> Michal Hocko
> SUSE Labs
