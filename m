From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: add cgroup.signal
Date: Mon, 26 Apr 2021 18:24:21 +0200
Message-ID: <20210426162421.6okhu5ng3xj3azoo@wittgenstein>
References: <20210423171351.3614430-1-brauner@kernel.org>
 <YIbRZeWIl8i6soSN@blackbook>
 <20210426152932.ekay5rfyqeojzihc@wittgenstein>
 <CALvZod5=eLQMdVXxuhj9ia=PkoRvT5oBxeqZAVtQpSukZ=tCxA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALvZod5=eLQMdVXxuhj9ia=PkoRvT5oBxeqZAVtQpSukZ=tCxA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Apr 26, 2021 at 09:08:32AM -0700, Shakeel Butt wrote:
> On Mon, Apr 26, 2021 at 8:29 AM Christian Brauner
> <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> [...]
> > > Have you considered accepting a cgroup fd to pidfd_send_signal and
> > > realize this operation through this syscall? (Just asking as it may
> > > prevent some of these consequences whereas bring other unclarities.)
> >
> > That's semantically quite wrong on several fronts, I think.
> > pidfd_send_signal() operates on pidfds (and for a quirky historical
> > reason /proc/<pid> though that should die at some point). Making this
> > operate on cgroup fds is essentially implicit multiplexing which is
> > pretty nasty imho. In addition, this is a cgroup concept not a pidfd
> > concept.
> 
> What's your take on a new syscall cgroupfd_send_signal()? One
> complexity would be potentially different semantics for v1 and v2.

I would think that this will be labeled overkill and has - imho - almost
zero chance of being accepted.
You'd essentially need to argue that it's sensible for a (virtual)
filesystem to have a separate syscall or syscalls (a signal sending one
at that).
In addition you'd break the filesystem api model that cgroups are
designed around which seems unpleasant.
(And fwiw, an ioctl() would have the same issues though it has
precedence if you look at nsfs. But nsfs doesn't have any real
filesystem interaction model apart from being open()able and is
basically a broken out part from procfs.)
