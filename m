From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove cgrp->kn check in css_populate_dir()
Date: Mon, 17 Jul 2023 08:44:46 -1000
Message-ID: <ZLWMHgssvfK-nQXR@slm.duckdns.org>
References: <20230717143923.1781747-1-kamalesh.babulal@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689619488; x=1692211488;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WnUsVHtWOhbBc6SqMYJ3oA4XGwTAbIDV93qcCN9I8QI=;
        b=sWvLA6CgADJ/Pb2Z/tcxN22e+YnTrODv/utZE95TV2bUYwj0iERCCE7NL9bd0QiX70
         PzZqiCDCFHWtQnnIZJMXkud0LsPma9s2YcLkKwlmBcSmT40Dh092DDpN3GLFa1S+Oly8
         KWWLlHkPHKETyKwqnDU5HU3x2PTa1040FcOFeOshBlSI7xR//SYr61eBN/lNz+FaeAK9
         EqOxsB50Ztj16BB1iY5eiY+yIaf7PkY3y4kS+2SAcdkro6Nrd66aqlZWt1pAH61+/2ck
         EjL1oPUiuL+j5JVeeI+oZIc/BSRIWouGhGXdl/Rzqb98ngcAvL6MpFomvf5ZRv6EETIC
         vayA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230717143923.1781747-1-kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jul 17, 2023 at 08:09:23PM +0530, Kamalesh Babulal wrote:
> cgroup_create() creates cgrp and assigns the kernfs_node to cgrp->kn,
> then cgroup_mkdir() populates base and csses cft file by calling
> css_populate_dir() and cgroup_apply_control_enable() with a valid
> cgrp->kn. Check for NULL cgrp->kn, will always be false, remove it.
> 
> Signed-off-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.6.

Thanks.

-- 
tejun
