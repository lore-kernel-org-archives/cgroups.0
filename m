From: syzbot <syzbot+cbb52e396df3e565ab02@syzkaller.appspotmail.com>
Subject: Re: KASAN: use-after-free Read in get_mem_cgroup_from_mm
Date: Fri, 22 Mar 2019 02:36:01 -0700
Message-ID: <00000000000035d0e70584ab952b@google.com>
References: <000000000000601367057a095de4@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <000000000000601367057a095de4@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"; delsp="yes"
Content-Transfer-Encoding: 7bit
To: aarcange@redhat.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, dvyukov@google.com, hannes@cmpxchg.org, hughd@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mgorman@suse.de, mhocko@kernel.org, peterx@redhat.com, rientjes@google.com, rppt@linux.ibm.com, rppt@linux.vnet.ibm.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz, vdavydov.dev@gmail.com, willy@infradead.org, zhongjiang@huawei.com

Bisection is inconclusive: the first bad commit could be any of:

2c43838c sched/isolation: Enable CONFIG_CPU_ISOLATION=y by default
bf29cb23 sched/isolation: Make CONFIG_NO_HZ_FULL select CONFIG_CPU_ISOLATION
d94d1053 sched/isolation: Document boot parameters dependency on  
CONFIG_CPU_ISOLATION=y
4c470317 Merge branch 'sched-urgent-for-linus' of  
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1592b037200000
start commit:   0072a0c1
git tree:       upstream
dashboard link: https://syzkaller.appspot.com/bug?extid=cbb52e396df3e565ab02
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12835e25400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=172fa5a3400000

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
