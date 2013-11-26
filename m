From: Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup management daemon
Date: Tue, 26 Nov 2013 13:24:59 -0800
Message-ID: <CAO_RewZh+dNkUdZdu-R3CKTvYzbPL50v-BsBHvek75ti3V6kZQ@mail.gmail.com>
References: <20131125224335.GA15481@mail.hallyn.com> <CAO_RewZGWARUafKzDc_t3G5OedGtEPTZgB2VYeHHiKSSrja8fA@mail.gmail.com>
 <20131126054718.GA19134@mail.hallyn.com> <CAO_RewZ8cUn-PdXfQF0yH=V=9UqE7Yo1JX2pt2c71WYDrpYE0Q@mail.gmail.com>
 <20131126205819.GA27266@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=UmrdYJabFwxaQ5Cw29dpyT7Chqjh0Qs5+gLKiG9OcPE=;
        b=OrK2XreAyfNgUYpxO/CmRE5vz0xsFeEHD9S0iwjiv1of/mnXvt/7YZjtfCSY6Nczex
         6PItaNU5phlnlli/U5nnlJx3BGU2oWT+FTh4P/lXtPMiaLh/Q42LASqahs4GLvd8IAoA
         SRlMNx5KjFJm9ZkrmkLq+u8Xc+Ifs2cQtDAzaV6Aco4PENjUWKc2YlEtljH6JSwvbp/6
         SAuECPz9joqu2bgN0iyP8HAmX3jdm0HS/0b5nx7R6EnqQ7tPgVwZ9Dr9Zsas9bHbYDp+
         Mg6ygm428pO+qplWUQ8NC9NCxiI4/e04qiQ8CB4qaDzA0EDnIrmO4gSqAVnKUBdVDl4S
         kTbA==
In-Reply-To: <20131126205819.GA27266-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?ISO-8859-1?Q?St=E9phane_Graber?= <stgraber-/Ni+VN9Krahg9hUCZPvPmw@public.gmane.org>

lmctfy literally supports ".." as a container name :)

