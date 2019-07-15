From: Dave Chiluk <chiluk+linux@indeed.com>
Subject: Re: [PATCH v5 1/1] sched/fair: Fix low cpu usage with high throttling
 by removing expiration of cpu-local slices
Date: Mon, 15 Jul 2019 10:44:39 -0500
Message-ID: <CAC=E7cVSVqg8raXgVC8f7wB+BJO8TAjSU=0UN-M+Oxuo2raXAw@mail.gmail.com>
References: <1558121424-2914-1-git-send-email-chiluk+linux@indeed.com>
 <1561664970-1555-1-git-send-email-chiluk+linux@indeed.com>
 <1561664970-1555-2-git-send-email-chiluk+linux@indeed.com>
 <xm26lfxhwlxr.fsf@bsegall-linux.svl.corp.google.com> <20190711095102.GX3402@hirez.programming.kicks-ass.net>
 <xm26v9w8jwgl.fsf@bsegall-linux.svl.corp.google.com> <CAC=E7cV4sO50NpYOZ06n_BkZTcBqf1KQp83prc+oave3ircBrw@mail.gmail.com>
 <xm26muhikiq2.fsf@bsegall-linux.svl.corp.google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=indeed.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ScxfIM+hKDT1VQaIZy4BKqol+JPqVs71rTa7fK4KN1M=;
        b=gnHK+c2cwZGKOdspduqrUgKCh6lVrsKIInyhuuavEpiiOcbGli77C58lcIXgh934gd
         X+tLt3k+Ik4aenfsxG9NFO2TPCD832u+KzaI36GcEuU2FPeWtzF+N76i6iSHvlttqWsR
         k+frcRdRsmUd5oRFAvWQ9JfUk8UTM29DlkBao=
In-Reply-To: <xm26muhikiq2.fsf@bsegall-linux.svl.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ben Segall <bsegall@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Pqhil Auld <pauld@redhat.com>, Peter Oskolkov <posk@posk.io>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Brendan Gregg <bgregg@netflix.com>, Kyle Anderson <kwa@yelp.com>, Gabriel Munos <gmunoz@netflix.com>, John Hammond <jhammond@indeed.com>, Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, Paul Turner <pjt@google.com>

On Fri, Jul 12, 2019 at 5:10 PM <bsegall@google.com> wrote:
> Ugh. Maybe we /do/ just give up and say that most people don't seem to
> be using cfs_b in a way that expiration of the leftover 1ms matters.

That was my conclusion as well.  Does this mean you want to proceed
with my patch set?  Do you have any changes you want made to the
proposed documentation changes, or any other changes for that matter?
