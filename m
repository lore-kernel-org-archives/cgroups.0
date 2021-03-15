From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v2 7/8] memcg: accounting for tty_struct objects
Date: Mon, 15 Mar 2021 13:40:07 +0100
Message-ID: <YE9Vp16wg08gauf8@kroah.com>
References: <YEnWUrYOArju66ym@dhcp22.suse.cz>
 <61134897-703e-a2a8-6f0b-0bf6e1b79dda@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615812010;
        bh=Addb2iMgVQqYTjlqpyb4lfTa/TOCEQtI6cmBSE/kUxQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ij7Bb4+gYBoglnHboFoqS4PsD6ZTVk7kYZ5du9jgWzMZb7DCBcuUNKD9tRBFtJdJa
         rszzB8VuOkOtUFhiSzFzExEnizVoE5wbSLPtajY3+39t/NsdYA1JHdFMBUcgBotf3n
         aVrE6ZfPgquTUFd+3k0d5xqlO3+uQdsqVhYtCgD4=
Content-Disposition: inline
In-Reply-To: <61134897-703e-a2a8-6f0b-0bf6e1b79dda-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jiri Slaby <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Mon, Mar 15, 2021 at 03:23:53PM +0300, Vasily Averin wrote:
> Non-accounted multi-page tty-related kenrel objects can be created
> from inside memcg-limited container.
> ---
>  drivers/tty/tty_io.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> index 74733ec..a3b881b 100644
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -1503,7 +1503,7 @@ void tty_save_termios(struct tty_struct *tty)
>  	/* Stash the termios data */
>  	tp = tty->driver->termios[idx];
>  	if (tp == NULL) {
> -		tp = kmalloc(sizeof(*tp), GFP_KERNEL);
> +		tp = kmalloc(sizeof(*tp), GFP_KERNEL_ACCOUNT);
>  		if (tp == NULL)
>  			return;
>  		tty->driver->termios[idx] = tp;
> @@ -3128,7 +3128,7 @@ struct tty_struct *alloc_tty_struct(struct tty_driver *driver, int idx)
>  {
>  	struct tty_struct *tty;
>  
> -	tty = kzalloc(sizeof(*tty), GFP_KERNEL);
> +	tty = kzalloc(sizeof(*tty), GFP_KERNEL_ACCOUNT);
>  	if (!tty)
>  		return NULL;
>  
> -- 
> 1.8.3.1
> 


Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- Your patch does not have a Signed-off-by: line.  Please read the
  kernel file, Documentation/SubmittingPatches and resend it after
  adding that line.  Note, the line needs to be in the body of the
  email, before the patch, not at the bottom of the patch or in the
  email signature.

- You did not specify a description of why the patch is needed, or
  possibly, any description at all, in the email body.  Please read the
  section entitled "The canonical patch format" in the kernel file,
  Documentation/SubmittingPatches for what is needed in order to
  properly describe the change.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
