From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IPC: account for kmem usage on mqueue and msg
Date: Tue, 18 Oct 2016 20:26:19 +0200
Message-ID: <20161018182619.GB27792@dhcp22.suse.cz>
References: <1476806075-1210-1-git-send-email-arozansk@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1476806075-1210-1-git-send-email-arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Stefan Schimanski <sttts-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Tue 18-10-16 11:54:35, Aristeu Rozanski wrote:
> When kmem accounting switched from account by default to only account if
> flagged by __GFP_ACCOUNT, IPC mqueue and messages was left out.

I guess this was because ipv msgqueue shouldn't allow for memory
consumption runaways. The number of message queues and messages pending
in them is bounded and not a large amount of memory AFAIR. Anyway I do
not see anything unreasonable about accounting the memory to the caller.

Have you noticed this by a code inspection or you have a real world
usecase where the missing accounting caused some problems? This would be
a useful information for the changelog.

> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Stefan Schimanski <sttts-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reported-by: Stefan Schimanski <sttts-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

I am not familiar with this code enough to give my ack but I do not see
anything obviously wrong either.

> ---
>  ipc/msgutil.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/ipc/msgutil.c b/ipc/msgutil.c
> index a521999..bf74eaa 100644
> --- a/ipc/msgutil.c
> +++ b/ipc/msgutil.c
> @@ -53,7 +53,7 @@ static struct msg_msg *alloc_msg(size_t len)
>  	size_t alen;
>  
>  	alen = min(len, DATALEN_MSG);
> -	msg = kmalloc(sizeof(*msg) + alen, GFP_KERNEL);
> +	msg = kmalloc(sizeof(*msg) + alen, GFP_KERNEL_ACCOUNT);
>  	if (msg == NULL)
>  		return NULL;
>  
> @@ -65,7 +65,7 @@ static struct msg_msg *alloc_msg(size_t len)
>  	while (len > 0) {
>  		struct msg_msgseg *seg;
>  		alen = min(len, DATALEN_SEG);
> -		seg = kmalloc(sizeof(*seg) + alen, GFP_KERNEL);
> +		seg = kmalloc(sizeof(*seg) + alen, GFP_KERNEL_ACCOUNT);
>  		if (seg == NULL)
>  			goto out_err;
>  		*pseg = seg;
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
