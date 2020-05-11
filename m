From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] doc: cgroup: update note about conditions when oom
 killer is invoked
Date: Mon, 11 May 2020 10:39:04 +0200
Message-ID: <20200511083904.GB29153@dhcp22.suse.cz>
References: <158894738928.208854.5244393925922074518.stgit@buzz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <158894738928.208854.5244393925922074518.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>

On Fri 08-05-20 17:16:29, Konstantin Khlebnikov wrote:
> Starting from v4.19 commit 29ef680ae7c2 ("memcg, oom: move out_of_memory
> back to the charge path") cgroup oom killer is no longer invoked only from
> page faults. Now it implements the same semantics as global OOM killer:
> allocation context invokes OOM killer and keeps retrying until success.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  Documentation/admin-guide/cgroup-v2.rst |   17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index bcc80269bb6a..1bb9a8f6ebe1 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1172,6 +1172,13 @@ PAGE_SIZE multiple when read back.
>  	Under certain circumstances, the usage may go over the limit
>  	temporarily.
>  
> +	In default configuration regular 0-order allocation always
> +	succeed unless OOM killer choose current task as a victim.
> +
> +	Some kinds of allocations don't invoke the OOM killer.
> +	Caller could retry them differently, return into userspace
> +	as -ENOMEM or silently ignore in cases like disk readahead.

I would probably add -EFAULT but the less error codes we document the
better.

> +
>  	This is the ultimate protection mechanism.  As long as the
>  	high limit is used and monitored properly, this limit's
>  	utility is limited to providing the final safety net.
> @@ -1228,17 +1235,9 @@ PAGE_SIZE multiple when read back.
>  		The number of time the cgroup's memory usage was
>  		reached the limit and allocation was about to fail.
>  
> -		Depending on context result could be invocation of OOM
> -		killer and retrying allocation or failing allocation.
> -
> -		Failed allocation in its turn could be returned into
> -		userspace as -ENOMEM or silently ignored in cases like
> -		disk readahead.  For now OOM in memory cgroup kills
> -		tasks iff shortage has happened inside page fault.
> -
>  		This event is not raised if the OOM killer is not
>  		considered as an option, e.g. for failed high-order
> -		allocations.
> +		allocations or if caller asked to not retry attempts.
>  
>  	  oom_kill
>  		The number of processes belonging to this cgroup

-- 
Michal Hocko
SUSE Labs
