From: John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC][PATCH] cgroup: Add new capability to allow a process to
 migrate other tasks between cgroups
Date: Tue, 4 Oct 2016 20:00:18 -0700
Message-ID: <CALAqxLU7qqKBVKO-bq_zKCUJqqvprNi8z5RpOb=Cec-VP=P4Yw@mail.gmail.com>
References: <1475626874-22949-1-git-send-email-john.stultz@linaro.org> <20161005003833.GA29239@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=QODuybSzKeX97D8QjIXm8UnNxhM/ghPm3TZRjV6o1jQ=;
        b=BNw83qB56v/WkOG/zD3iaU9FFrMIVF7diIxxB4f0tS3CJoYCxqfFOlnVwcR3ekMk3y
         uC8MxU8D1xgslyn+U51wKXNPQYfYBzjqyoZiUvXNuG8hBB5WdUXHeAemCjsENxOtxkVo
         6XOydyFwR9XuGwmMzpRPqqCh9/nGpcdh6Zs/4=
In-Reply-To: <20161005003833.GA29239@mail.hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, Android Kernel Team <kernel-team@android.com>, Rom Lemarchand <romlem@android.com>, Colin Cross <ccross@android.com>, Dmitry Shmidt <dimitrysh@google.com>, Todd Kjos <tkjos@google.com>, Christian Poetzsch <christian.potzsch@imgtec.com>, Amit Pundir <amit.pundir@linaro.org>

On Tue, Oct 4, 2016 at 5:38 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting John Stultz (john.stultz@linaro.org):
>> So this patch, as suggested by Tejun,  simply adds a new process
>> capability flag (CAP_CGROUP_MIGRATE_TASK), and uses it when checking
>
> So realistically, what all can this mean?  Freezing tasks, changing
> cpu/memory limits, changing network and disk throughput, forbid forking,
> and (most importantly) forbid access to certain devices.
>
> I think that's all ok.  (And we still separately check for inode write
> perms.)

Sounds good.

> If anything I'd say the GLOBAL_ROOT_UID check could be taken out since
> otherwise a host-root task effectively cannot drop this capability.

Is this ok to leave for a separate patch?

> Acked-by: Serge Hallyn <serge@hallyn.com>

Thanks for the review!

Unless there's other feedback, I'll sit on this until the merge window
is over and then resubmit for consideration for 4.10.

thanks
-john
