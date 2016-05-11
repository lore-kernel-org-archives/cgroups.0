From: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Documentation/memcg: remove restriction of setting kmem
 limit
Date: Wed, 11 May 2016 13:54:10 +0800
Message-ID: <5732C902.8020006@huawei.com>
References: <572B0105.50503@huawei.com> <20160505083221.GD4386@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160505083221.GD4386-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: corbet-T1hC0tSOHrs@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On 2016/5/5 16:32, Michal Hocko wrote:
> On Thu 05-05-16 16:15:01, Qiang Huang wrote:
>> We don't have this restriction for a long time, docs should
>> be fixed.
>>
>> Signed-off-by: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>  Documentation/cgroup-v1/memory.txt | 8 +++-----
>>  1 file changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/Documentation/cgroup-v1/memory.txt b/Documentation/cgroup-v1/memory.txt
>> index ff71e16..d45b201 100644
>> --- a/Documentation/cgroup-v1/memory.txt
>> +++ b/Documentation/cgroup-v1/memory.txt
>> @@ -281,11 +281,9 @@ different than user memory, since it can't be swapped out, which makes it
>>  possible to DoS the system by consuming too much of this precious resource.
>>  
>>  Kernel memory won't be accounted at all until limit on a group is set. This
>> -allows for existing setups to continue working without disruption.  The limit
>> -cannot be set if the cgroup have children, or if there are already tasks in the
>> -cgroup. Attempting to set the limit under those conditions will return -EBUSY.
>> -When use_hierarchy == 1 and a group is accounted, its children will
>> -automatically be accounted regardless of their limit value.
>> +allows for existing setups to continue working without disruption. When
>> +use_hierarchy == 1 and a group is accounted, its children will automatically
>> +be accounted regardless of their limit value.
> The restriction is not there anymore because the accounting is enabled
> by default even in the cgroup v1 - see b313aeee2509 ("mm: memcontrol:
> enable kmem accounting for all cgroups in the legacy hierarchy"). So
> this _whole_ paragraph could see some update.

Sorry for the delay.
Thanks for the hint, I'll sent a new patch soon.


