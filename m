From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/10] psi: pressure stall information for CPU, memory,
 and IO v2
Date: Mon, 30 Jul 2018 11:07:55 -0700
Message-ID: <20180730180755.GM1206094@devbig004.ftw2.facebook.com>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180727220123.GB18879@amd>
 <20180730154035.GC4567@cmpxchg.org>
 <20180730173940.GB881@amd>
 <20180730175120.GJ1206094@devbig004.ftw2.facebook.com>
 <20180730175936.GA2416@amd>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bcmzDygmGzmRfPe114L0/zYL4+ydIfyVDgGHoeXvqWI=;
        b=WboBz+biF9TN9se9aAMhuir7sBAMJI2lPv7fW6Hel6OMJuv2FCjQ6oL0SdaNYmfis6
         PwBOeJItpMAoHbuNqL+tSrMrGhNgoi09mV8Van+fsxGxvHbkYm30JH2YilaGEmz6fQv+
         GTRUUY6IkvXm0MwKdgl069lhl45I8gV9Mxq3ll85tOHs5CERaa3AKHF7+4Kc+wejHB8U
         HEdD9DGBrP8yG44csz9B7WlqUTi5NKWAm9wHZHol/bn+L07rN667pHr5WaGU6cQUt/Tw
         H44igUGMMGQ8mEyjD8Dt2qLLaRHFoDqR12ys/iUI3niDMPax5Fb2LMWJ99MJHLz2JsPF
         P/Dg==
Content-Disposition: inline
In-Reply-To: <20180730175936.GA2416@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pavel Machek <pavel@ucw.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Mon, Jul 30, 2018 at 07:59:36PM +0200, Pavel Machek wrote:
> Its true I have no interest in psi. But I'm trying to use same kernel
> you are trying to "improve" and I was confused enough by seing
> "CONFIG_PSI". And yes, my association was "pounds per square inch" and
> "what is it doing here".

Read the help message.  If that's not enough, we sure can improve it.

> So I'm asking you to change the name.
> 
> USB is well known acronym, so it is okay to have CONFIG_USB. PSI is
> also well known -- but means something else.
> 
> And the code kind-of acknowledges that acronym is unknown, by having
> /proc/pressure.

Your momentary confusion isn't the only criterion.

Thanks.

-- 
tejun
