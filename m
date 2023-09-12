From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] selftests: cgroup: fix test_zswap error path and
 meaningless check
Date: Tue, 12 Sep 2023 10:18:02 -0700
Message-ID: <20230912101802.25b280ac306694ff02001706@linux-foundation.org>
References: <20230912083800.57435-1-cerasuolodomenico@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694539084;
        bh=c2Ov69hO0AC4q1Ltdb0qHvD5gAxgfLF2qaudopzkkCk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kezSafD+vHrENLsiYBzEm37IOQg3Bw6BjYSSsBdcd588oUNoikJNXGPLkGNbD3JWB
         zIqxiSblsWziF/22AK6lLQFj/e0GOO1sZtNW0434skNnVWcKK9yPekM98UVsBbQg+d
         LPr0653efBwugzZ06KokYAw83E8DUPVypy9W+fXI=
In-Reply-To: <20230912083800.57435-1-cerasuolodomenico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Domenico Cerasuolo <cerasuolodomenico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: dan.carpenter-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, kernel-team-M8Ki61LpUEw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 12 Sep 2023 10:38:00 +0200 Domenico Cerasuolo <cerasuolodomenico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Replace destruction paths with simple returns before the test cgroup is
> created, there is nothing to free or destroy at that point.
> 
> Remove pointless check, stored_pages is a size_t and cannot be < 0.
> 
> ...
>
> @@ -208,8 +208,6 @@ static int test_no_kmem_bypass(const char *root)
>  		free(trigger_allocation);
>  		if (get_zswap_stored_pages(&stored_pages))
>  			break;
> -		if (stored_pages < 0)
> -			break;
>  		/* If memory was pushed to zswap, verify it belongs to memcg */
>  		if (stored_pages > stored_pages_threshold) {
>  			int zswapped = cg_read_key_long(test_group, "memory.stat", "zswapped ");

stored_pages will be set to -1 on error.  It would be better to cast
stored_pages to ssize_t in the check, rather than simply ignoring
errors?
