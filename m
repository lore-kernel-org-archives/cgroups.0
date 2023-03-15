From: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/5] cgroup/cpuset: Miscellaneous updates
Date: Wed, 15 Mar 2023 16:24:36 +0000
Message-ID: <20230315162436.GA19015@willie-the-truck>
References: <20230306200849.376804-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678897482;
        bh=rukzdJCI+tw+s5fqfJFihxS3X4oqBD7ma0Je+Y6QpCI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gvcMCkZvmy0xyYulnpAkGL249vbZumxIZ0gmXkUWaLHYTmhw1kp33kMRZlKUg5a76
         X44pZeW2eTX0mHmn2iwhbcGHa12xNEnuJertqUlxQxRTC8LM1winp7ziDhrja4Xo4V
         tKq84JCNasxgBzolzfo0cw+o2kc3rrFV4e+DJCpcevbiwn+vVedPEWX23oaWXkZKRY
         HgX7o5nl4rEs19UhpWrPMaZ42A++sXm7JfDVxHr0gmBnc+Dr23ZzeZU3TK2ZueGYYq
         lS07EIHkniiwkywE8VmoBG75ISitCjmfwdKKNkXh+iBKyxRazFcaGViCpbdGGXm6qr
         gVeSv56EqsbrA==
Content-Disposition: inline
In-Reply-To: <20230306200849.376804-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Hi Waiman,

On Mon, Mar 06, 2023 at 03:08:44PM -0500, Waiman Long wrote:
> This patch series includes miscellaneous update to the cpuset and its
> testing code.
> 
> Patch 2 is actually a follow-up of commit 3fb906e7fabb ("cgroup/cpuset:
> Don't filter offline CPUs in cpuset_cpus_allowed() for top cpuset tasks").
> 
> Patches 3-4 are for handling corner cases when dealing with
> task_cpu_possible_mask().

Thanks for cc'ing me on these. I ran my arm64 asymmetric tests and, fwiw,
I get the same results as vanilla -rc2, so that's good.

One behaviour that persists (and which I thought might be addressed by this
series) is the following. Imagine a 4-CPU system with CPUs 0-1 being 64-bit
only. If I configure a parent cpuset with 'cpuset.cpus' of "0-2" and a
child cpuset with 'cpuset.cpus' of "0-1", then attaching a 32-bit task
to the child cpuset will result in an affinity mask of 4. If I then change
'cpuset.cpus' of the parent cpuset to "0-1,3", the affinity mask of the
task remains at '4' whereas it might be nice to update it to '8', in-line
with the new affinity mask of the parent cpuset.

Anyway, I'm not complaining (this is certainly _not_ a regression), but
I thought I'd highlight it in case you were aiming to address this with
your changes.

Cheers,

Will
