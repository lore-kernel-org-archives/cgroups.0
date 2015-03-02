From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 2/2] cpusets,isolcpus: add file to show isolated cpus
 in cpuset
Date: Mon, 02 Mar 2015 15:54:49 +0100
Message-ID: <1425308089.2859.7.camel@gmail.com>
References: <1424882288-2910-1-git-send-email-riel@redhat.com>
	 <1424882288-2910-3-git-send-email-riel@redhat.com>
	 <54EEFE15.3010005@huawei.com>
	 <20150226121231.6fcba7e8@annuminas.surriel.com>
	 <20150302090933.GH21418@twins.programming.kicks-ass.net>
	 <1425300290.5863.17.camel@gmail.com> <54F47534.7070204@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:mime-version:content-transfer-encoding;
        bh=LMdJ2m3kYrygmCi7u+F48U5Xi2GY0twQblmkAYokmEM=;
        b=c5TEKXTiqjsUTS5cP36z4ISB1cUKV25C1AuJAXszqPxP4MoQXWNrXkK//iYkG0CsO1
         j+c5ZXpX4HYRhmgkxhLGmPxqZh3M6BteAkK+bmVzv0r0zJckLxrq4jQQFGM027qpm2UG
         O2qpLcd57aJQtwCvxSBl0lFwad+XCDi7AYSS8B8XsrRqBh0f/ZBW8j4K3oWJMwYIqwxT
         e2pEjMphm/RR+ev/9MWyG8jWJ0WCsMxO64DjKEqMd4vdw7hwO2amieSLMsfV/hvS8fAC
         0MM5H7LGSeDs3ImlXR7Rh28a+X82FPENsaKvA3LjBnsXfoUwItlKf2kbh2f62YdMJCv0
         QP5A==
In-Reply-To: <54F47534.7070204-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 2015-03-02 at 09:35 -0500, Rik van Riel wrote:
> On 03/02/2015 07:44 AM, Mike Galbraith wrote:
> > On Mon, 2015-03-02 at 10:09 +0100, Peter Zijlstra wrote:
> >> On Thu, Feb 26, 2015 at 12:12:31PM -0500, Rik van Riel wrote:
> >>> Subject: cpusets,isolcpus: add file to show isolated cpus in cpuset
> >>>
> >>> The previous patch makes it so the code skips over isolcpus when
> >>> building scheduler load balancing domains. This makes it hard to
> >>> see for a user which of the CPUs in a cpuset are participating in
> >>> load balancing, and which ones are isolated cpus.
> >>>
> >>> Add a cpuset.isolcpus file with info on which cpus in a cpuset are
> >>> isolated CPUs.
> >>>
> >>> This file is read-only for now. In the future we could extend things
> >>> so isolcpus can be changed at run time, for the root (system wide)
> >>> cpuset only.
> >>>
> >>> Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >>> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> >>> Cc: Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >>> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>> Cc: Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>> Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >>> Cc: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >>> Signed-off-by: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>
> >> So let me start off by saying I hate isolcpus ;-)
> >>
> >> Let me further state that I had hopes we could extend cpusets to
> >> natively provide the functionality isolcpus has, and kill isolcpus.
> > 
> > +1
> > 
> > That's where nohz_full goop belongs too.
> 
> Except nohz_full and isolcpus are very much global attributes of
> each CPU, so I am not sure whether it would make sense to allow
> configuration of this attribute anywhere other than the root
> cpuset.

They're attributes of exclusive sets, which excludes the root set.  It'd
be kinda hard to have the root set be both ticked and tickless :)

	-Mike

