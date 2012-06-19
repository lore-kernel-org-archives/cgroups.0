From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: add unlikely to mercg->move_charge_at_immigrate
Date: Tue, 19 Jun 2012 09:02:01 +0900
Message-ID: <4FDFC179.3050203@jp.fujitsu.com>
References: <1340025022-7272-1-git-send-email-liwp.linux@gmail.com> <4FDF2890.3020004@parallels.com> <20120618131918.GA2600@kernel>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120618131918.GA2600@kernel>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gavin Shan <shangw-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

(2012/06/18 22:19), Wanpeng Li wrote:
> On Mon, Jun 18, 2012 at 05:09:36PM +0400, Glauber Costa wrote:
>> On 06/18/2012 05:10 PM, Wanpeng Li wrote:
>>> From: Wanpeng Li<liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>>
>>> move_charge_at_immigrate feature is disabled by default. Charges
>>> are moved only when you move mm->owner and it also add additional
>>> overhead.
>>
>> How big is this overhead?
>>
>> That's hardly a fast path. And if it happens to matter, it will be
>> just bigger when you enable it, and the compiler start giving the
>> wrong hints to the code.
>
> Thank you for your quick response.
>
> Oh, Maybe I should just write comments "move_charge_at_immigrate feature
> is disabled by default. So add "unlikely", in order to compiler can optimize."
>

This doesn't affect the performance. likely/unlikely which doesn't affect
performance is never welcomed.

Thanks,
-Kame
