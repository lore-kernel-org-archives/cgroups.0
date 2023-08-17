From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] selftests: cgroup: fix test_kmem_memcg_deletion kernel
 mem check
Date: Thu, 17 Aug 2023 17:07:02 +0000
Message-ID: <20230817170702.mwem4nsy2ka4gj7n@google.com>
References: <jnyjalhg43mdnn6su2a2kmwzqasdyjsfdvipim2i2hvqo7w6y2@st57sbo4bkxf>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692292025; x=1692896825;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QnA3zPm2q98qby0UoFFaFMSu7nPrN723bBGGT2+DgLs=;
        b=cPbrT9R7dbSgZyIYn0MoABD+dW9CzgzB0c2szdO9q2gaQezgEccSgLaZARJUxDii3N
         z2xVLOsuI32LBrHAJjco19jtnJttDM9z5VTOcV4d0KghDeGC/LeT+LQNnXzLb5hXhfac
         epcWSxrBvzEcCnO1xidylUFN1IPNUinKwyDkLHxFBALc+nXRm8rKZcufVEx5nlkyrSzw
         8mIVqtIoFXayBbkUJNL8QSXTjk3u5fdN6MtfgO9MUf2uBhJ0JgHKIRfXe6BEmApaJufR
         vKiuZpi7tq+ULrqeuRVyaDWvIZTtmJqvL2nsHH8hLJF84cIrJNlcfxBv7IXZxOuZxpUV
         SCiQ==
In-Reply-To: <jnyjalhg43mdnn6su2a2kmwzqasdyjsfdvipim2i2hvqo7w6y2@st57sbo4bkxf>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Lucas Karpinski <lkarpins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Aug 17, 2023 at 08:47:26AM -0400, Lucas Karpinski wrote:
> The combination of using slab, anon, file, kernel_stack, and percpu is
> not accurate for total kernel memory utilization. Checking kernel within
> memory.stat provides a more accurate measurement.
> 
> Signed-off-by: Lucas Karpinski <lkarpins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  v1: https://lore.kernel.org/all/eex2vdlg4ow2j5bybmav73nbfzuspkk4zobnk7svua4jaypqb5@7ie6e4mci43t/
> 
>  tools/testing/selftests/cgroup/test_kmem.c | 25 +++++-----------------
>  1 file changed, 5 insertions(+), 20 deletions(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
> index ed2e50bb1e76..3ef979ee0edf 100644
> --- a/tools/testing/selftests/cgroup/test_kmem.c
> +++ b/tools/testing/selftests/cgroup/test_kmem.c
> @@ -166,7 +166,7 @@ static int cg_run_in_subcgroups(const char *parent,
>   */
>  static int test_kmem_memcg_deletion(const char *root)
>  {
> -	long current, slab, anon, file, kernel_stack, pagetables, percpu, sock, sum;
> +	long current, kernel;
>  	int ret = KSFT_FAIL;
>  	char *parent;
>  
> @@ -184,30 +184,15 @@ static int test_kmem_memcg_deletion(const char *root)
>  		goto cleanup;
>  
>  	current = cg_read_long(parent, "memory.current");
> -	slab = cg_read_key_long(parent, "memory.stat", "slab ");
> -	anon = cg_read_key_long(parent, "memory.stat", "anon ");
> -	file = cg_read_key_long(parent, "memory.stat", "file ");
> -	kernel_stack = cg_read_key_long(parent, "memory.stat", "kernel_stack ");
> -	pagetables = cg_read_key_long(parent, "memory.stat", "pagetables ");
> -	percpu = cg_read_key_long(parent, "memory.stat", "percpu ");
> -	sock = cg_read_key_long(parent, "memory.stat", "sock ");
> -	if (current < 0 || slab < 0 || anon < 0 || file < 0 ||
> -	    kernel_stack < 0 || pagetables < 0 || percpu < 0 || sock < 0)
> +	kernel = cg_read_key_long(parent, "memory.stat", "kernel ");
> +	if (current < 0 || kernel < 0)
>  		goto cleanup;
>  
> -	sum = slab + anon + file + kernel_stack + pagetables + percpu + sock;
> -	if (abs(sum - current) < MAX_VMSTAT_ERROR) {
> +	if (abs(kernel - current) < MAX_VMSTAT_ERROR) {

I don't think this is what you want. Since slab, kernel_stack,
pagetables and percpu are included in the kmem stats, you just want to
replace those with kmem. Basically keep the anon, file and sock stats.

