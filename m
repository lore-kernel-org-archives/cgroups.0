From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/8] cgroup: implement cgroup_is_ancestor()
Date: Mon, 8 Apr 2013 08:39:42 -0700
Message-ID: <20130408153942.GC3021@htj.dyndns.org>
References: <51627DA9.7020507@huawei.com>
 <51627DBB.5050005@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=Pg+MsMmX7TPSwuZFIo3uqCVzKE/OBv+7Vg5bSfEEWGw=;
        b=xERuuv6s6yl4SizinRyMdC+yNpH1MxKsaIW863bX82OkHJlT0KF8gSuOMJAMebwPrj
         FQVF+R12fa7uULo5u970n0r2QpEQsDfwTRkkbQa7K3YeWbuoQaa+DFSsjeas6xUQjxXn
         GQUsW4vKPOiKYCLfzZY5nDam6OgRsz0ETrFtZSjOWzqGH+uYFaAAHjzOB5Y+NGF0t2dR
         TugaCNcZ0TDyfMO7XOdORQpqUYCeC/ZTktr+0KLt3KtjeoUwpZijAnR8Dw+LzhrZBQ7d
         CgOJwnySDAeDnGjDip8DB5Nnxbyp2DYt8lCFK/TWQzkgyc/mbHJyUw/fA0Nm21+Otec3
         dAiQ==
Content-Disposition: inline
In-Reply-To: <51627DBB.5050005-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hello, Li.

On Mon, Apr 08, 2013 at 04:20:11PM +0800, Li Zefan wrote:
> +/**
> + * cgroup_is_ancestor - test "root" cgroup is an ancestor of "child"
> + * @child: the cgroup to be tested.
> + * @root: the cgroup supposed to be an ancestor of the child.

Please explain locking in the comment.  (I know it only requires both
cgroups to be accessible but being explicit is nice.)

> + * Returns true if "root" is an ancestor of "child" in its hierarchy.
> + */
> +bool cgroup_is_ancestor(struct cgroup *child, struct cgroup *root)

s/root/ancestor/

> +{
> +	int depth = child->depth;
> +
> +	if (depth < root->depth)
> +		return false;
> +
> +	while (depth-- != root->depth)
> +		child = child->parent;

Just walk up till it meets the ancestor or reaches root.  Why bother
with depth?

Thanks.

-- 
tejun
