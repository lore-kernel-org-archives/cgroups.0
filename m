From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v10 08/35] list: add a new LRU list type
Date: Thu, 6 Jun 2013 18:28:33 +0400
Message-ID: <51B09C91.4010104@parallels.com>
References: <1370287804-3481-1-git-send-email-glommer@openvz.org> <1370287804-3481-9-git-send-email-glommer@openvz.org> <20130605160758.19e854a6995e3c2a1f5260bf@linux-foundation.org> <20130606024909.GP29338@dastard>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130606024909.GP29338@dastard>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 06/06/2013 06:49 AM, Dave Chinner wrote:
>> > How [patch 09/35]'s inode_lru_isolate() avoids this bug I don't know. 
>> > Perhaps it doesn't.
> The LRU_RETRY cse is supposed to handle this. However, the LRU_RETRY
> return code is now buggy and you've caught that. It'll need fixing.
> My original code only had inode_lru_isolate() drop the lru lock, and
> it would return LRU_RETRY which would restart the scan of the list
> from the start, thereby avoiding those problems.
> 
Yes, I have changed that, but I wasn't aware that your original
intention for restarting from the beginning was to avoid such problems.
And having only half the brain Andrew has, I didn't notice it myself.

I will fix this somehow while trying to keep the behavior Mel insisted
on; iow; not retrying forever.
