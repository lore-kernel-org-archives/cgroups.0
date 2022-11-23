From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Optimize update_tasks_nodemask()
Date: Wed, 23 Nov 2022 08:54:37 -1000
Message-ID: <Y35sbREgYE6aIdIp@slm.duckdns.org>
References: <20221123082157.71326-1-haifeng.xu@shopee.com>
 <Y35Swdpq+rJe+Tu3@slm.duckdns.org>
 <5fccf438-fdbe-1bc8-6460-b3911cc51566@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5sSGgviv+Rd8DodQepSsltaLLYak+O+h9smkq8iHKcU=;
        b=fPjv6zZam2cSMYf9VamxmWMlMyv7kpdr5YdnhbjOilgItBXwb6LHw4mO0zpf3risoj
         T43v3+mu8k+SWFkbYVjXSMtXRTjZuqLsAZQgYsPkZll4do16vOHi2nbSdqbMOOQ+RSOd
         HQvnOHS5e6tZWST/ye/mBAGqlKPT8RyA04w8Bjy50IdYj8+otNvunOrr9NEAIQ5OnbNk
         8VXIAJ2XD2Fd61/wbMsmflnCo54arTeNGC1DBGpG5Ol7fDTNSUrV5DexVJL1LPLky1Vj
         vlnNvp7fTlt16YKuFSyhRsSaRHXaXYyLb+ZB5wvTuDzyRVYhn/5TI9qLi+rt/1jXsZCx
         7jkA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5fccf438-fdbe-1bc8-6460-b3911cc51566-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "haifeng.xu" <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 23, 2022 at 01:48:46PM -0500, Waiman Long wrote:
> I think it is an issue anyway if different threads of a process are in
> different cpusets with different node mask. It is not a configuration that
> should be used at all.

Anything memory related is in the same boat and people still use them
reaching whatever end results they reach. Given the whole thing is pretty
ill-defined, I don't wanna change the behavior now.

> This patch makes update_tasks_nodemask() somewhat similar to cpuset_attach()
> where all tasks are iterated to update the node mask but only the task
> leaders are required to update the mm. For a non-group leader task, maybe we
> can check if the group leader is in the same cpuset. If so, we can skip the
> mm update. Do we need similar change in cpuset_attach()?

The leader isn't special tho. We just wanna avoid visiting the same mm more
than once, right?

Thanks.

-- 
tejun
