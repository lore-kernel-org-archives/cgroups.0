From: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/2] Fix broken cpuset affinity handling on heterogeneous systems
Date: Tue, 31 Jan 2023 22:17:17 +0000
Message-ID: <20230131221719.3176-1-will@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675203444;
        bh=PJSvYLHcRpS9dbzIMih0FP+oXT/wdW6kY7rfhEtLzKA=;
        h=From:To:Cc:Subject:Date:From;
        b=Ygi679fQSEyO7ZcNdesDQOCNvrDlqqi9yDKz0+2k+46LCplrJWbu3qpXPqlXlDrJG
         QY8NBhs15zL+jPwDO0nUDIOp+boS9DL3iHtCvLm7tMJhdw90KfyR/OJVb/HPVsrGtU
         8Ple7yv1+7V3P84CupQNlbh4jk5O+fFai9HoF0qEUQaaG0e94OfCG9D5GxC9d4SIGu
         lxHe3tEjzeARnmfifNmlcwkk7chXl4elUZsJg25f9dmss5Ec/GM7zWMdwjQaTM7LxJ
         ORI4ojxwz/tDR6G3fmco+u6Nf+tOIZ9mLTlzAnjoRVSwU/SzfAnJ5aK7vzthufb2A8
         F/6OV29psiVEQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi folks,

These two patches fix a couple of CPU affinity issues involving cpusets
on heterogeneous systems. A concrete example of this is running 32-bit
tasks on recent arm64 SoCs, where some of the cores are only capable of
64-bit execution.

The first patch (from Peter) fixes a regression introduced during the
recent merge window which is causing test failures in Android where the
problematic patches have been backported. The second patch fixes a
longer-standing issue, which I noticed while testing fixes for the
initial regression.

Ideally, both of these would land together, but fixing the regression
for 6.2 is my main concern.

Anyway, I don't think either Peter or I would call ourselves cpuset
experts (far from it!), so please have a look.

Cheers,

Will

Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

--->8

Peter Zijlstra (1):
  cpuset: Fix cpuset_cpus_allowed() to not filter offline CPUs

Will Deacon (1):
  cpuset: Call set_cpus_allowed_ptr() with appropriate mask for task

 kernel/cgroup/cpuset.c | 57 +++++++++++++++++++++++++++++++++---------
 1 file changed, 45 insertions(+), 12 deletions(-)

-- 
2.39.1.456.gfc5497dd1b-goog

