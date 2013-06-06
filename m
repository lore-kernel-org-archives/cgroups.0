From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v10 22/35] shrinker: convert remaining shrinkers to count/scan
 API
Date: Thu, 6 Jun 2013 12:27:28 +0400
Message-ID: <51B047F0.7060501@parallels.com>
References: <1370287804-3481-1-git-send-email-glommer@openvz.org> <1370287804-3481-23-git-send-email-glommer@openvz.org> <20130605160821.59adf9ad4efe48144fd9e237@linux-foundation.org> <20130606034116.GT29338@dastard>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130606034116.GT29338@dastard>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Glauber Costa <glommer@openvz.org>, linux-fsdevel@vger.kernel.org, Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, hughd@google.com, Greg Thelen <gthelen@google.com>, Dave Chinner <dchinner@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>, Chuck Lever <chuck.lever@oracle.com>, "J. Bruce Fields" <bfields@redhat.com>, Trond Myklebust <Trond.Myklebust@netapp.com>

On 06/06/2013 07:41 AM, Dave Chinner wrote:
>> Really, it would be best if you were to go through the entire patchset
>> > and undo all this.
> Sure, that can be done.
There is a lot to do, a lot to rebase, and many conflicts to fix.
Since I will be the one resending this anyway, let me just go ahead and
fix them.


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
