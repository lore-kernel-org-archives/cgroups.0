From: Tejun Heo <tj@kernel.org>
Subject: Re: cgroups-related hard lockup in 4.14?
Date: Wed, 20 Dec 2017 15:24:09 -0800
Message-ID: <20171220232409.GA1084507@devbig577.frc2.facebook.com>
References: <20171220225923.GA10374@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=q8Qv0xvvtLWs6bVeh41Hi7oA2ABC7ypSUxe9xftFLgA=;
        b=azR52P5ggMv9nT9ZvBPiLUBharIaW4PXCcnunY4Q+GyPv7so0dFaRHbMBPaWhkKN7g
         mwx0E5zmlQz4yrd11b13lMl64Akbd3BGu6W4wt8pP0Z0iP9mbInYp2/Lkcz7DOcKXwln
         Zf6GqjFN0CcUhn2Nrr5nFaDlvmWxhdYGAtHvbRMA9xvVrmoVY+pk6Se9WYbhJXSxnlx4
         Yn/tL+hjlt9TD728iQTDgZAjLUw8cBv7JiF86uj6gb/7qJrzdh4O+TFbpqdulNCUWzgV
         5PL9e1xwSTqrkXKGHsLWZO1FCJ6muxR09WcbifHsAobEPoKWVn4pqqGwK+n1QHtwrZcs
         bGgg==
Content-Disposition: inline
In-Reply-To: <20171220225923.GA10374@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Aloni <dan@kernelim.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org

On Thu, Dec 21, 2017 at 12:59:23AM +0200, Dan Aloni wrote:
> Hi,
> 
> Using netconsole, I was able to capture a hard lockup that seems to be
> related to cgroups, on a Fedora kernel based on v4.14.4.
> 
> By my analysis, from the 16 CPUs below, 14 are on css_set_lock, one is
> inside css_task_iter_advance, and the last one stuck trying to send an
> IPI, I guess because all other CPUs are spinning.
> 
> To add some context, I have been experiencing deadlocks on various
> machines starting from 4.13 and it's the first time I was able to
> capture one. It takes a few days to reproduce while idling or doing
> random work, and I have not yet come up with precise steps that can
> nail it.
> 
> I can try out patches in order to get more info on this issue.

Can you please try the following patch?

 https://marc.info/?l=linux-cgroups&m=151378281708793&q=raw

Thanks.

-- 
tejun
