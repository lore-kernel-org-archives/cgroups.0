From: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC][PATCH] cgroup_threadgroup_rwsem - affects scalability and
 OOM
Date: Fri, 12 Aug 2016 09:47:13 +1000
Message-ID: <20160811234713.GA22218@350D>
References: <4717ef90-ca86-4a34-c63a-94b8b4bfaaec@gmail.com>
 <20160810194306.GP25053@mtj.duckdns.org>
Reply-To: bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8VUReVUCLDCy46C0REHakaJMiwohe05gakfExhZ8e4M=;
        b=fPFLTRNkpjK0nrGdSDIvDPIEFRATeUFhUr4s4Z1NTE6IpsYZ3lqC8h1IXkzkXtobn2
         SMtFT7T6nMO11ohveqb0TSOTn96R/85Ni8LiKle8m4yV/Hk0TJt6VhGVcWreGsxNUqTu
         8/Hg5r69KZKg4hCjC1s8nxPjq9UYkQJlNd665DljsgMDSXkFo05PhQxRIhZon4xYtgy2
         U99f4owKPeaF/ND5l/ALzl+Psa6eNC4X5KJQc3SgJAZEpU469TFRJocHZa9lqnz4odYM
         UohocMopP5Zf76HKgm66axvNEILy9PNoZPpPpn+NinSZ91PZ/HBx5y5MdvqawnzalFWT
         0heA==
Content-Disposition: inline
In-Reply-To: <20160810194306.GP25053-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Wed, Aug 10, 2016 at 03:43:06PM -0400, Tejun Heo wrote:
> Hello,
> 
> Edited subject and description and applied the patch to
> cgroup/for-4.8-fixes w/ stable cc'd.
>

Thanks, Found a typo below.. small nit
 
> Thanks.
> ------ 8< ------
<snip>
> This patch moves the threadgroup_change_begin from before
> cgroup_fork() to just before cgroup_canfork().  There is no nee to
							     ^ need
> worry about threadgroup changes till the task is actually added to the
> threadgroup.  This avoids having to call reclaim with
> cgroup_threadgroup_rwsem held.
> 
