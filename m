From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: add cgroup.stat interface with basic hierarchy
 stats
Date: Thu, 27 Jul 2017 13:55:57 -0400
Message-ID: <da7c5db5-355b-28aa-dbf8-9a0b6eb6c66e@redhat.com>
References: <20170727161420.2552-1-guro@fb.com>
 <6a72e074-e01f-b93f-2c03-2bd0366d005b@redhat.com>
 <20170727174613.GA6457@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170727174613.GA6457-B3w7+ongkCiLfgCeKHXN1g2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 07/27/2017 01:46 PM, Roman Gushchin wrote:
> On Thu, Jul 27, 2017 at 01:38:55PM -0400, Waiman Long wrote:
>> On 07/27/2017 12:14 PM, Roman Gushchin wrote:
>>> Add a cgroup.stat interface to the base cgroup control files
>>> with the following metrics:
>>>
>>> nr_descendants		total number of descendant cgroups
>>> nr_dying_descendants	total number of dying descendant cgroups
>>> max_descendant_depth	maximum descent depth below the current cgroup
>> Both nr_descendants and max_descendant_depth can be found easily from
>> userspace by scanning the cgroup directory. nr_dying_descendants is a
>> transient figure and it should be 0 most of the time. So I wonder how
>> useful it can be.
>>
>> This new interface file will be more useful if it can reveal information
>> that cannot be easily obtained by looking from userspace alone.
> A cgroup can be in dying state for substantional amount of time
> (imagine a memcg which holds a page mlocked by a process in an other cgroup).
>
> The total amount of cgroups, as well as tree depth include dying cgroups,
> which are not visible from the userspace.
>
> The main purpose of this interface is to have a reasonable way to check if
> there are no leaks/refcounting issues, which prevents cgroups from being
> completely freed.
>

If that is the use case, I am OK with that. However, you may want to
document that either in the commit log or in the comment. Maybe you can
also list the full path of the offlined cgroups if it is what you are
looking for.

Cheers,
Longman
