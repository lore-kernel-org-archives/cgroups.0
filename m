From: Tejun Heo <tj@kernel.org>
Subject: Re: [BUG] cgroup lockup while upgrading udev on debian
Date: Mon, 22 Jan 2018 08:30:51 -0800
Message-ID: <20180122163051.GE1096857@devbig577.frc2.facebook.com>
References: <20180121213108.4218693b@gandalf.local.home>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oYFc+ceErf/YRESCtowUZvp7/9HwSJyys8Cd1yqhJr0=;
        b=AGDa2CpgiSbbY7pUqYGfQ6E5u5+Oh4o+iD2236VebxPBJ8IUJzMaocjeMu3DH7jNOo
         bpjnuXwUfua7nDYB+G/xdyffZ7BPKE19fBT/0ZHV1XTJkuFTO81/kZAau4QLQ9iBq/K0
         Nb4hQ7NnzhvDlpNytEoG6at4c7jZHGl1M41GtpJh4T9sKUOevLPaFXhvJuQrYcndqY2n
         Sa9yF1H31D7VnO/+S/Sfq2/eOp8BBFHjG8ivOdyYviEITk5qAelEF3BJZSznuSQaNCqb
         dWjhOKZFsR2Tp1Y6McFp+wALiH6EvQtQy87F8nLMTpT0k8vATLjpvV0U/6iM1UqcuS49
         G3zQ==
Content-Disposition: inline
In-Reply-To: <20180121213108.4218693b@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Hello, Steven.

On Sun, Jan 21, 2018 at 09:31:08PM -0500, Steven Rostedt wrote:
> While upgrading my system, it locked up while upgrading udev. It locked
> up on vanilla v4.14.12, and it also locked up on debian's 4.14 kernel
> as well. When I booted debian's 4.9 kernel, it upgraded fine.
> 
> Note, this is my main server and not a development box. It is not
> something I'm going to run bisects or other tests on. I don't even have
> it logging to serial console (hence the photo). It's serials are hooked
> to my test boxes. That is, it receives logs, it's not set up to send
> them.
> 
> Attached in the photo of the crash that happened when I did:
> 
>  # dpkg --configure udev

It looks like the same bug which was fixed by 74d0833c659a ("cgroup:
fix css_task_iter crash on CSS_TASK_ITER_PROC").  The bug got
introduced durinv v4.14 cycle and triggers when cgroup1 and cgroup2
are used at the same time, which the recent versions of systemd does
when in cgroup1 mode.

Thanks.

-- 
tejun
