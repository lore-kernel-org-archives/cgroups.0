From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [regression] cpuset: offlined CPUs removed from affinity masks
Date: Tue, 24 Mar 2020 14:01:39 -0400
Message-ID: <20200324180139.GB162390@mtj.duckdns.org>
References: <1251528473.590671.1579196495905.JavaMail.zimbra@efficios.com>
 <20200219154740.GD698990@mtj.thefacebook.com>
 <59426509.702.1582127435733.JavaMail.zimbra@efficios.com>
 <20200219155202.GE698990@mtj.thefacebook.com>
 <1358308409.804.1582128519523.JavaMail.zimbra@efficios.com>
 <20200219161222.GF698990@mtj.thefacebook.com>
 <316507033.21078.1583597207356.JavaMail.zimbra@efficios.com>
 <20200312182618.GE79873@mtj.duckdns.org>
 <1289608777.27165.1584042470528.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WTcUW0G2da/p6PXHgnEzI2FtMutVR8dAOTnWSKNo/+8=;
        b=fVKbJ0LHDno6UVMja5OyHYNwO6yCqhK1y3EJW23eRpqc3oLwkZVCCHkDqeP7sKA+QB
         ODf5aQrksDN+cOXyxvOmleitLuwhhjOcSmmOPRq+sIxi7IPWAxkAtnfM9pr1O7dG8fWc
         fvVPXU9zFB5XG8M+QtnplZPCqJiQrEy4ILlta4NAGap3zegdIxwUwOOYc3/NRmsIUsMw
         SH0lejDsepTjd9xxpMTjPsXy/MOuCQQx8SP/fiDqNPD5Vt2DrkKQkqWmR3U/1F0eYeoU
         Wl+Y11QpqpR7GbWrfdwyu1zHn1YLiX5j697r1x9qCTyKa6s1KGptQW9O2TCjdN7KsvGf
         G9sw==
Content-Disposition: inline
In-Reply-To: <1289608777.27165.1584042470528.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Valentin Schneider <valentin.schneider-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

Sorry about long delay.

On Thu, Mar 12, 2020 at 03:47:50PM -0400, Mathieu Desnoyers wrote:
> The basic idea is to allow applications to pin to every possible cpu, but
> not allow them to use this to consume a lot of cpu time on CPUs they
> are not allowed to run.
> 
> Thoughts ?

One thing that we learned is that priority alone isn't enough in isolating cpu
consumptions no matter how low the priority may be if the workload is latency
sensitive. The actual computation capacity of cpus gets saturated way before cpu
time is saturated and latency impact from lowered mips becomes noticeable. So,
depending on workloads, allowing threads to run at the lowest priority on
disallowed cpus might not lead to behaviors that users expect but I have no idea
what kind of usage models you have on mind for the new system call.

Thanks.

-- 
tejun
