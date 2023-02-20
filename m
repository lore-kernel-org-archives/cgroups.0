From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] mm: change memcg->oom_group access with atomic operations
Date: Mon, 20 Feb 2023 13:09:44 -0800
Message-ID: <Y/PhmEPc/qYeZ52T@P9FQF9L96D>
References: <20230220151638.1371-1-findns94@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676927389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8JBYS9FvWj14eT3JNuqmdGK9JV/xnFH80x2sQQSrkTI=;
        b=ddyUu3zsm6Y0+vR74DJIcnENOFBU8ue0+E83vkrKf6R+AXgHiE5UZ30o4jj02lbdkPvcYt
        hUCpldBu9NYSmkpAO3+ReRrGa6FiNIZdA+U5woA1UPiRVI9z6yNGlYdYQvvLUTggIAmbrf
        IhM61gJLeSwVxu90+kkRBSSiNec/GKE=
Content-Disposition: inline
In-Reply-To: <20230220151638.1371-1-findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Feb 20, 2023 at 11:16:38PM +0800, Yue Zhao wrote:
> The knob for cgroup v2 memory controller: memory.oom.group
> will be read and written simultaneously by user space
> programs, thus we'd better change memcg->oom_group access
> with atomic operations to avoid concurrency problems.
> 
> Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi Yue!

I'm curious, have any seen any real issues which your patch is solving?
Can you, please, provide a bit more details.

Also, WRITE/READ_ONCE() don't generally make operations atomic,
they only prevent the compiler from merging and re-fetching reads
and writes.

Thanks!
