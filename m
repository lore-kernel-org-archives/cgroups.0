From: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>
Subject: Re: Deadlock due to "cpuset: Make cpuset hotplug synchronous"
Date: Tue, 7 Apr 2020 14:07:26 +0100
Message-ID: <20200407130725.jhtth3bneo33zex6@e107158-lin.cambridge.arm.com>
References: <F0388D99-84D7-453B-9B6B-EEFF0E7BE4CC@lca.pw>
 <20200325191922.GM162390@mtj.duckdns.org>
 <20200326101529.xh763j5frq2r7mqv@e107158-lin>
 <20200403145523.GC162390@mtj.duckdns.org>
 <20200406105522.c66p4vzzzylety5d@e107158-lin.cambridge.arm.com>
 <20200406143405.GH162390@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200406143405.GH162390-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>, Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On 04/06/20 10:34, Tejun Heo wrote:
> On Mon, Apr 06, 2020 at 11:55:23AM +0100, Qais Yousef wrote:
> > What would be the right approach to get a fix in then? We have been skipping
> > this test for a while and we'd like to enable it but this failure is a
> > blocking issue.
> 
> Update the test so that it accounts for the async nature of the operation?

With a sleep() between the hp ops and the read? Isn't this a nasty hack?

I was just trying to find out what can be done for 5.7. But based on your
response this is sadly a dead end. For no reason I can comprehend.
