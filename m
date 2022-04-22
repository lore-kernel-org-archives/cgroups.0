From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 0/4] cgroup: Introduce cpu controller test suite
Date: Fri, 22 Apr 2022 05:32:27 -0700
Message-ID: <20220422123227.gtirbsygpjek3iss@dev0025.ash9.facebook.com>
References: <20220419213244.2104972-1-void@manifault.com>
 <YmHY3t9UC2/zDyMz@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YmHY3t9UC2/zDyMz-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hi Tejun,

On Thu, Apr 21, 2022 at 12:21:18PM -1000, Tejun Heo wrote:
> * Can you please repost w/ Ingo and Peterz cc'd?

Will do, I'll cc them on v2.

> * Maybe cpucg instead of cgcpu?

Agreed, that seems more intuitive. I'll change it in v2.

> * Single level testing is great but extending the case to cover deeper
>   nesting level would be great. ie. a test case with multi level tree w/
>   both under and over provisioned parts in the tree.

This sounds like a great idea. I have another patch set that I was planning
to send out which adds a few more testcases. I can include some testcases
in that set which validate more complicated nesting setups.

Thanks,
David
