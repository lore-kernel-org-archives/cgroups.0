From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] Fix a typo in memcontroller's documention
Date: Tue, 22 Nov 2011 13:13:23 +0900
Message-ID: <20111122131323.fbcb0828.kamezawa.hiroyu@jp.fujitsu.com>
References: <1321933584-2749-1-git-send-email-gaoyang.zyh@taobao.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321933584-2749-1-git-send-email-gaoyang.zyh-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Zhu Yanhai <zhu.yanhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org, Zhu Yanhai <gaoyang.zyh-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue, 22 Nov 2011 11:46:24 +0800
Zhu Yanhai <zhu.yanhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> It should be memsw.max_usage_in_bytes. This typo has been there for
> really a long time.
> 
> Signed-off-by: Zhu Yanhai <gaoyang.zyh-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Please CC cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org in the next time.

Thank you.


> ---
>  Documentation/cgroups/memory.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> index cc0ebc5..0f6b0f3 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
> @@ -61,7 +61,7 @@ Brief summary of control files.
>   memory.failcnt			 # show the number of memory usage hits limits
>   memory.memsw.failcnt		 # show the number of memory+Swap hits limits
>   memory.max_usage_in_bytes	 # show max memory usage recorded
> - memory.memsw.usage_in_bytes	 # show max memory+Swap usage recorded
> + memory.memsw.max_usage_in_bytes # show max memory+Swap usage recorded
>   memory.soft_limit_in_bytes	 # set/show soft limit of memory usage
>   memory.stat			 # show various statistics
>   memory.use_hierarchy		 # set/show hierarchical account enabled
> -- 
> 1.7.4.4
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
