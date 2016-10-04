From: John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC][PATCH 0/2] Another pass at Android style loosening of
 cgroup attach permissions
Date: Tue, 4 Oct 2016 11:03:43 -0700
Message-ID: <CALAqxLVSuf556f_sz8t6BEczyO1xKtnqrmjyKy05hzAjggn3tw@mail.gmail.com>
References: <1475556090-6278-1-git-send-email-john.stultz@linaro.org> <20161004161630.GC4205@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=wgTG1k13zTpGiDnOiPX/2OBPyoQWtDPhMbZ0KAI7hnE=;
        b=fJ15kZENGN3LAM5suoqs7Y0UHhNOGW0efJwbjQWkFzBh/xpgNu2LIbp8emKSLUKZNr
         /X+9+K83Lpz3u2FMOGMx0qBrIUst4VkWeWC3VwwGRUE5AIz9cvj31O8p2KKP8Iq2oL5x
         pP+npT5cYQQ8yYpPorC5sZRFyJAZYYiFCpuao=
In-Reply-To: <20161004161630.GC4205@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, Android Kernel Team <kernel-team@android.com>, Rom Lemarchand <romlem@android.com>, Colin Cross <ccross@android.com>, Dmitry Shmidt <dimitrysh@google.com>, Todd Kjos <tkjos@google.com>, Christian Poetzsch <christian.potzsch@imgtec.com>, Amit Pundir <amit.pundir@linaro.org>

On Tue, Oct 4, 2016 at 9:16 AM, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Oct 03, 2016 at 09:41:28PM -0700, John Stultz wrote:
>> The migration of a task from the foreground to background, or to
>> elevate a task to audio priority, may be done by system service that
>> does not run as root. So this patch allows processes with CAP_SYS_NICE
>> to be able to migrate tasks between cgroups.  I suspect if there was a
>> specific cap (CAP_SYS_CHANGE_CGROUP) for this, it would be usable here,
>> but in its absence, they've overloaded CAP_SYS_NICE for this use.
>
> CAP_SYS_RESOURCE won't do?

Oh, and I'll have to look into this one to see what CAP_SYS_RESOURCE
actually allows. We ran into trouble in the past changing the CAPs
required to something higher-level, which then causes trouble because
they want to avoid elevating permissions on system tasks and keep them
as restricted as possible.

thans
-john
