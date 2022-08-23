From: Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] cgroup: simplify cleanup in cgroup_css_set_fork()
Date: Tue, 23 Aug 2022 16:47:26 +0530
Message-ID: <681dfbc9-627f-6a09-76e2-b35a920fbe7b@quicinc.com>
References: <20220823091147.846082-1-brauner@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=DfKDKQJKl89x86Q5/XAwie+DWZgdFcgm0KsDDChz1D4=;
 b=H14arlBl3NbU9+h7eFhtPqdzY9Q+E3zrZ+eblwDHDsX6xudabBmqmBpVPlti09+8lDq+
 t4MtiuZVDl9oHo7ZXiZUjRsWSszDKyrka4tpnZFqC5A9w+Q0H0sCJK8ZYME46vh4DRz4
 vJXz0UzdefVIRqR7O1be1f6Kz3uLcD0HGk0p7aM+IxWVtWZhIte++mGYG3f1te0U62ii
 QoUsl5YO52h6AVTPWs5GJeu3Z3cPi6Con1dq80uyvCZbZGNS56LW4AMVUnnY8VnTe7NA
 NVKMK4ONegKbp2SnYJusBFe3NMP8P8BQnDeqB/uPNTgAXaNa+621B40vDsH7ax3hknMv 8w== 
Content-Language: en-US
In-Reply-To: <20220823091147.846082-1-brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

Hi,

On 8/23/2022 2:41 PM, Christian Brauner wrote:
> The call that initializes kargs->cset is find_css_set() and it is the
> last call in cgroup_css_set_fork(). If find_css_set() fails kargs->cset
> is NULL and we go to the cleanup path where we check that kargs->cset is
> non-NULL and if it is we call put_css_set(kargs->cset). But it'll always
> be NULL so put_css_set(kargs->cset) is never hit. Remove it.
> 
> Fixes: ef2c41cf38a7 ("clone3: allow spawning processes into cgroups")
> Reported-by: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> Signed-off-by: Christian Brauner (Microsoft) <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>   kernel/cgroup/cgroup.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index ffaccd6373f1..2ba516205057 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -6247,8 +6247,6 @@ static int cgroup_css_set_fork(struct kernel_clone_args *kargs)
>   	if (dst_cgrp)
>   		cgroup_put(dst_cgrp);
>   	put_css_set(cset);
> -	if (kargs->cset)
> -		put_css_set(kargs->cset);
>   	return ret;
>   }
>   

LGTM.

Reviewed-by: Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>

-Mukesh

> 
> base-commit: 1c23f9e627a7b412978b4e852793c5e3c3efc555
