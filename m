From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v1 0/7] memcg remove pre_destroy
Date: Sat, 14 Apr 2012 03:49:15 +0530
Message-ID: <87vcl3gtr0.fsf@skywalker.in.ibm.com>
References: <4F86B9BE.8000105@jp.fujitsu.com> <20120412160642.GA13069@google.com> <877gxksrq1.fsf@skywalker.in.ibm.com> <4F876C70.7060600@jp.fujitsu.com> <20120413085014.GA9205@tiehlicka.suse.cz>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120413085014.GA9205-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-mm@kvack.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups@vger.kernel.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> writes:

> On Fri 13-04-12 08:59:44, KAMEZAWA Hiroyuki wrote:
>> (2012/04/13 3:57), Aneesh Kumar K.V wrote:
>> 
>> > Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:
>> > 
>> >> Hello, KAMEZAWA.
>> >>
>> >> Thanks a lot for doing this.
>> >>
>> >> On Thu, Apr 12, 2012 at 08:17:18PM +0900, KAMEZAWA Hiroyuki wrote:
>> >>> In recent discussion, Tejun Heo, cgroup maintainer, has a plan to remove
>> >>> ->pre_destroy(). And now, in cgroup tree, pre_destroy() failure cause WARNING.
>> >>
>> >> Just to clarify, I'm not intending to ->pre_destroy() per-se but the
>> >> retry behavior of it, so ->pre_destroy() will be converted to return
>> >> void and called once on rmdir and rmdir will proceed no matter what.
>> >> Also, with the deprecated behavior flag set, pre_destroy() doesn't
>> >> trigger the warning message.
>> >>
>> >> Other than that, if memcg people are fine with the change, I'll be
>> >> happy to route the changes through cgroup/for-3.5 and stack rmdir
>> >> simplification patches on top.
>> >>
>> > 
>> > Any suggestion on how to take HugeTLB memcg extension patches [1]
>> > upstream. Current patch series I have is on top of cgroup/for-3.5
>> > because I need cgroup_add_files equivalent and cgroup/for-3.5 have
>> > changes around that. So if these memcg patches can also go on top of
>> > cgroup/for-3.5 then I can continue to work on top of cgroup/for-3.5 ?
>
> I would suggest working on top of memcg-devel tree or on top linux-next.
> Just pull the required patch-es from cgroup/for-3.5 tree before your
> work (I can include that into memcg-devel tree for you if you want).

I am expecting to have no conflicts with pending memcg changes. But I do
have conflicts with cgroup/for-3.5. That is the reason I decided to
rebase on top of cgroup/for-3.5. 


>
> Do you think this is a 3.5 material? I would rather wait some more. I
> didn't have time to look over it yet and there are still some unresolved
> issues so it sounds like too early for merging.


I would really like to get it merged for 3.5. I am ready to post V6 that
address all review feedback from V5 post. 


>
>> > Can HugeTLB memcg extension patches also go via this tree ? It
>> > should actually got via -mm. But then how do we take care of these
>> > dependencies ?
>
> You are not changing anything generic from cgroup so definitely go via
> Andrew.
>

agreed.


>> I'm not in hurry. To be honest, I cannot update patches until the next Wednesday.
>> So, If changes of cgroup tree you required are included in linux-next. Please post
>> your updated ones. I thought your latest version was near to be merged....
>> 
>> How do you think, Michal ?
>> Please post (and ask Andrew to pull it.) I'll review when I can.
>
> I would wait with pulling the patch after the review.
>

agreed. So I will do a v6 post and if we all agree with the changes it
can be pulled via -mm ?


>> I know yours and mine has some conflicts. I think my this series will
>> be onto your series. To do that, I hope your series are merged to
>> linux-next, 1st.
>> 

-aneesh
