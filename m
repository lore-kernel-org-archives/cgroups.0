From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/4] cgroup: Introduce cpu controller test suite
Date: Thu, 21 Apr 2022 12:21:18 -1000
Message-ID: <YmHY3t9UC2/zDyMz@slm.duckdns.org>
References: <20220419213244.2104972-1-void@manifault.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y4d38YpC96MwNpVBxn+LoFiok0to/qtpUK4U97fO1MU=;
        b=IowvYSLsWnTxjBUdv+pWRlN3Y36o14LXqsvlMe2fleitn2tK/LKdmR7N9WVyXdUpxb
         SYsa+UYLGmwH31GN8Uy72FxeasxkNOFRcJ4RlFMyTAGPXBjyrlocbuEawV2z2M4pwIoD
         2fhn9E5/kwuOLTjits3s8RMOmxFyRz/rXDiigLAyBU1OcD+qg2WX3OizjnJknlNqkGh4
         c3nP4cHf0Rr3IjWNRNnJzfXESFrfbsSedVCgFkZ4FQglUZ3pLkEg+eo7+lZBn4TGJwC/
         EkDxVfpDNUheBE6KMBGy43t8skITwdWshrMrQAmQ0nAOKqFEKLscYpeoYgYRiO/ByMWP
         1CVg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220419213244.2104972-1-void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

On Tue, Apr 19, 2022 at 02:32:40PM -0700, David Vernet wrote:
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

This looks great to me. A few small things:

* Can you please repost w/ Ingo and Peterz cc'd?

* Maybe cpucg instead of cgcpu?

* Single level testing is great but extending the case to cover deeper
  nesting level would be great. ie. a test case with multi level tree w/
  both under and over provisioned parts in the tree.

Thanks.

-- 
tejun
