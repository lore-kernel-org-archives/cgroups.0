From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RESEND][PATCH v4] cgroup: Use CAP_SYS_RESOURCE to allow a
 process to migrate other tasks between cgroups
Date: Mon, 5 Dec 2016 16:36:51 -0800
Message-ID: <CALCETrWuKpmXQqoQmcy4Va8abdpfCnMBYHWSD0nK5pocj2nfXA@mail.gmail.com>
References: <1478647728-30357-1-git-send-email-john.stultz@linaro.org>
 <CALCETrU5fCWoe0RXfKWuN7Zt9vLvoyHFcZnVqeqiKBpSKrMrxA@mail.gmail.com>
 <20161109000342.GA42532@ast-mbp.thefacebook.com> <CALCETrW_mPHneTvcAM6HyBLCJqcwKmcYEoC+kseyuyQZzj2a=A@mail.gmail.com>
 <CALAqxLXk+A9=A0oXGEduphXOQdbMg-wuGxmLkEk9cPHyn44X5Q@mail.gmail.com> <CALAqxLW-mq4Lnudtn5KMBPdzBTg5bhTXV9QmUC2vfabVru+fUA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=VmfCo/f8mkQ1/cv+VPR1EXMm/gBYZM6/w0C00H+YCfE=;
        b=aM/wLRoZQm91lqySg7veYLvoO+qSD2tCVmBW16bPwE13LUmNU0ymdPfH1Rh8R8BAT0
         mkbMPyWcLcMaNPfS/1JQ2qo3NEY+WJxF2HBMJCKVoijeJXik/LQET18ctz2ZVJ8d6Qla
         jxtPl9MQnPxyyx7D3WKJU0c4eFvcV+TbI4bLsZFhifnU4c62hI6VrywZ0PHHB5xQ6znO
         iSHmdy7Qb+8a1CHWMcwTQ3RoTjcEOuyAhRzhtK4neoDUpnTXSMQOSHcaFgzJcahcHK7H
         eaAFW/CiyOVqycDgcpIueUc03JU1ZIxpZoXBnNgp+Q3UuDUFPA4xQuOduoikBqfe0i06
         qlmQ==
In-Reply-To: <CALAqxLW-mq4Lnudtn5KMBPdzBTg5bhTXV9QmUC2vfabVru+fUA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, kafai-b10kYP2dOMg@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, Harald Hoyer <harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Network Development <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sargun Dhillon <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>, Pablo Neira Ayuso <pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Dmitry Shmidt <dimitrysh@google.>

On Mon, Dec 5, 2016 at 4:28 PM, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On Tue, Nov 22, 2016 at 4:57 PM, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> On Tue, Nov 8, 2016 at 4:12 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>>> On Tue, Nov 8, 2016 at 4:03 PM, Alexei Starovoitov
>>> <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>> On Tue, Nov 08, 2016 at 03:51:40PM -0800, Andy Lutomirski wrote:
>>>>>
>>>>> I hate to say it, but I think I may see a problem.  Current
>>>>> developments are afoot to make cgroups do more than resource control.
>>>>> For example, there's Landlock and there's Daniel's ingress/egress
>>>>> filter thing.  Current cgroup controllers can mostly just DoS their
>>>>> controlled processes.  These new controllers (or controller-like
>>>>> things) can exfiltrate data and change semantics.
>>>>>
>>>>> Does anyone have a security model in mind for these controllers and
>>>>> the cgroups that they're attached to?  I'm reasonably confident that
>>>>> CAP_SYS_RESOURCE is not the answer...
>>>>
>>>> and specifically the answer is... ?
>>>> Also would be great if you start with specifying the question first
>>>> and the problem you're trying to solve.
>>>>
>>>
>>> I don't have a good answer right now.  Here are some constraints, though:
>>>
>>> 1. An insufficiently privileged process should not be able to move a
>>> victim into a dangerous cgroup.
>>>
>>> 2. An insufficiently privileged process should not be able to move
>>> itself into a dangerous cgroup and then use execve to gain privilege
>>> such that the execve'd program can be compromised.
>>>
>>> 3. An insufficiently privileged process should not be able to make an
>>> existing cgroup dangerous in a way that could compromise a victim in
>>> that cgroup.
>>>
>>> 4. An insufficiently privileged process should not be able to make a
>>> cgroup dangerous in a way that bypasses protections that would
>>> otherwise protect execve() as used by itself or some other process in
>>> that cgroup.
>>>
>>> Keep in mind that "dangerous" may apply to a cgroup's descendents in
>>> addition to the cgroup being controlled.
>>
>> Sorry for taking awhile to get back to you here.  I'm a little
>> befuddled as to what next steps I should consider (and honestly, I'm
>> not totally sure I really grok your concern here, particularly what
>> you mean with "dangrous cgroups").
>>
>> So is going back to the CAP_CGROUP_MIGRATE approach (to properly
>> separate "sufficiently" from "insufficiently privileged") better?
>>
>> Or something closer to the original method Android used of each cgroup
>> having an allow_attach() check which could determine what is
>> sufficiently privledged for the respective level of danger the cgroup
>> might poise?
>>
>> Or just stepping back, what method would you imagine to be reasonable
>> to allow a specified task to migrate other tasks between cgroups
>> without it having to be root/suid?
>
> Any suggested feedback here?

I really don't know.  The cgroupfs interface is a bit unfortunate in
that it doesn't really express the constraints.  To safely migrate a
task, ISTM you ought to have some form of privilege over the task
*and* some form of privilege over the cgroup.  cgroupfs only handles
the latter.

CAP_CGROUP_MIGRATE ought to be okay.  Or maybe cgroupfs needs to gain
a concept of "dangerous" cgroups and further restrict them and
CAP_SYS_RESOURCE should be fine for non-dangerous cgroups?  I think I
favor the latter, but it might be nice to hear from Tejun first.

--Andy
