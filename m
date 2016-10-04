From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH 0/2] Another pass at Android style loosening of
 cgroup attach permissions
Date: Tue, 4 Oct 2016 15:49:32 -0400
Message-ID: <20161004194932.GI4205@htj.duckdns.org>
References: <1475556090-6278-1-git-send-email-john.stultz@linaro.org>
 <20161004161630.GC4205@htj.duckdns.org>
 <CALAqxLUPMxpngbZCSFW9wS+LbZJbfSUxTDEXX2x-FUmuN4H+QQ@mail.gmail.com>
 <20161004193838.GH4205@htj.duckdns.org>
 <CALAqxLWQ8hwWyzfUWnXY+oTssqTqyGenbbVFzJ7gzgu-7gWNgg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JZRGvJAFKI7j4oq2z9W8P1SLlCVtDfBtomEjfXX1o4g=;
        b=iuxFIwo0Q8rn43dsbpF4K5lDCxC12zyLszalJTPt0CqX57dfSn40bfQt01OjhYjb3E
         P89QGIKu6bKrAb1a7hpAIcAUAzaZuzamhFks1ARp0JAuQ0oHIDrZlF988GBtnf8oddt/
         XeiYAfkC+0V2lnnxDrMkb+QM5hYMK/luRe5vWID5LTQHcP+zfn4wPlAynx4GLVrWS0iu
         DgmCvuilCSCOP7eMXH/gaKQioef+estbQ+IkySZn3OG7bJjwUSh4EhRgfA6hzxM022pH
         3Bf64BpyS02pJI3+2nQdPUg2F+13wnO1ISHJOzCPoaMnNDvVQDxQM1kDLTo2ThpJwYZJ
         Mang==
Content-Disposition: inline
In-Reply-To: <CALAqxLWQ8hwWyzfUWnXY+oTssqTqyGenbbVFzJ7gzgu-7gWNgg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, Android Kernel Team <kernel-team@android.com>, Rom Lemarchand <romlem@android.com>, Colin Cross <ccross@android.com>, Dmitry Shmidt <dimitrysh@google.com>, Todd Kjos <tkjos@google.com>, Christian Poetzsch <christian.potzsch@imgtec.com>, Amit Pundir <amit.pundir@linaro.org>, Serge Hallyn <serge.hallyn@canonical.com>

Hello,

On Tue, Oct 04, 2016 at 12:46:24PM -0700, John Stultz wrote:
> Ok. I'll respin this introducing and using a new CAP value.
> 
> That said, while CAP_SYS_NICE seems a bit overloaded here, it doesn't
> conceptually have that much friction for use with cpuset and cpuctrl
> cgroups:

We need to solve it for userns too and I wanna avoid pushing
permission logic into specific controllers.  The logical extensions of
that would be protecting control interface files by different CAPs
too.  It might work for some knobs and then there will all but
certainly unclear corner cases and so on.  Let's please not go there.

Thanks.

-- 
tejun
