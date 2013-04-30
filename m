From: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v4 12/31] shrinker: add node awareness
Date: Tue, 30 Apr 2013 17:35:45 +0100
Message-ID: <20130430163545.GL6415@suse.de>
References: <1367018367-11278-1-git-send-email-glommer@openvz.org>
 <1367018367-11278-13-git-send-email-glommer@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1367018367-11278-13-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Sat, Apr 27, 2013 at 03:19:08AM +0400, Glauber Costa wrote:
> From: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Pass the node of the current zone being reclaimed to shrink_slab(),
> allowing the shrinker control nodemask to be set appropriately for
> node aware shrinkers.
> 
> [ v3: update ashmem ]
> Signed-off-by: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

Acked-by: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>

-- 
Mel Gorman
SUSE Labs
