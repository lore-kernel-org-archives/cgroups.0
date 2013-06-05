From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v10 05/35] dcache: remove dentries from LRU before
 putting on dispose list
Date: Wed, 5 Jun 2013 16:07:45 -0700
Message-ID: <20130605160745.c361efb9af7577015d9216ab@linux-foundation.org>
References: <1370287804-3481-1-git-send-email-glommer@openvz.org>
	<1370287804-3481-6-git-send-email-glommer@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1370287804-3481-6-git-send-email-glommer@openvz.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, Mel Gorman <mgorman@suse.de>, Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, hughd@google.com, Greg Thelen <gthelen@google.com>, Dave Chinner <dchinner@redhat.com>

On Mon,  3 Jun 2013 23:29:34 +0400 Glauber Costa <glommer@openvz.org> wrote:

> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Several of these patches were missing your (Glauber's) Signed-off-by:. 
I added this in my copies.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
