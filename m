From: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/2] cgroup/cpuset: Make hotplug code more efficient
Date: Fri, 3 Feb 2023 12:07:23 +0000
Message-ID: <20230203120722.GB6274@willie-the-truck>
References: <20230202143200.128753-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675426048;
        bh=msGwOm825d5bTfkvH6VS4qDGirjySSflMwYCy++8sKo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mm+hrRsZd6lHoQ4P32lEMMW/tnzXNG69D1a5bhZ18l3dD4lVqQsHuUiOz7kgZk8S2
         bfgNAN0H0THHk2/t1+Wi0s1tqGQdfQ9bNAVxRbF97I3Ly8781eoEWOoANXXAYAavXJ
         EnUWqZWGUqJfRdz36tJd4EGtwEQYGOWb+/jmuNKpWczJHCjvfNxDc4AXwsShZv6IPN
         jU3xHdXUWYpBFT5jO9MkcRn8P2WUz28PnrRbuXiVqv++DCBHczaxXAuCFYHh01MI9Y
         po7tGfu5rS17z7cq+dnMSArLm/JJV+ec2AR/v1SMWFP8k9rzo46kz0o1WmAGEhccaZ
         OcMdgfMUuJ3ZA==
Content-Disposition: inline
In-Reply-To: <20230202143200.128753-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

Hi Waiman,

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

I can't tell whether this is intended to address the issue I initially
reported at [1], so I gave it a spin anyway and it doesn't seem to help.

If it's unrelated, then sorry for the noise!

Will

[1] https://lore.kernel.org/r/20230117160825.GA17756@willie-the-truck
