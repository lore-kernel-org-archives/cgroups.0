From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 cgroup/for-5.8] cgroup: add cpu.stat file to root
 cgroup
Date: Thu, 28 May 2020 10:07:01 -0400
Message-ID: <20200528140701.GM83516@mtj.thefacebook.com>
References: <20200527160821.GC42293@cmpxchg.org>
 <20200527214316.524124-1-boris@bur.io>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c5VdfREkwzP6jqIZOFDaLilS2V6xWZ7RlAK0qP0rVTk=;
        b=abkUbCeVYyXvcNltdNzDUgkNUMN3nP0G3xnhUGHnZUuEMdO6cRsZZ7n/D5Rg8eIbNO
         PacVhQuQPeB+TJiYa8kZyUeGuPxjdQY/gELpvgbCoMNtz8SUQmKZRrqI6M9CWx2gL8aV
         je+gLtCguH3qjw0tUkfwThHVHnDklXRC2D6GGPGIWyBXVjCBZR7C1ZDVgZD6ovLN/BIT
         16ld6VTwiz4Cl1I45loB2HA4yLHDyBxGZ9u39pWfemEE2/JIIdoNh0gDNniTuAJAFL80
         jOW8cM2fxAQQya/uxtGanKJ6yfJ4gChPso1P2Fa5PhyoJ3jtpYZzVWQ2BzgYrpGCR7Pr
         DS8Q==
Content-Disposition: inline
In-Reply-To: <20200527214316.524124-1-boris-UrQYPotlwNs@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, May 27, 2020 at 02:43:19PM -0700, Boris Burkov wrote:
> Currently, the root cgroup does not have a cpu.stat file. Add one which
> is consistent with /proc/stat to capture global cpu statistics that
> might not fall under cgroup accounting.
> 
> We haven't done this in the past because the data are already presented
> in /proc/stat and we didn't want to add overhead from collecting root
> cgroup stats when cgroups are configured, but no cgroups have been
> created.
> 
> By keeping the data consistent with /proc/stat, I think we avoid the
> first problem, while improving the usability of cgroups stats.
> We avoid the second problem by computing the contents of cpu.stat from
> existing data collected for /proc/stat anyway.
> 
> Signed-off-by: Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>
> Suggested-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Applied to cgroup/for-5.8.

Thanks.

-- 
tejun
