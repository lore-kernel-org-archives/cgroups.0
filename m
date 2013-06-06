From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v10 03/35] dcache: convert dentry_stat.nr_unused to
 per-cpu counters
Date: Wed, 5 Jun 2013 19:48:01 -0700
Message-ID: <20130605194801.f9b25abf.akpm@linux-foundation.org>
References: <1370287804-3481-1-git-send-email-glommer@openvz.org>
	<1370287804-3481-4-git-send-email-glommer@openvz.org>
	<20130605160731.91a5cd3ff700367f5e155d83@linux-foundation.org>
	<20130606014509.GN29338@dastard>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130606014509.GN29338@dastard>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Chinner <david@fromorbit.com>
Cc: Glauber Costa <glommer@openvz.org>, linux-fsdevel@vger.kernel.org, Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, hughd@google.com, Greg Thelen <gthelen@google.com>, Dave Chinner <dchinner@redhat.com>

On Thu, 6 Jun 2013 11:45:09 +1000 Dave Chinner <david@fromorbit.com> wrote:

> Andrew, if you want to push the changes back to generic per-cpu
> counters through to Linus, then I'll write the patches for you.  But
> - and this is a big but - I'll only do this if you are going to deal
> with the "performance trumps all other concerns" fanatics over
> whether it should be merged or not. I have better things to do
> with my time have a flamewar over trivial details like this.

Please view my comments as a critique of the changelog, not of the code. 

There are presumably good (but undisclosed) reasons for going this way,
but this question is so bleeding obvious that the decision should have
been addressed up-front and in good detail.

And, preferably, with benchmark numbers.  Because it might have been
the wrong decision - stranger things have happened.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
