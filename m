From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] docs/admin-guide/cgroup-v2: Add hugetlb rsvd files
Date: Fri, 16 Apr 2021 16:45:38 -0400
Message-ID: <YHn3cifQv1FUOqfU@slm.duckdns.org>
References: <20210416141146.542786-1-odin@uged.al>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AWk2YlZvUGRhuI33/yUiX9atOwnUzYG38aU0FDL42xY=;
        b=FgYVOoIdZ4sQvOUT1JHrYKUFU+jlAZrX78C0g+MopM30ar0Syn+iLvzEO4VIqddWS1
         UysK6NZeNoZrgjYV+94LqtBg6zzL4j3YA3ymub+zYiZ7HeXW3eMcsbQNgLEtZbgEAGEd
         NwCAVBm68ZCQW0pd7nhRSmXyzRUx0qFOpF8n1ks4cGty5hzQZtu4xGt9G3IVGDqP9VrG
         VTBRVjqLw/87EP9NdCFf6ROhq+1yNH/Xh6Ix7K4uGy2tqn4qFLaaZo1GG5OF2CTo7hEd
         SIXouwLYFVsVloQAJHhTNhAQXYBEWaadxBljbSdFOBdn/wblVABFvDN+h05QUmQdmsf9
         Oj/A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210416141146.542786-1-odin-RObV4cXtwVA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Cc: corbet-T1hC0tSOHrs@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

(cc'ing memcg maintainers)

On Fri, Apr 16, 2021 at 04:11:46PM +0200, Odin Ugedal wrote:
> Add missing docs about reservation accounting for hugetlb in cgroup v2.
> 
> Signed-off-by: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
> ---
> RFC: This is linking from cgroup-v1 docs, and that is probably not
> optimal. The information about the difference between reservation
> accounting and page fault accounting is pretty hard to make short.
> 
> I think we have four ways to do it, but I don't know what is
> most optimal:
> 
> - Link from cgroup-v2 to cgroup-v1 (this patch)
> - Have a separate description for both v1 and v2
> - Move description from cgroup-v1 to cgroup-v2, and link from v1 to
>   v2.

This would be my preference but I don't really mind the other way around
that much.

> - Move info from cgroup-v1 to admin-guide/mm/hugetlbpage or
>   vm/hugetlbfs_reserv, and link from cgroup to them.

What do others think?

Thanks.

-- 
tejun
