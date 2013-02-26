From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] cgroup: add cgroup_name() API
Date: Mon, 25 Feb 2013 18:27:03 -0800
Message-ID: <20130226022703.GA13837@htj.dyndns.org>
References: <512B01FA.5020506@huawei.com>
 <512B020D.9040504@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=A9C3rvG/BdZyStiEK3XHzUyoLU1I3P1FlXTWFVb/+T8=;
        b=PffmAoMQtCMKrt4ZKcWq3exeDgIVuX9PRdaRMrzkYJUX+T4CvHNZmDKUtp5ZpGKIr6
         MMr7X7Wt4j90Peepo2IebW4LQHtIg75vqzX99bW9dy6Mq/GCU3Fs1kGo214Q9fEosfhZ
         YESv209JURQM28+HC10EUlpN2C532sXdH+oxIAmf+4R97aD5f7QVO57xiSPjfEKhFIGN
         y7RRUOHB7euyKpcGIBEZsx3FPQnzFLTsC0U9uYhz8d6NplrSs+68rdJQpt4E0F9A2C5P
         jaSA14QzkuZKqA7Os+M3CtgS/NDgHCVPDWASUUGgqGHEDRl4v0lOJJA4U5AwfzhYkdVI
         sq5Q==
Content-Disposition: inline
In-Reply-To: <512B020D.9040504-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Feb 25, 2013 at 02:17:49PM +0800, Li Zefan wrote:
> cgroup_name() returns the name of a cgroup and it must be called with
> rcu_read_lock() held.
> 
> This will be used by cpuset.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
...
>  /**
> + * cgroup_name - get the name of a cgroup
> + * @cgrp: the cgroup in question
> + *
> + * Must be called with rcu_read_lock() held.
> + */
> +char *cgroup_name(const struct cgroup *cgrp)
> +{
> +	if (!cgrp->parent)
> +		return "/";
> +	else
> +		return rcu_dereference(cgrp->name)->name;
> +}

Can't we initialize ->name of root cgroup to "/" and lose the
conditional?  We can lose the wrapper altogether but if you're worried
that sparse check isn't enough, we can have trivial inline wrapper,
but in that case it probably would help to rename cgrp->name to, say,
cgrp->__name and put a comment directing people to the accessing
wrapper which should probably return const char *.

Thanks.

-- 
tejun
