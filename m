From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v1 0/7] memcg remove pre_destroy
Date: Fri, 13 Apr 2012 00:27:42 +0530
Message-ID: <877gxksrq1.fsf@skywalker.in.ibm.com>
References: <4F86B9BE.8000105@jp.fujitsu.com> <20120412160642.GA13069@google.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120412160642.GA13069-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm@kvack.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups@vger.kernel.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

> Hello, KAMEZAWA.
>
> Thanks a lot for doing this.
>
> On Thu, Apr 12, 2012 at 08:17:18PM +0900, KAMEZAWA Hiroyuki wrote:
>> In recent discussion, Tejun Heo, cgroup maintainer, has a plan to remove
>> ->pre_destroy(). And now, in cgroup tree, pre_destroy() failure cause WARNING.
>
> Just to clarify, I'm not intending to ->pre_destroy() per-se but the
> retry behavior of it, so ->pre_destroy() will be converted to return
> void and called once on rmdir and rmdir will proceed no matter what.
> Also, with the deprecated behavior flag set, pre_destroy() doesn't
> trigger the warning message.
>
> Other than that, if memcg people are fine with the change, I'll be
> happy to route the changes through cgroup/for-3.5 and stack rmdir
> simplification patches on top.
>

Any suggestion on how to take HugeTLB memcg extension patches [1]
upstream. Current patch series I have is on top of cgroup/for-3.5
because I need cgroup_add_files equivalent and cgroup/for-3.5 have
changes around that. So if these memcg patches can also go on top of
cgroup/for-3.5 then I can continue to work on top of cgroup/for-3.5 ?

Can HugeTLB memcg extension patches also go via this tree ? It
should actually got via -mm. But then how do we take care of these
dependencies ?

[1]  http://thread.gmane.org/gmane.linux.kernel.cgroups/1517

-aneesh
