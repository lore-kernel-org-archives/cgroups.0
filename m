From: Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: KASAN: use-after-free Read in get_mem_cgroup_from_mm
Date: Wed, 6 Mar 2019 08:26:25 +0200
Message-ID: <20190306062625.GA3549@rapoport-lnx>
References: <00000000000006457e057c341ff8@google.com>
 <5C7BFE94.6070500@huawei.com>
 <CACT4Y+Z+CH0UTdSz-w_woMPrBwg-GuobV1Su4qd9ReffTkyfVg@mail.gmail.com>
 <5C7D2F82.40907@huawei.com>
 <CACT4Y+agwaszODNGJHCqn4fSk4Le9exn3Cau0nornJ0RaTpDJw@mail.gmail.com>
 <5C7D4500.3070607@huawei.com>
 <CACT4Y+b6y_3gTpR8LvNREHOV0TP7jB=Zp1L03dzpaz_SaeESng@mail.gmail.com>
 <5C7E1A38.2060906@huawei.com>
 <20190306020540.GA23850@redhat.com>
 <5C7F6048.2050802@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5C7F6048.2050802@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: zhong jiang <zhongjiang@huawei.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, syzbot <syzbot+cbb52e396df3e565ab02@syzkaller.appspotmail.com>, Michal Hocko <mhocko@kernel.org>, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>, Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Peter Xu <peterx@redhat.com>

Hi,

On Wed, Mar 06, 2019 at 01:53:12PM +0800, zhong jiang wrote:
> On 2019/3/6 10:05, Andrea Arcangeli wrote:
> > Hello everyone,
> >
> > [ CC'ed Mike and Peter ]
> >
> > On Tue, Mar 05, 2019 at 02:42:00PM +0800, zhong jiang wrote:
> >> On 2019/3/5 14:26, Dmitry Vyukov wrote:
> >>> On Mon, Mar 4, 2019 at 4:32 PM zhong jiang <zhongjiang@huawei.com> wrote:
> >>>> On 2019/3/4 22:11, Dmitry Vyukov wrote:
> >>>>> On Mon, Mar 4, 2019 at 3:00 PM zhong jiang <zhongjiang@huawei.com> wrote:
> >>>>>> On 2019/3/4 15:40, Dmitry Vyukov wrote:
> >>>>>>> On Sun, Mar 3, 2019 at 5:19 PM zhong jiang <zhongjiang@huawei.com> wrote:
> >>>>>>>> Hi, guys
> >>>>>>>>
> >>>>>>>> I also hit the following issue. but it fails to reproduce the issue by the log.
> >>>>>>>>
> >>>>>>>> it seems to the case that we access the mm->owner and deference it will result in the UAF.
> >>>>>>>> But it should not be possible that we specify the incomplete process to be the mm->owner.
> >>>>>>>>
> >>>>>>>> Any thoughts?
> >>>>>>> FWIW syzbot was able to reproduce this with this reproducer.
> >>>>>>> This looks like a very subtle race (threaded reproducer that runs
> >>>>>>> repeatedly in multiple processes), so most likely we are looking for
> >>>>>>> something like few instructions inconsistency window.
> >>>>>>>
> >>>>>> I has a little doubtful about the instrustions inconsistency window.
> >>>>>>
> >>>>>> I guess that you mean some smb barriers should be taken into account.:-)
> >>>>>>
> >>>>>> Because IMO, It should not be the lock case to result in the issue.
> >>>>> Since the crash was triggered on x86 _most likley_ this is not a
> >>>>> missed barrier. What I meant is that one thread needs to executed some
> >>>>> code, while another thread is stopped within few instructions.
> >>>>>
> >>>>>
> >>>> It is weird and I can not find any relationship you had said with the issue.:-(
> >>>>
> >>>> Because It is the cause that mm->owner has been freed, whereas we still deference it.
> >>>>
> >>>> From the lastest freed task call trace, It fails to create process.
> >>>>
> >>>> Am I miss something or I misunderstand your meaning. Please correct me.
> >>> Your analysis looks correct. I am just saying that the root cause of
> >>> this use-after-free seems to be a race condition.
> >>>
> >>>
> >>>
> >> Yep, Indeed,  I can not figure out how the race works. I will dig up further.
> > Yes it's a race condition.
> >
> > We were aware about the non-cooperative fork userfaultfd feature
> > creating userfaultfd file descriptor that gets reported to the parent
> > uffd, despite they belong to mm created by failed forks.
> >
> > https://www.spinics.net/lists/linux-mm/msg136357.html
> >
> 
> Hi, Andrea
> 
> I still not clear why uffd ioctl can use the incomplete process as the mm->owner.
> and how to produce the race.

There is a C reproducer in  the syzcaller report:

https://syzkaller.appspot.com/x/repro.c?x=172fa5a3400000
 
> From your above explainations,   My underdtanding is that the process handling do_exexve
> will have a temporary mm,  which will be used by the UUFD ioctl.

The race is between userfaultfd operation and fork() failure:

forking thread                  | userfaultfd monitor thread
--------------------------------+-------------------------------
fork()                          |
  dup_mmap()                    |
    dup_userfaultfd()           |
    dup_userfaultfd_complete()  |
                                |  read(UFFD_EVENT_FORK)
                                |  uffdio_copy()
                                |    mmget_not_zero()
    goto bad_fork_something     |
    ...                         |
bad_fork_free:                  |
      free_task()               |
                                |  mem_cgroup_from_task()
                                |       /* access stale mm->owner */
 
> Thanks,
> zhong jiang

-- 
Sincerely yours,
Mike.

