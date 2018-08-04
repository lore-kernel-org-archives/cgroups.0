From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: WARNING in try_charge
Date: Sat, 4 Aug 2018 22:45:03 +0900
Message-ID: <4660f164-b3e3-28a0-9898-718c5fa6b84d@I-love.SAKURA.ne.jp>
References: <0000000000005e979605729c1564@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0000000000005e979605729c1564@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: mhocko@kernel.org, David Rientjes <rientjes@google.com>
Cc: syzbot <syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com>, cgroups@vger.kernel.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, vdavydov.dev@gmail.com

syzbot is hitting WARN(1) because of mem_cgroup_out_of_memory() == false.
At first I suspected that syzbot is hitting

  static bool oom_kill_memcg_victim(struct oom_control *oc)
  {
          if (oc->chosen_memcg == NULL || oc->chosen_memcg == INFLIGHT_VICTIM)
                  return oc->chosen_memcg;

case because

  /* We have one or more terminating processes at this point. */
  oc->chosen_task = INFLIGHT_VICTIM;

is not called. But since that patch was dropped from next-20180803, syzbot
seems to be hitting a different race condition
( https://syzkaller.appspot.com/text?tag=CrashLog&x=12071654400000 ).

Therefore, next culprit I suspect is

    mm, oom: remove oom_lock from oom_reaper

    oom_reaper used to rely on the oom_lock since e2fe14564d33 ("oom_reaper:
    close race with exiting task").  We do not really need the lock anymore
    though.  212925802454 ("mm: oom: let oom_reap_task and exit_mmap run
    concurrently") has removed serialization with the exit path based on the
    mm reference count and so we do not really rely on the oom_lock anymore.

    Tetsuo was arguing that at least MMF_OOM_SKIP should be set under the lock
    to prevent from races when the page allocator didn't manage to get the
    freed (reaped) memory in __alloc_pages_may_oom but it sees the flag later
    on and move on to another victim.  Although this is possible in principle
    let's wait for it to actually happen in real life before we make the
    locking more complex again.

    Therefore remove the oom_lock for oom_reaper paths (both exit_mmap and
    oom_reap_task_mm).  The reaper serializes with exit_mmap by mmap_sem +
    MMF_OOM_SKIP flag.  There is no synchronization with out_of_memory path
    now.

which is in next-20180803, and my "mm, oom: Fix unnecessary killing of additional processes."
( https://marc.info/?i=1533389386-3501-4-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp )
could mitigate it. Michal and David, please respond.

