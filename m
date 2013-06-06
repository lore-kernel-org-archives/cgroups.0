From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v10 08/35] list: add a new LRU list type
Date: Thu, 6 Jun 2013 02:55:17 -0700
Message-ID: <20130606025517.8400c279.akpm@linux-foundation.org>
References: <1370287804-3481-1-git-send-email-glommer@openvz.org>
	<1370287804-3481-9-git-send-email-glommer@openvz.org>
	<20130605160758.19e854a6995e3c2a1f5260bf@linux-foundation.org>
	<20130606024909.GP29338@dastard>
	<20130605200554.d4dae16f.akpm@linux-foundation.org>
	<20130606044426.GX29338@dastard>
	<20130606000409.e4333f7c.akpm@linux-foundation.org>
	<51B05069.5070404@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <51B05069.5070404@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer@parallels.com>
Cc: Dave Chinner <david@fromorbit.com>, Glauber Costa <glommer@openvz.org>, linux-fsdevel@vger.kernel.org, Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, hughd@google.com, Greg Thelen <gthelen@google.com>, Dave Chinner <dchinner@redhat.com>

On Thu, 6 Jun 2013 13:03:37 +0400 Glauber Costa <glommer@parallels.com> wrote:

>  I do think it would be more appropriate to
> > discard the lib/ idea and move it all into fs/ or mm/.
> I have no particular love for this in lib/
> 
> Most of the users are in fs/, so I see no point in mm/
> So for me, if you are really not happy about lib, I would suggest moving
> this to fs/

Always feel free to differ but yes, fs/ seems better to me.

I suggested mm/ also because that's where the shrinker core resides.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
