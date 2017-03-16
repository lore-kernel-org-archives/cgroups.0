From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] kthread, cgroup: close race window where new
 kthreads can be migrated to non-root cgroups
Date: Thu, 16 Mar 2017 12:05:44 -0400
Message-ID: <20170316160544.GC15810@htj.duckdns.org>
References: <20170315231827.GA13656@htj.duckdns.org>
 <20170315231920.GB13656@htj.duckdns.org>
 <20170316150233.GB24478@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=L2ERGDuEkcMu6+02h3s+W/iK0J4e/m2UsXYmkZQY+Ic=;
        b=D5LnRebsm3+LzoEIutllidgmZjCnUUijuzhzAG7LGOZtM1VupOqiMEFm+s+i0H8jX0
         3JSrn5JCMe8oMonADvKLMLZO+CsYqVx1OvNzDlZaFpuemXT41qRZwYwtDEkk3nZi3nDM
         r+5vFzpJdw5nK+tu8uMM54WKuus7Beq/pkwq1pC3We4su50CawGH9tWSbZNM4AguOKwp
         zbSXnqiBsplDd90XV90Hsd+nJBYdPBLtQHhIag+SHpE/PUNtEm1pr+iPabl2XbDlWtFV
         zcWkVR6AEAqG7TMukVGK8SYc493c+FgDlgQzqWX3OsVesmPqcgNFxSo5AHDCfdmQivG7
         Ahwg==
Content-Disposition: inline
In-Reply-To: <20170316150233.GB24478@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Chris Mason <clm@fb.com>, linux-kernel@vger.kernel.org, kernel-team@fb.com, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

Hello,

On Thu, Mar 16, 2017 at 04:02:34PM +0100, Oleg Nesterov wrote:
> > +bool kthread_initialized(struct task_struct *k)
> > +{
> > +	struct kthread *kthread = to_kthread(k);
> > +
> > +	return kthread && test_bit(KTHREAD_INITIALIZED, &kthread->flags);
> > +}
> 
> Not sure I understand...
> 
> With this patch you can no longer migrate a kernel thread created by
> kernel_thread() ? Note that to_kthread() is NULL unless it was created
> by kthread_create().

Yeah, what it does is preventing migration of kthreads until the
kthread owner wakes it up for the first time.  The problem is that
kthread_bind() seals up future cgroup migrations from userland but
doesn't move back the kthread to the root cgroup, so the userland has
a window where it can mangle with cgroup membership inbetween and
break things.

The NULL test is there because the test may be performed before the
kthread itself sets up its struct kthread.

An alternative approach could be making kthread_bind() migrate the
kthread back to root cgroup, which btw is why affinity is fine as the
function overwrites it after setting NO_SETAFFINITY; however, the
problem there is that userland can put the kthread into !root cgroup
and starve it before it reaches create->done.

Thanks.

-- 
tejun
