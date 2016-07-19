From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup_pids: track highwater mark of pids
Date: Tue, 19 Jul 2016 15:07:08 -0400
Message-ID: <20160719190708.GO3078@mtj.duckdns.org>
References: <1468785820-3960-1-git-send-email-toiwoton@gmail.com>
 <1468785820-3960-3-git-send-email-toiwoton@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TUsIVsqIdc672ZxbtRf2C6OC1KxnoOBxQLu2jEqWcW8=;
        b=rnvG45JH9Z9u4xuHsULfzbXI8OLuZ9z2RGFuL0TzYLvh62W3O9+jgT2/71JwMCetIL
         zIIoKYIyy0XuHvqQd3bxrAicoi6XFVLMh6opzWS5XIOCk7g057gbZH5fVbKjK4GzElBI
         veWez8DWgTszSYe7rysq3mDu9vNLdIHiZ+mafv4Fz1e2euHw5S48cc4xYoyST6Rf3eiT
         UV8GmJP9EyU/vFJ04IEN6A7t8r9yrr+M41SuqFqZfJVJlhXJ+uHlGyHq5LecPtX27bpp
         ol/qH4dqCYWAIGBSyrWlayBYVryvLDWVvkENbYfDdpauaOuATcQdmYY9KW/btpA47VtZ
         XjMw==
Content-Disposition: inline
In-Reply-To: <1468785820-3960-3-git-send-email-toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Sun, Jul 17, 2016 at 11:03:38PM +0300, Topi Miettinen wrote:
> +static void pids_update_highwater_mark(struct pids_cgroup *p)
> +{
> +	while (1) {
> +		int64_t old_mark, new_mark, cur_mark;
> +
> +		old_mark = atomic64_read(&p->highwater_mark);
> +		new_mark = atomic64_read(&p->counter);
> +		if (old_mark >= new_mark)
> +			return;
> +		cur_mark = atomic64_cmpxchg(&p->highwater_mark, old_mark,
> +					    new_mark);
> +
> +		/* It's OK if the counter was decreased meanwhile */
> +		if (cur_mark == old_mark &&
> +		    atomic64_read(&p->counter) <= new_mark)
> +			return;
> +	}
> +}

I think it'd be better to make this part of pids_charge() - maybe use
atomic64_add_return() to get the current value and track the maximum?

> @@ -300,6 +341,11 @@ static struct cftype pids_files[] = {
>  		.read_s64 = pids_current_read,
>  		.flags = CFTYPE_NOT_ON_ROOT,
>  	},
> +	{
> +		.name = "highwater_mark",
> +		.read_s64 = pids_highwater_mark_read,
> +		.flags = CFTYPE_NOT_ON_ROOT,
> +	},

This should be an entry in the pids.stats file.  Please also update
the documentation accordingly.

Thanks.

-- 
tejun
