From: Lorenzo Stoakes <lstoakes-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] selftests: cgroup: Fix exception handling in
 test_memcg_oom_group_score_events()
Date: Sat, 25 Mar 2023 19:24:08 +0000
Message-ID: <fffcd98a-bb73-41cd-8545-0f2c55dd38f9@lucifer.local>
References: <f9303bdc-b1a7-be5e-56c6-dfa8232b8b55@web.de>
 <c383bdca-6f0d-4a75-e788-e1920faa0a62@web.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679772250;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tcnVA78wkVzbPfXfOJ2LEcC0Y+HKxsbDQcgFdv0NWhs=;
        b=Pocj9XuByR3+O92iq2mpvWIyQvZt/GKsOhuWboG4VjE1ElKkX0M4H1lkjCsl8CpzN7
         S+ad7YC4Ka3kz9ZCYnsWJks1NnAiyglsLk+s6xRkdqAIUP00quC16G8Z9x34sQQnbVbh
         jXBzC2ksIhiCRSVP/MOIxnJmAhqk8Q6+f/7JQGHIzgfUrQe7Yv8LsVLO1lYNvzya9RKz
         U28nihqEM2vbM0F4Kt/8TRoNk0jFm74V7HhKDqzntjVTk83BhJ3v+NIHGkJYLjZJWVAS
         mLB6Ocrk+OH0cPdE/HE/QAXFeE7sILEp4687gd04apIH9gcHkTvWB1FuHftWvYlbmvPv
         vTSQ==
Content-Disposition: inline
In-Reply-To: <c383bdca-6f0d-4a75-e788-e1920faa0a62-S0/GAf8tV78@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Markus Elfring <Markus.Elfring-S0/GAf8tV78@public.gmane.org>
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Jay Kamat <jgkamat-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cocci-MZpvjPyXg2s@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sat, Mar 25, 2023 at 07:30:21PM +0100, Markus Elfring wrote:
> Date: Sat, 25 Mar 2023 19:11:13 +0100
>
> The label “cleanup” was used to jump to another pointer check despite of
> the detail in the implementation of the function
> “test_memcg_oom_group_score_events” that it was determined already
> that a corresponding variable contained a null pointer.

This is poorly writte and confusing. Something like 'avoid unnecessary null
check/cg_destroy() invocation' would be far clearer.

>
> 1. Thus return directly after a call of the function “cg_name” failed.
>

This feels superfluious.

> 2. Use an additional label.

This also feels superfluious.

>
> 3. Delete a questionable check.

This seems superfluois and frankly, rude. It's not questionable, it's
readable, you should try to avoid language like 'questionable' when the
purpose of the check is obvious.

>
>
> This issue was detected by using the Coccinelle software.
>
> Fixes: a987785dcd6c8ae2915460582aebd6481c81eb67 ("Add tests for memory.oom.group")

Fixes what in the what now? This is not a bug fix, it's a 'questionable'
refactoring.

> Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> ---
>  tools/testing/selftests/cgroup/test_memcontrol.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
> index f4f7c0aef702..afcd1752413e 100644
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> @@ -1242,12 +1242,11 @@ static int test_memcg_oom_group_score_events(const char *root)
>  	int safe_pid;
>
>  	memcg = cg_name(root, "memcg_test_0");
> -
>  	if (!memcg)
> -		goto cleanup;
> +		return ret;
>
>  	if (cg_create(memcg))
> -		goto cleanup;
> +		goto free_cg;
>
>  	if (cg_write(memcg, "memory.max", "50M"))
>  		goto cleanup;
> @@ -1275,8 +1274,8 @@ static int test_memcg_oom_group_score_events(const char *root)
>  	ret = KSFT_PASS;
>
>  cleanup:
> -	if (memcg)
> -		cg_destroy(memcg);
> +	cg_destroy(memcg);
> +free_cg:
>  	free(memcg);
>
>  	return ret;
> --
> 2.40.0
>
>

I dislike this patch, it adds complexity for no discernible purpose and
actively makes the code _less_ readable and in a self-test of all places (!)

Not all pedantic Coccinelle results are actionable. Remember that it's
humans who are reading the code.

Your email client/scripting is still somehow broken, I couldn't get b4 to
pull it correctly and it seems to have a duplicate message ID. You really
need to take a look at that (git send-email should do this fine for
example).

Please try to filter the output of Coccinelle and instead of spamming
thousands of pointless patches that add no value, try to choose those that
do add value.

My advice overall would be to just stop.
