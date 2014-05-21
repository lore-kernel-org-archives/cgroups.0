From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.16] cgroup: clean up MAINTAINERS entries
Date: Wed, 21 May 2014 14:42:07 +0900
Message-ID: <537C3CAF.5080204@jp.fujitsu.com>
References: <20140513194958.GD28815@htj.dyndns.org> <20140519203339.GE27506@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140519203339.GE27506-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

(2014/05/20 5:33), Tejun Heo wrote:
> On Tue, May 13, 2014 at 03:49:58PM -0400, Tejun Heo wrote:
>> There are currently three cgroup related entries in MAINTAINERS.  Make
>> the following updates.
>>
>> * Make the names - both cgroup and cpuset - singular.  We're mixing
>>    singular and plural all over the place for no good reason.
>>
>> * Drop containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org from CGROUP.  That list
>>    doesn't have much to do with cgroup per-se.
>>
>> * Add Documentation field to CGROUP.
>>
>> * Drop mm/*cgroup* from CGROUP.  memcg has separate maintainers.
>>
>> * Prefix the controller-specific ones with "CONTROL CGROUP -" and
>>    collect cgroup related entries under the core one.
>>
>> * Add (MEMCG) abbreviation to MEMCG entry.
>>
>> * Drop Balbir Singh and KAMEZAWA Hiroyuki from memcg maintainers.  It
>>    has been quite a while since both actually worked on memcg.
>>
>> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> Applied to cgroup/for-3.16.
>
thank you.

-Kame
  

