From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 2/2] sched: add throttled time stat for throttled
 children
Date: Wed, 21 Jun 2023 11:23:17 -1000
Message-ID: <ZJNqRefKRP5mxFaw@slm.duckdns.org>
References: <20230620183247.737942-1-joshdon@google.com>
 <20230620183247.737942-2-joshdon@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687382600; x=1689974600;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I4rxMNbWqvL7SlrQRGe8uFSm6XpuYw7vzKHdGgmcjiI=;
        b=MSf3PCXq6wdLohcP9gMgCzMabwUNVmiy4Osu4b3QDHklikztVAPUZkOPJaihAdm1z4
         cKDA/Zb36eDxDxF/+j92qnBpKTjKp9o8FPaqZaPw4KdEaiTPHoy8t0rCXJ/ytda3tKtS
         wUi42M5xqm0IeiQ6aF096aYo7xjYAzNDPdOS1HVoaOmwnvVVQ3GdmoT9oVj60i3UeOnK
         nBnJFEZHfvRvi++CwEzljmyCohdD2tZQ5aSD4piwJDOvGgrayNoUkG0oGTpYoN3coPJM
         aAyoM8KEMMRJgcckSr6tUgfo4L5r2FuiKEssu4ZqtvoZc2Ye5PuZw+l4sSxXQhS/NpRR
         cf/A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230620183247.737942-2-joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org

On Tue, Jun 20, 2023 at 11:32:47AM -0700, Josh Don wrote:
> We currently export the total throttled time for cgroups that are given
> a bandwidth limit. This patch extends this accounting to also account
> the total time that each children cgroup has been throttled.
> 
> This is useful to understand the degree to which children have been
> affected by the throttling control. Children which are not runnable
> during the entire throttled period, for example, will not show any
> self-throttling time during this period.
> 
> Expose this in a new interface, 'cpu.stat.local', which is similar to
> how non-hierarchical events are accounted in 'memory.events.local'.
> 
> Signed-off-by: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
