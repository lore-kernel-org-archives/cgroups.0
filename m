From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Documentation: cgroup v1: remove section about subsystem
 as a module.
Date: Thu, 21 Jan 2016 11:25:54 +0800
Message-ID: <56A04FC2.7000205@huawei.com>
References: <1452779165-15567-1-git-send-email-rami.rosen@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452779165-15567-1-git-send-email-rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Rami Rosen <rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org

On 2016/1/14 21:46, Rami Rosen wrote:
> This patch removes the text relating to compiling cgroup as a module,
> since commit  3ed80a62bf95 ("cgroup: drop module support") makes this text not
> relevant anymore.
> 
> Signed-off-by: Rami Rosen <rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Acked-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

> ---
>  Documentation/cgroup-v1/cgroups.txt | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/Documentation/cgroup-v1/cgroups.txt b/Documentation/cgroup-v1/cgroups.txt
> index c6256ae..176f95e 100644
> --- a/Documentation/cgroup-v1/cgroups.txt
> +++ b/Documentation/cgroup-v1/cgroups.txt
> @@ -525,11 +525,6 @@ Each subsystem should:
>  - add an entry in linux/cgroup_subsys.h
>  - define a cgroup_subsys object called <name>_subsys
>  
> -If a subsystem can be compiled as a module, it should also have in its
> -module initcall a call to cgroup_load_subsys(), and in its exitcall a
> -call to cgroup_unload_subsys(). It should also set its_subsys.module =
> -THIS_MODULE in its .c file.
> -
>  Each subsystem may export the following methods. The only mandatory
>  methods are css_alloc/free. Any others that are null are presumed to
>  be successful no-ops.
> 
