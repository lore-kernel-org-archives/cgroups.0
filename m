From: Tejun Heo <tj@kernel.org>
Subject: Re: [regression] cpuset: offlined CPUs removed from affinity masks
Date: Wed, 19 Feb 2020 10:19:22 -0500
Message-ID: <20200219151922.GB698990@mtj.thefacebook.com>
References: <1251528473.590671.1579196495905.JavaMail.zimbra@efficios.com>
 <1317969050.4131.1581955387909.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SUXofl/MO5dWKqPfuAcBzgvKEpVFwkTb4AVbcHvWhdc=;
        b=qPicIwGzMD/HopbeCVkjoisZLYQAfbLcyi1p0R1hAaHnso/AF0eu8g8vXlN6X9FEtL
         7fECFrXeR75PQ2/4EVbfDkXZbWXLnCZr7B4njrFd2xev//SFJ56qpIS7cTAGwLOppIW+
         6QoIEKm0kuX4X1tDUjofK4Xwep6ZNvUTyo3/6OkUYns5edz9MSvCBMcFqSaIEeLPNjYc
         jVK5cC7Qcho1lEs9bINnbQ/2tR+4alIRjxDZ/mm7X8VPxSrCXF1CXFjBGBewsAJyrwt1
         BBtqD47i/ja6Hd9VM80jRs/6hlKZn+c7PApQ4oKjv//RN+EflbPUKgkHwt4/RA+hrmHd
         IHPQ==
Content-Disposition: inline
In-Reply-To: <1317969050.4131.1581955387909.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Valentin Schneider <valentin.schneider@arm.com>

Hello,

On Mon, Feb 17, 2020 at 11:03:07AM -0500, Mathieu Desnoyers wrote:
> Hi,
> 
> Adding Tejun and the cgroups mailing list in CC for this cpuset regression I
> reported last month.
> 
> Thanks,
> 
> Mathieu
> 
> ----- On Jan 16, 2020, at 12:41 PM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:
> 
> > Hi,
> > 
> > I noticed the following regression with CONFIG_CPUSET=y. Note that
> > I am not using cpusets at all (only using the root cpuset I'm given
> > at boot), it's just configured in. I am currently working on a 5.2.5
> > kernel. I am simply combining use of taskset(1) (setting the affinity
> > mask of a process) and cpu hotplug. The result is that with
> > CONFIG_CPUSET=y, setting the affinity mask including an offline CPU number
> > don't keep that CPU in the affinity mask, and it is never put back when the
> > CPU comes back online. CONFIG_CPUSET=n behaves as expected, and puts back
> > the CPU into the affinity mask reported to user-space when it comes back
> > online.

Because cpuset operations irreversibly change task affinity masks
rather than masking them dynamically, the interaction has always been
kinda broken. Hmm... Are there older kernel vesions which behave
differently? Off the top of my head, I can't think of sth which could
have changed that behavior recently but I could easily be missing
something.

Thanks.

-- 
tejun
