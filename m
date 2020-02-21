From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 1/9] hugetlb_cgroup: Add hugetlb_cgroup reservation counter
Date: Thu, 20 Feb 2020 17:52:52 -0800
Message-ID: <CAHS8izPZPDB=nK9Sm3znXxegSSr8Qf4NU5MiDcBb8EAF53LPLg@mail.gmail.com>
References: <20200211213128.73302-1-almasrymina@google.com>
 <20200211151906.637d1703e4756066583b89da@linux-foundation.org>
 <CAHS8izPUFQWq3PzhhRzp7u11173_-cmRkNuQWEswS51Xz6ZM0Q@mail.gmail.com>
 <20200219130648.83e6810848774c6fd649c445@linux-foundation.org>
 <CAHS8izN_FJektipBwiLsCO8ysMTM7k=CR_k3OV7+_y0ZbrGw+A@mail.gmail.com>
 <20200220162813.aea8a14fe050473b73440323@linux-foundation.org> <0cdd654b-a1f6-fea2-e448-209fbbe14b5c@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ed/ULQux6UGHmXOZ5IaN1TKuoav4MaQaUXExci3Yy7w=;
        b=fipejZ7K5WnG6SXrZ80ASoZ5TGGWl3vqTWYavMHSfZT7FhkAJuDP3Gec4Y8Tkc3kIq
         k+A+MtU9VEay6hpyl0nPlsALIfsWzjSJvl34jvi5nKYHrF3Likd8E1NzpI54bCq0hD13
         uZ2cVBG3xy/XXl4Zj6WnwhXA0K0RV3imaPJCS2huh9A2C7yAQVs5+Y0/7u/qzd89Drzu
         JdE6BgUkerPnKyyMLGbh0RnHJb/kOTgPmRfue4kT4IQ6owDzY4mXgTqtjrrj8ctMhc1L
         zjuAstA0xMpKN0ZnxRlpECVKfTbLlWKwoMOOfZWYGzEw33Z7AbtQ6oMixuUnYRC6Zxye
         iQVg==
In-Reply-To: <0cdd654b-a1f6-fea2-e448-209fbbe14b5c-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Feb 20, 2020 at 4:41 PM Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
> On 2/20/20 4:28 PM, Andrew Morton wrote:
> > It all looks pretty good and I expect we can get everything into
> > 5.7-rc1, unless some issues pop up.
> >

Awesome! I'll be on the lookout for issues.

Folks that reviewed (and especially Mike), thank you so much for the
patient reviews!

> > It's unclear to me whether
> > http://lkml.kernel.org/r/CAHS8izOTipknnYaKz=FdzL-7yW-Z61ck1yPnYWixyMSJuTUYLQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
> > was going to result in an update?
>
> Yes there was,
>
> https://lore.kernel.org/linux-mm/20200219233610.13808-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/
>
> BTW, I've been through the selftest code at a high level.  Not at the level
> of detail Shuah may provide.  I am just happy that Mina provided a relatively
> comprehensive test for this new functionality.  Will give it an ACK shortly.
> --
> Mike Kravetz
