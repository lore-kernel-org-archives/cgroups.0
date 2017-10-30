From: "Maciej S. Szmigiero" <mail-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>
Subject: Re: [PATCH] cfq-iosched: add "leaf_weight" setting for the root
 cgroup in cgroups v2
Date: Mon, 30 Oct 2017 17:02:41 +0100
Message-ID: <7acef26f-3c11-6623-a95d-fefd06f555a0@maciej.szmigiero.name>
References: <a1828795-3f51-9455-9d0b-93f9dcfb6fd4@maciej.szmigiero.name>
 <20171030145526.GB3252168@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171030145526.GB3252168-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 30.10.2017 15:55, Tejun Heo wrote:
> On Sun, Oct 29, 2017 at 05:36:53PM +0100, Maciej S. Szmigiero wrote:
>> CFQ scheduler has a property that processes (or tasks in cgroups v1) that
>> aren't assigned to any particular cgroup - that is, which stay in the root
>> cgroup - effectively form an implicit leaf child node attached to the root
>> cgroup.
>>
>> This behavior is documented in blkio-controller.txt for cgroups v1, however
>> as far as I know it isn't documented anywhere for cgroups v2 besides a
>> generic remark that "How resource consumption in the root cgroup is
>> governed is up to each controller" in cgroup-v2.txt.
>>
>> By default, this implicit leaf child node has a (CFQ) weight which is two
>> times higher that the default weight of a child cgroup.
>>
>> cgroups v1 provide a "leaf_weight" setting which allow changing this value.
>> However, this setting is missing from cgroups v2 and so the only way to
>> tweak how much IO time processes in the root cgroup get is to adapt
>> weight settings of all child cgroups accordingly.
>> Let's add a "leaf_weight" setting to the root cgroup in cgroups v2, too.
>>
>> Note that new kernel threads appear in the root cgroup and there seems to
>> be no way to change this since kthreadd cannot be moved to another cgroup
>> (for a good reason).
>>
>> Signed-off-by: Maciej S. Szmigiero <mail-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>
> 
> I don't think we wanna do this.  It's inconsistent with what other
> controllers do 

And what do other (cgroup v2) controllers do in this case?
The only other controller that I know about that divides a shared resource
by weights is the cpu controller but it isn't implemented for cgroups v2
yet.

If this controller (cpu) is going to behave the same way in cgroups v2 as
it is in cgroups v1 with respect to processes in the root cgroup (mapping
priorities to weights) then it won't have this problem.

The "leaf_weight" name is both consistent with how this setting is named
in cgroups v1 and also underlines that this isn't a normal "weight"
setting, which apply at a parent cgroup level.

> and we want to charge the IOs in the root cgroup to the
> right cgroup.

As long as it is possible to have process in the root cgroup there has to
be some policy how resources are distributed to these processes.

It's only that currently for cgroups v2 this policy is undocumented and
has a hardcoded weight setting (of 200).
This patch documents this behaviors and makes it adjustable, just as it
is in cgroups v1.

> Thanks.

Thanks,
Maciej
