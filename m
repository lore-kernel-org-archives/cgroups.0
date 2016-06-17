From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/3] mm: memcontrol: fix cgroup creation failure after
 many small jobs
Date: Fri, 17 Jun 2016 14:18:42 -0400
Message-ID: <20160617181842.GP3262@mtj.duckdns.org>
References: <20160616034244.14839-1-hannes@cmpxchg.org>
 <20160616200617.GD3262@mtj.duckdns.org>
 <20160617162310.GA19084@cmpxchg.org>
 <20160617162516.GD19084@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sMUua6hiB4gPi63A8rZFU29Q1f8pVbCw38u2ysrQy8w=;
        b=ANaHvefrXCvt+mZXp3mrm8OoraoNRG6NJpeJJiAh3VCUxBDLQTKp30s74VmsuALzNM
         D/y7Tqcd4966R6WzMXq2gBxhyJBSX6TWDaXGTpyEdpml4MEyZIeHI8OQlH0w2vqNx5TW
         1VYKK5yOcl9nX7mgykoAtjs+JBMRbuJdDfeY1QsiicNGCHgfmnofC2lGJcHaTdL4+BN5
         1s9OZSj89Bi4QOPxpAThKAzxpyaWgW5Yj8acDPXR0eLIen4wiVbutSFbAIZRh0TwejSZ
         pWX39yOERGxv992lNhPIG/UuuQfPFdwWvBxbW8QGNfZPqOQWo5lqoWPAgYheYmmWZTH8
         FfSg==
Content-Disposition: inline
In-Reply-To: <20160617162516.GD19084@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, Michal Hocko <mhocko@suse.cz>, Li Zefan <lizefan@huawei.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, Jun 17, 2016 at 12:25:16PM -0400, Johannes Weiner wrote:
> The memory controller has quite a bit of state that usually outlives
> the cgroup and pins its CSS until said state disappears. At the same
> time it imposes a 16-bit limit on the CSS ID space to economically
> store IDs in the wild. Consequently, when we use cgroups to contain
> frequent but small and short-lived jobs that leave behind some page
> cache, we quickly run into the 64k limitations of outstanding CSSs.
> Creating a new cgroup fails with -ENOSPC while there are only a few,
> or even no user-visible cgroups in existence.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
