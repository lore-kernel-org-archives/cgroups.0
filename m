From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/2] cpusets,isolcpus: exclude isolcpus from load balancing
 in cpusets
Date: Tue, 24 Feb 2015 18:10:56 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1502241810420.19547@chino.kir.corp.google.com>
References: <1424727906-4460-1-git-send-email-riel@redhat.com> <1424727906-4460-2-git-send-email-riel@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=pqR7oqb+4FcvN+AL6zFphX9zNS3s1uFR1hbFC8JAISw=;
        b=mTD1UGzKvdqhbvy1FdbmvN6D4AMDaCubsLbCPp+Eo1k3FEl4+mce1Dm934HXnmSsQr
         wmpaaasucn2U6IKdABoC7AyaTElHsq0w/YD+qMwY5urxm2W01CmR6Z4BhRRcHPPlar5t
         gU+akwHRH1jch1RTCuGbZZFvZqxnLd6nEFMRQ/S+KssQRqeGe+jzDbCiB86wz8xLxpNK
         PX0pwHI+BMNdO01MMeWb7byo2p/kl1T0WUDw7Dzp81A76Gd0QDIUk3SuxtBzBt43dXAX
         yvilmZI8ageD08i2ZP4Lm4TcKYYBB8jO7HvYyXK27pcSbh1q9WxcMO48MLLGTtTqSo/V
         8p6Q==
In-Reply-To: <1424727906-4460-2-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Clark Williams <williams@redhat.com>, Li Zefan <lizefan@huawei.com>, Ingo Molnar <mingo@redhat.com>, Luiz Capitulino <lcapitulino@redhat.com>, cgroups@vger.kernel.org

On Mon, 23 Feb 2015, riel@redhat.com wrote:

> From: Rik van Riel <riel@redhat.com>
> 
> Ensure that cpus specified with the isolcpus= boot commandline
> option stay outside of the load balancing in the kernel scheduler.
> 
> Operations like load balancing can introduce unwanted latencies,
> which is exactly what the isolcpus= commandline is there to prevent.
> 
> Previously, simply creating a new cpuset, without even touching the
> cpuset.cpus field inside the new cpuset, would undo the effects of
> isolcpus=, by creating a scheduler domain spanning the whole system,
> and setting up load balancing inside that domain. The cpuset root
> cpuset.cpus file is read-only, so there was not even a way to undo
> that effect.
> 
> This does not impact the majority of cpusets users, since isolcpus=
> is a fairly specialized feature used for realtime purposes.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Clark Williams <williams@redhat.com>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Luiz Capitulino <lcapitulino@redhat.com>
> Cc: cgroups@vger.kernel.org
> Signed-off-by: Rik van Riel <riel@redhat.com>

Tested-by: David Rientjes <rientjes@google.com>
