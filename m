From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cpusets: Allocate heap only when required
Date: Fri, 24 Jan 2014 05:36:31 -0500
Message-ID: <20140124103631.GB4101@htj.dyndns.org>
References: <8622e93b9c49c66ffdc9ef0aa8371c322718edd5.1390475530.git.viresh.kumar@linaro.org>
 <alpine.DEB.2.02.1401231330530.7313@chino.kir.corp.google.com>
 <52E1C8BD.2010500@huawei.com>
 <alpine.DEB.2.02.1401240230190.9846@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jDdWhgxR/U05cHSWkZLX5RPDTnLFmYtw98QBIG1Us/0=;
        b=mhEy/ho8Dz3V/AZPaw/PqeYBIxdD+KBWAIa174MiD0tH4nTk6oiPufN+xBHOkjyEO0
         gyDkgm/D0zpje0zhOfwN8ZKrp0H8CIZOJ1RZQjILLnIl7FmaPY2mWQtgxy48zmPlwg4Z
         kZcoFJF3A2YbEE5q07tbYnOr/OoziLQZWarUmfnK0j07BDOHtwOUMF1TkQWYYlpFfoZ2
         b+ZeCuOz/P2NhmmBcxcVqtCU5Pd1muQ+EEeg/fZMIPwKGrIxmH5mPatJLIenRsUsdDEE
         WNhPvwBTzpHB4sX+JFaGZVSlJVYV0Q74nv0+H0LbOm5qGRcJk9nRz0pbUCxFFwQcn3DG
         L9Jw==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401240230190.9846-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Jan 24, 2014 at 02:33:27AM -0800, David Rientjes wrote:
> It's not harmless, if heap_init() fails with -ENOMEM then the write fails 
> even though it may not be for memory_spread_page or memory_spread_slab, 
> which is the minority of the callers of this function.

And depending on details like that would actually be more harmful.
Please remember that all writes through cgroupfs may fail under very
high memory pressure.  There's no "this specific set of writes to this
specific knob isn't affected by memory pressure" guarantee.

Thanks.

-- 
tejun
