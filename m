From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 cgroup/for-5.20] cgroup: Replace
 cgroup->ancestor_ids[] with ->ancestors[]
Date: Sat, 30 Jul 2022 00:42:09 +0200
Message-ID: <YuRiQc35guAWcbjt@blackbook>
References: <YuQvcCrcgNWbtndU@slm.duckdns.org>
 <YuRJ7uzKY5/fokH5@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1659134531; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1rD+aoO58/UXvvvt/aND0JlhDHBAo4vbm4X2nBeuMrk=;
        b=nbv4TSFz/AnJ67K2qEUp0Et7jSzrGj8ODP/vQ+wQ5NbNs4GVIu4Lic3m9pVH14mB7IAxPw
        38W7rHxJ+F4RbBLqFG1hS1HjDT6b+uI46lCtzHEHYaMDAlDCS1Yd3ZVU+mq1C96HfSj08e
        2PxnIbPcmNaWI+rlSU4gbKxre7POMmQ=
Content-Disposition: inline
In-Reply-To: <YuRJ7uzKY5/fokH5-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pablo Neira Ayuso <pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org>

On Fri, Jul 29, 2022 at 10:58:22AM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> @@ -520,8 +520,8 @@ struct cgroup_root {
>  	/* The root cgroup.  Root is destroyed on its release. */
>  	struct cgroup cgrp;
>  
> -	/* for cgrp->ancestor_ids[0] */
> -	u64 cgrp_ancestor_id_storage;
> +	/* for cgrp->ancestors[0] */
> +	u64 cgrp_ancestor_storage;

Just noticed, this member is (and was AFAICS) superfluous.


Michal
