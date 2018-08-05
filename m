From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: WARNING in try_charge
Date: Sun, 5 Aug 2018 20:33:11 +0900
Message-ID: <3d4ca33d-54cb-ca5d-95cc-034fe62e5a35@I-love.SAKURA.ne.jp>
References: <0000000000005e979605729c1564@google.com>
 <4660f164-b3e3-28a0-9898-718c5fa6b84d@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4660f164-b3e3-28a0-9898-718c5fa6b84d@I-love.SAKURA.ne.jp>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: mhocko@kernel.org, David Rientjes <rientjes@google.com>
Cc: syzbot <syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com>, cgroups@vger.kernel.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, vdavydov.dev@gmail.com

On 2018/08/04 22:45, Tetsuo Handa wrote:
> syzbot is hitting WARN(1) because of mem_cgroup_out_of_memory() == false.

Since syzbot found a syz reproducer, I asked syzbot to try two patches.

Setting MMF_OOM_SKIP under oom_lock to prevent from races
( https://syzkaller.appspot.com/x/patch.diff?x=10fb3fd0400000 ) was not sufficient.

Waiting until __mmput() completes (with timeout using OOM score feedback)
( https://syzkaller.appspot.com/x/patch.diff?x=101e449c400000 ) solved this race.
