From: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Fri, 27 Feb 2015 14:46:13 +0100
Message-ID: <54F07525.4050100@nod.at>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com> <20150227114940.GB3964@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150227114940.GB3964-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Tejun,

Am 27.02.2015 um 12:49 schrieb Tejun Heo:
> This isn't a proper resource to control.  kmemcg just grew proper
> reclaim support and will be useable to control kernel side of memory
> consumption.

just to make sure that I understand the big picture.
The plan is to limit kernel memory per cgroup such that fork bombs and
stuff cannot harm other groups of processes?

Thanks,
//richard
