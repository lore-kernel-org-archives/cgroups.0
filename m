From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: WARNING in try_charge
Date: Tue, 7 Aug 2018 05:26:23 +0900
Message-ID: <078bde8d-b1b5-f5ad-ed23-0cd94b579f9e@i-love.sakura.ne.jp>
References: <fc6e173e-8bda-269f-d44f-1c5f5215beac@I-love.SAKURA.ne.jp>
 <0000000000006350880572c61e62@google.com>
 <20180806174410.GB10003@dhcp22.suse.cz>
 <20180806175627.GC10003@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180806175627.GC10003@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@kernel.org>, syzbot <syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com>
Cc: cgroups@vger.kernel.org, dvyukov@google.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, vdavydov.dev@gmail.com

On 2018/08/07 2:56, Michal Hocko wrote:
> So the oom victim indeed passed the above force path after the oom
> invocation. But later on hit the page fault path and that behaved
> differently and for some reason the force path hasn't triggered. I am
> wondering how could we hit the page fault path in the first place. The
> task is already killed! So what the hell is going on here.
> 
> I must be missing something obvious here.
> 
YOU ARE OBVIOUSLY MISSING MY MAIL!

I already said this is "mm, oom: task_will_free_mem(current) should ignore MMF_OOM_SKIP for once."
problem which you are refusing at https://www.spinics.net/lists/linux-mm/msg133774.html .
And you again ignored my mail. Very sad...
