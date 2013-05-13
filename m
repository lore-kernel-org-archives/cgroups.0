From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v6 15/31] fs: convert fs shrinkers to new scan/count API
Date: Mon, 13 May 2013 11:28:16 +0400
Message-ID: <51909610.1010801@parallels.com>
References: <1368382432-25462-1-git-send-email-glommer@openvz.org>  <1368382432-25462-16-git-send-email-glommer@openvz.org> <1368425530.3208.13.camel@sauron.fi.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1368425530.3208.13.camel-Bxnoe/o8FG+Ef9UqXRslZEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Adrian Hunter <adrian.hunter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

On 05/13/2013 10:12 AM, Artem Bityutskiy wrote:
> On Sun, 2013-05-12 at 22:13 +0400, Glauber Costa wrote:
>> From: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>> Convert the filesystem shrinkers to use the new API, and standardise
>> some of the behaviours of the shrinkers at the same time. For
>> example, nr_to_scan means the number of objects to scan, not the
>> number of objects to free.
>>
>> I refactored the CIFS idmap shrinker a little - it really needs to
>> be broken up into a shrinker per tree and keep an item count with
>> the tree root so that we don't need to walk the tree every time the
>> shrinker needs to count the number of objects in the tree (i.e.
>> all the time under memory pressure).
> 
> UBIFS part looks OK.
> 
Great. Could I add your acked or reviewed by tag ?
