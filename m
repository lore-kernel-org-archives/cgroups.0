From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v3] cpu/hotplug: wait for cpuset_hotplug_work to finish on cpu onlining
Date: Sat, 19 Jun 2021 22:18:39 +0200
Message-ID: <87zgvlhalc.ffs@nanos.tec.linutronix.de>
References: <20210317003616.2817418-1-aklimov@redhat.com> <87tuowcnv3.ffs@nanos.tec.linutronix.de> <CALW4P+L9_tYgfOPv0riWWnv54HPhKPDJ4EK4yYaWsz0MdDGqfw@mail.gmail.com> <CAFBcO+8NBZxNdXtVuTXt9_m9gWTq7kxrcDcdFntvVjR_0rM13A@mail.gmail.com> <CAFBcO+9wLjDW6n-ZSean_UQHSJ44Tpw9XBz-3UMoVCeUridj4Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624133919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZGxCAU5/Gg8G2QXDWd/7foFOuvLUzMk0dmwKNfusq2U=;
        b=FHmONuVOMr4+7/40TNNSG/hiyaLtRMfUkmIbkXSCD/DmuFl04ct6WCfWE+39chTJdbVo1K
        lUkQjjBuuKAg6b3uWhjaay0x1XBeysHVjJvvYDnPA3CbOnwoaUXbS4dHcEX48bVwbs9A3d
        c5ZICg5YoTojMIaLEza7vvJcfaRqO2QnCHxq/oE+NoZEJ7f8pIncF4YsfasW4My6HvrtyB
        1TDAwwmoNiLm/PseNG964ShmAm7yLLmdOfa3d05H7gNgaqBdm911btMTVAIisw+eqxASYf
        XZu4AQNSI2sTJOUfz242Z5WKZ+393Zc+Qj0gREGjZugpB/ngoSw+C6a4Z9KJfg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624133919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZGxCAU5/Gg8G2QXDWd/7foFOuvLUzMk0dmwKNfusq2U=;
        b=6b7bpcDeTlfRnxblWGna3hiV6agE0oq0oY3LeyiryUSDr6tNRpuxRD1lIR9Ci0vNIP7Mef
        VHs4dCzzxHGlwdAg==
In-Reply-To: <CAFBcO+9wLjDW6n-ZSean_UQHSJ44Tpw9XBz-3UMoVCeUridj4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yury Norov <yury.norov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Joshua Baker <jobaker-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, audralmitchel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Qais Yousef <qais.yousef-5wv7dgnIgG8@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Alexey Klimov <klimov.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Alexey,

On Mon, Jun 14 2021 at 19:14, Alexey Klimov wrote:
> On Thu, Apr 15, 2021 at 2:30 AM Alexey Klimov <aklimov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> On Sun, Apr 4, 2021 at 3:32 AM Alexey Klimov <klimov.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> > On Sat, Mar 27, 2021 at 9:01 PM Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
>
> [...]
>
>> Are you going to submit the patch? Or I can do it on your behalf if you like.
>
> Are you going to send out this to lkml as a separate patch or do you
> want me to do this on your behalf?

sorry I forgot about this completely. No need to resend. It's on LKML
already. I pick it up from this thread.

Thanks,

      tglx


