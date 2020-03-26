From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC] cpuset: Make cpusets get restored on hotplug
Date: Thu, 26 Mar 2020 16:18:59 -0400
Message-ID: <20200326201649.GQ162390@mtj.duckdns.org>
References: <20200326191623.129285-1-joel@joelfernandes.org>
 <20200326192035.GO162390@mtj.duckdns.org>
 <20200326194448.GA133524@google.com>
 <972a5c1b-6721-ac20-cec5-617af67e617d@redhat.com>
 <CAPz6YkVUsDz456z8-X2G_EDd-uet1rRNnh2sDUpdcoWp_fkDDw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rzV++PjycMf1C6DNb3Bvn/qTQ5TRkWt2M63e9VE4bbI=;
        b=D2TAtx8FfNkFcX/x5Nkw002dVxBLRsFTu4IS+wnPcNna/HdEd9nkWgy9PEdV/ryXF8
         irjFtYV0LC17Obpl11YhzuGa4+N49pl/Aw74ddi4HOsG7AcwArBKjooG8cYpmyV+wwG3
         yibNMAa48vwV9r3a6ZMHEhyFvTcE++PToGoR7eY/ZIYkLYDLGbMGtaAJWOMahom5CPlk
         Vv25JfW5GVTqTUL+SEfUtYSbpUIsAsEawlnnwhwDMr0Q0XOlFf7Q+n31hCeooERR5YRU
         7te2t0z/N8pjtGy7z0t+TH242ZaiAP/vaXLtsZWat51yM+LIaQ6wvz1Hj3xqTzPFhUL+
         erew==
Content-Disposition: inline
In-Reply-To: <CAPz6YkVUsDz456z8-X2G_EDd-uet1rRNnh2sDUpdcoWp_fkDDw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Jesse Barnes <jsbarnes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, vpillai-tWEdnPwa2b6ifxm/DiOjgA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Guenter Roeck <groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Greg Kerr <kerrnel-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Thu, Mar 26, 2020 at 01:05:04PM -0700, Sonny Rao wrote:
> I am surprised if anyone actually wants this behavior, we (Chrome OS)

The behavior is silly but consistent in that it doesn't allow empty active
cpusets and it has been like that for many many years now.

> found out about it accidentally, and then found that Android had been
> carrying a patch to fix it.  And if it were a desirable behavior then
> why isn't it an option in v2?

Nobody is saying it's a good behavior (hence the change in cgroup2) and there
are situations where changing things like this is justifiable, but, here:

* The proposed change makes the interface inconsistent and does so
  unconditionally on what is now a mostly legacy interface.

* There already is a newer version of the interface which includes the
  desired behavior.

* I forgot but as Waiman pointed out, you can even opt-in to the new
  behavior, which is more comprehensive without the inconsitencies,
  while staying on cgroup1.

Thanks.

-- 
tejun
