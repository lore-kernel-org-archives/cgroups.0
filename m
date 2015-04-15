From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH V2] cpuset: Add knob to make allowed masks hotplug
 invariant on legacy hierarchy
Date: Wed, 15 Apr 2015 17:19:26 +0200
Message-ID: <20150415151926.GS23123@twins.programming.kicks-ass.net>
References: <20150410141118.11284.36206.stgit@preeti.in.ibm.com>
 <20150411083537.GR27490@worktop.programming.kicks-ass.net>
 <20150413070117.GX24151@twins.programming.kicks-ass.net>
 <552BB3A5.9060905@linux.vnet.ibm.com>
 <20150413144311.GF5029@twins.programming.kicks-ass.net>
 <552E4E41.3030008@linux.vnet.ibm.com>
 <20150415150302.GA25089@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150415150302.GA25089-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, nacc-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, bharata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Wed, Apr 15, 2015 at 10:03:02AM -0500, Serge E. Hallyn wrote:

> Peter, is the question "why can't we just use the unified hierarchy for
> cpusets"?

No, the question is why can't you use the unified hierarchy cpuset
semantics -- without the actual unified hierarchy stuff.
