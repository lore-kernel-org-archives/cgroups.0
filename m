From: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC v2 09/10] landlock: Handle cgroups (performance)
Date: Sat, 27 Aug 2016 13:43:09 -0700
Message-ID: <20160827204307.GA43714@ast-mbp.thefacebook.com>
References: <1472121165-29071-1-git-send-email-mic@digikod.net>
 <1472121165-29071-10-git-send-email-mic@digikod.net>
 <20160826021432.GA8291@ast-mbp.thefacebook.com>
 <57C05BF0.8000706@digikod.net>
 <20160826230539.GA26683@ast-mbp.thefacebook.com>
 <57C19E6E.6040908@digikod.net>
 <20160827180642.GA38754@ast-mbp.thefacebook.com>
 <57C1EB72.2050703@digikod.net>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=HiRlMXQlixJN3xC9FCjV2scoj7YxQudwJvHjQhz1G88=;
        b=K4j8zKf4keN6CKhzx3cSQbAvQo/JH4wK4b9otUe6qAMs2qflHKckl9KiVf2t5Se6mZ
         Y8tjjcT2YiB23bVEs8oTO//ocVFoaPCaDbHJAXfltYBfnAV82etQna/IqNz+2TUSvS1s
         P/FZe9Qe89dfgUqJUnidD25OCVqcLmaTFMfFAISkDntKL2zhgU1bFuDrz1wr8ffnbYqT
         aUgdMe5nRGiHCcZarI35X4y+nkZ6yESQo0asya3lgeSX0Zvy0WqdSPyBvhNO/bL6Y+QM
         AcvS2gxytjgX7ye9q5wE73bQlwlDBuO7T5RE0rsnMyZVn84fdkVOUqMTr4DnOal4FzMH
         mtRQ==
Content-Disposition: inline
In-Reply-To: <57C1EB72.2050703-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Sargun Dhillon <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Aug 27, 2016 at 09:35:14PM +0200, Micka=EBl Sala=FCn wrote:
>=20
> On 27/08/2016 20:06, Alexei Starovoitov wrote:
> > On Sat, Aug 27, 2016 at 04:06:38PM +0200, Micka=EBl Sala=FCn wrote:
> >>
> >> On 27/08/2016 01:05, Alexei Starovoitov wrote:
> >>> On Fri, Aug 26, 2016 at 05:10:40PM +0200, Micka=EBl Sala=FCn wrote:
> >>>>
> >>>>>
> >>>>> - I don't think such 'for' loop can scale. The solution needs to wo=
rk
> >>>>> with thousands of containers and thousands of cgroups.
> >>>>> In the patch 06/10 the proposal is to use 'current' as holder of
> >>>>> the programs:
> >>>>> +   for (prog =3D current->seccomp.landlock_prog;
> >>>>> +                   prog; prog =3D prog->prev) {
> >>>>> +           if (prog->filter =3D=3D landlock_ret->filter) {
> >>>>> +                   cur_ret =3D BPF_PROG_RUN(prog->prog, (void *)&c=
tx);
> >>>>> +                   break;
> >>>>> +           }
> >>>>> +   }
> >>>>> imo that's the root of scalability issue.
> >>>>> I think to be able to scale the bpf programs have to be attached to
> >>>>> cgroups instead of tasks.
> >>>>> That would be very different api. seccomp doesn't need to be touche=
d.
> >>>>> But that is the only way I see to be able to scale.
> >>>>
> >>>> Landlock is inspired from seccomp which also use a BPF program per
> >>>> thread. For seccomp, each BPF programs are executed for each syscall.
> >>>> For Landlock, some BPF programs are executed for some LSM hooks. I d=
on't
> >>>> see why it is a scale issue for Landlock comparing to seccomp. I also
> >>>> don't see why storing the BPF program list pointer in the cgroup str=
uct
> >>>> instead of the task struct change a lot here. The BPF programs execu=
tion
> >>>> will be the same anyway (for each LSM hook). Kees should probably ha=
ve a
> >>>> better opinion on this.
> >>>
> >>> seccomp has its own issues and copying them doesn't make this lsm any=
 better.
