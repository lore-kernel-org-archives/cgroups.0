From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 0/5] cgroup/cpuset: A new "isolcpus" paritition
Date: Wed, 12 Apr 2023 15:17:44 -1000
Message-ID: <ZDdYOI9LB87ra2t_@slm.duckdns.org>
References: <20230412153758.3088111-1-longman@redhat.com>
 <ZDcGVebCpyktxyWh@slm.duckdns.org>
 <1ce6a073-e573-0c32-c3d8-f67f3d389a28@redhat.com>
 <ZDcS_yVCgh6g1LoM@slm.duckdns.org>
 <e38f72aa-9705-cf0c-a565-fb790f16c53e@redhat.com>
 <ZDdG1K0kTETZMTCu@slm.duckdns.org>
 <cd4c3f92-4a01-e636-7390-8c6a3d0cfe6c@redhat.com>
 <ZDdNy2NAfj2_1CbW@slm.duckdns.org>
 <1b8d9128-d076-7d37-767d-11d6af314662@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681348667; x=1683940667;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aicWCnIBboKYj1UbmrIfysKq+w2Fw/6QRrG0gA3j6sY=;
        b=gYjjpD3JLH90EnGPJ9RcpcnDr0n4+5DTGSITYkHo/YynUUF6qZzpx0oGXdeF8F7Xjg
         AfXieG0P88XI6Nzkz1BFcevqb5GLWXPeccE5IJJamDBYFjnkb7Axu61u/6VjRPGr4EPZ
         SpaOxhK7cWQeH9785nGjVxI3aDbmLIPcUpoGn6/YUyrNDAxcPayfy632I/kFjQlNGZ9h
         wQ884KystVfhyecLHxVtIzMtMN6TwQ/C3+wN5tyZTC9lEbWTt3mZCbzrt1ix7k9RQlaI
         em+DSJHooOoW+JhPsh1zOeS/ubqfeFOiyJp3P+gqlAPWLyl8zClupd7ddpGci462z9Dy
         Uz6w==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1b8d9128-d076-7d37-767d-11d6af314662-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Hello, Waiman.

On Wed, Apr 12, 2023 at 08:55:55PM -0400, Waiman Long wrote:
> > Sounds a bit contrived. Does it need to be something defined in the root
> > cgroup?
> 
> Yes, because we need to take away the isolated CPUs from the effective cpus
> of the root cgroup. So it needs to start from the root. That is also why we
> have the partition rule that the parent of a partition has to be a partition
> root itself. With the new scheme, we don't need a special cgroup to hold the

I'm following. The root is already a partition root and the cgroupfs control
knobs are owned by the parent, so the root cgroup would own the first level
cgroups' cpuset.cpus.reserve knobs. If the root cgroup wants to assign some
CPUs exclusively to a first level cgroup, it can then set that cgroup's
reserve knob accordingly (or maybe the better name is
cpuset.cpus.exclusive), which will take those CPUs out of the root cgroup's
partition and give them to the first level cgroup. The first level cgroup
then is free to do whatever with those CPUs that now belong exclusively to
the cgroup subtree.

> isolated CPUs. The new root cgroup file will be enough to inform the system
> what CPUs will have to be isolated.
> 
> My current thinking is that the root's "cpuset.cpus.isolated" will start
> with whatever have been set in the "isolcpus" or "nohz_full" boot command
> line and can be extended from there but not shrank below that as there can
> be additional isolation attributes with those isolated CPUs.

I'm not sure we wanna tie with those automatically. I think it'd be
confusing than helpful.

Thanks.

-- 
tejun
