From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next] cgroup/cpuset: fix kernel-doc
Date: Wed, 2 Aug 2023 15:25:46 -0400
Message-ID: <2dffccd0-d7a3-58aa-6dc6-d44ac67f6e99@redhat.com>
References: <20230802030412.173344-1-caixinchen1@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691004349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Prrsefdk3q3EqmcQR6Ob1G4yDp+W6OWglyjzE+QR0R8=;
        b=Xml2rYQY+/9npUwZWTghhexNNk0+7ytN1YzJzF5/EGR6AZ0JWUIXB3L0Jdm7wQgtGguRwH
        iHRGqPrh5gCAMp2fUF+E8/EAuHTrBFexdrruIaHTdmxXb0FJLkHJUhc85ioFjXv3umT/dW
        q8xlqhW4Lx9PTqnze0p9FoMdkL1pGWk=
Content-Language: en-US
In-Reply-To: <20230802030412.173344-1-caixinchen1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Cai Xinchen <caixinchen1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 8/1/23 23:04, Cai Xinchen wrote:
> Add kernel-doc of param @rotor to fix warnings:
>
> kernel/cgroup/cpuset.c:4162: warning: Function parameter or member
> 'rotor' not described in 'cpuset_spread_node'
> kernel/cgroup/cpuset.c:3771: warning: Function parameter or member
> 'work' not described in 'cpuset_hotplug_workfn'
>
> Signed-off-by: Cai Xinchen <caixinchen1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>   kernel/cgroup/cpuset.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index b278b60ed788..58ec88efa4f8 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -3753,6 +3753,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
>   
>   /**
>    * cpuset_hotplug_workfn - handle CPU/memory hotunplug for a cpuset
> + * @work: unused
>    *
>    * This function is called after either CPU or memory configuration has
>    * changed and updates cpuset accordingly.  The top_cpuset is always
> @@ -4135,6 +4136,7 @@ bool cpuset_node_allowed(int node, gfp_t gfp_mask)
>   
>   /**
>    * cpuset_spread_node() - On which node to begin search for a page
> + * @rotor: round robin rotor
>    *
>    * If a task is marked PF_SPREAD_PAGE or PF_SPREAD_SLAB (as for
>    * tasks in a cpuset with is_spread_page or is_spread_slab set),

Looks good to me.

Acked-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

