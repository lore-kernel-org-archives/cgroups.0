From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v11 00/15] kmemcg shrinkers
Date: Wed, 27 Nov 2013 09:47:42 +1100
Message-ID: <20131126224742.GB10988@dastard>
References: <cover.1385377616.git.vdavydov@parallels.com>
 <20131125174135.GE22729@cmpxchg.org>
 <529443E4.7080602@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <529443E4.7080602@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org, mhocko@suse.cz, glommer@openvz.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org

On Tue, Nov 26, 2013 at 10:47:00AM +0400, Vladimir Davydov wrote:
> Hi,
> 
> Thank you for the review. I agree with all your comments and I'll
> resend the fixed version soon.
> 
> If anyone still has something to say about the patchset, I'd be glad
> to hear from them.

Please CC me on all the shrinker/list-lru changes being made as I am
the original author of the list-lru code and the shrinker
integration and have more than a passing interest in ensuring
it doesn't get broken or crippled....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
