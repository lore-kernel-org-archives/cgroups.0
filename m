From: Tejun Heo <tj@kernel.org>
Subject: Re: [regression] cpuset: offlined CPUs removed from affinity masks
Date: Wed, 19 Feb 2020 10:47:40 -0500
Message-ID: <20200219154740.GD698990@mtj.thefacebook.com>
References: <1251528473.590671.1579196495905.JavaMail.zimbra@efficios.com>
 <1317969050.4131.1581955387909.JavaMail.zimbra@efficios.com>
 <20200219151922.GB698990@mtj.thefacebook.com>
 <1589496945.670.1582126985824.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ar2wlN6dePLPhoLZZdzWfBNN9k6fU+94pITjgWF6huI=;
        b=sclZeeHgnDkV2FYKT4/orsaaiuStLqZ7oDvYPByVLnhQ45JVzoiKCg9SNfqUizUXM1
         PdKKpACiSBRuyoCuBePSMjBUHNo4RiVhaQpzsZ0g7GEoD+iOQEGeIRwVuOnx3h26J1Ll
         f5WxGv/gxdwlLwPEZh458ue58Eg3YNYlrnY6R/Sku7ouKhgxM9m9fDbsXTYOg9cY3pqZ
         OyfPMBpISOolqyPwsuMfSyNBaRCjilHCmXNoPo5yFAw3iJv73AZ+2e5WTTAsqnTmKPn/
         NyriSK0FpjMHtR07Ra8dLqT9DO+YQCvCmVSBG1mQ8yH0AkBapksPiboe4tPq1PuZCEzV
         R3mg==
Content-Disposition: inline
In-Reply-To: <1589496945.670.1582126985824.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Li Zefan <lizefan@huawei.com>, cgroups <cgroups@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Valentin Schneider <valentin.schneider@arm.com>

On Wed, Feb 19, 2020 at 10:43:05AM -0500, Mathieu Desnoyers wrote:
> The regression I'm talking about here is that CONFIG_CPUSET=y changes the
> behavior of the sched_setaffinify system call, which existed prior to
> cpusets.
> 
> sched_setaffinity should behave in the same way for kernels configured with
> CONFIG_CPUSET=y or CONFIG_CPUSET=n.
> 
> The fact that cpuset decides to irreversibly change the task affinity mask
> may not be considered a regression if it has always done that, but changing
> the behavior of sched_setaffinity seems to fit the definition of a regression.

We generally use "regression" for breakages which weren't in past
versions but then appeared later. It has debugging implications
because if we know something is a regression, we generally can point
to the commit which introduced the bug either through examining the
history or bisection.

It is a silly bug, for sure, but slapping regression name on it just
confuses rather than helping anything.

-- 
tejun
