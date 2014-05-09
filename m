From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: remove cgroup_tree_mutex
Date: Fri, 9 May 2014 15:58:27 -0400
Message-ID: <20140509195827.GG4486@htj.dyndns.org>
References: <1399407574-21472-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=pH/J0ji/BBAzlucYwEs/zX4MI033cbEeMnz65ZSUEdg=;
        b=tV5W7d2ItdrZRda5F6B69A00gzwr1s0l8G/xhYoda/J8E3p/i8yWrQIA6I5Wl618vn
         BWf1WzvAtuOOdEjNijA8h0TfphkwQefWWl4x238eDyWsCQwcN8EHPeowdhK63PKZdIMC
         1mjh9FuRcyS/pMMmtKCdwRUh6+/6PfKcD2+0zcvaTDdUSef1Snf9EVClZtrCeD4cAW8f
         SSNYkffe23NLvya39hwbv3kg5UgAJM4KQVN9R71uZsH4Hsx3OhfdylRmoCOapNBlQO+I
         9waof9PvnviIJuJtqO6W5NyXU8BVVuDBNVrF08JsI2aRXBVoeLC6jG35DYqMMPrws4ni
         gNFQ==
Content-Disposition: inline
In-Reply-To: <1399407574-21472-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, May 06, 2014 at 04:19:26PM -0400, Tejun Heo wrote:
> This patchset is on top of
> 
>   cgroup/for-3.16 12d3089c192c ("kernel/cpuset.c: convert printk to pr_foo()")
> + [1] [PATCHSET cgroup/for-3.16] cgroup: post unified hierarchy fixes and updates
> + [2] [PATCHSET cgroup/for-3.16] cgroup: implement cftype->write()
> 
> and is available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-kill-tree_mutex

Refreshed without content change on top of

 b9a63d0116e8 ("Merge branch 'for-3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu into for-3.16")
 + [1] [PATCHSET v2 cgroup/for-3.16] cgroup: post unified hierarchy fixes and updates
 + [2] (REFRESHED) [PATCHSET cgroup/for-3.16] cgroup: implement cftype->write()

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-kill-tree_mutex-v2

Thanks.

-- 
tejun

[1] http://lkml.kernel.org/g/1399663975-315-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[2] http://lkml.kernel.org/g/20140509195059.GE4486-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org
