From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [GIT PULL] cgroup changes for v4.5-rc1
Date: Mon, 11 Jan 2016 19:20:12 -0800
Message-ID: <CA+55aFwhyPZaEaDod2jRtG6Yw_+uFqjLyr99xCtCWyidiXombw@mail.gmail.com>
References: <20160111200607.GK1898@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=KEJMZnE0j3nHlwRn4NJzGqzZGB6Q7BB6mgLsYFxCjqA=;
        b=kYsB9+SSAaV30RJBd/10pkd/zL7l7et7yTI95PhkuHGDS2AXwrlJAzI9kor1zHwaH1
         1mXrKBePtQ+EXkHVWZYJRl6Tu30JqD9oi91dKO4of+s73mVokyxYRgAgCyaLa5FmIw27
         dWa7RZJzl+jvA15Xr8kHSJI56Q9wBEnO+F/7hLBItXVqHr8I86hvMqLFHWQLz+0qwklN
         sBUXocv6wsqw3KiYbNVYNptO7rnnOdQ2S4RwMbvVbHeDzje+klPqWILNflLDDikczt5j
         if6vj5LGmoX/9c33PHGD2UmupYRW7p4WNBAG1H7NPvzUdpINFeZxqpGouDGpMTExSrzj
         dT9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=KEJMZnE0j3nHlwRn4NJzGqzZGB6Q7BB6mgLsYFxCjqA=;
        b=LhCzZTWklH9A4yAJRmf/onAN7u7MsJdFJDr/OeTKcBWGVftayBKz2velpIW6w5kxWq
         imyRJVs4JSxmjpskiKnXN2EkX+UcbDYBhyVHflChlrRw8mQZScVEYcRSLI6ik2zkD5o1
         dIhq1ZY7eXxGYNQPgybirmh0Tv5h7/gGPXBrY=
In-Reply-To: <20160111200607.GK1898-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jan 11, 2016 at 12:06 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> cgroup changes for v4.5-rc1.

Hmm. Is it really called for to rename all the docs etc
"cgroup-legacy", considering that it's the one that is actually used,
and the new one isn't even ready yet?

That seems very questionable.

                 Linus
