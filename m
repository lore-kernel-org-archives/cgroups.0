From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] cgroup: disable irqs while holding css_set_lock
Date: Fri, 17 Jun 2016 01:36:25 -0400
Message-ID: <20160617053625.GL31708@htj.duckdns.org>
References: <1465325475-30593-1-git-send-email-bristot@redhat.com>
 <20160607193008.GA31708@htj.duckdns.org>
 <6f15f27f-3757-5413-4292-1386e95bc278@redhat.com>
 <38469b61-7cc5-5fec-4de3-0e9a616dfe95@redhat.com>
 <20160616220315.GH3262@mtj.duckdns.org>
 <20160616221434.GI3262@mtj.duckdns.org>
 <cf514889-8a4d-1ef4-cf4a-fd1a9b9bcb1d@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7xkDIYw8xWXfJUzkkQ8cr0cQTbz9XF2hrq87FSWAwaU=;
        b=vmHwB4ZRDO/e39186t1uAxxPdw8Ys1uoEV3K+1gizdFocr2e+WCN68ufc48mlXeZdC
         kos+SVc7My11JhhJcq7awURe0+oOVR/wF43WKzOVTYhrVCaFEfQ2MhmDRIYwJIJhW2nw
         EenzgcF8aA+wI4LvkPKkVq8hfp8bRrgSSDOI36NfSKYVKSADE7bKcFguc5tJDZbEqdRX
         waczPJ8npnid7hhAzJTRXyAdiRDcOUT1bGEYOFYSxegxM9t/KlKObaug4izwOVGOZOqp
         ZWLI2u8e+jKzO9XHhgQ5xeP7BJjtcH11AbCxYSzbzSvMosYtfy2M7mWOnHi/VFu7kMBI
         JkMw==
Content-Disposition: inline
In-Reply-To: <cf514889-8a4d-1ef4-cf4a-fd1a9b9bcb1d@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Bristot de Oliveira <daolivei@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>, "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Juri Lelli <juri.lelli@arm.com>, cgroups@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>

Hello,

On Thu, Jun 16, 2016 at 09:12:32PM -0300, Daniel Bristot de Oliveira wrote:
> The use of the irq spin_(un)lock_irq() assumes that the code is always
> called with IRQs enabled. But that is not always true in this case, as
> we call cgroup_free() in the hard IRQ context, and unconditionally
> enable IRQ in this context is a problem. So we need to use irqsave/restore.
> 
> Discussing with rostedt, we figured that this needs to be IRQ safe
> (using irqsave/restore) in the PREEMPT RT too, so I need to code a v3 of
> this patch using raw_spin_*() functions to avoid this problem in the -rt
> kernel as well.
> 
> Do you see any problems on this?

Use of raw_spin is fine but I don't see how, say, rebind_subsystems()
or cgroup_setup_root() can ever be called with irq disabled given that
they assume sleepable context.  Please use _irq and _irqsave
appropriately depending on the circumstances.

Thanks.

-- 
tejun
