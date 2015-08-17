From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 1/3] cgroup: define controller file conventions
Date: Tue, 18 Aug 2015 00:04:48 +0200
Message-ID: <20150817220448.GC29138@cmpxchg.org>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
 <1438641689-14655-2-git-send-email-tj@kernel.org>
 <20150804193101.GI17598@mtj.duckdns.org>
 <55C15B4C.9080202@jp.fujitsu.com>
 <20150805074758.GA11182@dhcp22.suse.cz>
 <55C2C6B0.3080203@jp.fujitsu.com>
 <20150807181722.GA24877@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150807181722.GA24877@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Tejun Heo <tj@kernel.org>, mingo@redhat.com, peterz@infradead.org, lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, Aug 07, 2015 at 08:17:23PM +0200, Michal Hocko wrote:
> On Thu 06-08-15 11:30:08, KAMEZAWA Hiroyuki wrote:
> >  - *.oom_control      - for surviving/notifiyng out of memory
> >                         memcg's oom can be recovered if limit goes up rather than kill.
> 
> I think it is very much useful - when used wisely. I have seen many
> calls for user defined OOM policies but then we have seen those that are
> more creative like having the policy maker live in the same memcg which
> requires some hacks to prevent from self-deadlocks.
> So overall this is very attractive but we might need to think about a
> better interface. BPF sounds like a potential way to go. I feel the
> memcg and the global approaches should be consistent as much as possible
> wrt. API.

I'm not sure I still see a usecase for this.

The whole idea behind memory.high is to give the user the chance to
monitor the group's health and then act upon that. You can freeze the
group if you must, gather information, kill tasks. This is the way to
implement a custom OOM policy.

memory.max on the other hand tells the *kernel* when to OOM, with all
the implications that a kernel OOM has. Don't configure that when you
don't want your tasks killed.
