From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v7 09/12] sysfs: fix deadlock race with module removal
Date: Mon, 20 Sep 2021 13:52:21 -0700
Message-ID: <CAPcyv4i0xEwMQ5kSK-xGroV7aZr3j1YNrGMVLiLMr3U8nFCMKA@mail.gmail.com>
References: <20210918050430.3671227-1-mcgrof@kernel.org> <20210918050430.3671227-10-mcgrof@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CqRJNowvS30DA449VJOT4nm+AVZU/Om+Rqqdzurt050=;
        b=iNAgLEI2/KhgFVKx72MAqTdpftvJ0aSwNn3Ejh2yEcwAEjl6yoUfTnx7YEE5xxLLuP
         1vGxRNVkPSZajZSlr8Z++4xK6MAUHC1hmL5Id1qonAbXlE3/B+ITv3TcdqeZXgF72TRn
         4mGdKsRJPPWvKJHSRyo74FHrclds73dk7pRuX3CP2b8e/4WSGZ1Bq4cr1ZIziuehan85
         Ibn/f5om/hzTPFJ53Rr+YajWSeJ7r/pZP6MkvHev6u5k9zJZtMW+MjXYotZIebVMDL9X
         pWqDSK819z2UFpUUjUM2uNFjNrF6D0bjnx9OQJsvR13XORAUQ5lu6dSGmtpqaJqXNUyn
         bwYA==
In-Reply-To: <20210918050430.3671227-10-mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, jeyu-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Masahiro Yamada <masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nick Desaulniers <ndesaulniers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Nathan Chancellor <nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, ojeda-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, vitor-HdruG0TBZYlAfugRpC6u6w@public.gmane.org, elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, rf-yzvPICuk2AA4QjBA90+/kJqQE7yCjDx5@public.gmane.org, Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, David Laight <David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org>, bvanassche-HInyCGIudOg@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Andy Shevchenko <andriy.s>

On Fri, Sep 17, 2021 at 10:05 PM Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> When sysfs attributes use a lock also used on module removal we can
> race to deadlock. This happens when for instance a sysfs file on
> a driver is used, then at the same time we have module removal call
> trigger. The module removal call code holds a lock, and then the sysfs
> file entry waits for the same lock. While holding the lock the module
> removal tries to remove the sysfs entries, but these cannot be removed
> yet as one is waiting for a lock. This won't complete as the lock is
> already held. Likewise module removal cannot complete, and so we deadlock.
>
> This can now be easily reproducible with our sysfs selftest as follows:
>
> ./tools/testing/selftests/sysfs/sysfs.sh -t 0027
>
> To fix this we extend the struct kernfs_node with a module reference and
> use the try_module_get() after kernfs_get_active() is called which
> protects integrity and the existence of the kernfs node during the
> operation.
>
> So long as the kernfs node is protected with kernfs_get_active() we know
> we can rely on its contents. And, as now just documented in the previous
> patch, we also now know that once kernfs_get_active() is called the module
> is also guarded to exist and cannot be removed.
>
> If try_module_get() fails we fail the operation on the kernfs node.
>
> We use a try method as a full lock means we'd then make our sysfs
> attributes busy us out from possible module removal, and so userspace
> could force denying module removal, a silly form of "DOS" against module
> removal. A try lock on the module removal ensures we give priority to
> module removal and interacting with sysfs attributes only comes second.
> Using a full lock could mean for instance that if you don't stop poking
> at sysfs files you cannot remove a module.
>
> Races between removal of sysfs files and the module are not possible
> given sysfs files are created by the same module, and when a sysfs file
> is being used kernfs prevents removal of the sysfs file. So if module
> removal is actually happening the removal would have to wait until
> the sysfs file operation is complete.
>
> This deadlock was first reported with the zram driver, however the live
> patching folks have acknowledged they have observed this as well with
> live patching, when a live patch is removed. I was then able to
> reproduce easily by creating a dedicated selftests.
>
> A sketch of how this can happen follows:
>
> CPU A                              CPU B
>                                    whatever_store()
> module_unload
>   mutex_lock(foo)
>                                    mutex_lock(foo)
>    del_gendisk(zram->disk);
>      device_del()
>        device_remove_groups()

This flow seems possible to trigger with:

   echo $dev > /sys/bus/$bus/drivers/$driver/unbind

I am missing why module pinning is part of the solution when it's the
device_del() path that is racing? Module removal is just a more coarse
grained way to trigger unbind => device_del(). Isn't the above a bug
in the driver, not missing synchronization in kernfs? Forgive me if
the unbind question was asked and answered elsewhere, this is my first
time taking a look at this series.
