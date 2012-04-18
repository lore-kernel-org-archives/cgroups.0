From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v1 0/7] memcg remove pre_destroy
Date: Wed, 18 Apr 2012 16:15:12 +0900
Message-ID: <4F8E6A00.50707@jp.fujitsu.com>
References: <4F86B9BE.8000105@jp.fujitsu.com> <CALWz4izGo4aCyC7xbWyL+yfNiaUmZXPwD8bLgJVpqtcAGfyJ9w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALWz4izGo4aCyC7xbWyL+yfNiaUmZXPwD8bLgJVpqtcAGfyJ9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

(2012/04/18 2:35), Ying Han wrote:

> On Thu, Apr 12, 2012 at 4:17 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
>> In recent discussion, Tejun Heo, cgroup maintainer, has a plan to remove
>> ->pre_destroy(). And now, in cgroup tree, pre_destroy() failure cause WARNING.
>>
>> By pre_destroy(), rmdir of cgroup can return -EBUSY or some error.
>> It makes cgroup complicated and unstable. I said O.K. to remove it and
>> this patch is modification for memcg.
>>
>> One of problem in current implementation is that memcg moves all charges to
>> parent in pre_destroy(). At doing so, if use_hierarchy=0, pre_destroy() may
>> hit parent's limit and may return -EBUSY. To fix this problem, this patch
>> changes behavior of rmdir() as
>>
>>  - if use_hierarchy=0, all remaining charges will go to root cgroup.
>>  - if use_hierarchy=1, all remaining charges will go to the parent.
> 
> 
> We need to update the "4.3 Removing a cgroup" session in Documentation.
> 


Sure, will do.

Thanks,
-Kame
