From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 0/6] Backport rework of deadline bandwidth restoration
 for 6.4.y
Date: Sun, 27 Aug 2023 10:34:53 +0200
Message-ID: <2023082742-dad-henna-cb35@gregkh>
References: <20230821221956.698117-1-qyousef@layalina.io>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1693125307; x=1693211707; bh=Jv
        SLkiKnJg7r+Lmp4xfUHOcdesoZivHQDSlyjxiRtjQ=; b=vPqEkglFojsGGcLwBY
        lG2flpx9r8FmK5nCGywrpMX6PsceUo6YMrQv5fmBo9/gO8FzmGv9znw1P2Yt0jtD
        c5+R/u/yoDrT9KSfvQWhalUtinE+HIV+zSpAYoxAWisbOyuRKEaMvY5E/o8UCSrm
        RpRm3pQFxDacMfyK1PcCI+WbXz2DDzzgjLBo1/n150V3elpBEgllIEN9oI/3EzR0
        Mp3uqCE3pnzLz/XTtdfVsInoFuXIAmSivUvDTfEi+tXp+pYef+22ZzUrWRtWOGr5
        GaeliZwdz5J+FHRGsCwsO+ZxBT0DOYMBs2nvCz0nIFZ4EnvdXkHmfHldgnQY57H4
        msrw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1693125307; x=1693211707; bh=JvSLkiKnJg7r+
        Lmp4xfUHOcdesoZivHQDSlyjxiRtjQ=; b=dw9ckfY77+MEfwvYwJUcSP4uls71J
        VtLEfkwJ8fKC9fY1xQcdppEfrpZUkwBOjqQyjDnagJ3PPReh25wkDsSLS+9ovDO8
        N9p874zu3l+uWZfRhpeJsqtlz0X/I4E+7hipxtG8glESaI+Tcf0jflqr9LvEFyTQ
        oOG+jwwFx/AfvdhhVcdkcXPfQlsSsCPJrxjdNU2+8waAwtDrUws71DkJI+V6rvA6
        7AgCy8tWblmYdWoAYfXeMd9HISZMGaGP/AHF6byvYwlbetg6aLgagHXO1e7gcJHQ
        CyINkG9SDT8HJjBWhRsckcuzKfuWQANtihzvUr2UVAUYXmEwY+EONbw6w==
Content-Disposition: inline
In-Reply-To: <20230821221956.698117-1-qyousef@layalina.io>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qais Yousef <qyousef@layalina.io>
Cc: stable@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Peter Zijlstra <peterz@infradead.org>, Vincent Guittot <vincent.guittot@linaro.org>, Ingo Molnar <mingo@kernel.org>, Hao Luo <haoluo@google.com>, John Stultz <jstultz@google.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Aug 21, 2023 at 11:19:50PM +0100, Qais Yousef wrote:
> This is a backport of the series that fixes the way deadline bandwidth
> restoration is done which is causing noticeable delay on resume path. It also
> converts the cpuset lock back into a mutex which some users on Android too.
> I lack the details but AFAIU the read/write semaphore was slower on high
> contention.
> 
> Compile tested against some randconfig for different archs. Only boot tested on
> x86 qemu.
> 
> Based on v6.4.11
> 
> Original series:
> 
> 	https://lore.kernel.org/lkml/20230508075854.17215-1-juri.lelli@redhat.com/
> 
> Thanks!

All backports now queued up, thanks for doing this work!

greg k-h
