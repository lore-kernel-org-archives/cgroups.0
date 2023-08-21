From: Qais Yousef <qyousef@layalina.io>
Subject: Re: [PATCH 0/6] Backport rework of deadline bandwidth restoration
 for 6.1.y
Date: Mon, 21 Aug 2023 22:58:52 +0100
Message-ID: <20230821215852.qc5e6cqjbkgob6nf@airbuntu>
References: <20230820152417.518806-1-qyousef@layalina.io>
 <2023082140-dreaded-hemstitch-84b9@gregkh>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1692655135; x=1693259935;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xZx0If7VnJ4j8LySOPTnKHBC3HYJ+LY29Fzf9AdSRdo=;
        b=wwE+i55gac9vrq6+Vw6RsJhUsFXlx1hfF862zikhtnEQO122lP7ycLTxuaXnV6FdBc
         6hLlGZ9VL9ImHF1uHd83GrfUrCnfGjaDG1dHm/NepAvZFiJCzRhc3QqWvKzbMvwDm3mJ
         UxPNbwVVuDzYmMex5oDV8RGD4Cz9iKYvUTr5dC8PT327GIb3uBu43Igh8AHPNf4nyf1D
         xofx1990g1JHr6+6wzB10SGBnVxfIRsEUslUxt9hDo9UOuyrSKsTVefZVMfM6bpwRd4T
         uJ6brI4WIcPlE+iv+NFeQlTc/iQ4iPwrW69GMkcVmplNNRz6XWo3maGaKuSSaiAqdl4g
         KKpw==
Content-Disposition: inline
In-Reply-To: <2023082140-dreaded-hemstitch-84b9@gregkh>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Peter Zijlstra <peterz@infradead.org>, Vincent Guittot <vincent.guittot@linaro.org>, Ingo Molnar <mingo@kernel.org>, Hao Luo <haoluo@google.com>, John Stultz <jstultz@google.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 08/21/23 15:26, Greg KH wrote:
> On Sun, Aug 20, 2023 at 04:24:11PM +0100, Qais Yousef wrote:
> > This is a backport of the series that fixes the way deadline bandwidth
> > restoration is done which is causing noticeable delay on resume path. It also
> > converts the cpuset lock back into a mutex which some users on Android too.
> > I lack the details but AFAIU the read/write semaphore was slower on high
> > contention.
> > 
> > Compile tested against some randconfig for different archs and tested against
> > android14-6.1 GKI kernel.
> > 
> > My testing is limited to resume path only; and general phone usage to make sure
> > nothing falls apart. Would be good to have some deadline specific testing done
> > too.
> > 
> > Based on v6.1.46
> 
> I can't take these for only some branches, as you know.  Any reason why
> you didn't also do 6.4.y?

Beside being tunneled visioned towards LTS only, nope.

They apply cleanly on 6.4.y and preparing the patches now. I'm not sure I can
run any tests on 6.4.y though except maybe boot test on qemu.

Waiting for compile tests to finish and will post shortly.


Thanks!
