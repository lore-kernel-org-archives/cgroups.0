From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: deprecate memory.force_empty knob
Date: Mon, 12 May 2014 11:00:14 -0400
Message-ID: <20140512150014.GB1421@htj.dyndns.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-3-git-send-email-tj@kernel.org>
 <20140512145324.GE9564@dhcp22.suse.cz>
 <20140512145803.GF9564@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=VAM05vE3DgUELZdjUPNsgMHNy6j0JXCNOkp3YKj+s8o=;
        b=G9krcS/0RmM/YBPVgNeFFulSwzxojiw6mJb9m7sUk+zyOeK2NGhxRuDG3le0zZTA7k
         wv7uuAdXOrd+kwIhGt9P6hA05tjjGQOsPBe7LIeiAcSr8+MoH1g32It+qNwjAkbewQAz
         Z7UDmMcpOZpjRhaTrUecTguvhzw8bpo+YUM9CbJOScJAOxvexbVTbZlheB4TtOI5PhP4
         X973A4FlMK3WuFIC3/P74P8GbUUHjiFLzuVqFTxTLTahbJKVJyIAbO3H+mHtdrWgYYFY
         DLLGbW7eB2tyfgcR7PRhFvl6w+/gQ3G61/1H2QA/9TmByJzp04sMqXqlIT4JUEIfR/es
         ySdg==
Content-Disposition: inline
In-Reply-To: <20140512145803.GF9564-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org

On Mon, May 12, 2014 at 04:58:03PM +0200, Michal Hocko wrote:
> @@ -4793,6 +4793,10 @@ static int mem_cgroup_force_empty_write(struct cgroup_subsys_state *css,
>  
>  	if (mem_cgroup_is_root(memcg))
>  		return -EINVAL;
> +	pr_info("%s (%d): memory.force_empty is deprecated and will be removed.",
> +			current->comm, task_pid_nr(current));
> +	pr_cont(" Let us know if you know if it needed in your usecase at");
> +	pr_cont(" linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org\n");
>  	return mem_cgroup_force_empty(memcg);

It probably would be way easier to just mark the knob with
CFTYPE_INSANE.

Thanks.

-- 
tejun
