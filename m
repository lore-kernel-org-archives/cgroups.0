From: Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 09/12] sysfs: fix deadlock race with module removal
Date: Mon, 20 Sep 2021 14:43:45 -0700
Message-ID: <YUkAkSUQtUZvNvTu@bombadil.infradead.org>
References: <20210918050430.3671227-1-mcgrof@kernel.org>
 <20210918050430.3671227-10-mcgrof@kernel.org>
 <6db06c27-e3af-b0aa-6f38-9c31dd8194fa@acm.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=D26fSnJLbC9XZDfSrbIUPFGxJqUcYaE49d48YeAtGx8=; b=NBcRJuW96wCs2L5yciBjnu4F4c
        Rn9oYNN1r/1pdLA61JWi8mSh2jw4C197H6PxcOg2RORNnVp0NHy3B2/mVwzXnkDgC9Bnt9SFoFpZq
        E4HHHEzgLP5+gHSOKUS4bEvDYdobZ6BKb8IOsWWpInVAuyr0pBgxnJp8SXIHvvLfeLKukmB80eL+B
        HOWdqQdII79WYdIrZ/4XgmeMgjaGc0llYrEViO4WDCrlrjRY4sBOgcW6IYtgGedGJUZuTpyw49ERA
        cKp1wpEFy0klyQ3ztACi2tVfmneinCUyDoVWNGLeZRw814u7MRUpuq5zDgDHzlfmHeRjcjSf8u/Nl
        pMB4G/bw==;
Content-Disposition: inline
In-Reply-To: <6db06c27-e3af-b0aa-6f38-9c31dd8194fa-HInyCGIudOg@public.gmane.org>
Sender: Luis Chamberlain <mcgrof-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jeyu-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ndesaulniers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ojeda-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org, vitor-HdruG0TBZYlAfugRpC6u6w@public.gmane.org, elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rf-yzvPICuk2AA4QjBA90+/kJqQE7yCjDx5@public.gmane.org, stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org, David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, trishalfonso-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mbenes-IBi9RG/b67k@public.gmane.org, ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org, sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes@cmpxchg.

On Mon, Sep 20, 2021 at 02:36:38PM -0700, Bart Van Assche wrote:
> On 9/17/21 10:04 PM, Luis Chamberlain wrote:
> > A sketch of how this can happen follows:
> > 
> > CPU A                              CPU B
> >                                     whatever_store()
> > module_unload
> >    mutex_lock(foo)
> >                                     mutex_lock(foo)
> >     del_gendisk(zram->disk);
> >       device_del()
> >         device_remove_groups()
> > 
> > In this situation whatever_store() is waiting for the mutex foo to
> > become unlocked, but that won't happen until module removal is complete.
> > But module removal won't complete until the sysfs file being poked
> > completes which is waiting for a lock already held.
> 
> If I remember correctly I encountered the deadlock scenario described
> above for the first time about ten years ago while working on the SCST
> project. We solved this deadlock by removing the sysfs attributes from
> the module unload code before grabbing mutex_lock(foo), e.g. by calling
> sysfs_remove_file().

Well the sysfs attributes in zram do tons of funky mucking around so
unfortunately no. It's not the only driver where this can happen. It is
why I decided to work on a generic solution instead.

> This works because calling sysfs_remove_file()
> multiple times in a row is safe. Is that solution good enough for the
> zram driver?

The sysfs attributes are group attributes part of the block, and so are
removed for the driver on a del_gendisk(). So unfortunately no, this
would not be a good solution in this case.

  Luis
