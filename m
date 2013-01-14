From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v2 0/2] slightly change shrinker behaviour for very small
 object sets
Date: Mon, 14 Jan 2013 11:58:36 -0800
Message-ID: <50F4636C.6030908@parallels.com>
References: <1356086810-6950-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1356086810-6950-1-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, Dave Shrinnker <david@fromorbit.com>, Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, kamezawa.hiroyu@jp.fujitsu.com

On 12/21/2012 02:46 AM, Glauber Costa wrote:
> Hi,
> 
> * v2: fix sysctl_vfs_cache_pressure for all users.
> 
> I've recently noticed some glitches in the object shrinker mechanism when a
> very small number of objects is used. Those situations are theoretically
> possible, albeit unlikely. But although it may feel like it is purely
> theoretical, they can become common in environments with many small containers
> (cgroups) in a box.
> 
> Those patches came from some experimentation I am doing with targetted-shrinking
> for kmem-limited memory cgroups (Dave Shrinnker is already aware of such work).
> In such scenarios, one can set the available memory to very low limits, and it
> becomes easy to see this.
> 
> 
Hi,

Who should pick this one up?

Are there any comments aside from Dave's Reviewed-by tag that I wrongly
transcribed?

Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
