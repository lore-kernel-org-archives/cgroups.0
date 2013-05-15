From: Glauber Costa <glommer@parallels.com>
Subject: Re: [patch v3 -mm 2/3] memcg: Get rid of soft-limit tree infrastructure
Date: Wed, 15 May 2013 12:38:52 +0400
Message-ID: <5193499C.8080505@parallels.com>
References: <1368431172-6844-1-git-send-email-mhocko@suse.cz> <1368431172-6844-3-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1368431172-6844-3-git-send-email-mhocko@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>, Michel
 Lespinasse <walken@google.com>, Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>

On 05/13/2013 11:46 AM, Michal Hocko wrote:
> Now that the soft limit is integrated to the reclaim directly the whole
> soft-limit tree infrastructure is not needed anymore. Rip it out.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  mm/memcontrol.c |  224 +------------------------------------------------------
>  1 file changed, 1 insertion(+), 223 deletions(-)
Great =)

Reviewed-by: Glauber Costa <glommer@openvz.org>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
