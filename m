From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: fix a few kernel-doc warnings & coding
 style
Date: Tue, 10 Jan 2023 12:29:01 -1000
Message-ID: <Y73mrfdnjJk2T9bj@slm.duckdns.org>
References: <20230108021217.15491-1-rdunlap@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IVyTJ4Bvb0dosRz2MzjeXlGvXv4v3QkWAgztM4d7AbQ=;
        b=FoOd0/lpm1Ec2a6lG9I04pjIOWJqT8qMjboF6tzFvFMjGcuBE9LFy0Ej1Q3fBFtKNH
         aWjoY4qnBiG4MrUJCmdWg8uzNOgfic6j8xOZB/eSQ/Jm6CfbPYV+9+qNnir9+rc8w+BX
         ec6VJy4q9I28VKPqm4Kfr6w3MDor6TZoH4qnKfVbYnIsdxBhTkCAVnc9HAXARXG1ROvh
         NC6wqDFifheIYVZSA/hFNwYZeUVFAWRjpDQUam3CtjrS5CZCcD5b4eGIswmFKKnV1vo4
         VQcN+atJhXmqY/80BApmimSASTNjg5FmWGNq1ze986+YezbZV7GIaHrK5H50+5o3nNc1
         X9jA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230108021217.15491-1-rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jan 07, 2023 at 06:12:17PM -0800, Randy Dunlap wrote:
> Fix kernel-doc notation warnings:
> 
> kernel/cgroup/cpuset.c:1309: warning: Excess function parameter 'cpuset' description in 'update_parent_subparts_cpumask'
> kernel/cgroup/cpuset.c:3909: warning: expecting prototype for cpuset_mem_spread_node(). Prototype was for cpuset_spread_node() instead
> 
> Also drop a blank line before EXPORT_SYMBOL_GPL() to be consistent
> with kernel coding style.
> 
> Signed-off-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Applied to cgroup/for-6.2-fixes.

Thanks.

-- 
tejun
