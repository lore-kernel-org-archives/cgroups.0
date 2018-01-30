From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] Documentation: Fix 'file_mapped' -> 'mapped_file'
Date: Tue, 30 Jan 2018 18:12:41 +0100
Message-ID: <20180130171241.GI21609@dhcp22.suse.cz>
References: <20180130164213.20387-1-florian.schmidt@neclab.eu>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180130164213.20387-1-florian.schmidt@neclab.eu>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Florian Schmidt <florian.schmidt@neclab.eu>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On Tue 30-01-18 17:42:13, Florian Schmidt wrote:
> There is no entry file_mapped in the memory.stat file. This looks like a
> simple word flip that's gone unnoticed since 2010 (dc10e281f5fc,
> memcg: update documentation).
> 
> Signed-off-by: Florian Schmidt <florian.schmidt@neclab.eu>

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks for catching this.

> ---
>  Documentation/cgroup-v1/memory.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/cgroup-v1/memory.txt b/Documentation/cgroup-v1/memory.txt
> index cefb63639070..a4af2e124e24 100644
> --- a/Documentation/cgroup-v1/memory.txt
> +++ b/Documentation/cgroup-v1/memory.txt
> @@ -524,9 +524,9 @@ Note:
>  	Only anonymous and swap cache memory is listed as part of 'rss' stat.
>  	This should not be confused with the true 'resident set size' or the
>  	amount of physical memory used by the cgroup.
> -	'rss + file_mapped" will give you resident set size of cgroup.
> +	'rss + mapped_file" will give you resident set size of cgroup.
>  	(Note: file and shmem may be shared among other cgroups. In that case,
> -	 file_mapped is accounted only when the memory cgroup is owner of page
> +	 mapped_file is accounted only when the memory cgroup is owner of page
>  	 cache.)
>  
>  5.3 swappiness
> -- 
> 2.16.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
