From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] oom: choose a more suitable process to kill while all
 processes are not killable
Date: Fri, 20 Dec 2019 12:37:44 +0100
Message-ID: <20191220113744.GF20332@dhcp22.suse.cz>
References: <1576823172-25943-1-git-send-email-zgpeng.linux@gmail.com>
 <20191220071334.GB20332@dhcp22.suse.cz>
 <CAE5vP3mHjdM-PwjUURwXgZDfgQ0b2BbgHkWZCHe-ysSmZ58pFw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE5vP3mHjdM-PwjUURwXgZDfgQ0b2BbgHkWZCHe-ysSmZ58pFw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?utf-8?B?5b2t5b+X5Yia?= <zgpeng.linux@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, zgpeng <zgpeng@tencent.com>

[Please do not top post]

On Fri 20-12-19 17:56:20, 彭志刚 wrote:
> certainly.
> 
> Steps to reproduce:
> (1)Create a mm cgroup and set memory.limit_in_bytes
> (2)Move the bash process to the newly created cgroup, and set the
> oom_score_adj of the  bash process to -998.
> (3)In bash, start multiple processes, each process consumes different
> memory until cgroup oom is triggered.
> 
> The triggered phenomenon is shown below. We can see that when cgroup oom
> happened, process 23777 was killed, but in fact, 23772 consumes more memory;
> 
> [  591.000970] Tasks state (memory values in pages):
> [  591.000970] [  pid  ]   uid  tgid total_vm      rss pgtables_bytes swapents oom_score_adj name
> [  591.000973] [  23344]     0 23344     2863      923    61440        0        -998 bash
> [  591.000975] [  23714]     0 23714    27522    25935   258048        0        -998 test
> [  591.000976] [  23772]     0 23772   104622   103032   876544        0        -998 test

points = 103032 + 0 + 876544/4096 = 103246

> [  591.000978] [  23777]     0 23777    78922    77335   667648        0        -998 test

points = 77335 + 0 + 667648/4096 = 77498

It is not clear what is the actual hard limit but let's assume that
rss+page_tables is the only charged memory (or at least the majority of
it). That would be 207680 so the normalized oom_score_adj would be
-206586 which is way too big for both tasks so from the OOM killer
perspective both tasks are equal.

The question is whether this is a bug or a (mis)feature. The
oom_score_adj je documented as follows:
Documentation/filesystems/proc.txt
: Consequently, it is very simple for userspace to define the amount of memory to
: consider for each task.  Setting a /proc/<pid>/oom_score_adj value of +500, for
: example, is roughly equivalent to allowing the remainder of tasks sharing the
: same system, cpuset, mempolicy, or memory controller resources to use at least
: 50% more memory.  A value of -500, on the other hand, would be roughly
: equivalent to discounting 50% of the task's allowed memory from being considered
: as scoring against the task.

Which implies that we are talking about the budget based on a usable
memory (aka hard limit in this case). I do agree that the semantic is
awkward. I know there are usecases which try to use the existing scheme
for oom_score_adj to fine tune oom decisions and I am worried your patch
might break those.

That being said, I am not sure this change is safe wrt. to backward
compatibility. I would rather recommend to not using oom_score_adj for
anything but OOM_SCORE_ADJ_MIN resp OOM_SCORE_ADJ_MAX.
-- 
Michal Hocko
SUSE Labs
