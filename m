From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] remove BUG() in possible but rare condition
Date: Wed, 11 Apr 2012 15:59:35 -0300
Message-ID: <4F85D497.6070309@parallels.com>
References: <1334167824-19142-1-git-send-email-glommer@parallels.com> <20120411184845.GA24831@tiehlicka.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120411184845.GA24831-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 04/11/2012 03:48 PM, Michal Hocko wrote:
> On Wed 11-04-12 15:10:24, Glauber Costa wrote:
>> While stressing the kernel with with failing allocations today,
>> I hit the following chain of events:
>>
>> alloc_page_buffers():
>>
>> 	bh = alloc_buffer_head(GFP_NOFS);
>> 	if (!bh)
>> 		goto no_grow;<= path taken
>>
>> grow_dev_page():
>>          bh = alloc_page_buffers(page, size, 0);
>>          if (!bh)
>>                  goto failed;<= taken, consequence of the above
>>
>> and then the failed path BUG()s the kernel.
>>
>> The failure is inserted a litte bit artificially, but even then,
>> I see no reason why it should be deemed impossible in a real box.
>>
>> Even though this is not a condition that we expect to see
>> around every time, failed allocations are expected to be handled,
>> and BUG() sounds just too much. As a matter of fact, grow_dev_page()
>> can return NULL just fine in other circumstances, so I propose we just
>> remove it, then.
>
> I am not familiar with the code much but a trivial call chain walk up to
> write_dev_supers (in btrfs) shows that we do not check for the return value
> from __getblk so we would nullptr and there might be more.
> I guess these need some treat before the BUG might be removed, right?

You might very well be right, but if this is the case, this function is 
probably wrong already.

find_or_create_page() failing will make it return NULL as well, and that 
won't trigger the BUG() path.

At least in ext4 in my test case, the filesystem seems consistent after 
a couple of runs
triggering this
