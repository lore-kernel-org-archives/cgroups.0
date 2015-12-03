From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-4.4-fixes] cgroup_pids: don't account for the root
 cgroup
Date: Thu, 3 Dec 2015 10:17:24 -0500
Message-ID: <20151203151724.GF27463@mtj.duckdns.org>
References: <20151130224543.GC9039@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=QAqYljqgsnxDbPlwTGtlZoWP+jtRIRWo7MB9RT6PR5g=;
        b=jU957sJV8bPwYJNRVgzmIvX2TEsoeREmARWtWqsagyID+ZSONjHQwQ9JbGKM+Du8Sd
         WocuI+QpZffmtHaOrfiEiARUTYRvGUJEqg9w/LVeURqiBMg8yzwQhjjhWoT14u9unPiv
         DXA8p7hno7P21b8AtHq/8b/89f8bjtQVDaPvGxpxyUUJToCGPrOuQ7Oh+rAz4oVD5/mI
         U8znjw66NMfEElIm3MN/zKtIvw73gB9sqChG+gvZXRhK2r8m0jDsyXSjSllClOjk18Qe
         7ly9a3YnR8SEUE418d9s2h2hIZQ94YPcHq5XJHrxBykqj4zJXooinIBJIfdgaingmUgA
         PO4Q==
Content-Disposition: inline
In-Reply-To: <20151130224543.GC9039-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

On Mon, Nov 30, 2015 at 05:45:43PM -0500, Tejun Heo wrote:
> From 7bbb8d4e913853a1346d95745ca8092f0cc8ce00 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Mon, 30 Nov 2015 17:24:34 -0500
> 
> Because accounting resources for the root cgroup sometimes incurs
> measureable overhead for workloads which don't care about cgroup and
> often ends up calculating a number which is available elsewhere in a
> slightly different form, cgroup is not in the business of providing
> system-wide statistics.  The pids controller which was introduced
> recently was exposing "pids.current" at the root.  This patch disable
> accounting for root cgroup and removes the file from the root
> directory.
> 
> While this is a userland visible behavior change, pids has been
> available only in one version and was badly broken there, so I don't
> think this will be noticeable.  If it turns out to be a problem, we
> can reinstate it for v1 hierarchies.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

Applying to cgroup/for-4.4-fixes.

Thanks.

-- 
tejun
