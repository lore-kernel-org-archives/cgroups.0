From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v9 3/8] cpuset: Rebuild root domain deadline accounting information
Date: Thu, 25 Jul 2019 10:00:26 -0600
Message-ID: <CANLsYkzd1Vt5L+tcmtnC+gm6MCe2yYWNi3WEif+4dN2DmcMijA@mail.gmail.com>
References: <20190719140000.31694-1-juri.lelli@redhat.com> <20190719140000.31694-4-juri.lelli@redhat.com>
 <20190725135351.GA108579@gmail.com> <20190725135615.GB108579@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=th3QGwA5K0Aod/hrhTKzXbdEWqw5GM7JKiuVFRg5Xpk=;
        b=u2YxyJZJnPugr5UyAeZSSPQSyKumnK2fNlAhVccfH/AhV/Vq38llxZhgI4Bi2x0pNp
         EnhLr/xJAMwZcuoe+5hEVhhjpzIdWkEotLd0wAVzzVA/ZBEwPeppTrBSmkf6VSZ0SJGH
         yOR2v0t0taqYu6a0uGIbVdts0kiwtd2FrtOrp12uH39YiIJpfgbIetCuK+kiMQrgrosz
         A2fZ04DB5h9guj+1E7Oqu9++XlTqwlH1Pq67jsaW53j3gfl2saHHQy3HqpSS34hBw42r
         sXnB1IhvR2l5kIfS9caL2cTLHNIIA1t3KF7kaW92V8lolMKzxBubTyJAHb9Y0RNWlPyV
         KLVw==
In-Reply-To: <20190725135615.GB108579@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, tj@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "luca.abeni" <luca.abeni@santannapisa.it>, Claudio Scordino <claudio@evidence.eu.com>, Tommaso Cucinotta <tommaso.cucinotta@santannapisa.it>, Daniel Bristot de Oliveira <bristot@redhat.com>, Li Zefan <lizefan@huawei.com>, longman@redhat.com, Dietmar Eggemann <dietmar.eggemann@arm.com>, cgroups@vger.kernel.org

On Thu, 25 Jul 2019 at 07:56, Ingo Molnar <mingo@kernel.org> wrote:
>
>
> * Ingo Molnar <mingo@kernel.org> wrote:
>
> >
> > * Juri Lelli <juri.lelli@redhat.com> wrote:
> >
> > > When the topology of root domains is modified by CPUset or CPUhotplug
> > > operations information about the current deadline bandwidth held in the
> > > root domain is lost.
> > >
> > > This patch addresses the issue by recalculating the lost deadline
> > > bandwidth information by circling through the deadline tasks held in
> > > CPUsets and adding their current load to the root domain they are
> > > associated with.
> > >
> > > Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> > > Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
> >
> > Was this commit written by Mathieu? If yes then it's missing a From line.
> > If not then the Signed-off-by should probably be changed to Acked-by or
> > Reviewed-by?
>
> So for now I'm assuming that the original patch was written by Mathieu,
> with modifications by you. So I added his From line and extended the SOB
> chain with the additional information that you modified the patch:
>
>     Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
>     Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
>     Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
>     [ Various additional modifications. ]
>     Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>     Signed-off-by: Ingo Molnar <mingo@kernel.org>
>
> Let me know if that's not accurate!

You are correct - thanks,
Mathieu

>
> Thanks,
>
>         Ingo
