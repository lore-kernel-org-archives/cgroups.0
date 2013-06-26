From: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.11] cgroup: grab cgroup_mutex in drop_parsed_module_refcounts()
Date: Wed, 26 Jun 2013 14:51:36 -0400
Message-ID: <51CB3838.10400@oracle.com>
References: <51C9D17B.5090208@oracle.com> <20130626010454.GD30407@mtj.dyndns.org> <20130626010521.GE30407@mtj.dyndns.org> <20130626175008.GF4405@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130626175008.GF4405-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trinity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 06/26/2013 01:50 PM, Tejun Heo wrote:
> On Tue, Jun 25, 2013 at 06:05:21PM -0700, Tejun Heo wrote:
>> This isn't strictly necessary as all subsystems specified in
>> @subsys_mask are guaranteed to be pinned; however, it does spuriously
>> trigger lockdep warning.  Let's grab cgroup_mutex around it.
>>
>> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> Applied both patches to cgroup/for-3.11.

FWIW, for both patches,

	Tested-by: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>


Thanks,
Sasha
