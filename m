From: William Dauchy <wdauchy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: strange oom behaviour on 3.10
Date: Thu, 10 Oct 2013 14:30:33 +0200
Message-ID: <CAJ75kXab53kyyoLs5agu83-YxqXfXVzATPj+nydrN9R-azZx4g@mail.gmail.com>
References: <CAJ75kXYqNfWejMhykEqmby4Yvs1w+Tv+QxKHZF67j77HJnco5A@mail.gmail.com>
 <20131010002412.GC856@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=5Tyk24jJRF7OFZCgClOFaf0C8kpF6XGsUr6cb6FcCLs=;
        b=mIlXan9lzsh/LGF//W5/NFOcPPAgg83W+gyjsfvvhDXHK8sSbFWr1VC2F6SG2BMGch
         RHJ6WuvXBziV+nzLqCAotaWc2U40CzVKeI1v9rA2OmWH04eCHMrgAiAI2/QhG9vyuDiY
         6c+jLAkHcmq8HPeKyga50tftCOvHfsbMmS0Qy1qEGae3tqKYHZq9kKMom7Ih/baHJYJv
         DtpXHcytpdkmeAyeW2cIJODIrR8YAVgSPxsqbgmzYFfodAlBtyntWaMxdB+kHtVMLC6s
         Vbs4pi7t8ETLXDAd+zU95O1gqu6nta8COCX3S2I3spiNqqf+kdfs67P90NT+HRTjLGuN
         gKZA==
In-Reply-To: <20131010002412.GC856-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hi Johannes,

Thank you for you quick reply. and the details given for my questions.

On Thu, Oct 10, 2013 at 2:24 AM, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> Can you try this patch on top of what you have right now?

Ok; let me some time to test it.

Regards,
-- 
William
