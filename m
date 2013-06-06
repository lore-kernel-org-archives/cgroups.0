From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v10 08/35] list: add a new LRU list type
Date: Thu, 6 Jun 2013 15:47:29 +0400
Message-ID: <51B076D1.20007@parallels.com>
References: <1370287804-3481-1-git-send-email-glommer@openvz.org> <1370287804-3481-9-git-send-email-glommer@openvz.org> <20130605160758.19e854a6995e3c2a1f5260bf@linux-foundation.org> <20130606024909.GP29338@dastard> <20130605200554.d4dae16f.akpm@linux-foundation.org> <20130606044426.GX29338@dastard> <20130606000409.e4333f7c.akpm@linux-foundation.org> <51B05069.5070404@parallels.com> <20130606025517.8400c279.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130606025517.8400c279.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 06/06/2013 01:55 PM, Andrew Morton wrote:
> On Thu, 6 Jun 2013 13:03:37 +0400 Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> 
>>  I do think it would be more appropriate to
>>> discard the lib/ idea and move it all into fs/ or mm/.
>> I have no particular love for this in lib/
>>
>> Most of the users are in fs/, so I see no point in mm/
>> So for me, if you are really not happy about lib, I would suggest moving
>> this to fs/
> 
> Always feel free to differ but yes, fs/ seems better to me.
> 
> I suggested mm/ also because that's where the shrinker core resides.
> 
As I said, unless Dave has a strong point against it, I don't really
care if it lives in lib/ or not. It is infrastructure, but not
necessarily lib-like infrastructure.

Now, I have been thinking about this during the last hour, and as much
as all users are in fs/, putting it into mm/ would give us quite some
other advantage: namely, it has been already detected that we would like
to have, if possible, stronger ties between shrinkers, caches and the
underlying lists. We use a bunch of mm/ infrastructure, etc.

This is always something we can change if it really hurts, but right now
I am 51 % mm/ 49 % fs/

