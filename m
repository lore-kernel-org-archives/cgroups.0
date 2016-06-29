From: Aleksa Sarai <asarai@suse.de>
Subject: Re: [PATCH 1/2] cgroup: pids: show number of failed forks since limit
 reset
Date: Wed, 29 Jun 2016 15:10:26 +1000
Message-ID: <ec289e47-9761-ff21-b264-1391aa22cfd4@suse.de>
References: <20160624030049.13341-1-asarai@suse.de>
 <20160624030049.13341-2-asarai@suse.de>
 <20160624153151.GQ3262@mtj.duckdns.org>
 <78d17b23-d712-7d9c-3655-34c646bc4897@suse.de>
 <20160626234258.GJ9219@stj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20160626234258.GJ9219@stj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Kenny Yu <kennyyu@fb.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

> On Sun, Jun 26, 2016 at 09:34:41PM +1000, Aleksa Sarai wrote:
>> If a user has a setup where they wait for notifications on changes to
>> pids.event, and then auto-adjust the cgroup limits based on the number of
>> failures you have a race condition between reading the pids.event file and
>> then setting the new limit. Then, upon getting notified again there may have
>> been many failed forks with the old limit set, so you might decide to bump
>> up the limit again.
>>
>> It's not a huge deal, I just though it could be useful to alleviate problems
>> like the above.
>
> This is something which can easily be avoided from userland.  I don't
> think we need to add extra facilities for this.

Maybe I'm misunderstanding what the purpose of pids.events is meant to 
be. If it's just meant to be a "hint" to the administrator, then that 
seems like an awfully odd way of giving hints (the kernel logging should 
be enough for that). If it's meant so that the administrator can make 
policy decisions, then she won't know if the change in failures happened 
before or after she adjusted the limit.

I also don't see what you mean by "it can be avoided from userland". 
There's a race between changing pids.max and a process forking that 
causes pids.events to be updated.

-- 
Aleksa Sarai
Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/
