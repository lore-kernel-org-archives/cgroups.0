From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: first step towards hierarchical controller
Date: Tue, 26 Jun 2012 11:12:09 -0700
Message-ID: <20120626181209.GR3869@google.com>
References: <1340717428-9009-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=0AcnfGkA74hhozMhXy2RWYT+bu3IXrT1sT2F/v9T0lI=;
        b=mRKELX0GKi9ko3mRmWQ/Vl2RTYuQGq1Yj5/pfRmVoQY64I1y5hTWZlDxVFCB5BEYrI
         ygKQHC5Tji0LhBIOZ/AhjMkEc3lAdpGF1lJCwwHYM2QdMXYXXGK4FoY/7FDQtRgPh267
         RU20vXMtC1LqR82PfK5b2+/Wo+uKdU78pQpwq1WzFijm0PcBzhmdmixpqhjLtmg4kgyF
         JNPDidIig9SuBiB7pT3LpTJdz8EkMdSmF9PQJFbrtJiVHQdZ4/hWVl9xqmqUvwfoJXqc
         NX1xWDZ4DVdwzbMaKiNi/kh3t7ojli7Zk8uFbER8yIqBVgWDR45+gF4FhG6aQz837Ffg
         NKQA==
Content-Disposition: inline
In-Reply-To: <1340717428-9009-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Tue, Jun 26, 2012 at 05:30:28PM +0400, Glauber Costa wrote:
> Okay, so after recent discussions, I am proposing the following
> patch. It won't remove hierarchy, or anything like that. Just default
> to true in the root cgroup, and print a warning once if you try
> to set it back to 0.
> 
> I am not adding it to feature-removal-schedule.txt because I don't
> view it as a consensus. Rather, changing the default would allow us
> to give it a time around in the open, and see if people complain
> and what we can learn about that.
> 
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> CC: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Just in case it wasn't clear in the other posting.

 Nacked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

You can't change the default behavior silently.  Not in this scale.

Thanks.

-- 
tejun
