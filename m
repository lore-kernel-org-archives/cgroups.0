From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [regression] cpuset: offlined CPUs removed from affinity masks
Date: Thu, 12 Mar 2020 14:26:19 -0400
Message-ID: <20200312182618.GE79873@mtj.duckdns.org>
References: <1251528473.590671.1579196495905.JavaMail.zimbra@efficios.com>
 <20200219151922.GB698990@mtj.thefacebook.com>
 <1589496945.670.1582126985824.JavaMail.zimbra@efficios.com>
 <20200219154740.GD698990@mtj.thefacebook.com>
 <59426509.702.1582127435733.JavaMail.zimbra@efficios.com>
 <20200219155202.GE698990@mtj.thefacebook.com>
 <1358308409.804.1582128519523.JavaMail.zimbra@efficios.com>
 <20200219161222.GF698990@mtj.thefacebook.com>
 <316507033.21078.1583597207356.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eViXmXzzaMR0CsZTGCPQ+TrKF+BfmVsvrf179rOhgZI=;
        b=vaPuM3qaA0oNIgyjxBq9fo3DjzTSplT6RX2awoFL63OjPQPW+ohK7ZmosBeMwA33rp
         gl4GllPZLcLHYZjGqrIAb/x62R4MxbseghAwoKVUWsFKml4ds2fxEWkE9HZwDll19KCn
         +Qmm33d/9prjdKrV8qLAkUOCwW/Ea0XxuIeTMbHrR2CbhUESvN7ZOnpAX2IWxAiyHYiO
         5K3TXt2oMTzXZSTkU86QSSKimtBUmLZGpezZ/So5SG5QdO/JbE9q+Tfj2/Hv0NoOlagI
         01At2u7pl/YpF9OLfCOZvE2pgd/wPC2cfGrm2fjJhcbN6NhoXPI1h8i0Eut9nII5A4zE
         v+KA==
Content-Disposition: inline
In-Reply-To: <316507033.21078.1583597207356.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Valentin Schneider <valentin.schneider-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

Hello,

On Sat, Mar 07, 2020 at 11:06:47AM -0500, Mathieu Desnoyers wrote:
> Looking into solving this, one key issue seems to get in the way: cpuset
> appear to care about not allowing to create a cpuset which has no currently
> active CPU where to run, e.g.:
...
> Clearly, there is an intent that cpusets take the active mask into
> account to prohibit creating an empty cpuset, but nothing prevents
> cpu hotplug from creating an empty cpuset.
> 
> I wonder how to solve this inconsistency ?

Please try cpuset in cgroup2. It shouldn't have those issues.

Thanks.

-- 
tejun
