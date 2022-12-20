From: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
Subject: Re: [PATCH v9 3/8] cpuset: Rebuild root domain deadline accounting
 information
Date: Tue, 20 Dec 2022 11:43:09 +0000
Message-ID: <20221220114309.coi2o4ewosgouy6o@airbuntu>
References: <20190719140000.31694-1-juri.lelli@redhat.com>
 <20190719140000.31694-4-juri.lelli@redhat.com>
 <20221216233501.gh6m75e7s66dmjgo@airbuntu>
 <CAKfTPtA0M5XOP4UdkFeSNen98e842OfKTBDOt0r-y_TD4w54jw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Izi5rtgy1gy7iKuRR2cyO+zgmNxqGI8JekC2jp3If4w=;
        b=isuVeixmHfbDsDcKHUdjtJo4925V08Z10w1T9CrZoACnBFjfLsEuLH5+M4VcQSxWRB
         TaTDWZkT/kH+ZCDW6i82k3V81ahhqxjRfXxkOSTxFmdxh2C14WNVYm5nYR8oazqJLPA+
         Tp4nXtHMTmZj7mVCviywGmX5aY6RNehPdHTiNzNb1dfGTUOwWguYSsabN7Iy+R1w0KPr
         BU0HXGwqSJvlffLf5+LDTJTX/pBMluHntTBs6mmmW67uJRK7MZyNdVzd0XRGtMMYD50H
         f1mzcoAErYYMfOOS6E+nKjSlt0bJuW4XQyBoV7IvmVHlw9ZolV4sPqdIJR1iBt70QEPK
         tItw==
Content-Disposition: inline
In-Reply-To: <CAKfTPtA0M5XOP4UdkFeSNen98e842OfKTBDOt0r-y_TD4w54jw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 12/19/22 09:07, Vincent Guittot wrote:
> On Sat, 17 Dec 2022 at 00:35, Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org> wrote:
> >
> > Hi
> >
> > On 07/19/19 15:59, Juri Lelli wrote:
> > > When the topology of root domains is modified by CPUset or CPUhotplug
> > > operations information about the current deadline bandwidth held in the
> > > root domain is lost.
> > >
> > > This patch addresses the issue by recalculating the lost deadline
> > > bandwidth information by circling through the deadline tasks held in
> > > CPUsets and adding their current load to the root domain they are
> > > associated with.
> > >
> > > Signed-off-by: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > > Signed-off-by: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > ---
> >
> > We see that rebuild_root_domain() can take 10+ ms (I get a max of 20ms quite
> > consistently) on suspend/resume.
> >
> > Do we actually need to rebuild_root_domain() if we're going through
> > a suspend/resume cycle?
> 
> During suspend to ram, there are cpus hotplug operation but If you use
> suspend to idle, you will skip cpus hotplug operation and its
> associated rebuild.

Thanks Vincent. I'll check on that - but if we want to keep suspend to ram?
Do we really to incur this hit?


Thanks
