From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 00/11] mm: fix page aging across multiple cgroups
Date: Thu, 7 Nov 2019 09:45:55 -0800
Message-ID: <20191107174555.GA116752@cmpxchg.org>
References: <20190603210746.15800-1-hannes@cmpxchg.org>
 <CALvZod7821vuP_KcOKZkzKu-6b_kzDPrximi3E-Ld95fd=zbMg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YQHzfatweJlvu9QRgWqn6mLupzORKF19rwgbns+H/Ko=;
        b=G8fRkvwVCgK+5AnZZD/V83YvXyFilTUx9GafaEg/RlOfkWwhafnHdqdNeGKXLF/H6K
         FDoIV9FDSYGiZwaMLLnBtT4HOWe9rvBSeoXdkoOt977x30UGwRbKIQD62Y3e0SHPGkJE
         zj18IxkktF05wkCUiif3Tune+pTbQR19EfTWV8nDz4Wk+HvNaFZ82cJrX2VmWcejNZCG
         /iA/y8UqcJOl8F5Lh91S8tMoq40Go993jzHkeaTYmeYHGrX9dqqW6SRh5BZnroMcF8Jn
         BD77+M4HBjqEt44AKkO6oPWfH6+/na5b+Omr1i/uNPazTemCNSqER5sX4i6vu+vqbhQq
         hrYw==
Content-Disposition: inline
In-Reply-To: <CALvZod7821vuP_KcOKZkzKu-6b_kzDPrximi3E-Ld95fd=zbMg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <kernel-team@fb.com>

On Wed, Nov 06, 2019 at 06:50:25PM -0800, Shakeel Butt wrote:
> On Mon, Jun 3, 2019 at 2:59 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > When applications are put into unconfigured cgroups for memory
> > accounting purposes, the cgrouping itself should not change the
> > behavior of the page reclaim code. We expect the VM to reclaim the
> > coldest pages in the system. But right now the VM can reclaim hot
> > pages in one cgroup while there is eligible cold cache in others.
> >
> > This is because one part of the reclaim algorithm isn't truly cgroup
> > hierarchy aware: the inactive/active list balancing. That is the part
> > that is supposed to protect hot cache data from one-off streaming IO.
> >
> > The recursive cgroup reclaim scheme will scan and rotate the physical
> > LRU lists of each eligible cgroup at the same rate in a round-robin
> > fashion, thereby establishing a relative order among the pages of all
> > those cgroups. However, the inactive/active balancing decisions are
> > made locally within each cgroup, so when a cgroup is running low on
> > cold pages, its hot pages will get reclaimed - even when sibling
> > cgroups have plenty of cold cache eligible in the same reclaim run.
> >
> > For example:
> >
> >    [root@ham ~]# head -n1 /proc/meminfo
> >    MemTotal:        1016336 kB
> >
> >    [root@ham ~]# ./reclaimtest2.sh
> >    Establishing 50M active files in cgroup A...
> >    Hot pages cached: 12800/12800 workingset-a
> >    Linearly scanning through 18G of file data in cgroup B:
> >    real    0m4.269s
> >    user    0m0.051s
> >    sys     0m4.182s
> >    Hot pages cached: 134/12800 workingset-a
> >
> 
> Can you share reclaimtest2.sh as well? Maybe a selftest to
> monitor/test future changes.

I wish it were more portable, but it really only does what it says in
the log output, in a pretty hacky way, with all parameters hard-coded
to my test environment:

---

#!/bin/bash

# this should protect workingset-a from workingset-b

set -e
#set -x

echo Establishing 50M active files in cgroup A...
rmdir /cgroup/workingset-a 2>/dev/null || true
mkdir /cgroup/workingset-a
echo $$ > /cgroup/workingset-a/cgroup.procs
rm -f workingset-a
dd of=workingset-a bs=1M count=0 seek=50 2>/dev/null >/dev/null
cat workingset-a > /dev/null
cat workingset-a > /dev/null
cat workingset-a > /dev/null
cat workingset-a > /dev/null
cat workingset-a > /dev/null
cat workingset-a > /dev/null
cat workingset-a > /dev/null
cat workingset-a > /dev/null
echo -n "Hot pages cached: "
./mincore workingset-a

echo -n Linearly scanning through 2G of file data cgroup B:
rmdir /cgroup/workingset-b >/dev/null || true
mkdir /cgroup/workingset-b
echo $$ > /cgroup/workingset-b/cgroup.procs
rm -f workingset-b
dd of=workingset-b bs=1M count=0 seek=2048 2>/dev/null >/dev/null
time (
  cat workingset-b > /dev/null
  cat workingset-b > /dev/null
  cat workingset-b > /dev/null
  cat workingset-b > /dev/null
  cat workingset-b > /dev/null
  cat workingset-b > /dev/null
  cat workingset-b > /dev/null
  cat workingset-b > /dev/null )
echo -n "Hot pages cached: "
./mincore workingset-a