> >>> Like seccomp bpf programs are all gigantic switch statement that looks
> >>> for interesting syscall numbers. All syscalls of a task are paying
> >>> non-trivial seccomp penalty due to such design. If bpf was attached p=
er
> >>> syscall it would have been much cheaper. Of course doing it this way
> >>> for seccomp is not easy, but for lsm such facility is already there.
> >>> Blank call of a single bpf prog for all lsm hooks is unnecessary
> >>> overhead that can and should be avoided.
> >>
> >> It's probably a misunderstanding. Contrary to seccomp which run all the
> >> thread's BPF programs for any syscall, Landlock only run eBPF programs
> >> for the triggered LSM hooks, if their type match. Indeed, thanks to the
> >> multiple eBPF program types and contrary to seccomp, Landlock only run
> >> an eBPF program when needed. Landlock will have almost no performance
> >> overhead if the syscalls do not trigger the watched LSM hooks for the
> >> current process.
> >=20
> > that's not what I see in the patch 06/10:
> > all lsm_hooks in 'static struct security_hook_list landlock_hooks'
> > (which eventually means all lsm hooks) will call
> > static inline int landlock_hook_##NAME
> > which will call landlock_run_prog()
> > which does:
> > + for (landlock_ret =3D current->seccomp.landlock_ret;
> > +      landlock_ret; landlock_ret =3D landlock_ret->prev) {
> > +    if (landlock_ret->triggered) {
> > +       ctx.cookie =3D landlock_ret->cookie;
> > +       for (prog =3D current->seccomp.landlock_prog;
> > +            prog; prog =3D prog->prev) {
> > +               if (prog->filter =3D=3D landlock_ret->filter) {
> > +                       cur_ret =3D BPF_PROG_RUN(prog->prog, (void *)&c=
tx);
> > +                       break;
> > +               }
> > +       }
> >=20
> > that is unacceptable overhead and not a scalable design.
> > It kinda works for 3 lsm_hooks as in patch 6, but doesn't scale
> > as soon as more lsm hooks are added.
>=20
> Good catch! I forgot to check the program (sub)type in the loop to only
> run the needed programs for the current hook. I will fix this.
>=20
>=20
> >=20
> >> As said above, Landlock will not run an eBPF programs when not strictly
> >> needed. Attaching to a cgroup will have the same performance impact as
> >> attaching to a process hierarchy.
> >=20
> > Having a prog per cgroup per lsm_hook is the only scalable way I
> > could come up with. If you see another way, please propose.
> > current->seccomp.landlock_prog is not the answer.
>=20
> Hum, I don't see the difference from a performance point of view between
> a cgroup-based or a process hierarchy-based system.
>=20
> Maybe a better option should be to use an array of pointers with N
> entries, one for each supported hook, instead of a unique pointer list?

yes, clearly array dereference is faster than link list walk.
Now the question is where to keep this prog_array[num_lsm_hooks] ?
Since we cannot keep it inside task_struct, we have to allocate it.
Every time the task is creted then. What to do on the fork? That
will require changes all over. Then the obvious optimization would be
to share this allocated array of prog pointers across multiple tasks...
and little by little this new facility will look like cgroup.
Hence the suggestion to put this array into cgroup from the start.

> Anyway, being able to attach an LSM hook program to a cgroup thanks to
> the new BPF_PROG_ATTACH seems a good idea (while keeping the possibility
> to use a process hierarchy). The downside will be to handle an LSM hook
> program which is not triggered by a seccomp-filter, but this should be
> needed anyway to handle interruptions.

what do you mean 'not triggered by seccomp' ?
You're not suggesting that this lsm has to enable seccomp to be functional?
imo that's non starter due to overhead.
