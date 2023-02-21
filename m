From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v10 5/9] sched/fair: Take into account latency priority
 at wakeup
Date: Tue, 21 Feb 2023 16:08:33 +0100
Message-ID: <Y/Tecdpxls3N6pO+@hirez.programming.kicks-ass.net>
References: <20230113141234.260128-1-vincent.guittot@linaro.org>
 <20230113141234.260128-6-vincent.guittot@linaro.org>
 <Y/TBdB23akBbUjqd@hirez.programming.kicks-ass.net>
 <CAKfTPtAk2A8zPgOfpbN0s4LZv+d7ABB9=5tAEMCbVrf263XtjA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hgiqFcrHrTOErRluuJ8EB5lE7JskCeix2FOR6T4RAXM=; b=Hi5kfNI2kxEJjzN24oHOhV2D/I
        +4VjRZJ2X2mYpVBtbjR3AiN2kZfCQ0W4hnWSt/Z3eAr36X+lH9yPwAEBaRLcAUL79PJXvn2VUyFJi
        vic7vETHl1ZcQK2IXt7mQi2IT+PBL0delArNyV9UhYFTSDzFQmZ/xf34ciFvXV2gAbthqaUmfGzhW
        HmXblbalNa+HLd7MQigDMeRLgE1a0EHMrERCeei6wKb+wN+Cv6Fy0Ero0i3WoVKrtOJXHWSOJWacA
        DQT7GRrrnxjH6QaKqTPj3bMOgljcx3uD7R4fFdJc0zNX1A/r2pSNRn8/MJ+433PsUI3Aewg5C3OmK
        i+/c0aqQ==;
Content-Disposition: inline
In-Reply-To: <CAKfTPtAk2A8zPgOfpbN0s4LZv+d7ABB9=5tAEMCbVrf263XtjA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, parth-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org, chris.hyser-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, patrick.bellasi-X6neQFFVdzGsTnJN9+BGXg@public.gmane.org, David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, timj-mXXj517/zsQ@public.gmane.org, kprateek.nayak-5C7GfCeVMHo@public.gmane.org, yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, youssefesmat-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org

On Tue, Feb 21, 2023 at 03:21:54PM +0100, Vincent Guittot wrote:
> On Tue, 21 Feb 2023 at 14:05, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> > Should we perhaps also do this for latency_nice == 0?, in any case I
> > think this can be moved to its own patch to avoid doing too much in the
> > one patch. It seems fairly self contained.
> 
> This function is then removed by patch 9 as the additional rb tree
> fixes all cases

Also, since you remove it again later, perhaps not introduce it at all?
