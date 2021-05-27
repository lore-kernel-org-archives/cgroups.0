From: Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH 1/3] sched/fair: Add tg_load_contrib cfs_rq decay checking
Date: Thu, 27 May 2021 14:49:27 +0200
Message-ID: <CAKfTPtC50AkBcm-AQf63XQOFE3w5ZbRS7Sh=yDDSG1hM1wBhvg@mail.gmail.com>
References: <20210518125202.78658-1-odin@uged.al> <20210518125202.78658-2-odin@uged.al>
 <CAKfTPtCCZhjOCZR6DMSxb9qffG2KceWONP_MzoY6TpYBmWp+hg@mail.gmail.com>
 <CAFpoUr0f50hKUtWvpTy221xT+pUocY7LXCMCo3cPJupjgMtotg@mail.gmail.com>
 <CAKfTPtCaZOSEzRXVN9fTR2vTxGiANEARo6iDNMFiQV5=qAA4Tw@mail.gmail.com>
 <CAKfTPtAFn3=anfTCxKTDXF0wpttpEiAhksLvcEPdSiYZTj38_A@mail.gmail.com>
 <CAFpoUr1zGNf9vTbWjwsfY9E8YBjyE5xJ0SwzLebPiS7b=xz_Zw@mail.gmail.com>
 <CAKfTPtDRdFQqphysOL+0g=befwtJky0zixyme_V5eDz71hC5pQ@mail.gmail.com>
 <CAFpoUr0SOqyGifT5Lpf=t+A+REWdWezR-AY2fM_u1-CCs8KFYQ@mail.gmail.com>
 <CAKfTPtArj_XkgPXRJKZxN0MM2+v=3+RjAVVkmbpB1gBLCuzJvA@mail.gmail.com> <CAFpoUr2NM9RHE=jdbi5aNj2LeVr4iKJ3thMPUNhp_SnCe7tnfg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IPDKpeQP85lIS4gYU8UwCGKlha6ptbLg1ETtgq9iJMw=;
        b=Ouf7cM44WCMGrm8fB7veWn15pNkwVEiXKb0QxbC/6bj4dPtrlIsZS6zoutiY35TfzI
         097B1D3YFkZQHZXtjwhlPzC7cnD/hcK6Gx76hJSk5ndux2q8TKdfmr/2rKgU+JCq5NAa
         +GaUfLpKW3nyxIqagUzfXa/jw4H5busK3vFCzgxEl0I0auWr0J5HUinZofrnBMWE5y4W
         hGRAAXGOtKWEIlygch53DVVQy9oVM9rxXKCQ7MXY0oJcmGjMEITpWB15GeMYmjKMkgxR
         4zx3LshbFTI5tj2f4NtzO2jfN7lCeQF83EC0Os2tkkbgr9N0opi955P1EZIa0/u6tKVu
         QUww==
In-Reply-To: <CAFpoUr2NM9RHE=jdbi5aNj2LeVr4iKJ3thMPUNhp_SnCe7tnfg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Odin Ugedal <odin@uged.al>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Thu, 27 May 2021 at 14:38, Odin Ugedal <odin@uged.al> wrote:
>
> Hi again,
>
> Saw your patchset now, and that is essentially the same as I did. I
> guess you want to keep that patchset instead of me updating this
> series then?

yes

>
> Also, could you take a look at patch 2 and 3 in this series? Should I

Yes, I'm going to have a look at patch 2 and 3

> resend those in a new series, or?
>
> Odin
