From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 00/16] memcg accounting from OpenVZ
Date: Fri, 16 Jul 2021 05:55:42 -0700
Message-ID: <CALvZod66KF-8xKB1dyY2twizDE=svE8iXT_nqvsrfWg1a92f4A@mail.gmail.com>
References: <8664122a-99d3-7199-869a-781b21b7e712@virtuozzo.com>
 <919bd022-075e-98a7-cefb-89b5dee80ae8@virtuozzo.com> <CALvZod5Kxrj3T99CEd8=OaoW8CwKtHOVhno58_nNOqjR2y=x6Q@mail.gmail.com>
 <3a60b936-b618-6cef-532a-97bbdb957fb1@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7YVe12K3kAf74Lw6w7FM9BISBfQ+xdkVlpPe2xtnZxw=;
        b=S1/f9dxk1+qzNpT4FBDWITbM6Bgtq5eX45j8wxtciNfUAcIAlC1LzMee1hh0QkZ0HY
         lg+mFnaoj2vPn6A8SZR+yhktxiJ770BndjMgvWPgp2bjQDPDLKG7wc5ZgxKBf6/OoOB8
         MwrpPg4hSlzZp0AdZGujKVaYhlCIkkA23YJabdnHyafUisZIxmQhpcTlK7s4GqSN7vDu
         v0ZIav43+PieP8CTwmsV1uh8ZK+Tw6wObkgvCEoxiR2Ko17xbGGEdqkwAh8OfvS/+QMM
         QS/BlBO10sHKcfRLUWuvikVte6UouWZydyHvyLNMH4rjhNwyFsM/fw9GUf8aR2RX7lqs
         MIkg==
In-Reply-To: <3a60b936-b618-6cef-532a-97bbdb957fb1-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrei Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, H. Peter Anvin

On Thu, Jul 15, 2021 at 9:11 PM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>
> On 7/15/21 8:11 PM, Shakeel Butt wrote:
> > On Tue, Apr 27, 2021 at 11:51 PM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
> >>
> >> OpenVZ uses memory accounting 20+ years since v2.2.x linux kernels.
> >> Initially we used our own accounting subsystem, then partially committed
> >> it to upstream, and a few years ago switched to cgroups v1.
> >> Now we're rebasing again, revising our old patches and trying to push
> >> them upstream.
> >>
> >> We try to protect the host system from any misuse of kernel memory
> >> allocation triggered by untrusted users inside the containers.
> >>
> >> Patch-set is addressed mostly to cgroups maintainers and cgroups@ mailing
> >> list, though I would be very grateful for any comments from maintainersi
> >> of affected subsystems or other people added in cc:
> >>
> >> Compared to the upstream, we additionally account the following kernel objects:
> >> - network devices and its Tx/Rx queues
> >> - ipv4/v6 addresses and routing-related objects
> >> - inet_bind_bucket cache objects
> >> - VLAN group arrays
> >> - ipv6/sit: ip_tunnel_prl
> >> - scm_fp_list objects used by SCM_RIGHTS messages of Unix sockets
> >> - nsproxy and namespace objects itself
> >> - IPC objects: semaphores, message queues and share memory segments
> >> - mounts
> >> - pollfd and select bits arrays
> >> - signals and posix timers
> >> - file lock
> >> - fasync_struct used by the file lease code and driver's fasync queues
> >> - tty objects
> >> - per-mm LDT
> >>
> >> We have an incorrect/incomplete/obsoleted accounting for few other kernel
> >> objects: sk_filter, af_packets, netlink and xt_counters for iptables.
> >> They require rework and probably will be dropped at all.
> >>
> >> Also we're going to add an accounting for nft, however it is not ready yet.
> >>
> >> We have not tested performance on upstream, however, our performance team
> >> compares our current RHEL7-based production kernel and reports that
> >> they are at least not worse as the according original RHEL7 kernel.
> >
> > Hi Vasily,
> >
> > What's the status of this series? I see a couple patches did get
> > acked/reviewed. Can you please re-send the series with updated ack
> > tags?
>
> Technically my patches does not have any NAKs. Practically they are still them merged.
> I've expected Michal will push it, but he advised me to push subsystem maintainers.
> I've asked Tejun to pick up the whole patch set and I'm waiting for his feedback right now.
>
> I can resend patch set once again, with collected approval and with rebase to v5.14-rc1.
> However I do not understand how it helps to push them if patches should be processed through
> subsystem maintainers. As far as I understand I'll need to split this patch set into
> per-subsystem pieces and sent them to corresponded maintainers.
>

Usually these kinds of patches (adding memcg accounting) go through mm
tree but if there are no dependencies between the patches and a
consensus that each subsystem maintainer picks the corresponding patch
then that is fine too.
