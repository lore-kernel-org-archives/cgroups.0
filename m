From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup/rstat: check updated_next only for root
Date: Wed, 5 Jan 2022 20:35:04 +0100
Message-ID: <20220105193504.GD6464@blackbody.suse.cz>
References: <20211225000932.7253-1-richard.weiyang@gmail.com>
 <20211225000932.7253-2-richard.weiyang@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1641411306; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Z17oxaYwg5r8TgwQI6BE8dbSIQZLwXeeFGf1aSsvug=;
        b=OTCOfH2WPAMMQkt+3TAEX6ZBUT4c3ABmrKzqMqxC6D8ToDb3RnKstrASy4k4jbK4CKpo7q
        84oc9WI1Niako3lRlOmch5jo8RO49ySl0GN58qxBvDiBXrWqTOCM8nW99zMX0CImTDJIU3
        EEmTSpun/SYKq2KK4Ey2GZVzufXrHUo=
Content-Disposition: inline
In-Reply-To: <20211225000932.7253-2-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Dec 25, 2021 at 12:09:32AM +0000, Wei Yang <richard.weiyang-Re5JQEe=
Qqe8AvxtiuMwx3w@public.gmane.org> wrote:
> This means we can remove the check on ->updated_next, if we make sure
> the subtree from @root is on list, which could be done by checking
> updated_next for root.

Nice refactoring.

> @@ -96,9 +97,12 @@ static struct cgroup *cgroup_rstat_cpu_pop_updated(str=
uct cgroup *pos,
>  	 * We're gonna walk down to the first leaf and visit/remove it.  We
>  	 * can pick whatever unvisited node as the starting point.
>  	 */
> -	if (!pos)
> +	if (!pos) {
>  		pos =3D root;
> -	else
> +		// return NULL if this subtree is not on-list
> +		if (!cgroup_rstat_cpu(pos, cpu)->updated_next)
> +			return NULL;
> +	} else
+		/* return NULL if this subtree is not on-list */

Just a coding style nitpick.

The patch is otherwise
Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

