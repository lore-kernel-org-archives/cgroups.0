From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup:namespace: Remove unused cgroup_namespaces_init()
Date: Mon, 14 Aug 2023 14:30:09 -1000
Message-ID: <ZNrHEab_635Z68Pl@slm.duckdns.org>
References: <20230810112528.838797-1-lujialin4@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692059412; x=1692664212;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mkGNWYSgRV4909uG6OYXpkPdXlVdi8nXfegqc4fz99o=;
        b=SnlqSEdp6FwjyYK0/JgNgCFOe0+OyYkJxcVB71brWYFhDqH1zKvIVtEozJnPdxAb9J
         tVDVEeCLy0xicy6Ft/jB+WceTPL1ieHuR4FCyw+778HUSlzbfyeH6y0bDnvi3QSSfn3G
         d4Kxosrkb3+1XejznEeh+eNCyV+042Cxyqo5ChrGaigrxU8tizQw46IAvr3RgAzDdsju
         N4frI+gHFVf0H0Cpfz4WmiLeCZc4x7HXImzuZ+1nEKCeepboFMqpyfZBQy1fZnlavlfY
         Gi7dqvZpfai6ubCCEh//IiRlNAU0XIC+uO5oOKasdetSpPgfuDf0wrUGDP4cTS/v2KRV
         L4CQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230810112528.838797-1-lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Aug 10, 2023 at 11:25:28AM +0000, Lu Jialin wrote:
> cgroup_namspace_init() just return 0. Therefore, there is no need to
> call it during start_kernel. Just remove it.
> 
> Fixes: a79a908fd2b0 ("cgroup: introduce cgroup namespaces")
> Signed-off-by: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.6.

Thanks.

-- 
tejun
