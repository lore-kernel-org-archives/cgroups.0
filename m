From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 1/1] cgroup: make per-cgroup pressure stall tracking
 configurable
Date: Tue, 8 Jun 2021 15:01:05 -0400
Message-ID: <YL++cWuetMvfx9Tf@slm.duckdns.org>
References: <20210524195339.1233449-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tyj1ti03dIMK1ozRhjYuzmAR0/ZNP3Nds6icyKCHFlQ=;
        b=aquonKpFpgW+meXELKk7PeP2BVEA64UDJBDwLTmHutu10dBUUYxGnxY/IIjgPhz1tZ
         YvU/9lSBFDD5nca8ydmknI4+DI0UMUvW5frN06/dfKwmSQYvoUBddPuKk+wCm2Fut1aS
         s/BhxnBO6tXrWGLaNJzeglvRX7Yf4f+cIkry6stGacZIGLeqgQUXTjKsK9tXFlnK0fh4
         dT4pcL2b5cHyY3b9OZtOlT2P12Uk2v3gfGx0NqxpvOMc4osp/8IdJLF8ukCPfbJQN1ph
         w9rpiWsMk6qxYup0HnG0vl4Y5b1frD11laPoGhDn7EIXl4m67RBRitzQURMiI2Bvkh29
         E0iA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210524195339.1233449-1-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, macro-fOkVWZO6G+f10XsdtD+oqA@public.gmane.org, viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Mon, May 24, 2021 at 12:53:39PM -0700, Suren Baghdasaryan wrote:
> PSI accounts stalls for each cgroup separately and aggregates it at each
> level of the hierarchy. This causes additional overhead with psi_avgs_work
> being called for each cgroup in the hierarchy. psi_avgs_work has been
> highly optimized, however on systems with large number of cgroups the
> overhead becomes noticeable.
> Systems which use PSI only at the system level could avoid this overhead
> if PSI can be configured to skip per-cgroup stall accounting.
> Add "cgroup_disable=pressure" kernel command-line option to allow
> requesting system-wide only pressure stall accounting. When set, it
> keeps system-wide accounting under /proc/pressure/ but skips accounting
> for individual cgroups and does not expose PSI nodes in cgroup hierarchy.
> 
> Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-5.14.

Thanks.

-- 
tejun
