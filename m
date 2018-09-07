From: Daniel Drake <drake@endlessm.com>
Subject: Re: [PATCH 0/9] psi: pressure stall information for CPU, memory, and
 IO v4
Date: Fri, 7 Sep 2018 15:36:56 +0800
Message-ID: <CAD8Lp44vHpMiWZdU9+mp-pe2kXmnxF1zm20SNWf2BVunk8c46g@mail.gmail.com>
References: <20180828172258.3185-1-hannes@cmpxchg.org> <20180905214303.GA30178@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=r8ccPo/7uRlB+FgFLfDdo+e5tdArx5VEGHE51bjxrEE=;
        b=kpQXdqNTGkxpHlUhmQ0QdSFCfd6m7vVvZgwSxWboGJ1gn5rlg4ycazarMfwbxC9HoD
         kHT9ddJ24h6qxEwSQyH3aorgIT2X43MwLFf0q9aKG8VFppYBaOEimhmDRWFyN6x4yZ2i
         2D9Ie3cpMRVvNQawQi9KtM4SfHvlBBNfxN+0mq1mYsKGCv32jwzXxM/jRlwu0V2s6DQU
         y5usao1+PGUDUFjW6qhPz0EHGu4aeOfhV6ZYTbktSi0WEZHuYb7LmV+QSU7Wnvc+0jZI
         tbAQIhLLv7IzO4WP+S65IOandeUKJlwy1aMbRnOMv4yjRPtkDE5bm707GJACjGSqMPVP
         2T4A==
In-Reply-To: <20180905214303.GA30178@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Peter Enderborg <peter.enderborg@sony.com>, Shakeel Butt <shakeelb@google.com>, Mike Galbraith <efault@gmx.de>, linux-mm@kvack.org, cgroups@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>, kernel-team@fb.com

On Thu, Sep 6, 2018 at 5:43 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> Peter, do the changes from v3 look sane to you?
>
> If there aren't any further objections, I was hoping we could get this
> lined up for 4.20.

That would be excellent. I just retested the latest version at
http://git.cmpxchg.org/cgit.cgi/linux-psi.git (Linux 4.18) and the
results are great.

Test setup:
Endless OS
GeminiLake N4200 low end laptop
2GB RAM
swap (and zram swap) disabled

Baseline test: open a handful of large-ish apps and several website
tabs in Google Chrome.
Results: after a couple of minutes, system is excessively thrashing,
mouse cursor can barely be moved, UI is not responding to mouse
clicks, so it's impractical to recover from this situation as an
ordinary user

Add my simple killer:
https://gist.github.com/dsd/a8988bf0b81a6163475988120fe8d9cd
Results: when the thrashing causes the UI to become sluggish, the
killer steps in and kills something (usually a chrome tab), and the
system remains usable. I repeatedly opened more apps and more websites
over a 15 minute period but I wasn't able to get the system to a point
of UI unresponsiveness.

Thanks,
Daniel
