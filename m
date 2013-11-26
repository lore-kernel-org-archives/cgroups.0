From: Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup management daemon
Date: Tue, 26 Nov 2013 12:38:47 -0800
Message-ID: <CAO_RewZ8cUn-PdXfQF0yH=V=9UqE7Yo1JX2pt2c71WYDrpYE0Q@mail.gmail.com>
References: <20131125224335.GA15481@mail.hallyn.com> <CAO_RewZGWARUafKzDc_t3G5OedGtEPTZgB2VYeHHiKSSrja8fA@mail.gmail.com>
 <20131126054718.GA19134@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=ZineGu2EYNyRS8PYs7ZOaFexCjUqtD6R9xMVmB4L3jc=;
        b=nJpjmo9RRgU5oJGBOwSzTWckoHeR8JCZ6NwDviPMTV5PLWwsw2UH4mIEsCPjoe/13h
         +HD+uFqjhzV0qvZtCkPr0dsPY7UiH+243L/zkO/FlGhAGT388rcLpmaYTkHHwlcKNXHK
         IrBcpyzLBuhsp11cs+MzIotjm5hZhihOdPXtLE1nWpMJF7YSYItfWALVa5k+HulMuLGJ
         b+V5QOjJcwdNfgLEOe1aP/4i0klstL4QufLXU/we3tGJwsKaqsKkkOgw0Nzj1d+CXSYB
         GGjKtEMBgn7w4JDtRoDYjOtDqcIIvhmMehwZ9JACyPVABfZG8ns5bXyfhXLQubHNYofX
         9E2Q==
In-Reply-To: <20131126054718.GA19134-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?ISO-8859-1?Q?St=E9phane_Graber?= <stgraber-/Ni+VN9Krahg9hUCZPvPmw@public.gmane.org>

On Mon, Nov 25, 2013 at 9:47 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> Quoting Tim Hockin (thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
>> Thanks for this!  I think it helps a lot to discuss now, rather than
>> over nearly-done code.
>>
>> On Mon, Nov 25, 2013 at 2:43 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
>> > Additionally, Tejun has specified that we do not want users to be
>> > too closely tied to the cgroupfs implementation.  Therefore
>> > commands will be just a hair more general than specifying cgroupfs
>> > filenames and values.  I may go so far as to avoid specifying
>> > specific controllers, as AFAIK there should be no redundancy in
>> > features.  On the other hand, I don't want to get too general.
>> > So I'm basing the API loosely on the lmctfy command line API.
>>
>> I'm torn here.  While I agree in principle with Tejun, I am concerned
>> that this agent will always lag new kernel features or that the thin
>> abstraction you want to provide here does not easily accommodate some
>> of the more ... oddball features of one cgroup interface or another.
>>
>> This agent is the very bottom of the stack, and should probably not do
>> much by way of abstraction.  I think I'd rather let something like
>> lmctfy provide the abstraction more holistically, and relegate this
>
> If lmctfy is an abstraction layer that should keep Tejun happy, and
> it could keep me out of the resource naming game which makes me happy :)
>
>> agent to very simple plumbing and policy.  It could be as simple as
>> providing read/write/etc ops to specific control files.  It needs to
>> handle event_fd, too, I guess.  This has the nice side-effect of
>> always being "current" on kernel features :)
>>
>> > Summary
>> >
>> > Each 'host' (identified by a separate instance of the linux kernel) will
>> > have exactly one running daemon to manage control groups.  This daemon
>> > will answer cgroup management requests over a dbus socket, located at
>> > /sys/fs/cgroup/manager.  This socket can be bind-mounted into various
>> > containers, so that one daemon can support the whole system.
>> >
>> > Programs will be able to make cgroup requests using dbus calls, or
>> > indirectly by linking against lmctfy which will be modified to use the
>> > dbus calls if available.
>> >
>> > Outline:
>> >   . A single manager, cgmanager, is started on the host, very early
>> >     during boot.  It has very few dependencies, and requires only
>> >     /proc, /run, and /sys to be mounted, with /etc ro.  It will mount
>> >     the cgroup hierarchies in a private namespace and set defaults
>> >     (clone_children, use_hierarchy, sane_behavior, release_agent?) It
>> >     will open a socket at /sys/fs/cgroup/cgmanager (in a small tmpfs).
>>
>> Where does the config come from?  How do I specify which hierarchies I
>> want and where, and which flags?
>
> That'll have to be in a file in /etc (which can be mounted readonly).
> There should be no surprises there so I've not thought about the format.
>
>> >   . A client (requestor 'r') can make cgroup requests over
>> >     /sys/fs/cgroup/manager using dbus calls.  Detailed privilege
>> >     requirements for r are listed below.
>> >   . The client request will pertain an existing or new cgroup A.  r's
>> >     privilege over the cgroup must be checked.  r is said to have
>> >     privilege over A if A is owned by r's uid, or if A's owner is mapped
>> >     into r's user namespace, and r is root in that user namespace.
>>
>> Problem with this definition.  Being owned-by is not the same as
>> has-root-in.  Specifically, I may choose to give you root in your own
>> namespace, but you sure as heck can not increase your own memory
>> limit.
>
> 1. If you don't want me to change the value at all, then just don't map
> A's owner into the namespace.  I'm uid 100000 which is root in my namespace,
> but I only have privilege over other uids mapped into my namespace.

