From: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/4] cgroup/cpuset: Miscellaneous updates
Date: Tue, 28 Mar 2023 14:40:01 +0100
Message-ID: <20230328134000.GA1333@willie-the-truck>
References: <20230317151508.1225282-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680010807;
        bh=icUy13Xzx8zHFQYe+wcW2EESbKwQa3rKnpkk5O1qqOo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dnpLXIuxAYnWll/36a77A70//tWgi7UQv5dZoVH7VSv2/a9EAsI0GZIPnCgkhA060
         VslmWbFGcWf79brWo36ELhrhE4YyMh5zn7QADHaduPRccfPGtc2gnmExolXu23WsLX
         BGzcIr3YSBMUrjvDqgeyz7MYhzYeT/fh9xgr7KOr2hiZ2/rZAY3b148Sw+k6mDWbt+
         19GUyK6xFRoVD0yvXTL2QRBWihNcViUPyY5kRqGUeNBin+6uiuKHKcmb7w40DPVFhS
         hwBCh79JIrz2NcJEj/7c3A9x97h6lXiSofq63UTTdgyGiV5iUm9rA1aihu3tuGL1m3
         0rCqqFWrsCoKA==
Content-Disposition: inline
In-Reply-To: <20230317151508.1225282-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hi Waiman,

On Fri, Mar 17, 2023 at 11:15:04AM -0400, Waiman Long wrote:
>  v2:
>   - Add a new patch 1 that fixes a bug introduced by recent v6.2 commit
>     7a2127e66a00 ("cpuset: Call set_cpus_allowed_ptr() with appropriate
>     mask for task").
>   - Make a small twist and additional comment to patch 2 ("cgroup/cpuset:
>     Skip task update if hotplug doesn't affect current cpuset") as
>     suggested by Michal.
>   - Remove v1 patches 3/4 for now for further discussion.
> 
> This patch series includes miscellaneous update to the cpuset and its
> testing code.

FWIW, this series also passes my asymmetric 32-bit tests.

Cheers,

Will
