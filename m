From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/4] cgroup: export cgrp_dfl_root
Date: Wed, 5 Aug 2015 16:23:29 -0400
Message-ID: <20150805202329.GR17598@mtj.duckdns.org>
References: <1438547024-23497-1-git-send-email-tj@kernel.org>
 <1438547024-23497-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=iuyINIC7O3SXJMJeywu4bGyeLcCQ7iAYJBYuXHHE2HM=;
        b=gacq8Tl/Wqdnabi6wjDsXXJ8+sY3g7C5wAiXpL3YvS7uRK8zg6qh/NbXvJnQ6CLFv2
         icWzZw7ECfx5e9+v9bbh3FpUbtPN6bahmqW+/IdxRPp+WE0rSwVRcanynmomlAQQI152
         poctyBzZbta9qiRySGptIJGHMRMzcYKR3iFxttbcJUmuiEL2nkdG8+2FNz8mD4sIgWEH
         i+DjA1/a9y8z1ODY3QQbF4RZWkeWFUhaNGkzAzrNn9a23z4pyY3GOgiz5+X1NXVXXFVn
         yJLXfDm3TeSx3gyfnC45xPm9nSepoxB/oJwHbJMqf+1ImJKG0dlZYAyiqL0J09cqxXbu
         KvKA==
Content-Disposition: inline
In-Reply-To: <1438547024-23497-2-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Sun, Aug 02, 2015 at 04:23:41PM -0400, Tejun Heo wrote:
> While cgroup subsystems can't be modules, blkcg supports dynamically
> loadable policies which interact with cgroup core.  Export
> cgrp_dfl_root so that cgroup_on_dfl() can be used in those modules.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Applied to cgroup/for-4.3-unified-base

Thanks.

-- 
tejun
