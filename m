From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup] cgroup: set the correct return code if hierarchy
 limits are reached
Date: Thu, 30 Jun 2022 04:25:57 +0900
Message-ID: <YrynRcW4/B2nl/kK@mtj.duckdns.org>
References: <186d5b5b-a082-3814-9963-bf57dfe08511@openvz.org>
 <d8a9e9c6-856e-1502-95ac-abf9700ff568@openvz.org>
 <YrpO9CUDt8hpUprr@castle>
 <17916824-ba97-68ba-8166-9402d5f4440c@openvz.org>
 <20220628091648.GA12249@blackbody.suse.cz>
 <YrrIWe/nn5hoVyu9@mtj.duckdns.org>
 <525a3eea-8431-64ad-e464-5503f3297722@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FOvU7kkY3061/Y6ML2riqvq9E9PyjzheNXe1X2hbYKw=;
        b=V9dUu8WtJeBE8oGYB7nq+4RFkzp3O7qiE28jpnaaEt3/FzsvCqubr9YdtYM6mODSY8
         dIUJluVOX75DHnavuyZ+/jgaLm4g8f4cYXnC8EMbWW/f54M1wsTwqtBLsQZzSnDQjQhu
         4fCs36fLopglf6HJXBUSbNnZPK18HlPzMa/J/sN4owOeqydod23RerxcOZIP5cpVTjWP
         77ukE+oErNdhKUIj9uRPop6ewX/GaseO3pgjt7dRfQIhgFu9YBcvdOrA0AW4z9yXjnTl
         +bpTkGSPWzroB99J7apjT2zvpSRe4o81bpRqoo1JMcNLcnp8Ou1XO/++4YqaIB3s0AfA
         DJ+A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <525a3eea-8431-64ad-e464-5503f3297722-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jun 29, 2022 at 09:13:02AM +0300, Vasily Averin wrote:
> I experimented on fedora36 node with LXC and centos stream 9 container.
> and I did not noticed any critical systemd troubles with original -EAGAIN.
> When cgroup's limit is reached systemd cannot start new services, 
> for example lxc-attach generates following output:
> 
> [root@fc34-vvs ~]# lxc-attach c9s
> lxc-attach: c9s: cgroups/cgfsng.c: cgroup_attach_leaf: 2084 Resource temporarily unavailable - Failed to create leaf cgroup ".lxc"
> lxc-attach: c9s: cgroups/cgfsng.c: __cgroup_attach_many: 3517 Resource temporarily unavailable - Failed to attach to cgroup fd 11
> lxc-attach: c9s: attach.c: lxc_attach: 1679 Resource temporarily unavailable - Failed to attach cgroup
> lxc-attach: c9s: attach.c: do_attach: 1237 No data available - Failed to receive lsm label fd
> lxc-attach: c9s: attach.c: do_attach: 1375 Failed to attach to container
> 
> I did not found any loop in userspace caused by EAGAIN.
> Messages looks unclear, however situation with the patched kernel is not much better:
> 
> [root@fc34-vvs ~]# lxc-attach c9s
> lxc-attach: c9s: cgroups/cgfsng.c: cgroup_attach_leaf: 2084 No space left on device - Failed to create leaf cgroup ".lxc"
> lxc-attach: c9s: cgroups/cgfsng.c: __cgroup_attach_many: 3517 No space left on device - Failed to attach to cgroup fd 11
> lxc-attach: c9s: attach.c: lxc_attach: 1679 No space left on device - Failed to attach cgroup
> lxc-attach: c9s: attach.c: do_attach: 1237 No data available - Failed to receive lsm label fd
> lxc-attach: c9s: attach.c: do_attach: 1375 Failed to attach to container

I'd say "resource temporarily unavailable" is better fitting than "no
space left on device" and the syscall restart thing isn't handled by
-EAGAIN return value. Grep restart_block for that.

Thanks.

-- 
tejun
