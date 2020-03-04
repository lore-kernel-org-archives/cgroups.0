From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Memory reclaim protection and cgroup nesting (desktop use)
Date: Wed, 4 Mar 2020 11:30:44 -0500
Message-ID: <20200304163044.GF189690@mtj.thefacebook.com>
References: <d4826b9e568f1ab7df19f94c409df11956a8e262.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=K4BeHblYXMy0jWZevx0X7etvY4HSc10p3TfF4SsNt5M=;
        b=iVS3T6wquyX/FWV1nq/cJXE2LdWrz8AEhTgPW18XqQ2ELQwisn/W76smiuCyICLB0p
         TAuQJ0fJRabTH6jMTNK89S9FTpC0JKCVgih+m7VKtN3BbfzMX/0U9DD9oJxdQQaMs1+C
         zs4xCYDaiTiEpGJHW+QzoVI5K5OsoD1PUSS2ibvwrty7ZE4fPVPlPAz8WNaU0lDKXhmO
         j7JKPSrzzP94Ky2NJN++LguGAGKgi7x7IwtHmQgSC5Xat8yN8aCJvvCeYWf6zYkD0/Np
         0MEaHYzQyScqzH0QmIfa0tFkWIJc1v8+pveYzECCi8suYzEonyDvZlXMknoNkof7QBOt
         RxCA==
Content-Disposition: inline
In-Reply-To: <d4826b9e568f1ab7df19f94c409df11956a8e262.camel-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Benjamin Berg <benjamin-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello,

(cc'ing Johannes and quoting whole msg)

On Wed, Mar 04, 2020 at 10:44:44AM +0100, Benjamin Berg wrote:
> Hi,
> 
> TL;DR: I seem to need memory.min/memory.max to be set on each child
> cgroup and not just the parents. Is this expected?

Yes, currently. However, v5.7+ will have a cgroup2 mount option to
propagate protection automatically.

  https://lore.kernel.org/linux-mm/20191219200718.15696-4-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org/

> I have been experimenting with using cgroups to protect a GNOME
> session. The intention is that the GNOME Shell itself and important
> other services remain responsive, even if the application workload is
> thrashing. The long term goal here is to bridge the time until an OOM
> killer like oomd would get the system back into normal conditions using
> memory pressure information.
> 
> Note that I have done these tests without any swap and with huge
> memory.min/memory.low values. I consider this scenario pathological,
> however, it seems like a reasonable way to really exercise the cgroup
> reclaim protection logic.

It's incomplete and more brittle in that the kernel has to treat a
large portion of memory usage as essentially memlocked.

> The resulting cgroup hierarchy looked something like:
> 
> -.slice
> ├─user.slice
> │ └─user-1000.slice
> │   ├─user-HmGangybm7RTDjBF/Jpztg@public.gmane.org
> │   │ ├─session.slice
> │   │ │ ├─gsd-*.service
> │   │ │ │ └─208803 /usr/libexec/gsd-rfkill
> │   │ │ ├─gnome-shell-wayland.service
> │   │ │ │ ├─208493 /usr/bin/gnome-shell
> │   │ │ │ ├─208549 /usr/bin/Xwayland :0 -rootless -noreset -accessx -core -auth /run/user/1000/.mutter-Xwayla>
> │   │ │ │ └─ …
> │   │ └─apps.slice
> │   │   ├─gnome-launched-tracker-miner-fs.desktop-208880.scope
> │   │   │ └─208880 /usr/libexec/tracker-miner-fs
> │   │   ├─dbus-:1.2-org.gnome.OnlineAccounts@0.service
> │   │   │ └─208668 /usr/libexec/goa-daemon
> │   │   ├─flatpak-org.gnome.Fractal-210350.scope
> │   │   ├─gnome-terminal-server.service
> │   │   │ ├─209261 /usr/libexec/gnome-terminal-server
> │   │   │ ├─209434 bash
> │   │   │ └─ … including the test load i.e. "make -j32" of a C++ code
> 
> 
> I also enabled the CPU and IO controllers in my tests, but I don't
> think that is as relevant. The main thing is that I set

CPU control isn't but IO is. Without working IO isolation, it's
relatively easy to drive the system into the ground given enough
stress ouside the protected area.

>   memory.min: 2GiB
>   memory.low: 4GiB
> 
> using systemd on all of
> 
>  * user.slice,
>  * user-1000.slice,
>  * user-j7y+/WGsDUWKtF1m3vyIGg@public.gmane.org,
>  * session.slice and
>  * everything inside session.slice
>    (i.e. gnome-shell-wayland.service, gsd-*.service, …)
> 
> excluding apps.slice from protection.
> 
> (In a realistic scenario I expect to have swap and then reserving maybe
> a few hundred MiB; DAMON might help with finding good values.)

What's DAMON?

> At that point, the protection started working pretty much flawlessly.
> i.e. my gnome-shell would continue to run without major page faulting
> even though everything in apps.slice was thrashing heavily. The
> mouse/keyboard remained completely responsive, and interacting with
> applications ended up working much better thanks to knowing where input
> was going. Even if the applications themselves took seconds to react.
> 
> So far, so good. What surprises me is that I needed to set the
> protection on the child cgroups (i.e. gnome-shell-wayland.service).
> Without this, it would not work (reliably) and my gnome-shell would
> still have a lot of re-faults to load libraries and other mmap'ed data
> back into memory (I used "perf --no-syscalls -F" to trace this and
> observed these to be repeatedly for the same pages loading e.g.
> functions for execution).
> 
> Due to accounting effects, I would expect re-faults to happen up to one
> time in this scenario. At that point the page in question will be
> accounted against the shell's cgroup and reclaim protection could kick
> in. Unfortunately, that did not seem to happen unless the shell's
> cgroup itself had protections and not just all of its parents.
> 
> Is it expected that I need to set limits on each child?

Yes, right now, memory.low needs to be configured all the way down to
the leaf to be effective, which can be rather cumbersome. As written
above, future kernels will be easier to work with in this respect.

Thanks.

-- 
tejun
