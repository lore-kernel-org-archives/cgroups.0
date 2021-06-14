From: Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] cpu/hotplug: wait for cpuset_hotplug_work to finish on
 cpu onlining
Date: Mon, 14 Jun 2021 19:14:48 +0100
Message-ID: <CAFBcO+9wLjDW6n-ZSean_UQHSJ44Tpw9XBz-3UMoVCeUridj4Q@mail.gmail.com>
References: <20210317003616.2817418-1-aklimov@redhat.com> <87tuowcnv3.ffs@nanos.tec.linutronix.de>
 <CALW4P+L9_tYgfOPv0riWWnv54HPhKPDJ4EK4yYaWsz0MdDGqfw@mail.gmail.com> <CAFBcO+8NBZxNdXtVuTXt9_m9gWTq7kxrcDcdFntvVjR_0rM13A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623694503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XoLLCXJLmHm9xP9JVi6L/4crsU3Bp6fWjhRZ5/p958Y=;
        b=NvqhF2j4hVetN7H5/8FCaawGOlj264250DN3QfNc+OvVrbxElRLNEHRlrJfNqMSQFavTf6
        MTHX4AuTr3gi4M1faiiiOF2wywk0YutUie6zccuQgf8kRtT8tg7ambG3zP8GILBmjViWjK
        mwRS7PcT95/Kxh4JEaZU8F1XB+tTS80=
In-Reply-To: <CAFBcO+8NBZxNdXtVuTXt9_m9gWTq7kxrcDcdFntvVjR_0rM13A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yury Norov <yury.norov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Joshua Baker <jobaker-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, audralmitchel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Alexey Klimov <klimov.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Thomas,
Just gentle ping.

On Thu, Apr 15, 2021 at 2:30 AM Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Sun, Apr 4, 2021 at 3:32 AM Alexey Klimov <klimov.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > On Sat, Mar 27, 2021 at 9:01 PM Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:

[...]

> Are you going to submit the patch? Or I can do it on your behalf if you like.

Are you going to send out this to lkml as a separate patch or do you
want me to do this on your behalf?

Best regards,
Alexey

