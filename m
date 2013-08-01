From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 6/7] cgroup: rename current_css_set_cg_links
Date: Thu, 1 Aug 2013 09:11:52 +0800
Message-ID: <51F9B5D8.4080707@huawei.com>
References: <51F8C7C5.9040608@huawei.com> <51F8C83F.6010407@huawei.com> <20130731113857.GM2810@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130731113857.GM2810-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2013/7/31 19:38, Tejun Heo wrote:
> Hello,
> 
> On Wed, Jul 31, 2013 at 04:18:07PM +0800, Li Zefan wrote:
>> As we've renamed css_set->cg_links to css_set->cgrp_links (See commit
>> 69d0206c79 "cgroup: bring some sanity to naming around cg_cgroup_link"),
>> it's better to also rename the debug file.
>>
>> As the "debug" cgroup subsystem is for debug only and acts as a sample
>> on how to write a cgroup subsystem, it's fine to change the interface.
> 
> I'd rather not do this.  It doesn't really buy us anything and stuff
> like cgrp_links isn't interesting to actual controllers anyway.
> 

not a big deal
