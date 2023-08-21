From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 0/6] Backport rework of deadline bandwidth restoration
 for 6.1.y
Date: Mon, 21 Aug 2023 15:26:03 +0200
Message-ID: <2023082140-dreaded-hemstitch-84b9@gregkh>
References: <20230820152417.518806-1-qyousef@layalina.io>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1692624366;
        bh=wo0AEq7EVLKcJNozUw706Dbt/mblagvb19WS0DocC+A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V/U5FQXfP7owWoyl3u1JxwD1cHjEUFKG09746gRFkXDP1fKWXpzqEutKp5T+YVlIw
         6D6CY94Zcc1Emt2MBjamEHENJfOnn/7+afTAltLYm3pkNlcrocUDqmGateOT0InCAn
         AUxwehIro76XKzfZ3YhS8n84UtJuLMwwG0dhQEG0=
Content-Disposition: inline
In-Reply-To: <20230820152417.518806-1-qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, John Stultz <jstultz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Aug 20, 2023 at 04:24:11PM +0100, Qais Yousef wrote:
> This is a backport of the series that fixes the way deadline bandwidth
> restoration is done which is causing noticeable delay on resume path. It also
> converts the cpuset lock back into a mutex which some users on Android too.
> I lack the details but AFAIU the read/write semaphore was slower on high
> contention.
> 
> Compile tested against some randconfig for different archs and tested against
> android14-6.1 GKI kernel.
> 
> My testing is limited to resume path only; and general phone usage to make sure
> nothing falls apart. Would be good to have some deadline specific testing done
> too.
> 
> Based on v6.1.46

I can't take these for only some branches, as you know.  Any reason why
you didn't also do 6.4.y?

thanks,

greg k-h
