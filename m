From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH 6/9] cgroup_freezer: make freezer->state mask of flags
Date: Thu, 08 Nov 2012 14:00:34 +0900
Message-ID: <509B3C72.3050904@jp.fujitsu.com>
References: <1351931915-1701-1-git-send-email-tj@kernel.org> <1351931915-1701-7-git-send-email-tj@kernel.org> <509B371E.9050005@jp.fujitsu.com> <20121108044255.GG2660@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121108044255.GG2660-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(2012/11/08 13:42), Tejun Heo wrote:
> Hello, Kame.
>
> On Thu, Nov 08, 2012 at 01:37:50PM +0900, Kamezawa Hiroyuki wrote:
>> How about
>> enum {
>>     __CGROUP_FREEZING,
>>     __CGROUP_FROZEN,
>> };
>>
>> #define CGROUP_FREEZER_STATE_MASK  0x3
>> #define CGROUP_FREEZER_STATE(state)	((state) & CGROUP_FREEZER_STATE_MASK)
>> #define CGROUP_THAW(state)	(CGROUP_FREEZER_STATE(state) == 0)
>> #define CGROUP_FREEZING(state)	(CGROUP_FREEZER_STATE(state) == __CGROUP_FREEZING)
>> #define CGROUP_FROZEN(state)\
>> 	(CGROUP_FREEZER_STATE(state) == (__CGROUP_FREEZING | __CGROUP_FROZEN))
>
> I think it's a bit overdone and we have cases where we test for
> FREEZING regardless of FROZEN and cases where test for FREEZING &&
> !FROZEN.  We can have, say, CGROUP_FREZING() and then
> CGROUP_FREEZING_BUT_NOT_FROZEN(), but it feels more like obfuscation
> than anything else.
>

Hm, then, I'm glad if I can see what combinations of flags are valid and
meanings of them in source code comments.

Anyway,
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