I think I understand this, but it is subtle.  Maybe some examples would help?

> 2. I've considered never allowing changes to your own cgroup.  So if you're
> in /a/b, you can create /a/b/c and modify c's settings, but you can't modify
> b's.  OTOH, that isn't strictly necessary - if we did allow it, then you
> could simply clam /a/b's memory to what you want, and stick me in /a/b/c,
> so I can't escape the memory limit you wanted.

This is different from what we do internally, but it's an interesting
semantic.  I'm wary of how much we want to make this API about
enforcement of policy vs simple enactment.  In other words, semantics
that diverge from UNIX ownership might be more complicated to
understand than they are worth.

> 3. I've not considered having the daemon track resource limits - i.e. creating
> a cgroup and saying "give it 100M swap, and if it asks, let it increase that
> to 200M."  I'd prefer that be done incidentally through (1) and (2).  Do you
> feel that would be insufficient?

I think this is a higher-level issue that should not be addressed here.

> Or maybe your question is something different and I'm missing it?

My point was that I, as machine admin, create a memory cgroup of 100
MB for you and put you in it.   I also give you root-in-namespace.
You must not be able to change 100 MB to 200 MB.  From your (1) you
are saying that system UID 0 owns the cgroup and is NOT mapped into
your namespace.  Therefore your definition holds.  I think I can buy
that.

>> >   . The client request may pertain a victim task v, which may be moved
>> >     to a new cgroup.  In that case r's privilege over both the cgroup
>> >     and v must be checked.  r is said to have privilege over v if v
>> >     is mapped in r's pid namespace, v's uid is mapped into r's user ns,
>> >     and r is root in its userns.  Or if r and v have the same uid
>> >     and v is mapped in r's pid namespace.
>> >   . r's credentials will be taken from socket's peercred, ensuring that
>> >     pid and uid are translated.
>> >   . r passes PID(v) as a SCM_CREDENTIAL, so that cgmanager receives the
>> >     translated global pid.  It will then read UID(v) from /proc/PID(v)/status,
>> >     which is the global uid, and check /proc/PID(r)/uid_map to see whether
>> >     UID is mapped there.
>> >   . dbus-send can be enhanced to send a pid as SCM_CREDENTIAL to have
>> >     the kernel translate it for the reader.  Only 'move task v to cgroup
>> >     A' will require a SCM_CREDENTIAL to be sent.
>> >
>> > Privilege requirements by action:
>> >     * Requestor of an action (r) over a socket may only make
>> >       changes to cgroups over which it has privilege.
>> >     * Requestors may be limited to a certain #/depth of cgroups
>> >       (to limit memory usage) - DEFER?
>> >     * Cgroup hierarchy is responsible for resource limits
>> >     * A requestor must either be uid 0 in its userns with victim mapped
>> >       ito its userns, or the same uid and in same/ancestor pidns as the
>> >       victim
>> >     * If r requests creation of cgroup '/x', /x will be interpreted
>> >       as relative to r's cgroup.  r cannot make changes to cgroups not
>> >       under its own current cgroup.
>>
>> Does this imply that r in a lower-level (farter from root) of the
>> hierarchy can not make requests of higher levels of the hierarchy
>> (closer to root), even though they have permissions as per the
>> definition of privilege?
>
> Right.

