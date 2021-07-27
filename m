From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH TTY] memcg: drop GFP_KERNEL_ACCOUNT use in
 tty_save_termios()
Date: Tue, 27 Jul 2021 11:32:07 +0200
Message-ID: <YP/Sl8a5PqUFZAi5@kroah.com>
References: <d42bd2a3-74a0-163f-6e3a-ad702f6d2817@virtuozzo.com>
 <afbaec7c-1872-d43a-1240-e077adc0d6d9@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627378329;
        bh=5Ez4IXemr8M6FoN3lv3kTwfLMCVrpyMcVjl7PW1H/ls=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XUPRPfJGcA1bM6D58QeUAcuHwuh4hTPgHONhJ4hMVTUbs4zthrO/+R1Nd/jGKB0GY
         cyW6nGQbFKuu0V+3K1AOOMTFOpLeu6W+2MVXw00LUiUBb8r6Hxo6sQ1//wCkA84Jbj
         H5qGKbffQbrfOnP6ID5NNBkygNmzIHPnOvEDEC/k=
Content-Disposition: inline
In-Reply-To: <afbaec7c-1872-d43a-1240-e077adc0d6d9-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Jiri Slaby <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jul 27, 2021 at 12:26:12PM +0300, Vasily Averin wrote:
> Jiri Slaby pointed that termios are not saved for PTYs and for other
> terminals used inside containers. Therefore accounting for saved
> termios have near to zero impact in real life scenarios.
> 
> Cc: Jiri Slaby <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Fixes: 854dd8a572a0 ("memcg: enable accounting for tty-related objects")
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> ---
>  drivers/tty/tty_io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> index e787f6f..a6230b2 100644
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -1493,7 +1493,7 @@ void tty_save_termios(struct tty_struct *tty)
>  	/* Stash the termios data */
>  	tp = tty->driver->termios[idx];
>  	if (tp == NULL) {
> -		tp = kmalloc(sizeof(*tp), GFP_KERNEL_ACCOUNT);
> +		tp = kmalloc(sizeof(*tp), GFP_KERNEL);
>  		if (tp == NULL)
>  			return;
>  		tty->driver->termios[idx] = tp;
> -- 
> 1.8.3.1
> 

I can just drop the original patch from my tree, it has not gone into my
unmutable branch yet.

thanks,

greg k-h
