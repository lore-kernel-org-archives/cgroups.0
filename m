From: Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: mm: mkfs.ext4 invoked oom-killer on i386 - pagecache_get_page
Date: Fri, 22 May 2020 02:23:09 +0530
Message-ID: <CA+G9fYs2jg-j_5fdb0OW0G-JzDjN7b8d9qnX7uuk9p4c7mVSig@mail.gmail.com>
References: <CA+G9fYu2ruH-8uxBHE0pdE6RgRTSx4QuQPAN=Nv3BCdRd2ouYA@mail.gmail.com>
 <20200501135806.4eebf0b92f84ab60bba3e1e7@linux-foundation.org>
 <CA+G9fYsiZ81pmawUY62K30B6ue+RXYod854RS91R2+F8ZO7Xvw@mail.gmail.com>
 <20200519075213.GF32497@dhcp22.suse.cz> <CAK8P3a2T_j-Ynvhsqe_FCqS2-ZdLbo0oMbHhHChzMbryE0izAQ@mail.gmail.com>
 <20200519084535.GG32497@dhcp22.suse.cz> <CA+G9fYvzLm7n1BE7AJXd8_49fOgPgWWTiQ7sXkVre_zoERjQKg@mail.gmail.com>
 <CA+G9fYsXnwyGetj-vztAKPt8=jXrkY8QWe74u5EEA3XPW7aikQ@mail.gmail.com>
 <20200520190906.GA558281@chrisdown.name> <20200521095515.GK6462@dhcp22.suse.cz>
 <20200521163450.GV6462@dhcp22.suse.cz> <CA+G9fYuDWGZx50UpD+WcsDeHX9vi3hpksvBAWbMgRZadb0Pkww@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+fLCJ2GM93cwoKTZdZ4WFD0IYvwQ9ZS8NpXP6kyN8Oc=;
        b=TBv65LdWvJKhGaaNuo9NEb78jnL9BrQAOtPhzoDfCosM1uH7i74IqGHCHmYGaJPdHz
         CWCviqP1kSYaAcJp76r0NmD2UjTYe3MeXRUjZ7Gfj0csgNWpJcH5xbzTOLaFtf8uT5+3
         /uM6hI+J/Gq/ki4ylpSu3zLN9n1wTEPzv14fLIVPyhMmtfoFCL62Kx4yZeWDBbv/l5w1
         K39JR/uyz8X+Y20+CXNOcXbl3HbDDa7fsDpPrOTRV9Q5SbBB3Jb/BXIJzdJ9gGDiZkj+
         XTUH4ek9bRuZIljRPeGI/rG4e1ojQtcnYVTE/xIktlVknSWMIJfaLJsufV1okj576bpp
         EBuQ==
In-Reply-To: <CA+G9fYuDWGZx50UpD+WcsDeHX9vi3hpksvBAWbMgRZadb0Pkww@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao@gmail.com>, Michal Hocko <mhocko@kernel.org>, Chris Down <chris@chrisdown.name>
Cc: Anders Roxell <anders.roxell@linaro.org>, "Linux F2FS DEV, Mailing List" <linux-f2fs-devel@lists.sourceforge.net>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, open list <linux-kernel@vger.kernel.org>, Linux-Next Mailing List <linux-next@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Arnd Bergmann <arnd@arndb.de>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Chao Yu <chao@kernel.org>, Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>, Matthew Wilcox <willy@infradead.org>, Chao Yu <yuchao0@huawei.com>, lkft-triage@lists.linaro.org, Johannes Weiner <hannes@cmpxchg.org>, Roman

My apology !
As per the test results history this problem started happening from
Bad : next-20200430 (still reproducible on next-20200519)
Good : next-20200429

The git tree / tag used for testing is from linux next-20200430 tag and reverted
following three patches and oom-killer problem fixed.

Revert "mm, memcg: avoid stale protection values when cgroup is above
protection"
Revert "mm, memcg: decouple e{low,min} state mutations from protectinn checks"
Revert "mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix"

Ref tree:
https://github.com/roxell/linux/commits/my-next-20200430

Build images:
https://builds.tuxbuild.com/whyTLI1O8s5HiILwpLTLtg/

Test log:
https://lkft.validation.linaro.org/scheduler/job/1444321#L1164

- Naresh
