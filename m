From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v10 12/35] shrinker: add node awareness
Date: Thu, 6 Jun 2013 12:23:26 +0400
Message-ID: <51B046FE.30507@parallels.com>
References: <1370287804-3481-1-git-send-email-glommer@openvz.org> <1370287804-3481-13-git-send-email-glommer@openvz.org> <20130605160810.5b203c3368b9df7d087ee3b1@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130605160810.5b203c3368b9df7d087ee3b1-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 06/06/2013 03:08 AM, Andrew Morton wrote:
> On Mon,  3 Jun 2013 23:29:41 +0400 Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> 
>> From: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>> Pass the node of the current zone being reclaimed to shrink_slab(),
>> allowing the shrinker control nodemask to be set appropriately for
>> node aware shrinkers.
> 
> Again, some musings on node hotplug would be interesting.
> 
>> --- a/drivers/staging/android/ashmem.c
>> +++ b/drivers/staging/android/ashmem.c
>> @@ -692,6 +692,9 @@ static long ashmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>>  				.gfp_mask = GFP_KERNEL,
>>  				.nr_to_scan = 0,
>>  			};
>> +
>> +			nodes_setall(sc.nodes_to_scan);
> 
> hm, is there some way to do this within the initializer? ie:
> 
> 				.nodes_to_scan = magic_goes_here(),
> 
> Also, it's a bit sad to set bits for not-present and not-online nodes.
> 

Unfortunately there is no "nodes_setpresent" or anything like that in
nodemask.h. Maybe I should just go ahead and write them.
