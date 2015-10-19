From: "Robert Gierzinger" <robert.gierzinger-RbZlAiThDcE@public.gmane.org>
Subject: =?utf-8?q?Re=3A_cgroup_pid_controller_side_effects?=
Date: Mon, 19 Oct 2015 12:00:11 +0200
Message-ID: <25ed-5624bf00-9-6577f300@260675660>
References: <20151016173943.GA2162@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=gmx.at; s=mail;
	t=1445248811; bh=n49puKw5KIm5+/0b85cdkP7uy8mauAYfLStrKZBAk/Q=;
	h=in-reply-to:to:from:subject:date:cc:From:Sender:To:CC:Subject:
	 Date;
	b=Oy7BmrxvesdalnjiqKaiiIp5HBzQoOrv2z6ghsBylf59xkZIRODP6nUntGAdFbH6N
	 wxEpIn1DC0gu8K9JQJhISYW2qOcdlCmY4uI8/XXoUtHtKJof3vfFu9V/hHxetkddLX
	 EsRb44mG2noKYwmYageNR8uIeKR5IftNkjCAjW5psNXfKCgzbQPokxGSfrva/QH4Qn
	 3QOUYhLINKQjmSSfQfbfzIZghJLDdAU7glI2icVhR1XgPHG67GdQmCDoU3vGbIVBkW
	 5crErGJOQZH3l60jYhMv2g/ye/+IOlDxgJ4C3OaZj66UgyG3tFQ/lKJHeRSLR+/gX1
	 qS7r3dPpyNrIw==
in-reply-to: <20151016173943.GA2162-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

 
On Friday, October 16, 2015 19:39 CEST, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote: 
> Could you retry your test against the following branch?
> 
> https://git.kernel.org/cgit/linux/kernel/git/tj/cgroup.git/log/?h=for-4.4

Nice! This seems to work great, yummy! The system behaves as expected, I did some tests on a virtual 4-core machine with root cgroups, user cgroups executing shell and the mentioned c-forkbomb with up to 5k procs per cgroup. Even under parallel "attack" within several groups the other process groups just worked fine. 

Thanks for the great work!

Robert