Is this really a required semantic?  We have use cases where
read-access is required to parent cgroups, which means this agent
could never handle reads.  It's not clear that we have use cases for
write-access to parents, though we have talked about eventfd - is that
read or write access?  Does this daemon want to handle event fd?

>> How do we reconcile this pseudo-virtualization with /proc/self/cgroup
>> which DOES expose raw paths?
>
> We <shrug> :)
>
> Just as /proc/cpuinfo isn't updated depending on your cpuset.  If you
> want to know the true depth, it's not my goal to fool you.

That's a fair answer.

>
>> >     * If r is not in the initial user_ns, then it may not change settings
>> >       in its own cgroup, only descendants.  (Not strictly necessary -
>> >       we could require the use of extra cgroups when wanted, as lxc does
>> >       currently)
>> >     * If r requests creation of cgroup '/x', it must have write access
>> >       to its own cgroup  (not strictly necessary)
>>
>> Can you explain what you mean by "not strictly necessary" - is this
>> part of the requirement space or not?
>
> Not sure why I put that there.  Let me state it more generally - if r wants
> to create /a/b/c (which is relative to his own current cgroup), then r
> must have write access under /a/b.  Whether he must have write access to his
> /, that I'm not sure about.

As above, I think following UNIX perms is the most sane thing we can
do.  I presume that everywhere you say "is owned by" and "has access
to" in this doc you mean strictly through UNIX perms?

>> >     * If r requests chown of cgroup /x to uid Y, Y is passed in a
>> >       ucred over the unix socket, and therefore translated to init
>> >       userns.
>>
>> I though only UID 0 could specify a UID other than the real UID?  Have
>> I misunderstood that?
>
> UID 0 in a child user ns should be able to pass in any uid in his own
> namespace.

And non-0 UIDs in any namespace should not be able to operate across
UIDs.  Got it.