On Tue, Nov 26, 2013 at 12:58 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> Quoting Tim Hockin (thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
>> On Mon, Nov 25, 2013 at 9:47 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
>> > Quoting Tim Hockin (thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> ...
>> >> >   . A client (requestor 'r') can make cgroup requests over
>> >> >     /sys/fs/cgroup/manager using dbus calls.  Detailed privilege
>> >> >     requirements for r are listed below.
>> >> >   . The client request will pertain an existing or new cgroup A.  r's
>> >> >     privilege over the cgroup must be checked.  r is said to have
>> >> >     privilege over A if A is owned by r's uid, or if A's owner is mapped
>> >> >     into r's user namespace, and r is root in that user namespace.
>> >>
>> >> Problem with this definition.  Being owned-by is not the same as
>> >> has-root-in.  Specifically, I may choose to give you root in your own
>> >> namespace, but you sure as heck can not increase your own memory
>> >> limit.
>> >
>> > 1. If you don't want me to change the value at all, then just don't map
>> > A's owner into the namespace.  I'm uid 100000 which is root in my namespace,
>> > but I only have privilege over other uids mapped into my namespace.
>>
>> I think I understand this, but it is subtle.  Maybe some examples would help?
>
> When you create a user namespace, at first it is empty, and you are 'nobody'
> (-1).  Then magically some uids from the host, say 100000-101999, are mapped
> into your namespace, to uids 0-1999.
>
> Now assume you're uid 0 inside that namespace.  You have privilege over your
> uids, 0-999, which are 100000-101999 on the host.
>
> If cgroup file A is owned by host uid 0, then the owner is not mapped into
> the user namespace.  uid 0 inside the namespace only gets the world access
> rights to that file.
>
> If cgroup file A is owned by host uid 100100, then uid 0 in the
> namespace has access to that file by virtue of being root, and uid 100
> in the namespace (100100 on the host) has access to the file by virtue
> of being the owner.
>
>> > 2. I've considered never allowing changes to your own cgroup.  So if you're
>> > in /a/b, you can create /a/b/c and modify c's settings, but you can't modify
>> > b's.  OTOH, that isn't strictly necessary - if we did allow it, then you
>> > could simply clam /a/b's memory to what you want, and stick me in /a/b/c,
>> > so I can't escape the memory limit you wanted.
>>
>> This is different from what we do internally, but it's an interesting
>> semantic.  I'm wary of how much we want to make this API about
>> enforcement of policy vs simple enactment.  In other words, semantics
>> that diverge from UNIX ownership might be more complicated to
>> understand than they are worth.
>
> The semantics I gave are exactly the user namespace semantics.  If you're
> not using a user namespace then they simply do not apply, and you are back
> to strict UNIX ownership semantics that you want.  But allowing 'root' in
> a user namespace to have privilege over uids, without having any privilege
> outside its own namespace, must be honored for this to be usable by lxc.
>
> Like I said, on the bright side, if you don't want to care about user
> namespaces, then everything falls back to strict unix semantics - so if
> you don't want to care, you don't have to care.
>
>> > 3. I've not considered having the daemon track resource limits - i.e. creating
>> > a cgroup and saying "give it 100M swap, and if it asks, let it increase that
>> > to 200M."  I'd prefer that be done incidentally through (1) and (2).  Do you
>> > feel that would be insufficient?
>>
>> I think this is a higher-level issue that should not be addressed here.
>>
>> > Or maybe your question is something different and I'm missing it?
>>
>> My point was that I, as machine admin, create a memory cgroup of 100
>> MB for you and put you in it.   I also give you root-in-namespace.
>> You must not be able to change 100 MB to 200 MB.  From your (1) you
>> are saying that system UID 0 owns the cgroup and is NOT mapped into
>> your namespace.  Therefore your definition holds.  I think I can buy
>> that.
>>
>> >> >   . The client request may pertain a victim task v, which may be moved
>> >> >     to a new cgroup.  In that case r's privilege over both the cgroup
>> >> >     and v must be checked.  r is said to have privilege over v if v
>> >> >     is mapped in r's pid namespace, v's uid is mapped into r's user ns,
>> >> >     and r is root in its userns.  Or if r and v have the same uid
>> >> >     and v is mapped in r's pid namespace.
>> >> >   . r's credentials will be taken from socket's peercred, ensuring that
>> >> >     pid and uid are translated.
>> >> >   . r passes PID(v) as a SCM_CREDENTIAL, so that cgmanager receives the
>> >> >     translated global pid.  It will then read UID(v) from /proc/PID(v)/status,
>> >> >     which is the global uid, and check /proc/PID(r)/uid_map to see whether
>> >> >     UID is mapped there.
>> >> >   . dbus-send can be enhanced to send a pid as SCM_CREDENTIAL to have
>> >> >     the kernel translate it for the reader.  Only 'move task v to cgroup
>> >> >     A' will require a SCM_CREDENTIAL to be sent.
>> >> >
>> >> > Privilege requirements by action:
>> >> >     * Requestor of an action (r) over a socket may only make
>> >> >       changes to cgroups over which it has privilege.
>> >> >     * Requestors may be limited to a certain #/depth of cgroups
>> >> >       (to limit memory usage) - DEFER?
>> >> >     * Cgroup hierarchy is responsible for resource limits
>> >> >     * A requestor must either be uid 0 in its userns with victim mapped
>> >> >       ito its userns, or the same uid and in same/ancestor pidns as the
>> >> >       victim
>> >> >     * If r requests creation of cgroup '/x', /x will be interpreted
>> >> >       as relative to r's cgroup.  r cannot make changes to cgroups not
>> >> >       under its own current cgroup.
>> >>
>> >> Does this imply that r in a lower-level (farter from root) of the
>> >> hierarchy can not make requests of higher levels of the hierarchy
>> >> (closer to root), even though they have permissions as per the
>> >> definition of privilege?
>> >
>> > Right.
>>
>> Is this really a required semantic?  We have use cases where
>> read-access is required to parent cgroups, which means this agent
>> could never handle reads.  It's not clear that we have use cases for
>> write-access to parents, though we have talked about eventfd - is that
>> read or write access?  Does this daemon want to handle event fd?
>
> Denying read access to parent cgroups is not strictly necessary to meet
> any of my requirements.  Eventfd only requires an open read handle to
> the file, so that should be ok.
>
> So to support that, I guess I'd want to add a 'get-my-cgroup'
> command with controller argument, which reeturns the absolute
> path.  Cgroups which start with a '/' are taken as absolute
> cgroup paths, as opposed to the usual, relative-to-my-own.
> It sounds like you also might want to just use '../' ?
>
> I'd refuse write access for now altogether.  We can talk later, if
> someone finds a need, about a way to support conditional write
> access, but that's pretty much completely bypassing the hierarchial
> constraints :)
>
> -serge
