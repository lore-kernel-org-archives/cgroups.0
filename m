From: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC v2 09/10] landlock: Handle cgroups (netfilter match)
Date: Sat, 27 Aug 2016 11:32:52 -0700
Message-ID: <20160827183250.GD38754@ast-mbp.thefacebook.com>
References: <1472121165-29071-1-git-send-email-mic@digikod.net>
 <1472121165-29071-10-git-send-email-mic@digikod.net>
 <20160826021432.GA8291@ast-mbp.thefacebook.com>
 <57C05BF0.8000706@digikod.net>
 <20160826230539.GA26683@ast-mbp.thefacebook.com>
 <57C1A159.3040905@digikod.net>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Ye9TwW9qo/p/tpMZ57zl6DTS+DLyOORG3sdAv28Lr9s=;
        b=s69tDGrmYTgcgfR8AOggOUy+d9pzjsIgv55rW/fBKSoIiKzbu8yCqyscLwDovj9Mwe
         /p4kYkmhbaDc4wki/IOXJUwOyBNfkRMfoj8DdIyqN4khVxsOYYkSgRQ0WLr4b9kIacUH
         Sn7yrRJcD84HD4kmYQkNa3LWqvE2LA0HGhY7519jiEUznV75A+/MWWU6F2hKWI6oz2rn
         FgAdHp/ZoIEbAd3EDSddlhjVtDHMZ4Y3p9uP1zHnqOaWxe7I2pV88+szib3sZh+lieyj
         AvBcZ3LAWEf2i3eGEVBw4ibQFWwd3jyi6LGjK4fwbkFfOH+JMhMUipAbyzH2Ji5uxxaC
         xlNA==
Content-Disposition: inline
In-Reply-To: <57C1A159.3040905-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Sargun Dhillon <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Aug 27, 2016 at 04:19:05PM +0200, Micka=EBl Sala=FCn wrote:
>=20
> On 27/08/2016 01:05, Alexei Starovoitov wrote:
> > On Fri, Aug 26, 2016 at 05:10:40PM +0200, Micka=EBl Sala=FCn wrote:
> >> To sum up, there is four related patchsets:
> >> * "Landlock LSM: Unprivileged sandboxing" (this series)
> >> * "Add Checmate, BPF-driven minor LSM" (Sargun Dhillon)
> >> * "Networking cgroup controller" (Anoop Naravaram)
> >> * "Add eBPF hooks for cgroups" (Daniel Mack)
>=20
> >>> Anoop Naravaram's use case is to control the ports the applications
> >>> under cgroup can bind and listen on.
> >>> Such use case can be solved by such 'lsm cgroup controller' by
> >>> attaching bpf program to security_socket_bind lsm hook and
> >>> filtering sockaddr.
> >>> Furthermore Sargun's use case is to allow further sockaddr rewrites
> >>> from the bpf program which can be done as natural extension
> >>> of such mechanism.
> >>>
> >>> If I understood Daniel's Anoop's Sargun's and yours use cases
> >>> correctly the common piece of kernel infrastructure that can solve
> >>> them all can start from Daniel's current set of patches that
> >>> establish a mechanism of attaching bpf program to a cgroup.
> >>> Then adding lsm hooks to it and later allowing argument rewrite
> >>> (since they're already in the kernel and no ToCToU problems exist)
>=20
> >> For the network-related series, I think it make more sense to simply
> >> create a netfilter rule matching a cgroup and then add more features to
> >> netfilter (restrict port ranges and so on) thanks to eBPF programs.
> >> Containers are (usually) in a dedicated network namespace, which open
> >> the possibility to not only rely on cgroups (e.g. match UID,
> >> netmask...). It would also be more flexible to be able to load a BPF
> >> program in netfilter and update its maps on the fly to make dynamic
> >> rules, like ipset does, but in a more generic way.
>=20
> What do the netdev folks think about this design?

such design doesn't scale when used for container management and
that's what we need to solve.
netns has its overhead and management issues. There are proposals to
solve that but that is orthogonal to containers in general.
A lot of them don't use netns.
