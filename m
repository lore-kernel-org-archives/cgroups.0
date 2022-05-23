From: David Vernet <void@manifault.com>
Subject: Re: [PATCH] cgroup: Fix an error handling path in
 alloc_pagecache_max_30M()
Date: Mon, 23 May 2022 06:48:23 -0700
Message-ID: <20220523134823.lcbruwv5eodueoag@dev0025.ash9.facebook.com>
References: <628312312eb40e0e39463a2c06415fde5295c716.1653229120.git.christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <628312312eb40e0e39463a2c06415fde5295c716.1653229120.git.christophe.jaillet@wanadoo.fr>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: dan.carpenter@oracle.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org

On Sun, May 22, 2022 at 04:18:51PM +0200, Christophe JAILLET wrote:
> If the first goto is taken, 'fd' is not opened yet (and is un-initialized).
> So a direct return is safer.
> 
> Fixes: c1a31a2f7a9c ("cgroup: fix racy check in alloc_pagecache_max_30M() helper function")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  tools/testing/selftests/cgroup/test_memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
> index c3d0d5f7b19c..8833359556f3 100644
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> @@ -448,7 +448,7 @@ static int alloc_pagecache_max_30M(const char *cgroup, void *arg)
>  	high = cg_read_long(cgroup, "memory.high");
>  	max = cg_read_long(cgroup, "memory.max");
>  	if (high != MB(30) && max != MB(30))
> -		goto cleanup;
> +		return -1;
>  
>  	fd = get_temp_fd();
>  	if (fd < 0)
> -- 
> 2.34.1
> 

Acked-by: David Vernet <void@manifault.com>
