From: Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 00/16] slab accounting for memcg
Date: Fri, 21 Sep 2012 12:40:15 +0300
Message-ID: <CAOJsxLFVMYUxoVOcaCAtvwZmyMHS9mB3msP8gHn0a6NqzneLqQ@mail.gmail.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=GUKMhU6l6zvq4jdCO8Hw/P9lAhRC8rb2+r/3h3TRlwo=;
        b=ItFUzO+F7/T569du+u3AHVOSDeLv7tqMQr4mI8M5NJjh8kecoqGaKZD/aCABtK8ttv
         xIFfSTOeoQ8TPa3JhbwHrEwo76+RWTWwswxna7zqRSzRQMls9phD9IYRH6/MYFjD8Qc0
         dXJw5yErMjm+OfL5oWjWJ0mevLoRpPL/YoUMj1IXkzVPHEJBi4yjblc8cWkFeNsxSWAo
         lsXYiUARj+QbL3Rz26gAGajEmDJYqLTkd4AJ31zix/q9lFIj0i0q2HuUNYWX88TmolTM
         qj1N1tsipKDLcgDcEVhfkEMsxdzzJYI4yBxqs3w+w2CBtmZ6AYEMUmfgkgNNrNctaHkn
         xGwA==
In-Reply-To: <1347977530-29755-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hi Glauber,

On Tue, Sep 18, 2012 at 5:11 PM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> This is a followup to the previous kmem series. I divided them logically
> so it gets easier for reviewers. But I believe they are ready to be merged
> together (although we can do a two-pass merge if people would prefer)
>
> Throwaway git tree found at:
>
>         git://git.kernel.org/pub/scm/linux/kernel/git/glommer/memcg.git kmemcg-slab
>
> There are mostly bugfixes since last submission.

Overall, I like this series a lot. However, I don't really see this as a
v3.7 material because we already have largeish pending updates to the
slab allocators. I also haven't seen any performance numbers for this
which is a problem.

So what I'd really like to see is this series being merged early in the
v3.8 development cycle to maximize the number of people eyeballing the
code and looking at performance impact.

Does this sound reasonable to you Glauber?

                        Pekka
