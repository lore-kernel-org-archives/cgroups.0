From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: WARNING in try_charge
Date: Tue, 7 Aug 2018 01:02:07 +0900
Message-ID: <4bf70718-59fd-dcad-c20e-8601cd665bca@i-love.sakura.ne.jp>
References: <0000000000006350880572c61e62@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0000000000006350880572c61e62@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: mhocko@kernel.org
Cc: syzbot <syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com>, cgroups@vger.kernel.org, dvyukov@google.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, vdavydov.dev@gmail.com

On 2018/08/07 0:42, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer still triggered crash:
> WARNING in try_charge
> 
> Killed process 6410 (syz-executor5) total-vm:37708kB, anon-rss:2128kB, file-rss:0kB, shmem-rss:0kB
> oom_reaper: reaped process 6410 (syz-executor5), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
> task=syz-executor5 pid=6410 invoked memcg oom killer. oom_victim=1
> ------------[ cut here ]------------
> Memory cgroup charge failed because of no reclaimable memory! This looks like a misconfiguration or a kernel bug.
> WARNING: CPU: 1 PID: 6410 at mm/memcontrol.c:1707 mem_cgroup_oom mm/memcontrol.c:1706 [inline]
> WARNING: CPU: 1 PID: 6410 at mm/memcontrol.c:1707 try_charge+0x734/0x1680 mm/memcontrol.c:2264
> Kernel panic - not syncing: panic_on_warn set ...

Michal, this is "mm, oom: task_will_free_mem(current) should ignore MMF_OOM_SKIP for once."
problem which you are refusing at https://www.spinics.net/lists/linux-mm/msg133774.html .
