From: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Subject: Re: [RFC v0 1/4] net: Only update sk_cgrp_prioidx on change
Date: Mon, 16 Apr 2012 13:27:40 -0400
Message-ID: <20120416172740.GG13366@hmsreliant.think-freely.org>
References: <1334590506-19462-1-git-send-email-wagi@monom.org>
 <1334590506-19462-2-git-send-email-wagi@monom.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1334590506-19462-2-git-send-email-wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Mon, Apr 16, 2012 at 05:35:03PM +0200, Daniel Wagner wrote:
> From: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
> 
> Do not make the cache line dirty when nothing has changed.
> sock_update_classid() does exactly the same thing.
> 
> Signed-off-by: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
> CC: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
> CC: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> CC: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  net/core/sock.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/sock.c b/net/core/sock.c
> index c7e60ea..75c4b72 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1190,10 +1190,14 @@ EXPORT_SYMBOL(sock_update_classid);
>  
>  void sock_update_netprioidx(struct sock *sk)
>  {
> +	u32 prioidx;
> +
>  	if (in_interrupt())
>  		return;
>  
> -	sk->sk_cgrp_prioidx = task_netprioidx(current);
> +	prioidx = task_netprioidx(current);
> +	if (prioidx != sk->sk_cgrp_prioidx)
> +		sk->sk_cgrp_prioidx = prioidx;
>  }
>  EXPORT_SYMBOL_GPL(sock_update_netprioidx);
>  #endif
> -- 
> 1.7.10.130.g36e6c
> 
> 

Acked-by: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
