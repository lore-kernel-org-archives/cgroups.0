From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: WARNING in try_charge
Date: Tue, 7 Aug 2018 00:12:01 +0900
Message-ID: <570de9f7-eda8-ec72-a4d0-92b4cc2b4fd7@i-love.sakura.ne.jp>
References: <884de816-671a-44d4-a6a1-2ad7eff53715@I-love.SAKURA.ne.jp>
 <00000000000070698b0572c28ebc@google.com>
 <20180806113212.GK19540@dhcp22.suse.cz>
 <39db7dbc-fedf-a86e-3c8b-0192e83d3c8d@i-love.sakura.ne.jp>
 <20180806145833.GA8607@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180806145833.GA8607@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@kernel.org>
Cc: syzbot <syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com>, cgroups@vger.kernel.org, dvyukov@google.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, vdavydov.dev@gmail.com, David Howells <dhowells@redhat.com>

On 2018/08/06 23:58, Michal Hocko wrote:
>> Since I can't find mm related changes between next-20180803 (syzbot can reproduce) and
>> next-20180806 (syzbot has not reproduced), I can't guess what makes this problem go away.
> 
> Hmm, but original report was against 4.18.0-rc6-next-20180725+ kernel.
> And that one had the old group oom code. /me confused.
> 

Yes. But I confirmed that syzbot can reproduce this problem with next-20180803
which already dropped the old group oom code. Therefore, I think that syzbot is
hitting a problem other than the old group oom code.
