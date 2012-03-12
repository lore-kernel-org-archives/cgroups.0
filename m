From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Date: Mon, 12 Mar 2012 15:10:50 -0700
Message-ID: <20120312221050.GG23255@google.com>
References: <20120221211938.GE12236@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=FCXP9qwzCYEYrRS50S0+dgk8Sd6D+Q0q/u/lJGyqYgg=;
        b=sr6ra80NTRLK5mgq5rmqhwTAhLI4LuSHY4aJY/Ctzaay3Q8tP2wGKMXiOi6gTSe8t9
         lExoMdqU4AMvyQstYezA+Pnsygklhh2vyxCyxgIo/QbjrGo48/9spKHmcVcUx47crDKI
         yRXWl2zzHXigyd8Tpe5J2pMoSkS3lTzESg0yRG9gVbXv3e1J5vj2FrVnV7UnUHR+D6ht
         yl/UKHNYNyKuiAHdn9eZBF5fp2xaz1bhQFDlsU6I0f3+n1vjUPSiSO5tUOVvlk5dwiXN
         CZv68d91xPNwmrIme3sP/XFQNEE7UslgrwMcNo6jIQBbIWKytNPA+uS1qq9QChn3DjMA
         Twww==
Content-Disposition: inline
In-Reply-To: <20120221211938.GE12236-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Schmidt <mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Hello, guys.

Thanks a lot for the discussion and here are my take aways:

* At least to me, nobody seems to have strong enough justification for
  orthogonal multiple hierarchies, so, yeah, unless something else
  happens, I'm scheduling multiple hierarchy support for the chopping
  block.  This is a long term thing (think years), so no need to panic
  right now and as is life plans may change and fail to materialize,
  but I intend to at least move away from it.

* Several people pointed out that it would be inconvenient to require
  cgroup hierarchy to be a strict super-imposed tree on top of process
  tree and that program groups / sessions aren't like that either.  I
  agree, so it will hopefully be single hierarchy which more or less
  behaves the same as the current hierarchy.

* How to map controllers which aren't aware of full hierarchy is still
  an open question but I'm still standing by one active node on any
  root-to-leaf path w/ root group serving as the special rest group.

  This should happen first for the long migration to begin.  I might
  get to it someday but if anyone can beat me to it, please go ahead.
  I'll be ecstatic to review and merge the patches.

Also, I'll slowly be marking features which don't seem essential,
especially the convenience features for multiple hierarchies, as
deprecated and eventually chop them.

Thank you.

-- 
tejun
