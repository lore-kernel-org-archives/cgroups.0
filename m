From: Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 09/12] sysfs: fix deadlock race with module removal
Date: Tue, 21 Sep 2021 08:48:49 -0700
Message-ID: <CAB=NE6WjupsJFwsj94sC_j3gcYn2Qo0sx1=tMv=WUZ83jq_DFw@mail.gmail.com>
References: <20210917194709.3562413-1-mcgrof@kernel.org> <20210917194709.3562413-10-mcgrof@kernel.org>
 <c70dcb03e27e43c5b5311e184357df39@AcuMS.aculab.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632239352;
        bh=SYPIsUeB0QpNl9iOqz8TrUCBGO94e+noRg1ECZdTJME=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=UaaVRIqswzz+NS3S8fQEaKMO9RtdOXsyeprnTEIheXJKQGHNj08P7eyrd/PQOFBCR
         AN5tBBs86O+nP3GdbvOj2N+vfIACcMw2gY7GyzZmcnfLHUMHWEqqTO8tVeryaAcPBC
         wa3PUemimJFndCXNOCuGMsRHqw57UEYG+Vl8QmekwFARdVX0/7ufVsMqf8T+9g7Szp
         diWZkbbph3gXn35UaYmr5cUyleLHlYXnKdZMqMkRG/D9zQZoy6oFBj2a59MNnxAHRK
         YIYKWUHNZvNhOBYpWGFXq5g7hiH0GMlpMxwr02jYDVngebiKxCzBjK5YB3wvzgzdsQ
         QI6X04sAKlF5w==
In-Reply-To: <c70dcb03e27e43c5b5311e184357df39-1XygrNkDbNvwg4NCKwmqgw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org>
Cc: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "jeyu-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <jeyu-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "ndesaulniers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <ndesaulniers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "ojeda-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <ojeda-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "vitor-HdruG0TBZYlAfugRpC6u6w@public.gmane.org" <vitor-HdruG0TBZYlAfugRpC6u6w@public.gmane.org>, "elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, rf-yzvPICuk2AB0ssr/7FiavQ@public.gmane.org

On Tue, Sep 21, 2021 at 1:24 AM David Laight <David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org> wrote:
>
> From: Luis Chamberlain
> > Sent: 17 September 2021 20:47
> >
> > When sysfs attributes use a lock also used on module removal we can
> > race to deadlock. This happens when for instance a sysfs file on
> > a driver is used, then at the same time we have module removal call
> > trigger. The module removal call code holds a lock, and then the sysfs
> > file entry waits for the same lock. While holding the lock the module
> > removal tries to remove the sysfs entries, but these cannot be removed
> > yet as one is waiting for a lock. This won't complete as the lock is
> > already held. Likewise module removal cannot complete, and so we deadlock.
>
> Isn't the real problem the race between a sysfs file action and the
> removal of the sysfs node?

Nope, that is taken care of by kernfs.

> This isn't really related to module unload - except that may
> well remove some sysfs nodes.

Nope, the issue is a deadlock that can happen due to a shared lock on
module removal and a driver sysfs operation.

> This is the same problem as removing any other kind of driver callback.
> There are three basic solutions:
> 1) Use a global lock - not usually useful.
> 2) Have the remove call sleep until any callbacks are complete.
> 3) Have the remove just request removal and have a final
>    callback (from a different context).

Kernfs already does a sort of combination of 1) and 2) but 1) is using
atomic reference counts.

> If the remove can sleep (as in 2) then there is a requirement
> on the driver code to not hold any locks across the 'remove'
> that can be acquired during the callbacks.

And this is the part that kernfs has no control over since the removal
and sysfs operation are implementation specific.

> Now, for sysfs, you probably only want to sleep the remove code
> while a read/write is in progress - not just because the node
> is open.
> That probably requires marking an open node 'invalid' and
> deferring delete to close.

This is already done by kernfs.

> None of this requires a reference count on the module.

You are missing the point to the other aspect of the try_module_get(),
it lets you also check if module exit has been entered. By using
try_module_get() you let the module exit trump proceeding with an
operation, therefore also preventing any potential use of a shared
lock on module exit and the driver specific sysfs operation.

  Luis
