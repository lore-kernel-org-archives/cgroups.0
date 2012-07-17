From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Update remount documentation
Date: Tue, 17 Jul 2012 11:13:49 -0700
Message-ID: <20120717181349.GC2878@google.com>
References: <1341910158-8994-1-git-send-email-wagi@monom.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=J5vYC1jIThHECXi3WK/9YDqxYK7f6F0p8xtd6ztuN2E=;
        b=Dclng3r4lZ3UEgiRNi3yt4Ui74nNHhiSaDyzCwE6VnseV6+M4a/W3VpiiT+P+bT5Uo
         jZ0+OFiSyO4RxJkRIuZ4sCFledwkb/KOgYEm8XhFSTMwdMPQsMWCVHOS14S1DsOjAnEY
         Ymcw1jSYYIykJB5zMcwBZxVyzrYVUJJf8CGUlnycksX165AxhKPbo5Y2RuMWVhsY+FMa
         UB/HyF/oV3SyKC0dZkbDkyHrUX4Sw/K/mDbgjD0zXdAaAYfeqDMiuMUy76LfiJnpvATl
         cC9KxRvihqhLeASoLcDl78f4Zps4KqtV1YrFajkKmI/DI4Y+IxPXBgDAYSlOWqmWcV3u
         DDhA==
Content-Disposition: inline
In-Reply-To: <1341910158-8994-1-git-send-email-wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On Tue, Jul 10, 2012 at 10:49:18AM +0200, Daniel Wagner wrote:
> From: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
> 
> Remounting support will be removed in the future
> (see feature-removal-schedule.txt). Discourage users to use it.
> 
> Signed-off-by: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
> Cc: Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Applied to cgroup/for-3.6.  Thanks.

-- 
tejun
