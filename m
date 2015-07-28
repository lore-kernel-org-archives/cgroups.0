From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/10] cgroup: introduce cgroup_subsys->legacy_name
Date: Tue, 28 Jul 2015 14:39:36 +0800
Message-ID: <55B723A8.1080201@huawei.com>
References: <1437763434-28699-1-git-send-email-tj@kernel.org> <1437763434-28699-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437763434-28699-3-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> @@ -1448,7 +1451,8 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
>  		}
>  
>  		for_each_subsys(ss, i) {
> -			if (strcmp(token, ss->name))
> +			if (strcmp(token, ss->name) &&
> +			    strcmp(token, ss->legacy_name))
>  				continue;

As mounting with specified subsystems is only allowed in legacy hierarchy,
I think we should allow using leagcy name only?

>  			if (ss->disabled)
>  				continue;
