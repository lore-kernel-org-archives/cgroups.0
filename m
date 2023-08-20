From: Qais Yousef <qyousef@layalina.io>
Subject: Re: [PATCH 0/6] Backport rework of deadline bandwidth restoration
 for 5.10.y
Date: Mon, 21 Aug 2023 00:02:57 +0100
Message-ID: <20230820230257.gmcmjuuirzq6xs52@airbuntu>
References: <20230820152144.517461-1-qyousef@layalina.io>
 <883a5a4f-b34e-689c-2fbd-7bf03db532eb@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1692572579; x=1693177379;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zASfMBgzYAjTR9c8GY5qaV+9MUOdSaUxlBCpiQVP8k0=;
        b=t/M436gLUC3+++Lm6yg65sJ9KSAuXIfPhOB12Lo8i7//DnPoosE1I3P39EuLVL4PNO
         zRxoSgoVSQgGE3VjMiyyof23ui1TFdgoOKaNFJqRby3F43/I7OR79Cz5BLE5wPYPtI5T
         VBr3r68voLEMZTuMRzdBo/IZTrf/8IHoS1DY3JjHEIyBznscOY5H2pCCx6BI5FHNijtM
         PPDqEKa5XS8oOtFuuVIwZel0iFIUHGm+0+a427vbiMxzGMDaz4p0GD7I/pHZfv3K5R9g
         SxKsr4mnY/efclf92+bb94JKR4Cr2yuLCpMgCL6hEieNYhRuwNR6i4S5WrF4+WvvQekE
         eH2g==
Content-Disposition: inline
In-Reply-To: <883a5a4f-b34e-689c-2fbd-7bf03db532eb@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: stable@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Tejun Heo <tj@kernel.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Peter Zijlstra <peterz@infradead.org>, Vincent Guittot <vincent.guittot@linaro.org>, Ingo Molnar <mingo@kernel.org>, Hao Luo <haoluo@google.com>, John Stultz <jstultz@google.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 08/20/23 12:24, Waiman Long wrote:
> 
> On 8/20/23 11:21, Qais Yousef wrote:
> > This is a backport of the series that fixes the way deadline bandwidth
> > restoration is done which is causing noticeable delay on resume path. It also
> > converts the cpuset lock back into a mutex which some users on Android too.
> > I lack the details but AFAIU the read/write semaphore was slower on high
> > contention.
> 
> Note that it was a percpu rwsem before this patch series. It was not a
> regular rwsem. Percpu rwsem isn't designed to handle high write lock
> contention. A regular rwsem should be similar to mutex in performance when
> handling high write lock contention.

Thanks a lot for the clarification Waiman! Much appreciated.


Cheers

--
Qais Yousef
