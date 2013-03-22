From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
Date: Fri, 22 Mar 2013 12:22:23 +0400
Message-ID: <514C14BF.3050009@parallels.com>
References: <514A60CD.60208@huawei.com> <20130321090849.GF6094@dhcp22.suse.cz> <20130321102257.GH6094@dhcp22.suse.cz> <514BB23E.70908@huawei.com> <20130322080749.GB31457@dhcp22.suse.cz> <514C1388.6090909@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <514C1388.6090909-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On 03/22/2013 12:17 PM, Li Zefan wrote:
>> GFP_TEMPORARY groups short lived allocations but the mem cache is not
>> > an ideal candidate of this type of allocations..
>> > 
> I'm not sure I'm following you...
> 
> char *memcg_cache_name()
> {
> 	char *name = alloc();
> 	return name;
> }
> 
> kmem_cache_dup()
> {
> 	name = memcg_cache_name();
> 	kmem_cache_create_memcg(name);
> 	free(name);
> }
> 
> Isn't this a short lived allocation?
> 

Hi,

Thanks for identifying and fixing this.

Li is right. The cache name will live long, but this is because the
slab/slub caches will strdup it internally. So the actual memcg
allocation is short lived.
