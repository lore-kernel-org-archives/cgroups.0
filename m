From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 0/4] cgroup: Introduce cpu controller test suite
Date: Fri, 22 Apr 2022 19:50:44 +0200
Message-ID: <20220422175044.GX2731@worktop.programming.kicks-ass.net>
References: <20220422173349.3394844-1-void@manifault.com>
 <YmLqdIiXdpQqcPTd@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Toyju6a+evnhzH+Nqks+WR6DENzUjw2yWJmWU3651y0=; b=b0QAaktQMlIxRfq/uHTuerhC7B
        Z53GTvIOeOO2kg5KrMW1hGLzc9YhdqWmc4rqrLeV63geBifrYl7QT8IfiaAx72PSDbHixmrAuTM5A
        5N+FanBJW3e/1JOMd/6zxYCkQhoErfZ7wPYKKmQRYYgyBiYn9e8ztX+3O3JZOBaeDADGnZVO9fPxy
        MBreCn8jNX04jupKTnL29af4St2DmZDV7klFTdgRamsFyECj1miJZaxhwuIsylseJ9IbUzKoqw9bY
        JKbau1LLKiNZtUjjs59qyKi7sy1sbku1D89tsYC7ZK09divKAXHrXAqMfXATyTvHEgJAyF9lIMrns
        z4tW2xOg==;
Content-Disposition: inline
In-Reply-To: <YmLqdIiXdpQqcPTd-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Apr 22, 2022 at 07:48:36AM -1000, Tejun Heo wrote:
> Hello, David.
> 
> On Fri, Apr 22, 2022 at 10:33:47AM -0700, David Vernet wrote:
> > This patchset introduces a new test_cpu.c test suite as part of
> > tools/testing/selftests/cgroup. test_cpu.c will contain testcases that
> > validate the cgroup v2 cpu controller.
> > 
> > This patchset only contains testcases that validate cpu.stat and
> > cpu.weight, but I'm expecting to send further patchsets after this that
> > also include testcases that validate other knobs such as cpu.max.
> > 
> > Note that checkpatch complains about a missing MAINTAINERS file entry for
> > [PATCH 1/4], but Roman Gushchin added that entry in a separate patchset:
> > https://lore.kernel.org/all/20220415000133.3955987-4-roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org/.
> 
> Looks great to me. Thanks for adding the much needed selftests. Peter, if
> you're okay with it, imma route it through the cgroup tree.

Sure, have at. Thanks!
