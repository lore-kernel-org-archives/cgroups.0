From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next v2 1/9] blk-iocost: cleanup ioc_qos_write() and
 ioc_cost_model_write()
Date: Wed, 30 Nov 2022 10:31:27 -1000
Message-ID: <Y4e9n89vJ45+9WD2@slm.duckdns.org>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-2-linan122@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zERogrghEXBrjx46RlEGcBUab/oF8o5TSfDWdWk3204=;
        b=CbBJH1iSFlP/+nWb9lr6aDG63sPp/lrVxYD5U9xyWoQntUFWySjlkoLu5qHG6HjIGf
         XG+btjog3tUDwuH4Zx62q9zDDXiniyM0ILQ94Y8hyBEF5bAxpXwloJxWsNMeB2WTH2bW
         M0SWvKno+eCyw3zJIrlZPSVggxp0wo44y6OFZl1Wbg64Ds+TWOepX6dVmaBCvLPGo2zg
         VdWK8QSRqkSvOOwa4d3HX1VnjliG25vSJcSSHftki7wTOsmOjNYBaiQL6fC3nJNkKfkI
         PJA/7D1kOpFCnZaYehRAFxs8Lh3fRmjLMRRTMRSFAqjJG6PyRS6DAC82ODpJbPIMKiKY
         hH5w==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221130132156.2836184-2-linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Wed, Nov 30, 2022 at 09:21:48PM +0800, Li Nan wrote:
> @@ -3197,6 +3197,7 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
>  	enable = ioc->enabled;
>  	user = ioc->user_qos_params;
>  
> +	ret = -EINVAL;
>  	while ((p = strsep(&input, " \t\n"))) {
>  		substring_t args[MAX_OPT_ARGS];
>  		char buf[32];
> @@ -3218,7 +3219,7 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
>  			else if (!strcmp(buf, "user"))
>  				user = true;
>  			else
> -				goto einval;
> +				goto out_unlock;

So, I kinda dislike it. That's a lot of code to cover with one "ret =
-EINVAL" assignment which makes it pretty easy to make a mistake. People use
variables like i, ret, err without thinking much and it doesn't help that
you now can't tell whether a given exit condition is error or not by just
looking at it.

I don't know what great extra insight the return value from match_u64()
would carry (like, what else is it gonna say? and even if it does why does
that matter when we say -EINVAL to pretty much everything else) so I'm not
sure this matters but if you really want it just add a separate error return
label?

Thanks.

-- 
tejun
