From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH v7 09/12] sysfs: fix deadlock race with module removal
Date: Mon, 20 Sep 2021 14:17:02 -0700
Message-ID: <YUj6TrGbqlNI0OGC@bombadil.infradead.org>
References: <20210918050430.3671227-1-mcgrof@kernel.org>
 <20210918050430.3671227-10-mcgrof@kernel.org>
 <CAPcyv4i0xEwMQ5kSK-xGroV7aZr3j1YNrGMVLiLMr3U8nFCMKA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jbFpbU/rBCa68GfCBfDGQzurd4KjdTjdLIiL1Z6O5X4=; b=NOWbnSNka+TJ3kdTUO813SJKm0
        TORx1hpuFYKoxkXFiBCkXAOBy6hD7zyc6MIZmJgYW0V06aJAt2/n/B153hwd8lq5nHlXiLYzXRYV8
        GCFV4pP8qGkekKiCYajq1e7e0mT1py+Dz2pRF/+hJALSCFv6ik3uJ6drJqq7R/lg6h/8o7OHYUHBN
        8BRGw1YOjBSRemtwSzS4vAdCkZm61o39IUUGnSxTji1b8vi9NCEBh4IqTvQm9r/6dtP3KMro2EQ7V
        BOZ57fIIRtqSwAIp2/eLTQOzrQSpCFfNMCRTgKqAUh4mfl58tesnknLGfieor6T4qZPB2LQe6Yq4O
        RpQaXGGQ==;
Content-Disposition: inline
In-Reply-To: <CAPcyv4i0xEwMQ5kSK-xGroV7aZr3j1YNrGMVLiLMr3U8nFCMKA@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Williams <dan.j.williams@intel.com>
Cc: Tejun Heo <tj@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, jeyu@kernel.org, shuah <shuah@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, yzaikin@google.com, Nathan Chancellor <nathan@kernel.org>, ojeda@kernel.org, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, vitor@massaru.org, elver@google.com, Jarkko Sakkinen <jarkko@kernel.org>, Alexander Potapenko <glider@google.com>, rf@opensource.cirrus.com, Stephen Hemminger <stephen@networkplumber.org>, David Laight <David.Laight@aculab.com>, bvanassche@acm.org, jolsa@kernel.org, Andy Shevchenko <andriy.s>

On Mon, Sep 20, 2021 at 01:52:21PM -0700, Dan Williams wrote:
> On Fri, Sep 17, 2021 at 10:05 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> > This deadlock was first reported with the zram driver, however the live
> > patching folks have acknowledged they have observed this as well with
> > live patching, when a live patch is removed. I was then able to
> > reproduce easily by creating a dedicated selftests.
> >
> > A sketch of how this can happen follows:
> >
> > CPU A                              CPU B
> >                                    whatever_store()
> > module_unload
> >   mutex_lock(foo)
> >                                    mutex_lock(foo)
> >    del_gendisk(zram->disk);
> >      device_del()
> >        device_remove_groups()
> 
> This flow seems possible to trigger with:
> 
>    echo $dev > /sys/bus/$bus/drivers/$driver/unbind
> 
> I am missing why module pinning 

The aspect of try_module_get() which comes to value to prevent the
deadlock is it ensures kernfs ops do not run once exit is on the way.

> is part of the solution when it's the
> device_del() path that is racing?

But its not, the device_del() path will yield until the kernfs op
completes. It is fine to wait there.

The deadlock happens if a module exit routine uses a lock which is
also used on a sysfs op. If the lock was first held by module exit,
and module exit is waiting for the kernfs op to complete, and the
kernfs op is waiting to hold the same lock then the exit will wait
forever.

> Module removal is just a more coarse
> grained way to trigger unbind => device_del().

Right, but the device_del() path is not sharing a lock with the sysfs op.

> Isn't the above a bug
> in the driver, not missing synchronization in kernfs?

We can certainly take the position as an alternative:

  "thou shalt not use a lock on exit which is also used on a syfs op"

However that seems counter intuitive, specially if we can resolve the
issue easily with a try_module_get().

  Luis
