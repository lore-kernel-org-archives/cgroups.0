From: John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH v5] cgroup: Add new capability to allow a process to
 migrate other tasks between cgroups
Date: Tue, 13 Dec 2016 08:08:16 -0800
Message-ID: <CALAqxLVz4WH5T7mjD1U5XG1pWQCJqsO2LWYcpJ+xDPjRb9QMig@mail.gmail.com>
References: <1481593143-18756-1-git-send-email-john.stultz@linaro.org> <CAKgNAkhGSYmtqLnCyXH8-dbmBJreo9mbVGRMyd_9hZ5D1F7q4g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Dk5Fp8jgbpR4rkTH4TYKn9BkuBl6cs1uj6LrtDRN9Ko=;
        b=IULL2az8k5eCewHeBRc3BeSmVLenXIDJk5hCkZRQAb0ecruXVXFaTJy9BlDTrBteey
         I993wrr+5KyJTwNc/npK3dYTBW+OUY9Qu8c+1bvfjmwlwxuYXIuZ7tkZqLmH32AQFgFg
         SyEgOHcdPKfPjTtG7JKhnwVd5fGN1UAndc4iY=
In-Reply-To: <CAKgNAkhGSYmtqLnCyXH8-dbmBJreo9mbVGRMyd_9hZ5D1F7q4g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Rom Lemarchand <romlem@android.com>, Colin Cross <ccross@android.com>, Dmitry Shmidt <dimitrysh@google.com>, Todd Kjos <tkjos@google.com>, Christian Poetzsch <christian.potzsch@imgtec.com>, Amit Pundir <amit.pundir@linaro.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Kees Cook <keescook@chromium.org>, "Serge E . Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Linux API <linux-api@vger.kernel.org>

On Tue, Dec 13, 2016 at 1:47 AM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> On 13 December 2016 at 02:39, John Stultz <john.stultz@linaro.org> wrote:
> So, back to the discussion of silos. I understand the argument for
> wanting a new silo. But, in that case can we at least try not to make
> it a single-use silo?
>
> How about CAP_CGROUP_CONTROL or some such, with the idea that this
> might be a capability that allows the holder to step outside usual
> cgroup rules? At the moment, that capability would allow only one such
> step, but maybe there would be others in the future.

This sounds reasonable to me. Tejun/Andy: Objections?

thanks
-john
