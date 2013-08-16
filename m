From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: change cgroup_from_id() to css_from_id()
Date: Fri, 16 Aug 2013 13:06:59 -0400
Message-ID: <20130816170659.GM2505@htj.dyndns.org>
References: <520DCF2C.1020903@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=gQK7cnEnKqOPbCqBjZiWxclw9jhHZUmx+TeWhattSnE=;
        b=FORvm1JA2ZqfM5sJNpaq9KImETQJKQlIBa7VND2lL4lXpyFyRFioxR5k7F5CpR1uLn
         CVgEgtMMpcaQjDqZen9nV/HRmF7Y1ztPwQgT34Fsj8UusUI8AdIV71JCNtcUU/f14jAf
         yBxChYtMLqqndwQEPnq3C1/4nRQKEV60tXRU8rRqm18l+NoY7xM2j37182hUAc3chtuE
         I3eOHK118ZmIffNAF5LWeWkgGa091b2lCt8WCsHyLKl6onFyXid4t5oBSzoo89cilKmr
         wIh59YQ5YbpXVBy3mP3UfmpGJEJ6Y/hUmeRpa2/0UrWaMReke/2tsl1W55HWJStVQzE0
         NFiw==
Content-Disposition: inline
In-Reply-To: <520DCF2C.1020903-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Li.

On Fri, Aug 16, 2013 at 03:05:16PM +0800, Li Zefan wrote:
> +/**
> + * css_from_id - lookup css by id
> + * @ss: cgroup subsys to be looked into
> + * @id: the cgroup id
> + *
> + * Returns the css if there's valid one with @id, otherwise returns NULL.
> + * Should be called under rcu_read_lock().
> + */
> +struct cgroup_subsys_state *css_from_id(struct cgroup_subsys *ss, int id)

Can we please do css_from_id(int id, struct cgroup_subsys *ss)
instead?

Thanks.

-- 
tejun
