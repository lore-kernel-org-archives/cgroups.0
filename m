From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 02/18] cgroup_pids: track maximum pids
Date: Mon, 13 Jun 2016 17:12:27 -0400
Message-ID: <20160613211227.GG31708@htj.duckdns.org>
References: <1465847065-3577-1-git-send-email-toiwoton@gmail.com>
 <1465847065-3577-3-git-send-email-toiwoton@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HghmUgD0+iPFC2Wb4Z0o6wn/vsvXjjdUCgHvBEKfWsg=;
        b=TPhgOOt/t502ITcEirP41B3MW+UTZu61bR6Vb5HIO4RJY3ftYy6dMjIC0xCb5vbFsi
         mdn4azZDiRF7hF3ZOdOyokR7UyP1JFEeyUBvpd4uoCP/znN5u2QkN80RYvQuNB7ES6/V
         +F2pZPjpX05khBqB+WkT5DtPPL5XIxA/tE1YUUYdw+/LV3WIhhcc9uKbGi/8Y3qGBZOd
         eou4UESvABEW7SHQ/JPYVznOniqVPAtbMWvGRJMJ4O/MKjHU5lxm40XBxFjLuNKqgo0S
         k+HDfZBqMFre9Vx/2kHjYDuzqgCLuslDkONhaumMu06wEwOR+J4MXVqlGMz4EiRAhDt6
         b5Xg==
Content-Disposition: inline
In-Reply-To: <1465847065-3577-3-git-send-email-toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Mon, Jun 13, 2016 at 10:44:09PM +0300, Topi Miettinen wrote:
> Track maximum pids in the cgroup, present it in cgroup pids.current_max.

"max" is often used for maximum limits in cgroup.  I think "watermark"
or "high_watermark" would be a lot clearer.

> @@ -236,6 +246,14 @@ static void pids_free(struct task_struct *task)
>  	pids_uncharge(pids, 1);
>  }
>  
> +static void pids_fork(struct task_struct *task)
> +{
> +	struct pids_cgroup *pids = css_pids(task_css(task, pids_cgrp_id));
> +
> +	if (atomic64_read(&pids->cur_max) < atomic64_read(&pids->counter))
> +		atomic64_set(&pids->cur_max, atomic64_read(&pids->counter));
> +}

Wouldn't it make more sense to track high watermark from the charge
functions instead?  I don't get why this requires a separate fork
callback.  Also, racing atomic64_set's are racy.  The counter can end
up with a lower number than it should be.

> @@ -300,6 +326,11 @@ static struct cftype pids_files[] = {
>  		.read_s64 = pids_current_read,
>  		.flags = CFTYPE_NOT_ON_ROOT,
>  	},
> +	{
> +		.name = "current_max",

Please make this "high_watermark" field in pids.stats file.

Thanks.

-- 
tejun
