From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 1/3] sched: fix confusing PFA_NO_NEW_PRIVS constant
Date: Thu, 25 Sep 2014 09:42:23 +0800
Message-ID: <542372FF.4020808@huawei.com>
References: <542124D3.9000007@huawei.com> <20140924132218.GC16555@htj.dyndns.org> <20140924133513.GD16555@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140924133513.GD16555-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Miao Xie <miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 2014/9/24 21:35, Tejun Heo wrote:
> On Wed, Sep 24, 2014 at 09:22:18AM -0400, Tejun Heo wrote:
>> On Tue, Sep 23, 2014 at 03:44:19PM +0800, Zefan Li wrote:
>>> From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
>>>
>>> Commit 1d4457f99928 ("sched: move no_new_privs into new atomic flags")
>>> defined PFA_NO_NEW_PRIVS as hexadecimal value, but it is confusing
>>> because it is used as bit number. Redefine it as decimal bit number.
>>>
>>> Note this changes the bit position of PFA_NOW_NEW_PRIVS from 1 to 0.
>>>
>>> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>>> Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>> Cc: Miao Xie <miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
>>> Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>>> Signed-off-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
>>> Acked-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>>> [ lizf: slightly modified subject and changelog ]
>>> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>
>> Applied 1-3 to cgroup/for-3.17-fixes w/ the typo spotted by davidr
>> fixed.
> 
> Reverted due to build failure.  Will wait for a refreshed version. :(
> 

Didn't notice mm/slab.c uses PF_SPREAD_SLAB without the cpuset wrapper...
