From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 2/5] docs/cgroup: add entry for cgroup.kill
Date: Thu, 29 Apr 2021 20:22:03 -0700
Message-ID: <YIt32/aQJfkw53ic@carbon.dhcp.thefacebook.com>
References: <20210429120113.2238065-1-brauner@kernel.org>
 <20210429120113.2238065-2-brauner@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=QM3TwYOmgGt8gt7A54p7wXFWNh2YZdFv2N9SQ0DZZlY=;
 b=OTaDRaQkhkvuD1/3zGSq1g5WfTs3cMAaQaGwFhQnoJjmLJafrEyPg2ySc77GoqnbdIOh
 JWZg10vOr6JW+teKUy1aew5Iw5UbWIefABk6dARkDVfPGR/yz+VCKi23IwzZxPt9jyLX
 Et1eTHCPXc6Bq5u80m/FlyS57v6A1d/3nrw= 
Content-Disposition: inline
In-Reply-To: <20210429120113.2238065-2-brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

On Thu, Apr 29, 2021 at 02:01:10PM +0200, Christian Brauner wrote:
> From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> 
> Give a brief overview of the cgroup.kill functionality.
> 
> Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 64c62b979f2f..c9f656a84590 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -949,6 +949,23 @@ All cgroup core files are prefixed with "cgroup."
>  	it's possible to delete a frozen (and empty) cgroup, as well as
>  	create new sub-cgroups.
>  
> +  cgroup.kill
> +	A write-only single value file which exists in non-root cgroups.
> +	The only allowed value is "1".
> +
> +	Writing "1" to the file causes the cgroup and all descendant cgroups to
> +	be killed. This means that all processes located in the affected cgroup
> +	tree will be killed via SIGKILL.
> +
> +	Killing a cgroup tree will deal with concurrent forks appropriately and
> +	is protected against migrations. If callers require strict guarantees
> +	they can issue the cgroup.kill request after a freezing the cgroup via
> +	cgroup.freeze.

Hm, is it necessarily? What additional guarantees adds using the freezer?

> +
> +	In a threaded cgroup, writing this file fails with EOPNOTSUPP as
> +	killing cgroups is a process directed operation, i.e. it affects
> +	the whole thread-group.
> +
>  Controllers
>  ===========
>  
> -- 
> 2.27.0
> 
