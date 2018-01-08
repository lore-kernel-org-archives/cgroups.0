From: Tejun Heo <tj@kernel.org>
Subject: Re: cgroups(7): extending man-pages documentation for cgroups v2
Date: Mon, 8 Jan 2018 04:29:11 -0800
Message-ID: <20180108122911.GM3668920@devbig577.frc2.facebook.com>
References: <7e5b2a80-9439-4229-0ad0-eecca026a282@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eNdDmVNtqmVp4xzUcfGTmrXcx66Cqydk2IyVVi0DfZM=;
        b=oqI9KckYUg2fC/tM83Qywaq4z9UPl8xQmMEmVRwek5PfxEHRjJB1A/W9MRTUsT/Oiv
         PIMmH624MGAkmgLaUTIsYn3AB0UmTFFaGIK58MDClU7/fM8gVi/1syXl62KsfcHHXKqF
         EYf5WWaPEajYmCCjw1Wl4xqPhPXQyUkbo7+MeFR+nSfuSGu7nGEfJOfxTzkoJpmgvAtu
         06k/TMSVXFFK22+JqiRJsafhTvy2541+avoSLppUUcETMSYemdD5YjVSf5xuSCavR/+J
         fq+6B7kWHbykqAU220sDGCA7VAy5MLNdALQUUlT2qTQBTIELGbmTrYzxVQWRgyCyNqGu
         AHMA==
Content-Disposition: inline
In-Reply-To: <7e5b2a80-9439-4229-0ad0-eecca026a282@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Roman Gushchin <guro@fb.com>, lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, cgroups@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>

Hello, Michael.

On Tue, Jan 02, 2018 at 07:21:27PM +0100, Michael Kerrisk (man-pages) wrote:
> There are some older features, as well as new features in 
> cgroups v2 that have not so far been documented in the cgroups(7)
> manual page. I have been working on patches to add documentation
> for these features, and the man-pages branch containing these
> patches can be found at:
> https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/log/?h=draft_cgroup_updates
> 
> I will send the updates as a series of plain text messages,
> and CC relevant people on the various patches. Would it be
> possible for you to review these patches please.

Yes, will do.  Sorry about the delay.  Was traveling and then caught a
cold.

Thanks.

-- 
tejun
