From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Fix wrong check in
 update_parent_subparts_cpumask()
Date: Tue, 31 Jan 2023 12:21:35 -1000
Message-ID: <Y9mUb22hOY9CmEIt@slm.duckdns.org>
References: <20230131154803.192530-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7ZnMNTNoXOmaGSq2MU9iWJuW3qH7F1Tm7PkorK2d7rA=;
        b=HiHAGDju3Xjyz1jNGsC+PEn/3kaBnTTCUXPnV4kiqQLzMXAiFDCg59wVh1JdDG2m1Q
         oUkmbvwIw5N9kn3zynuIPTrCsOydyyjtwwS0jG1BJkXoVGd1kyRXajjGlMX5Dzk1hZDC
         qzfcY/tUf2GnwP+yLK2jBt343L2Y93l6ecpycpnnmhV4ukJlwbJKmzXeFdHu0MtUnl3q
         mm98BKdprBgGW72wB+YE8bebOdgZ95CHTCfkBYZbX5WVZ0yrGoqdfK9DLtuuStFRB5ko
         JzyTgRUckBpz+dtdBZBhlMYe+FbybhZyUE+RCosRACCoYpZWZbxr+sKYYg0I7j3+t760
         kVhw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230131154803.192530-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Srinivas Pandruvada <srinivas.pandruvada-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Tue, Jan 31, 2023 at 10:48:03AM -0500, Waiman Long wrote:
> It was found that the check to see if a partition could use up all
> the cpus from the parent cpuset in update_parent_subparts_cpumask()
> was incorrect. As a result, it is possible to leave parent with no
> effective cpu left even if there are tasks in the parent cpuset. This
> can lead to system panic as reported in [1].
> 
> Fix this probem by updating the check to fail the enabling the partition
> if parent's effective_cpus is a subset of the child's cpus_allowed.
> 
> Also record the error code when an error happens in update_prstate()
> and add a test case where parent partition and child have the same cpu
> list and parent has task. Enabling partition in the child will fail in
> this case.
> 
> [1] https://www.spinics.net/lists/cgroups/msg36254.html
> 
> Fixes: f0af1bfc27b5 ("cgroup/cpuset: Relax constraints to partition & cpus changes")
> Reported-by: Srinivas Pandruvada <srinivas.pandruvada-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.2-fixes w/ stable cc added.

Thanks.

-- 
tejun
