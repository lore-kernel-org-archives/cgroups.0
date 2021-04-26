From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: add cgroup.signal
Date: Mon, 26 Apr 2021 17:15:14 +0200
Message-ID: <20210426151514.od5d7bru7fyu24qs@wittgenstein>
References: <20210423171351.3614430-1-brauner@kernel.org>
 <YIMZkjzNFypjZao9@carbon.dhcp.thefacebook.com>
 <YIbRP5/w1ZD804DL@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YIbRP5/w1ZD804DL@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Apr 26, 2021 at 04:42:07PM +0200, Michal Koutn=C3=BD wrote:
> Hello.

(Tiny favor, can you please leave a newline before your inline replies.
Would make it easier to follow.)

>=20
> On Fri, Apr 23, 2021 at 12:01:38PM -0700, Roman Gushchin <guro-b10kYP2dOM=
g@public.gmane.org> wrote:
> > Overall it sounds very reasonable and makes total sense to me.
> I agree this sounds like very desired convenience...
>=20
> > Many userspace applications can use the new interface instead of
> > reading cgroup.procs in a cycle and killing all processes or using the
> > freezer and kill a frozen list of tasks.
> ...however, exactly because of this, I'm not convinced it's justifying
> yet another way how to do it and implement that in kernel. (AFAIU, both
> those ways should be reliable too (assuming reading cgroup.procs of the
> _default_ hierarchy), please correct me if I'm wrong.)
>=20
> > It will simplify the code and make it more reliable.
> It's not cost free though, part of the complexity is moved to the
> kernel.
> As Roman already pointed earlier, there are is unclear situation wrt
> forking tasks. The similar had to be solved for the freezer hence why
> not let uspace rely on that already? Having similar codepaths for
> signalling the cgroups seems like a way to have two similar codepaths
> side by side where one of them serves just to simplify uspace tools.

The established way of doing things in userspace stems from cgroup v1
where the concept of "kill this cgroup and all its descendants didn't
really make sense in the face of multiple hierarchies. This is in pretty
stark contrast to cgroup v2 where that concept first does make a lot of
sense. So the "traditional" way of killing cgroups is a take-over from
the legacy cgroup world.

Since cgroups organize and manage resources and processes killing
cgroups is arguably a core cgroup feature and in some form was always
planned. It just hasn't been high-priority.

We often tend to bring "this is just convenience and therefore not worth
it" as an argument (sure did it myself) but I think that's quite often
not a very good argument. We should very much try to make interfaces
simpler to use for userspace. In this specific instance the code comes
down from an algorithm to recursively kill all cgroups to a single write
into a file. Which seems like a good win.

This also allows for quite a few things that aren't currently possible
in userspace. Some of which were in the original mail (at least
implicitly).
For example, you can delegate killing of a privileged cgroup to a less
privileged or sandboxed process by having the privileged process open
the cgroup.kill file and then handing it off. In general similar to
freezing you can send around that file descriptor. You can kill
processes in ancestor or sibling pid namespaces as long as they are
encompassed in the same cgroup. And other useful things.

But really, the simplifcation alone is already quite good.
