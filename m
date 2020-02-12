From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] cpuset: Make cpuset hotplug synchronous
Date: Wed, 12 Feb 2020 22:32:48 +0100
Message-ID: <20200212213248.GE14897@hirez.programming.kicks-ass.net>
References: <1579878449-10164-1-git-send-email-prsood@codeaurora.org>
 <ee889f30-cb81-e0a8-6068-715ca3399fdd@codeaurora.org>
 <20200212211832.GC80993@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=62yXb7kO6TJItSD02Iyixn2SKX2PdulFGZN/QvehXUg=; b=q5RYRX42TPN9Oi7y9IkQKuSF2E
        tbIRdTFpijBPubabgk+LuJXJ9H5ZsDP33NNlcytmEkzwDsVcQYylkc/knhRDRjk3OeDy2rYfL5kAC
        xxLJJGqB4RIIq1a76bGWkDNl5jWqy1+m9mB2W4oLzqSn2EnTJtIz80KRAkL29vC28i9sm/EwIbGAH
        1RLVwsLBvqjN1NmUZF61mcxs81ZgvaqgmSkaWBIexyL8JHIiik38QZZHYDwBeksPu9X1OR8qoAka4
        jfb1V4ZPWz8NkD67huGn/uuvnj2A1atOBkMmywi9kjW0h2F2NQmgxATQ7g3bG8teJ2A8YJ1Wb8Bk8
        rpRJbgPw==;
Content-Disposition: inline
In-Reply-To: <20200212211832.GC80993-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Feb 12, 2020 at 04:18:32PM -0500, Tejun Heo wrote:
> On Sat, Feb 01, 2020 at 08:33:34AM +0530, Prateek Sood wrote:
> > Hi Tejun & Peter,
> > 
> > Could you please share your feedback on this patch for making
> > 
> > cpuset_hotplug_workfn synchronous.
> 
> Hey, IIRC, we went back forth with this several times. Unless there's
> a pressing reason to change, I'd rather leave it alone.

I think I have a similar patch in one of the many in-progress series I
keep around; IIRC it is the one where I add per-cpu support to
SCHED_DEADLINE. The hotplug accounting becomes easier if we do this.

Sadly this series is fairly low on the todo list atm though :/ I have no
problems keeping it around until such a time though.
