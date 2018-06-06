From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] cgroup changes for v4.18-rc1
Date: Tue, 5 Jun 2018 17:13:55 -0700
Message-ID: <CA+55aFzWdPavAPC--MY15RgwvU1QYgF+Uy7rMJmx2Dr3ddJdsQ@mail.gmail.com>
References: <20180605192157.GG1351649@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y5TUNqIcQV+0Kfj/Ws/ri5YCvIrNk/xqlgq30713LrA=;
        b=c3XJ7hVM7+qCG8uKWTrD46eBE0+Kzb+5GnzinuVYw9xgYWl2eS9L71896wQgHOsmB6
         GOsjIY/YpYopciGb/rBpITSGgJqruYZIqmcWCB3hfvx2n8UCyHtOWJuFuibDNLA4p9++
         X8+GgBb6uonxEZ/7ZULRrKUys/J+9kbqG6oGk=
In-Reply-To: <20180605192157.GG1351649@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups <cgroups@vger.kernel.org>

On Tue, Jun 5, 2018 at 12:22 PM Tejun Heo <tj@kernel.org> wrote:
>
> * cgroup uses file modified events to notify certain events.  A rate
>   limiting mechanism is added.

This "explanation" didn't really parse for me at all.

I edited the merge message to something that I think is correct and
made more sense to me.

               Linus
