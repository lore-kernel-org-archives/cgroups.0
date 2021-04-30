From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 3/5] tests/cgroup: use cgroup.kill in cg_killall()
Date: Thu, 29 Apr 2021 20:23:34 -0700
Message-ID: <YIt4NhikbQKc0Vku@carbon.dhcp.thefacebook.com>
References: <20210429120113.2238065-1-brauner@kernel.org>
 <20210429120113.2238065-3-brauner@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Tv8xAodhZB1pPWLe3ajSdpX6HV4ol17IoYFcGyP/eeg=;
 b=E+BHothG1Roe92Q5gkeQbZdXeOpFQ/j1tns/2OCleu4fbNdYUED4zqAz41XnU6bzTlVO
 ZjRtAVCnQ6p3KixOOE57HuSA6lZgfECwYzX1EYyKakdbPypZNuPcDrRALHnGi8Lq9thF
 tKzjKScGIvUXvwIqrQPQiKjr1D/FrMSEbto= 
Content-Disposition: inline
In-Reply-To: <20210429120113.2238065-3-brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

On Thu, Apr 29, 2021 at 02:01:11PM +0200, Christian Brauner wrote:
> From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> 
> If cgroup.kill file is supported make use of it.
> 
> Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> ---
>  tools/testing/selftests/cgroup/cgroup_util.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
> index 027014662fb2..3e27cd9bda75 100644
> --- a/tools/testing/selftests/cgroup/cgroup_util.c
> +++ b/tools/testing/selftests/cgroup/cgroup_util.c
> @@ -252,6 +252,10 @@ int cg_killall(const char *cgroup)
>  	char buf[PAGE_SIZE];
>  	char *ptr = buf;
>  
> +	/* If cgroup.kill exists use it. */
> +        if (!cg_write(cgroup, "cgroup.kill", "1"))
   ^^^^^^^^
   spaces?

> +		return 0;
> +
>  	if (cg_read(cgroup, "cgroup.procs", buf, sizeof(buf)))
>  		return -1;
>  
> -- 
> 2.27.0
> 

Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

with a fixed formatting.

Thanks!
