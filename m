From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cpuset: Allow cpuset controller in default hierarchy
Date: Thu, 24 Aug 2017 11:27:58 -0400
Message-ID: <3d276b09-97fe-9908-e9ba-3a250a77362e@redhat.com>
References: <1503585611-13496-1-git-send-email-longman@redhat.com>
 <20170824144322.GP491396@devbig577.frc2.facebook.com>
 <863b01d0-e724-dab6-258e-d5980f985938@redhat.com>
 <20170824150222.GQ491396@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170824150222.GQ491396-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 08/24/2017 11:02 AM, Tejun Heo wrote:
> Hello,
>
> On Thu, Aug 24, 2017 at 10:56:21AM -0400, Waiman Long wrote:
>> The main reason for sending out this patch is to figure out what exactly
>> is in your mind before enabling cpuset in v2.
>>
>> From my point of view, the exclusive setting makes cpuset behave more
>> like a resource domain that a resource allocated to one cgroup won't be
>> available for another cgroup. So we can argue it both ways whether it
>> violates the basic hierarchy rules or not.
> It's not even siblings interfering with other siblings.  The resource
> knobs belong to the parent, right?  So, the only thing it's doing is
> restricting the parent itself from creating certain configurations,
> which can be argued to be a feature but it's a really weird policy
> enforcement implemented in kernel.

Yes, it is an unusual feature. It is basically an enforcement in kernel
of what the user space can perfectly do by itself without the
involvement by the kernel. Perhaps, we should leave it out from v2 for
now. We can always add it back when the developers ask for it, but
deleting feature once it is in is a no-no.

>> I will be in the Plumbers Conference next month and we can talk more
>> about this. My goal is to make cgroup v2 ready for prime time hopefully
>> by the end of the year.
> Sure, the only thing I think we need for cpuset is cutting down the
> interface to the minimal set which provides all the features to
> userspace.

Besides *cpus and *mems, the rests are just flags that can be turned on
or off. Maybe we could use a single cpuset.flags file to replace all
those files and use + and - prefix to turn on and off flags like
subtree_control. That should reduce the interface bloat which can be a
concern if a large number of controllers are enabled in a cgroup.

Cheers,
Longman
