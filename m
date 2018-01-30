From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [patch -mm v2 2/3] mm, memcg: replace cgroup aware oom killer
 mount option with tunable
Date: Tue, 30 Jan 2018 11:58:51 +0000
Message-ID: <20180130115846.GA4720@castle.DHCP.thefacebook.com>
References: <alpine.DEB.2.10.1801251552320.161808@chino.kir.corp.google.com>
 <alpine.DEB.2.10.1801251553030.161808@chino.kir.corp.google.com>
 <20180125160016.30e019e546125bb13b5b6b4f@linux-foundation.org>
 <alpine.DEB.2.10.1801261415090.15318@chino.kir.corp.google.com>
 <20180126143950.719912507bd993d92188877f@linux-foundation.org>
 <alpine.DEB.2.10.1801261441340.20954@chino.kir.corp.google.com>
 <20180126161735.b999356fbe96c0acd33aaa66@linux-foundation.org>
 <20180129104657.GC21609@dhcp22.suse.cz>
 <20180129191139.GA1121507@devbig577.frc2.facebook.com>
 <20180130085445.GQ21609@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=0Q8DLGS+pKJ/3kfXirSwx3xwx9KqJZKGUn2CpBOX1aE=;
 b=B1PFHcMJY4XUr8O6qdfYQYQwHtWKIwhmhOKgNSvhMV2Sr/iTSjwObFB5vLdiridfE07m
 Vvg1/wBVBaKC9wQhR1HhFaS7sGYVPAvsSEBREEALacNxCXk1Dnk8otJiGkL8ixcRdvG/
 fwbZEUOfHVWe1syPpOZZ6lugXHnu9lelvpw= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=0Q8DLGS+pKJ/3kfXirSwx3xwx9KqJZKGUn2CpBOX1aE=;
 b=DVD2vvpTg6/PPDcSQnDfMoNFhqMT+8MNppu/Kp+EanFJ7tFMXrhyNoxsA5zCN0ZL3o/h8iskRZ9DmP4IOs3lpkaM5zXp9PxkSOR+p2zhFJY59JYTHHLDCj8uaKcKyebA8mOncJcHuEHZrVybt2YtebqqYinMtOmQk1c0Fg8KwlU=
Content-Disposition: inline
In-Reply-To: <20180130085445.GQ21609-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Jan 30, 2018 at 09:54:45AM +0100, Michal Hocko wrote:
> On Mon 29-01-18 11:11:39, Tejun Heo wrote:

Hello, Michal!

> diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
> index 2eaed1e2243d..67bdf19f8e5b 100644
> --- a/Documentation/cgroup-v2.txt
> +++ b/Documentation/cgroup-v2.txt
> @@ -1291,8 +1291,14 @@ This affects both system- and cgroup-wide OOMs. For a cgroup-wide OOM
>  the memory controller considers only cgroups belonging to the sub-tree
>  of the OOM'ing cgroup.
>  
> -The root cgroup is treated as a leaf memory cgroup, so it's compared
> -with other leaf memory cgroups and cgroups with oom_group option set.
                                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
IMO, this statement is important. Isn't it?

> +Leaf cgroups are compared based on their cumulative memory usage. The
> +root cgroup is treated as a leaf memory cgroup as well, so it's
> +compared with other leaf memory cgroups. Due to internal implementation
> +restrictions the size of the root cgroup is a cumulative sum of
> +oom_badness of all its tasks (in other words oom_score_adj of each task
> +is obeyed). Relying on oom_score_adj (appart from OOM_SCORE_ADJ_MIN)
> +can lead to overestimating of the root cgroup consumption and it is

Hm, and underestimating too. Also OOM_SCORE_ADJ_MIN isn't any different
in this case. Say, all tasks except a small one have OOM_SCORE_ADJ set to
-999, this means the root croup has extremely low chances to be elected.

> +therefore discouraged. This might change in the future, though.

Other than that looks very good to me.

Thank you!
