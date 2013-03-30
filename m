From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: take reference before releasing rcu_read_lock
Date: Sat, 30 Mar 2013 08:35:02 +0800
Message-ID: <51563336.701@huawei.com>
References: <51556CE9.9060000@huawei.com> <5155718A.90108@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5155718A.90108-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 2013/3/29 18:48, Glauber Costa wrote:
> On 03/29/2013 02:28 PM, Li Zefan wrote:
>> The memcg is not referenced, so it can be destroyed at anytime right
>> after we exit rcu read section, so it's not safe to access it.
>>
>> To fix this, we call css_tryget() to get a reference while we're still
>> in rcu read section.
>>
>> This also removes a bogus comment above __memcg_create_cache_enqueue().
>>
> Out of curiosity, did you see that happening ?
> 

Just by code inspection. This is not the only place you use RCU in this
wrong way. Remember the last patch I sent? ;)

> Theoretically, the race you describe seem real, and the fix is sound.
> 
