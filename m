From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/4] cgroup: Introduce cpu controller test suite
Date: Fri, 22 Apr 2022 08:40:46 -1000
Message-ID: <YmL2rt7A6qfiv1X4@slm.duckdns.org>
References: <20220422173349.3394844-1-void@manifault.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KgLoqACed/YZWsVbHrClZlNdD0m+rkp/BoBwdt4BJaE=;
        b=jjHDbpnHX6rMI9T8KFgLNp0ENDWYQzw2OnvkKfT9UQOI2yRq8Asp37du911P0uT51a
         W7bwMqKe5m4asxDiJP8/o2e5ghbCMtpvCswT/CZGdG8P847ssbbl0dQ3CJ0LFxfw47sr
         rVg/ipMn6ayl+b7lnPIceFAu3Phcsa6npmUORP1tKu0VEVYLu0F3NscVbL9JUQccqpkN
         UhePV2nn/P6+nKszndoc/eX5WqOSCST9zZsvh34SIzrCvgFeyDSgwO6nAe45qwDNx0Ik
         BELEuUDiscQ4ITnHg8DqExxZSnFdjjjM1ViRPTwtjGY255O1GtjRGFmUwJdrdAYtB+4J
         mG1A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220422173349.3394844-1-void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Apr 22, 2022 at 10:33:47AM -0700, David Vernet wrote:
> This patchset introduces a new test_cpu.c test suite as part of
> tools/testing/selftests/cgroup. test_cpu.c will contain testcases that
> validate the cgroup v2 cpu controller.
> 
> This patchset only contains testcases that validate cpu.stat and
> cpu.weight, but I'm expecting to send further patchsets after this that
> also include testcases that validate other knobs such as cpu.max.
> 
> Note that checkpatch complains about a missing MAINTAINERS file entry for
> [PATCH 1/4], but Roman Gushchin added that entry in a separate patchset:
> https://lore.kernel.org/all/20220415000133.3955987-4-roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org/.

Applied to cgroup/for-5.19.

Thanks.

-- 
tejun
