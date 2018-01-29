From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch -mm v2 2/3] mm, memcg: replace cgroup aware oom killer
 mount option with tunable
Date: Mon, 29 Jan 2018 11:11:39 -0800
Message-ID: <20180129191139.GA1121507@devbig577.frc2.facebook.com>
References: <alpine.DEB.2.10.1801161812550.28198@chino.kir.corp.google.com>
 <alpine.DEB.2.10.1801251552320.161808@chino.kir.corp.google.com>
 <alpine.DEB.2.10.1801251553030.161808@chino.kir.corp.google.com>
 <20180125160016.30e019e546125bb13b5b6b4f@linux-foundation.org>
 <alpine.DEB.2.10.1801261415090.15318@chino.kir.corp.google.com>
 <20180126143950.719912507bd993d92188877f@linux-foundation.org>
 <alpine.DEB.2.10.1801261441340.20954@chino.kir.corp.google.com>
 <20180126161735.b999356fbe96c0acd33aaa66@linux-foundation.org>
 <20180129104657.GC21609@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sEY4FAXJnQkgtEeq8rKVIY12bu5wu6D5y3KdOgaL6Oc=;
        b=nc9Z8CeUcEe1iY5o8LdyuPdPKH78yAw+qyWjHJKC/d1Q9vjzzv08LqJ0WYBOSg44T/
         klwjYaeCVg/9IG0ytfJsEd9D3NkcSVuhOn8FvfTIRNQ8mE7X8N9QCJ4plhlXnL6K5Kpw
         uudZhqqwScuqTYvyXl5czwyCgLN1sDQaUkSeCGVu9VTxx7eOj8cTKmH9e4/RoYX9z02Z
         EFvxdOB4qSNuBvqgS3480otVhjEE/If7Yl2wzsqRxhNY2lUfrb3l48qw06eR9/nW0CpI
         64Wa3P7nCwbVdJbWdHj4t9jnkICaieVVeWP8+nU91pIdC/sa32DZdz00b1/bvU2q/Jyb
         qBbQ==
Content-Disposition: inline
In-Reply-To: <20180129104657.GC21609-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hello, Michal.

On Mon, Jan 29, 2018 at 11:46:57AM +0100, Michal Hocko wrote:
> @@ -1292,7 +1292,11 @@ the memory controller considers only cgroups belonging to the sub-tree
>  of the OOM'ing cgroup.
>  
>  The root cgroup is treated as a leaf memory cgroup, so it's compared
> -with other leaf memory cgroups and cgroups with oom_group option set.
> +with other leaf memory cgroups and cgroups with oom_group option
> +set. Due to internal implementation restrictions the size of the root
> +cgroup is a cumulative sum of oom_badness of all its tasks (in other
> +words oom_score_adj of each task is obeyed). This might change in the
> +future.

Thanks, we can definitely use more documentation.  However, it's a bit
difficult to follow.  Maybe expand it to a separate paragraph on the
current behavior with a clear warning that the default OOM heuristics
is subject to changes?

Thanks.

-- 
tejun
