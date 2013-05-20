From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v7 18/34] fs: convert fs shrinkers to new scan/count API
Date: Tue, 21 May 2013 03:42:34 +0400
Message-ID: <519AB4EA.60905@parallels.com>
References: <1368994047-5997-1-git-send-email-glommer@openvz.org> <1368994047-5997-19-git-send-email-glommer@openvz.org> <1369038304.2728.37.camel@menhir> <519A2951.9040908@parallels.com> <519A407B.9030205@parallels.com> <20130520233807.GD24543@dastard>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130520233807.GD24543@dastard>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Adrian Hunter <adrian.hunter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On 05/21/2013 03:38 AM, Dave Chinner wrote:
>> If you for any reason wanted nr_to_scan to mean # of objects *scanned*,
>> > not freed, IOW, if this is not a mistake, please say so and justify.
> Justification presented. nr_to_scan has *always* meant "# of objects
> *scanned*", and this patchset does not change that.
> 
> Cheers,
> 
> Dave.
Good.

Thanks Dave, it makes sense.

I proactively changed this, but I will revert the changes tomorrow - and
just to be sure, audit again, but this time looking for the right thing.
