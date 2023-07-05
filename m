From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: avoid unneeded cpuset_mutex re-lock
Date: Tue, 4 Jul 2023 23:10:01 -0400
Message-ID: <974a48a8-7402-6303-10e8-9d5fe475bb42@redhat.com>
References: <20230704120352.1226787-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688526612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tdjVolfunLG09gIQv/MDbIflC0qYXjY8Y9Vwr+tdYRk=;
        b=S3i1ZP4K6E2txNxQruf0yb2TYd5El7xkzlBBLTJ1NWrivPeu6/vX5JDqTTBXvRtkhDK7/W
        cxrPshPMf5LrVPOxQeaxBs3YgUdqL2BqDyIo/OHxaWadsVBABqvOgfLxec4JpB+0pZjlif
        6Tii5YlzXw0mMakFou1iV/EffVmVglU=
Content-Language: en-US
In-Reply-To: <20230704120352.1226787-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 7/4/23 08:03, Miaohe Lin wrote:
> cpuset_mutex unlock and lock pair is only needed when transferring tasks
> out of empty cpuset. Avoid unneeded cpuset_mutex re-lock when !is_empty
> to save cpu cycles.
>
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>   kernel/cgroup/cpuset.c | 9 ++++-----
>   1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 601c40da8e03..e136269c152c 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -3521,17 +3521,16 @@ hotplug_update_tasks_legacy(struct cpuset *cs,
>   	is_empty = cpumask_empty(cs->cpus_allowed) ||
>   		   nodes_empty(cs->mems_allowed);
>   
> -	mutex_unlock(&cpuset_mutex);
> -
>   	/*
>   	 * Move tasks to the nearest ancestor with execution resources,
>   	 * This is full cgroup operation which will also call back into
>   	 * cpuset. Should be done outside any lock.
>   	 */
> -	if (is_empty)
> +	if (is_empty) {
> +		mutex_unlock(&cpuset_mutex);
>   		remove_tasks_in_empty_cpuset(cs);
> -
> -	mutex_lock(&cpuset_mutex);
> +		mutex_lock(&cpuset_mutex);
> +	}
>   }
>   
>   static void
Reviewed-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

