From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: disable irqs while holding css_set_lock
Date: Thu, 16 Jun 2016 18:03:15 -0400
Message-ID: <20160616220315.GH3262@mtj.duckdns.org>
References: <1465325475-30593-1-git-send-email-bristot@redhat.com>
 <20160607193008.GA31708@htj.duckdns.org>
 <6f15f27f-3757-5413-4292-1386e95bc278@redhat.com>
 <38469b61-7cc5-5fec-4de3-0e9a616dfe95@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wf32zfc6EkiPlu+pcAn9cs1gQL7Ez+t6c7rkQMPQ+yk=;
        b=ULU55dYwh/JsUktv4Oyi7amDPN6D9uaB1Lcl1UDAaZa1QkjGwo6cefgSr01oX5BcKZ
         ZvXf0/Eg03Yxs+1xrT1JNFFUTwQQPU3cNJDQ4TAtgt1QxiujgPR+r9axcKNIE1YUXNkh
         Xc4aGgHONPQeaqECypc79g6vAvuIFjoJs5HlJ4LsXfEcZkrdARTf3K1b1a15GUX6Sclw
         lkyX7FVAyolkBWza5hvyNjOd8YvU/PdNox/t/kYmXknLYBJF1gqwbtj4BrF7q/AcPjTO
         DH2GPkHD2XvaMjBRi41Ihg0ZieEGSi5FVnqBrqlfvy/5nX9/bpsD1RL5O7rdHJ5tzAh0
         eoDw==
Content-Disposition: inline
In-Reply-To: <38469b61-7cc5-5fec-4de3-0e9a616dfe95-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Bristot de Oliveira <daolivei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Luis Claudio R. Goncalves" <lgoncalv-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Juri Lelli <juri.lelli-5wv7dgnIgG8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jun 16, 2016 at 06:48:56PM -0300, Daniel Bristot de Oliveira wrote:
> On 06/07/2016 05:05 PM, Daniel Bristot de Oliveira wrote:
> > On 06/07/2016 04:30 PM, Tejun Heo wrote:
> >> Is this something in mainline?  This forces all task free path to be
> >> irq-safe, which *could* be fine but it's weird to make cgroup free
> >> path irq-safe for something which isn't in mainline.
> > 
> > you mean, mainline linux kernel? if so, yes it is. I was running the
> > v4.7-rc2 from Linus, as is.... no external patches applied.
> > 
> 
> is there any other question/objection about this patch?

Nope, I was just on vacation.  Applied to cgroup/for-4.7-fixes.

Thanks!

-- 
tejun
