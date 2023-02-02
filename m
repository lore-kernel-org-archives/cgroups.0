From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/2] cgroup/cpuset: Make hotplug code more efficient
Date: Thu, 2 Feb 2023 11:52:46 -1000
Message-ID: <Y9wwrvRDCspI6fhT@slm.duckdns.org>
References: <20230202143200.128753-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oPbQKX8+ZHiavjG0GpX1JkPzLwnGdWH//FsOE0v5fqg=;
        b=bTh7QzdUcluIUmAbaGdliBuyZhCIto2AflV+SltaNWnV46dCPIwNeCePIU/9c2iMdE
         c6MwnYIygtVy7olhrptGdPXQjAa9Q6ihDAnkj8cr8R7i20RxQB61n1B4xgkDK0EKyPJU
         H30Ap1rasAQ6UMfg6pTjk6LImI1CDQLtjwa+xH9vtnoJmdbFWtWeI/tom+KRXoLqylLU
         K91crbJ7H5Ct1sRQgomr/sJnDoxBRZnJznWLinf7LvUE3Dnn/1YtM/mbcr0aDOpL8L7+
         teP4fSUkgNPFgT6zZnAvhFu3OaiORiA1SV60V25P7R1rM7RwiBQUTpg9H6jfAVzQD8py
         J+EQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230202143200.128753-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Thu, Feb 02, 2023 at 09:31:58AM -0500, Waiman Long wrote:
>  v2:
>   - It turns out it works around the v1 cpuset missing offline cpu
>     problem better than I originally thought. So the patch description
>     is updated accordingly.
> 
> This small patch series makes the cpuset hotplug a bit more efficient
> by eliminating unnecessary task iteration and cpu/node masks update
> when a cpu hotplug event (online/offline) happens.
> 
> It can also largely work around the known problem of missing previously
> offlined cpus in v1 cpuset with some exceptions.

Imma hold on these patches for now. Let's see how the regression fix goes
and revisit after the merge window.

Thanks.

-- 
tejun
