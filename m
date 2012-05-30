From: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 3/6] expose fine-grained per-cpu data for cpuacct stats
Date: Wed, 30 May 2012 05:48:40 -0700
Message-ID: <CAPM31RJ7s+pNciOEnsfXRU9xCwnUano1k8CTEUuCjsSN5n0-1Q@mail.gmail.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>
 <1338371317-5980-4-git-send-email-glommer@parallels.com> <CAPM31RJanAvDB+pZ+h5J3W6KXvAwPgbbeXgw6C_56tx_Mc+cgA@mail.gmail.com>
 <4FC6107F.9020802@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=I4a8El8keX+qrCJyy5FgO31Uk4taKvDqtVxD6IGGQKQ=;
        b=cJV/xHLRoqxwI6jLL8kvPv6/skPJEuHtZupTTt19F0ekYV9YJ5uRxNqhTI9ur0+nbp
         3W6ZkCU/o5Lme5eKOopIErF4ZOnOYoGxZ2EYduQj+7IZohloTmhXLVp016nH6M02+TKF
         mFE8SdkjmVwNgUYi4QBtFQ4E/Z67BzFDmQlnJWiZHAt9cYyjrRFdRCfOrLz96OOloYbT
         3T+PfHJlAslkBSkYUZzqR/v2tI7s5uYPxgnGkTkmXH5qYnZrLO7zZweX/W5YGN27GNz2
         Gcgsn3YgtQ2oBU9ffFK2rQq3eUrzy0I1dG+LW+6jsaquhy9Bzo7tFGrjYeSIt05ylJWI
         zk7g==
In-Reply-To: <4FC6107F.9020802-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Wed, May 30, 2012 at 5:20 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> =
wrote:
> On 05/30/2012 03:24 PM, Paul Turner wrote:
>>>
>>> +static int cpuacct_stats_percpu_show(struct cgroup *cgrp, struct c=
ftype
>>> *cft,
>>> > =A0+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0struct cgroup_map_cb *cb)
>>> > =A0+{
>>> > =A0+ =A0 =A0 =A0 struct cpuacct *ca =3D cgroup_ca(cgrp);
>>> > =A0+ =A0 =A0 =A0 int cpu;
>>> > =A0+
>>> > =A0+ =A0 =A0 =A0 for_each_online_cpu(cpu) {
>>> > =A0+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_fill_cb(cb, ca, "user", cpu, =
CPUTIME_USER);
>>> > =A0+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_fill_cb(cb, ca, "nice", cpu, =
CPUTIME_NICE);
>>> > =A0+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_fill_cb(cb, ca, "system", cpu=
, CPUTIME_SYSTEM);
>>> > =A0+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_fill_cb(cb, ca, "irq", cpu, C=
PUTIME_IRQ);
>>> > =A0+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_fill_cb(cb, ca, "softirq", cp=
u, CPUTIME_SOFTIRQ);
>>> > =A0+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_fill_cb(cb, ca, "guest", cpu,=
 CPUTIME_GUEST);
>>> > =A0+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_fill_cb(cb, ca, "guest_nice",=
 cpu,
>>> > CPUTIME_GUEST_NICE);
>>> > =A0+ =A0 =A0 =A0 }
>>> > =A0+
>>
>> I don't know if there's much that can be trivially done about it but=
 I
>> suspect these are a bit of a memory allocation time-bomb on a many-C=
PU
>> machine. =A0The cgroup:seq_file mating (via read_map) treats everyth=
ing
>> as/one/ =A0record. =A0This means that seq_printf is going to end up
>> eventually allocating a buffer that can fit_everything_ =A0(as well =
as
>>
>> every power-of-2 on the way there). =A0Adding insult to injury is th=
at
>> that the backing buffer is kmalloc() not vmalloc().
>>
>> 200+ bytes per-cpu above really is not unreasonable (46 bytes just f=
or
>> the text, plus a byte per base 10 digit we end up reporting), but th=
at
>> then =A0leaves us looking at order-12/13 allocations just to print t=
his
>> thing when there are O(many) cpus.
>>
>
> And how's /proc/stat different ?
> It will suffer from the very same problems, since it also have this v=
ery
> same information (actually more, since I am skipping some), per-cpu.

So,

a) the information in /proc/stat is actually much denser since it's
"cpu VAL VAL VAL VAL" as opposed to "cpuX.FIELD VAL"
b) If it became a problem the /proc/stat case is actually fairly
trivially fixable by defining each cpu as a record and "everything
else" as a magic im-out-of-cpus value.

>
> Now, if you guys are okay with a file per-cpu, I can do it as well.
> It pollutes the filesystem, but at least protects against the fact th=
at this
> is kmalloc-backed.
>

As I prefaced, I'm not sure there's much that can be trivially done
about it.  This is really a fundamental limitation of how read_map()
works.

What we really need is a proper seq_file exposed through cftypes.
