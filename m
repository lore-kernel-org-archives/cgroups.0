From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v10 05/35] dcache: remove dentries from LRU before putting
 on dispose list
Date: Thu, 6 Jun 2013 12:04:37 +0400
Message-ID: <51B04295.2060009@parallels.com>
References: <1370287804-3481-1-git-send-email-glommer@openvz.org> <1370287804-3481-6-git-send-email-glommer@openvz.org> <20130605160745.c361efb9af7577015d9216ab@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130605160745.c361efb9af7577015d9216ab@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Glauber Costa <glommer@openvz.org>, linux-fsdevel@vger.kernel.org, Mel Gorman <mgorman@suse.de>, Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, hughd@google.com, Greg Thelen <gthelen@google.com>, Dave Chinner <dchinner@redhat.com>

On 06/06/2013 03:07 AM, Andrew Morton wrote:
> On Mon,  3 Jun 2013 23:29:34 +0400 Glauber Costa <glommer@openvz.org> wrote:
> 
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Several of these patches were missing your (Glauber's) Signed-off-by:. 
> I added this in my copies.
> 
I remember updating them all when Mel complained.
This one in particular I might have missed, since Dave provided an
updated copy after that fact - and I may have forgot to update it.

Thanks for noting, I will go through them all again making sure they're
all there.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
