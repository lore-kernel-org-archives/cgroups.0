From: "Paul E. McKenney" <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/4] RFC: support for global CPU list abbreviations
Date: Sun, 8 Nov 2020 13:24:29 -0800
Message-ID: <20201108212429.GA8195@paulmck-ThinkPad-P72>
References: <20201108160816.896881-1-paul.gortmaker@windriver.com>
 <20201108180222.GA17637@paulmck-ThinkPad-P72>
 <ca462940-c81d-d968-c870-e1a991331522@windriver.com>
Reply-To: paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604870669;
        bh=vxmvo8miQMzTKLGrFkPnE/1C253hjdvDi75bzDKNigs=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=D1Pwm4DU8rJIviPoYdLiBzgsCCxy6gVSQcFf1yNazQCs+JB9zxJgdTwWlBtlWRalj
         k2rJwirfrbAQI2n0Itq5h0UBa8J2Ry4ts8q+vOdavz1Ka+WsmrIB+R41zTp0+6m9mA
         oqXolKCTPHqB4f3SCxZi/a4bOJ+qs5NnZQON7P5w=
Content-Disposition: inline
In-Reply-To: <ca462940-c81d-d968-c870-e1a991331522-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Sun, Nov 08, 2020 at 03:21:40PM -0500, Paul Gortmaker wrote:
> On 2020-11-08 1:02 p.m., Paul E. McKenney wrote:
> 
> > Or I can carry them if you wish.  My expected changes in response to
> > this series are shown below, and are also what I used to test it.
> 
> Thanks Paul - that would get linux-next exposure w/o me pestering sfr.
> If nobody else has objections, having them in rcu-next would be great.

Unless/until someone objects, you got it!

							Thanx, Paul
