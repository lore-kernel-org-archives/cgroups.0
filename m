From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 4/5] cgroup/cpuset: Documentation update for partition
Date: Wed, 2 Aug 2023 11:01:57 -1000
Message-ID: <ZMrERWeIeEOGzXHO@slm.duckdns.org>
References: <20230713172601.3285847-1-longman@redhat.com>
 <20230713172601.3285847-5-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691010119; x=1691614919;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B5eoW13Er2byi3F5AVWdPVCJvLFofz+zD3HXMr0r2JM=;
        b=P1bVrDOw/XQIdFJy0p0oko56FRhKc/+1jthxROevZRwecRH5Uht2TndqyzxXrGGMog
         7/30DAYMILosXblR2uDbNqmfTJrJMBW568BcowS8vvbiHkiYdm130TChDOkV8z2pXcMs
         JIQa7odjTt+Hxyp0rxDAR4JkZ68MimCN76/dauJ6lareMIriz1fgAKe/SjYkFD9foGyk
         RufJNhvEQAOyBDZciJv+71xUTQgxVCkM9UKYs4VDR4ZbVvgFgnbLsUdnW8PCp73IgO3Z
         188Gk8UPI+WKN3h4oIfAgFSkQZ2mK/9lQRZpLS9Xo5/AK5XjzeLp31hGu5CfFmzyVgKt
         ryiw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230713172601.3285847-5-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Giuseppe Scrivano <gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello, Waiman.

On Thu, Jul 13, 2023 at 01:26:00PM -0400, Waiman Long wrote:
...
> +	When a valid partition is created, the value of this file will
> +	be automatically set to the largest subset of "cpuset.cpus"
> +	that can be granted for exclusive access from its parent if
> +	its value isn't explicitly set before.
> +
> +	Users can also manually set it to a value that is different from
> +	"cpuset.cpus".	In this case, its value becomes invariant and
> +	may no longer reflect the effective value that is being used
> +	to create a valid partition if some dependent cpuset control
> +	files are modified.
> +
> +	There are constraints on what values are acceptable to this
> +	control file.  If a null string is provided, it will invalidate a
> +	valid partition root and reset its invariant state.  Otherwise,
> +	its value must be a subset of the cgroup's "cpuset.cpus" value
> +	and the parent cgroup's "cpuset.cpus.exclusive" value.

As I wrote before, the hidden state really bothers me. This is fine when
there is one person configuring the system, but working with automated
management and monitoring tools can be really confusing at scale when there
are hidden states like this as there's no way to determine the current state
by looking at what's visible at the interface level.

Can't we do something like the following?

* cpuset.cpus.exclusive can be set to any possible cpus. While I'm not
  completely against failing certain writes (e.g. siblings having
  overlapping masks is never correct or useful), expanding that to
  hierarchical checking quickly gets into trouble around what happens when
  an ancestor retracts a CPU.

  I don't think it makes sense to reject writes if the applied rules can't
  be invariants for the same reason given for avoiding hidden states - the
  system can be managed by multiple agents at different delegation levels.
  One layer changing resource configuration shouldn't affect the success or
  failure of configuration operations in other layers.

* cpuset.cpus.exclusive.effective shows what's currently available for
  exclusive usage - ie. what'd be used for a partition if the cgroup is to
  become a partition at that point.

  This, I think, gets rid of the need for the hidden states. If .exclusive
  of a child of a partition is empty, its .exclusive.effective can show all
  the CPUs allowed in it. If .exclusive is set then, .exclusive.effective
  shows the available subset.

What do you think?

Thanks.

-- 
tejun
