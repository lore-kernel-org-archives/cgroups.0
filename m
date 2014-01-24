From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cpusets: Allocate heap only when required
Date: Fri, 24 Jan 2014 05:40:01 -0500
Message-ID: <20140124104001.GC4101@htj.dyndns.org>
References: <8622e93b9c49c66ffdc9ef0aa8371c322718edd5.1390475530.git.viresh.kumar@linaro.org>
 <alpine.DEB.2.02.1401231330530.7313@chino.kir.corp.google.com>
 <52E1C8BD.2010500@huawei.com>
 <CAKohpomn_wgQExfhJL6=MB9LrRhR4=+7t3ehy0d6vEq9duzr8Q@mail.gmail.com>
 <20140124102758.GA4101@htj.dyndns.org>
 <CAKohponoeEvYW5XvB5hAcQkz96uwrs-sLj_pag06A8K52F4RDw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=l8IDrBkTeTqAu8aQrK344C3v2cwdLwVFeMp/nBVGqzw=;
        b=jho1+IupTJirQf+ZLrIsqPEqGrNTZM+hbQJio9M8xYD8B50OwxOvJeK9kMMk+9F0Ih
         8GKZxzcGoyfAAFoWOHl9LwI7I4u4VALTnAbZUoL5zTsgsPKpSpqTsV6n2XxqwBUpFFN/
         T0TXF2oDpKwYoeOpiGFGbCnGQ+A2nZZEoR+f28P/TIVyDejHrr8+0Hl9Tv7VLr2+tGPt
         029E0pjpLY1gpeVudvQelbpDCQK+OrhAsaBiJpbglHrNhT33I9GfZnNa9MOima/Ywf+I
         qlrFZYE2hHaJDTZQqllRKHe+eIrNP3UYJHr/oZ64X4ya0VRjIh3+7HWJS3dPh7Dc4SQL
         Ia0g==
Content-Disposition: inline
In-Reply-To: <CAKohponoeEvYW5XvB5hAcQkz96uwrs-sLj_pag06A8K52F4RDw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Li Zefan <lizefan@huawei.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Lists linaro-kernel <linaro-kernel@lists.linaro.org>, Patch Tracking <patches@linaro.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Fri, Jan 24, 2014 at 04:03:18PM +0530, Viresh Kumar wrote:
> On 24 January 2014 15:57, Tejun Heo <tj@kernel.org> wrote:
> > Ummm... so, the original posting forgot to cc Li (the maintainer), me
> > or cgroups mailing list.  Please don't do this in the future.
> 
> I thought Ingo/PeterZ are maintainers of this as well, just after sending
> patch I had a look at MAINTAINERS to see if I was wrong and forgot
> somebody.
> 
> I saw Li there and sent a mail (private) to Li about this patch, I failed to
> see you or the cgroups list mentioned there for CPUSETS and so just
> sent mail to Li, otherwise I would have got all of you in loop..
>
> Anyways, I forgot to add even Li in the first place, so yes accepted,
> probably would be better if we can updated Maintainers :)

Li, can you please send a patch to add mailing list and tree tags to
the maintainers entry?  And, eh, it happens.  No worries.  Just don't
forget next time.

Thanks.

-- 
tejun