>> >     * if r requests setting a limit under /x, then
>> >       . either r must be root in its own userns, and UID(/x) be mapped
>> >         into its userns, or else UID(r) == UID(/x)
>> >       . /x must not be / (not strictly necessary, all users know to
>> >         ensure an extra cgroup layer above '/')
>>
>> I don't understand this point
>
> The point is to ensure that the in-kernel cgroup hierarchy support enforces
> that r can't escape his limits.  So if I create a container and i want it
> to not have memory {limit: 500M}, then either I can create /a/b, put the
> memory limit on /a/b, and put r into /a/b/c;  or I can put r right into
> /a/b and not let r modify /a/b's settings.
>
>> >       . setns(UIDNS(r)) would not work, due to in-kernel capable() checks
>> >         which won't be satisfied.  Therefore we'll need to do privilege
>> >         checks ourselves, then perform the write as the host root user.
>> >         (see devices.allow/deny).  Further we need to support older kernels
>> >         which don't support setns for pid.
>> >     * If r requests action on victim V, it passes V's pid in a ucred,
>> >       so that gets translated.
>> >       Daemon will verify that V's uid is mapped into r's userns.  Since
>> >       r is either root or the same uid as V, it is allowed to classify.
>> >
>> > The above addresses
>> >     * creating cgroups
>> >     * chowning cgroups
>> >     * setting cgroup limits
>> >     * moving tasks into cgroups
>> >   . but does not address a 'cgexec <group> -- command' type of behavior.
>> >     * To handle that (specifically for upstart), recommend that r do:
>> >       if (!pid) {
>> >         request_reclassify(cgroup, getpid());
>> >         do_execve();
>> >       }
>>
>> If I follow, you're saying that the caller does the fork/exec and all
>> this daemon does is munge cgroups for the calling PID?  If so, I
>> agree, I think.
>
> Right.  (Difference with the unfortunately libcgroup race conditions
> being that in this case we have the caller's cooperation :)
>
>> >   . alternatively, the daemon could, if kernel is new enough, setns to
>> >     the requestor's namespaces to execute a command in a new cgroup.
>> >     The new command would be daemonized to that pid namespaces' pid 1.
>> >
>> > Types of requests:
>> >   * r requests creating cgroup A'/A
>> >     . lmctfy/cli/commands/create.cc
>> >     . Verify that UID(r) mapped to 0 in r's userns
>> >     . R=cgroup_of(r)
>> >     . Verify that UID(R) is mapped into r's userns
>> >     . Create R/A'/A
>> >     . chown R/A'/A to UID(r)
>> >   * r requests to move task x to cgroup A.
>> >     . lmctfy/cli/commands/enter.cc
>> >     . r must send PID(x) as ancillary message
>> >     . Verify that UID(r) mapped to 0 in r's userns, and UID(x) is mapped into
>> >       that userns
>> >       (is it safe to allow if UID(x) == UID(r))?
>> >     . R=cgroup_of(r)
>> >     . Verify that R/A is owned by UID(r) or UID(x)?  (not sure that's needed)
>> >     . echo PID(x) >> /R/A/tasks
>> >   * r requests chown of cgroup A to uid X
>> >     . X is passed in ancillary message
>> >       * ensures it is valid in r's userns
>> >       * maps the userid to host for us
>> >     . Verify that UID(r) mapped to 0 in r's userns
>> >     . R=cgroup_of(r)
>> >     . Chown R/A to X
>> >   * r requests cgroup A's 'property=value'
>> >     . Verify that either
>> >       * A != ''
>> >       * UID(r) == 0 on host
>> >       In other words, r in a userns may not set root cgroup settings.
>> >     . Verify that UID(r) mapped to 0 in r's userns
>> >     . R=cgroup_of(r)
>> >     . Set property=value for R/A
>> >       * Expect kernel to guarantee hierarchical constraints
>> >   * r requests deletion of cgroup A
>> >     . lmctfy/cli/commands/destroy.cc (without -f)
>> >     . same requirements as setting 'property=value'
>> >   * r requests purge of cgroup A
>> >     . lmctfy/cli/commands/destroy.cc (with -f)
>> >     . same requirements as setting 'property=value'
>> >
>> > Long-term we will want the cgroup manager to become more intelligent -
>> > to place its own limits on clients, to address cpu and device hotplug,
>> > etc.  Since we will not be doing that in the first prototype, the daemon
>> > will not keep any state about the clients.
>> >
>> > Client DBus Message API
>> >
>> > <name>: a-zA-Z0-9
>> > <name>: "a-zA-Z0-9 "
>> > <controllerlist>: <controller1>[:controllerlist]
>> > <valueentry>: key:value
>> > <valueentry>: frozen
>> > <valueentry>: thawed
>> > <values>: valueentry[:values]
>> > keys:
>> >         {memory,swap}.{limit,soft_limit}
>> >         cpus_allowed  # set of allowed cpus
>> >         cpus_fraction # % of allowed cpus
>> >         cpus_number   # number of allowed cpus
>> >         cpu_share_percent   # percent of cpushare
>> >         devices_whitelist
>> >         devices_blacklist
>> >         net_prio_index
>> >         net_prio_interface_map
>> >         net_classid
>> >         hugetlb_limit
>> >         blkio_weight
>> >         blkio_weight_device
>> >         blkio_throttle_{read,write}
>> > readkeys:
>> >         devices_list
>> >         {memory,swap}.{failcnt,max_use,limitnuma_stat}
>> >         hugetlb_max_usage
>> >         hugetlb_usage
>> >         hugetlb_failcnt
>> >         cpuacct_stat
>> >         <etc>
>> > Commands:
>> >         ListControllers
>> >         Create <name> <controllerlist> <values>
>> >         Setvalue <name> <values>
>> >         Getvalue <name> <readkeys>
>> >         ListChildren <name>
>> >         ListTasks <name>
>> >         ListControllers <name>
>> >         Chown <name> <uid>
>> >         Chown <name> <uid>:<gid>
>> >         Move <pid> <name>  [[ pid is sent as a SCM_CREDENTIAL ]]
>> >         Delete <name>
>> >         Delete-force <name>
>> >         Kill <name>
>
> Will address the rest tomorrow.  Thanks for reviewing!
>
>> What are the requirements/goals around performance and concurrency?
>> Do you expect this to be a single-threaded thing, or can we handle
>> some number of concurrent operations?  Do you expect to use threads of
>> processes?
>>
>> Can you talk about logging - what and where?
>>
>> How will we handle event_fd?  Pass a file-descriptor back to the caller?
>>
>> That's all I can come up with for now.
