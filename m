From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup_pids: add fork limit
Date: Wed, 11 Nov 2015 02:25:34 +1100
Message-ID: <CAOviyaiXSCztjv0d99G-t-yo1wtGzXZr0qpuqcKDBdV=wnMinw@mail.gmail.com>
References: <144716440621.20175.1000688899886388119.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cyphar_com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=5dGbw0QEeo4CJguD5dKg1voA3YwjSf5aiT5EQJta0AI=;
        b=TPMjUjRX/kYNN3haHTT8qVXnKbq/mddSzXpOUgRgcSqrlRNjiaDKmRrN/tPi01KcuD
         eci/xA3ThI4fdzyXZKhHhncrqcYLL4dStuswtrB84v9YvHN5qQSmf+m37+LUKVi0mDUk
         uDYXZDz7bDTPGQcVqNRWZ6fKcPsQkNmHtZAs1huolVZNLLhBubV2YISCKJ1vegy/5I0J
         myM4UMgrLww1BLT8RPgAcYcjtlt8jgkWPMBFa/bcD3IHtIGUUzDf64KS4huzf1wojb2o
         KWXggd/bpZAoDJ7ydjBCUT2TiULHmZY6WYyTZ+Cu2i2znCOCkHSFBhicaNu0vkxHaLzL
         XIFg==
In-Reply-To: <144716440621.20175.1000688899886388119.stgit-Rjmu19FXx3rR8JxBgnUBv+rzNCUFrscg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Max Kellermann <mk-xMchvyqCc6DQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, max-hDT0AjmEH7RAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Max,

I agree with what Tejun said, I just wanted to make a few specific points:

> This patch introduces a new setting called "fork_remaining".  When
> positive, each successful fork decrements the value, and once it
> reaches zero, no further forking is allowed, no matter how many of
> those processes are still alive.  The special value "unlimited"
> disables the fork limit.

I don't understand *why* you want this. cgroups are meant to deal with
the accounting of *legitimate resources*, and I don't see how "the
number of forks ever in a given cgroup" is a reasonable resource. Not
to mention that it doesn't make sense IMO to make a limit that gets
smaller over time when processes that have died and been freed

> The goal of this limit is to have another safeguard against fork
> bombs.  It gives processes a chance to set up their child processes /
> threads, but will be stopped once they attempt to waste resources by
> continuously exiting and cloning new processes.  This can be useful
> for short-lived processes such as CGI programs.

Processes don't "use up resources" after they've died and been freed
(which is dealt with inside PIDs). Yes, lots of small processes that
die quickly could (in principle) make hard work for the scheduler, but
I don't see how "time spent scheduling in general" is a resource...
Fork bombs aren't bad because they cause a lot of fork()s, they're bad
because the *create a bunch of processes that use up memory*, which
happens because they call fork() a bunch of times and **don't
exit()**.

-- 
Aleksa Sarai (cyphar)
www.cyphar.com
