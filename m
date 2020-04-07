From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Deadlock due to "cpuset: Make cpuset hotplug synchronous"
Date: Tue, 7 Apr 2020 09:35:20 -0400
Message-ID: <20200407133520.GI162390@mtj.duckdns.org>
References: <F0388D99-84D7-453B-9B6B-EEFF0E7BE4CC@lca.pw>
 <20200325191922.GM162390@mtj.duckdns.org>
 <20200326101529.xh763j5frq2r7mqv@e107158-lin>
 <20200403145523.GC162390@mtj.duckdns.org>
 <20200406105522.c66p4vzzzylety5d@e107158-lin.cambridge.arm.com>
 <20200406143405.GH162390@mtj.duckdns.org>
 <20200407130725.jhtth3bneo33zex6@e107158-lin.cambridge.arm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=odzEhtuT1mkH5cv+06XvJ0mo1X9dWs4O45m8red/YFE=;
        b=lLPy54IqRiVI+gbF9bXttpMrnAgkCN0tMMlu1yiVIlS2/nkavZOJukt5viyskCkZCp
         /a3SWshrpdGsMCXv86eLzNPxbhRKSq1M1Ot/P5T8kc+zlZg61ebkbREN6INJiTb9T/nd
         bnWH7iDmLuseRsFocSas0ZOCT1ZaGSfA8inB2kUB37Q0d++qtW3YXbb6oyUtpgmgRj4B
         Ag0sQG+/+CRN2rKLdq+v2y00f8KGMwhdteP1POMgqhxUMBoefVpWT42aNaOUUb/cTIFw
         gWOHqN/gsvLlUHfCdmtSVn+SNDRwcyPuDSBY5pHYyLlkWMElV+QQ+GpDCw1CYnZ1hXk4
         gGXw==
Content-Disposition: inline
In-Reply-To: <20200407130725.jhtth3bneo33zex6-AIE2tiYzwxrZROr8t4l/smS4ubULX0JqMm0uRHvK7Nw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>
Cc: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>, Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Tue, Apr 07, 2020 at 02:07:26PM +0100, Qais Yousef wrote:
> On 04/06/20 10:34, Tejun Heo wrote:
> > On Mon, Apr 06, 2020 at 11:55:23AM +0100, Qais Yousef wrote:
> > > What would be the right approach to get a fix in then? We have been skipping
> > > this test for a while and we'd like to enable it but this failure is a
> > > blocking issue.
> > 
> > Update the test so that it accounts for the async nature of the operation?
> 
> With a sleep() between the hp ops and the read? Isn't this a nasty hack?

Some operations are just async. Why is that inherently wrong?

> I was just trying to find out what can be done for 5.7. But based on your
> response this is sadly a dead end. For no reason I can comprehend.

Because it's creating real issues while trying to address a non-real problem.
It's dumb. Fix the non-real part.

Thanks.

-- 
tejun
