From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/6] cgroup: clean up cgroup_subsys names and
 initialization
Date: Thu, 30 Jan 2014 10:16:44 +0100
Message-ID: <20140130091644.GB2749@gmail.com>
References: <1390952641-15950-1-git-send-email-tj@kernel.org>
 <1390952641-15950-4-git-send-email-tj@kernel.org>
 <20140129104648.GC9636@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Iut9v2xXNSS+wrGg4XaJHw+XXQCR7jHt2EoKptRqiDU=;
        b=uV01ry0xRbaPRNPUSBOHFE5tn6rd4gGvfBo7iPwl8A5+pEt0yJntgQh4/g8m+PRQsf
         eXs/8kElqe4aoiCLczHT+zOBWT6LucQJJKjHT5khShTWeh7hwZzsCLF4kcMT2Z4luJ86
         ZeOVHHQvSwFOi+qkKEC/2VgDbidkDL6a7Lxu2Pgpa8HzhcSafbsLrp+YE7ZSDZUbI4cH
         Zd9QazJ6SxgBcvvZCYC0UbNgTMnLoExRmxUjOAj1BzEQgaz28q4OZCfeKYhh9v++P8Vl
         uxeT8StFvvSCIN2j9OoPer/ibO+NWV570ytCJZjyIKMjH+YwMzUXXTM3qhKrwI6WraaY
         Fkxg==
Content-Disposition: inline
In-Reply-To: <20140129104648.GC9636-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Graf <tgraf-G/eBtMaohhA@public.gmane.org>


* Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> On Tue, Jan 28, 2014 at 06:43:58PM -0500, Tejun Heo wrote:
> > * With the above, renaming subsys identifiers to match the userland
> >   visible names doesn't cause any naming conflicts.  All non-matching
> >   identifiers are renamed to match the official names.
> > 
> >   cpu_cgroup -> cpu
> >   perf -> perf_event
> > 
> > Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Acked-by: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Acked-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks,

	Ingo
