From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] cpusets: Allocate heap only when required
Date: Fri, 24 Jan 2014 02:33:27 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1401240230190.9846@chino.kir.corp.google.com>
References: <8622e93b9c49c66ffdc9ef0aa8371c322718edd5.1390475530.git.viresh.kumar@linaro.org> <alpine.DEB.2.02.1401231330530.7313@chino.kir.corp.google.com> <52E1C8BD.2010500@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=P+nH1pY9bkJXJPalQ/K61C5GMudMcYTSz/OSyd97Zrk=;
        b=gjf6ceGkoL9o0jV9dR4Kp0eGEz9nzRH8L0l8QFv008aodutC/9QRinpQ9qlbi8k1On
         sBD9/J0/ZEqgHPx7c0gC/TEYj4uEtFHFzFwFmb/ur2SVH1o40YjUNzH38OTbpT+DUjJ+
         pOLVXrySjVPzBR1ITjMnt6KZzDe8pyvHPFqJC9DbrrYSACXiyt7IuzOXcOKozYgJM6oc
         doO7NytBbwhWQ8HiWAioZwTH8CIRGKwpub3jcJaqu4VepO1yuhZBscBu1JfRH3tbfcBN
         Xp7AU6JVM6oescHFO38eNhpSbqz6H64uOlMaurNhqDVzbH5GHyKkjo9o9UvrAzCslRxn
         Rp/A==
In-Reply-To: <52E1C8BD.2010500@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, mingo@kernel.org, peterz@infradead.org, linaro-kernel@lists.linaro.org, patches@linaro.org, linux-kernel@vger.kernel.org, Cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>

On Fri, 24 Jan 2014, Li Zefan wrote:

> >> update_flag() routine uses heap only when spread_flag_changed is true. Otherwise
> >> heap isn't used, but is allocated and freed unnecessarily.
> >>
> 
> but harmless
> 

It's not harmless, if heap_init() fails with -ENOMEM then the write fails 
even though it may not be for memory_spread_page or memory_spread_slab, 
which is the minority of the callers of this function.
