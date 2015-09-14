From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/5] cgroup, memcg, cpuset: implement
 cgroup_taskset_for_each_leader()
Date: Mon, 14 Sep 2015 16:49:07 -0400
Message-ID: <20150914204907.GI25369@htj.duckdns.org>
References: <1441998022-12953-1-git-send-email-tj@kernel.org>
 <1441998022-12953-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=1pLDfcwQ8R39J3VyF7VDTh2IaLjrSflkh7p0D+n0c1k=;
        b=qfkynledrA33LasAr/GlUACS+mWXl86MJnhJEdOK9htA1m5+WAFsu8zkA6vUxb8BZN
         ABforpY7CjOKRGwaNxaGQEqijqV0W/fYDKFejGJ1dsQxr+s0zlgSwKKRW3ATSm1JMQSY
         2G9RCKH6tOOjZwmaeLL5c/GUuwSE150KfM3/KG4g22YH4c2wFXBMxKFDkFwvQdbT0jPi
         mX11s1Ge+qMagiuvH1u3idSWnHsqgbG2a7jQvRa6bNIffB2lXN3fzQdIBSDFBGG6qzI+
         591rPqmDyhei5fas+d1JKBbM6LUPKOtRijp7TiMabplpPlzl3i0Dm0rRxXT1Ciui/t5w
         JJFg==
Content-Disposition: inline
In-Reply-To: <1441998022-12953-3-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Sep 11, 2015 at 03:00:19PM -0400, Tejun Heo wrote:
> It wasn't explicitly documented but, when a process is being migrated,
> cpuset and memcg depend on cgroup_taskset_first() returning the
> threadgroup leader; however, this approach is somewhat ghetto and
> would no longer work for the planned multi-process migration.
> 
> This patch introduces explicit cgroup_taskset_for_each_leader() which
> iterates over only the threadgroup leaders and replaces
> cgroup_taskset_first() usages for accessing the leader with it.
> 
> This prepares both memcg and cpuset for multi-process migration.  This
> patch also updates the documentation for cgroup_taskset_for_each() to
> clarify the iteration rules and removes comments mentioning task
> ordering in tasksets.
> 
> v2: A previous patch which added threadgroup leader test was dropped.
>     Patch updated accordingly.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Acked-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Michal, if you're okay with this patch, I'll apply the patchset in
cgroup/for-4.4.

Thanks.

-- 
tejun
