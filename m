From: Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [lxc-devel] cgroup management daemon
Date: Mon, 25 Nov 2013 20:52:59 -0800
Message-ID: <CAO_RewYmS0fH819BFCr9ozis1132dACgCPwbyb59gM1PafpUkw@mail.gmail.com>
References: <20131125224335.GA15481@mail.hallyn.com> <1385432284.8590.52.camel@mtking.wittsend.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=rsa6Flf2Sx/5vHyVdscu66SvkEc0gBMHj54k3wM4WEc=;
        b=XisIECy1LshqHjWkMWhHpL/gPW6DqyLenEtV+I+IX1H7PdqoJMV4TIZt9vUEOLocEP
         78ish2KR3qV51qIysL6WSJLryK7sH4lvMycnO96HcjeMgkqMwLBFSm7ZsFeYl/g1bugv
         hN2UBLpTYxQF4rqoKSw9GFgg4l05T2JT8rHvl9NmH3HqvkjLjfnENy94/p5sNQBF1iSn
         nx7vrZKuvRdVxLLVXDTrujvjknljR2WWDv3xWpRUNSu9uMpKDQBjDhL/eH97RNKEGJCv
         lr5Wqaew+nk6Ofy623dWiFxiw5KWSr6ys2kfMyyMfN0NGkBFDsAPeJHtAKQOn1erfLCd
         48+Q==
In-Reply-To: <1385432284.8590.52.camel-s3/A7Nnwjkf10ug9Blv0m0EOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mhw-UGBql2FAF+1Wk0Htik3J/w@public.gmane.org
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?ISO-8859-1?Q?St=E9phane_Graber?= <stgraber-/Ni+VN9Krahg9hUCZPvPmw@public.gmane.org>

At the start of this discussion, some months ago, we offered to
co-devel this with Lennart et al.  They did not seem keen on the idea.

If they have an established DBUS protocol spec, we should consider
adopting it instead of a new one, but we CAN'T just play follow the
leader and do whatever they do, change whenever they feel like
changing.

It would be best if we could get a common DBUS api specc'ed and all
agree to it.  Serge, do you feel up to that?

On Mon, Nov 25, 2013 at 6:18 PM, Michael H. Warfield <mhw-UGBql2FAF+1Wk0Htik3J/w@public.gmane.org> wrote:
> Serge...
>
> You have no idea how much I dread mentioning this (well, after
> LinuxPlumbers, maybe you can) but...  You do realize that some of this
> is EXACTLY what the systemd crowd was talking about there in NOLA back
> then.  I sat in those session grinding my teeth and listening to
> comments from some others around me about when systemd might subsume
> bash or even vi or quake.
>
> Somehow, you and others have tagged me as a "systemd expert" but I am
> far from it and even you noted that Lennart and I were on the edge of a
> physical discussion when I made some "off the cuff" remarks there about
> systemd design during my talk.  I personally rank systemd in the same
> category as NetworkMangler (err, NetworkManager) in its propensity for
> committing inexplicable random acts of terrorism and changing its
> behavior from release to release to release.  I'm not a fan and I'm not
> an expert, but I have to be involved with it and watch the damned thing
> like a trapped rat, like it or not.
>
> Like it or not, we can not go off on divergent designs.  As much as they
> have delusions of taking over the Linux world, they are still going to
> be a major factor and this sort of thing needs to be coordinated.  We
> are going to need exactly what you are proposing whether we have systemd
> in play or not.  IF we CAN kick it to the curb, when we need to, we
> still need to know how to without tearing shit up and breaking shit that
> thinks it's there.  Ideally, it shouldn't matter if systemd where in
> play or not.
>
> All I ask is that we not get too far off track that we have a major
> architectural divergence here.  The risk is there.
>
> Mike
>
>
> On Mon, 2013-11-25 at 22:43 +0000, Serge E. Hallyn wrote:
>> Hi,
>>
>> as i've mentioned several times, I want to write a standalone cgroup
>> management daemon.  Basic requirements are that it be a standalone
>> program; that a single instance running on the host be usable from
>> containers nested at any depth; that it not allow escaping ones
>> assigned limits; that it not allow subjegating tasks which do not
>> belong to you; and that, within your limits, you be able to parcel
>> those limits to your tasks as you like.
>>
>> Additionally, Tejun has specified that we do not want users to be
>> too closely tied to the cgroupfs implementation.  Therefore
>> commands will be just a hair more general than specifying cgroupfs
>> filenames and values.  I may go so far as to avoid specifying
>> specific controllers, as AFAIK there should be no redundancy in
>> features.  On the other hand, I don't want to get too general.
>> So I'm basing the API loosely on the lmctfy command line API.
>>
>> One of the driving goals is to enable nested lxc as simply and safely as
>> possible.  If this project is a success, then a large chunk of code can
>> be removed from lxc.  I'm considering this project a part of the larger
>> lxc project, but given how central it is to systems management that
>> doesn't mean that I'll consider anyone else's needs as less important
>> than our own.
>>
>> This document consists of two parts.  The first describes how I
>> intend the daemon (cgmanager) to be structured and how it will
>> enforce the safety requirements.  The second describes the commands
>> which clients will be able to send to the manager.  The list of
>> controller keys which can be set is very incomplete at this point,
>> serving mainly to show the approach I was thinking of taking.
>>
>> Summary
>>
>> Each 'host' (identified by a separate instance of the linux kernel) will
>> have exactly one running daemon to manage control groups.  This daemon
>> will answer cgroup management requests over a dbus socket, located at
>> /sys/fs/cgroup/manager.  This socket can be bind-mounted into various
>> containers, so that one daemon can support the whole system.
>>
>> Programs will be able to make cgroup requests using dbus calls, or
>> indirectly by linking against lmctfy which will be modified to use the
>> dbus calls if available.
>>
>> Outline:
>>   . A single manager, cgmanager, is started on the host, very early
>>     during boot.  It has very few dependencies, and requires only
>>     /proc, /run, and /sys to be mounted, with /etc ro.  It will mount
>>     the cgroup hierarchies in a private namespace and set defaults
>>     (clone_children, use_hierarchy, sane_behavior, release_agent?) It
>>     will open a socket at /sys/fs/cgroup/cgmanager (in a small tmpfs).
>>   . A client (requestor 'r') can make cgroup requests over
>>     /sys/fs/cgroup/manager using dbus calls.  Detailed privilege
>>     requirements for r are listed below.
>>   . The client request will pertain an existing or new cgroup A.  r's
>>     privilege over the cgroup must be checked.  r is said to have
>>     privilege over A if A is owned by r's uid, or if A's owner is mapped
>>     into r's user namespace, and r is root in that user namespace.
>>   . The client request may pertain a victim task v, which may be moved
>>     to a new cgroup.  In that case r's privilege over both the cgroup
>>     and v must be checked.  r is said to have privilege over v if v
>>     is mapped in r's pid namespace, v's uid is mapped into r's user ns,
>>     and r is root in its userns.  Or if r and v have the same uid
>>     and v is mapped in r's pid namespace.
>>   . r's credentials will be taken from socket's peercred, ensuring that
>>     pid and uid are translated.
>>   . r passes PID(v) as a SCM_CREDENTIAL, so that cgmanager receives the
>>     translated global pid.  It will then read UID(v) from /proc/PID(v)/status,
>>     which is the global uid, and check /proc/PID(r)/uid_map to see whether
>>     UID is mapped there.
>>   . dbus-send can be enhanced to send a pid as SCM_CREDENTIAL to have
>>     the kernel translate it for the reader.  Only 'move task v to cgroup
>>     A' will require a SCM_CREDENTIAL to be sent.
>>
>> Privilege requirements by action:
>>     * Requestor of an action (r) over a socket may only make
>>       changes to cgroups over which it has privilege.
>>     * Requestors may be limited to a certain #/depth of cgroups
>>       (to limit memory usage) - DEFER?
>>     * Cgroup hierarchy is responsible for resource limits
>>     * A requestor must either be uid 0 in its userns with victim mapped
>>       ito its userns, or the same uid and in same/ancestor pidns as the
>>       victim
>>     * If r requests creation of cgroup '/x', /x will be interpreted
>>       as relative to r's cgroup.  r cannot make changes to cgroups not
>>       under its own current cgroup.
>>     * If r is not in the initial user_ns, then it may not change settings
>>       in its own cgroup, only descendants.  (Not strictly necessary -
>>       we could require the use of extra cgroups when wanted, as lxc does
>>       currently)
>>     * If r requests creation of cgroup '/x', it must have write access
>>       to its own cgroup  (not strictly necessary)
>>     * If r requests chown of cgroup /x to uid Y, Y is passed in a
>>       ucred over the unix socket, and therefore translated to init
>>       userns.
>>     * if r requests setting a limit under /x, then
>>       . either r must be root in its own userns, and UID(/x) be mapped
>>         into its userns, or else UID(r) == UID(/x)
>>       . /x must not be / (not strictly necessary, all users know to
>>         ensure an extra cgroup layer above '/')
>>       . setns(UIDNS(r)) would not work, due to in-kernel capable() checks
>>         which won't be satisfied.  Therefore we'll need to do privilege
>>         checks ourselves, then perform the write as the host root user.
>>         (see devices.allow/deny).  Further we need to support older kernels
>>         which don't support setns for pid.
>>     * If r requests action on victim V, it passes V's pid in a ucred,
>>       so that gets translated.
>>       Daemon will verify that V's uid is mapped into r's userns.  Since
>>       r is either root or the same uid as V, it is allowed to classify.
>>
>> The above addresses
>>     * creating cgroups
>>     * chowning cgroups
>>     * setting cgroup limits
>>     * moving tasks into cgroups
>>   . but does not address a 'cgexec <group> -- command' type of behavior.
>>     * To handle that (specifically for upstart), recommend that r do:
>>       if (!pid) {
>>         request_reclassify(cgroup, getpid());
>>         do_execve();
>>       }
>>   . alternatively, the daemon could, if kernel is new enough, setns to
>>     the requestor's namespaces to execute a command in a new cgroup.
>>     The new command would be daemonized to that pid namespaces' pid 1.
>>
>> Types of requests:
>>   * r requests creating cgroup A'/A
>>     . lmctfy/cli/commands/create.cc
>>     . Verify that UID(r) mapped to 0 in r's userns
>>     . R=cgroup_of(r)
>>     . Verify that UID(R) is mapped into r's userns
>>     . Create R/A'/A
>>     . chown R/A'/A to UID(r)
>>   * r requests to move task x to cgroup A.
>>     . lmctfy/cli/commands/enter.cc
>>     . r must send PID(x) as ancillary message
>>     . Verify that UID(r) mapped to 0 in r's userns, and UID(x) is mapped into
>>       that userns
>>       (is it safe to allow if UID(x) == UID(r))?
>>     . R=cgroup_of(r)
>>     . Verify that R/A is owned by UID(r) or UID(x)?  (not sure that's needed)
>>     . echo PID(x) >> /R/A/tasks
>>   * r requests chown of cgroup A to uid X
>>     . X is passed in ancillary message
>>       * ensures it is valid in r's userns
>>       * maps the userid to host for us
>>     . Verify that UID(r) mapped to 0 in r's userns
>>     . R=cgroup_of(r)
>>     . Chown R/A to X
>>   * r requests cgroup A's 'property=value'
>>     . Verify that either
>>       * A != ''
>>       * UID(r) == 0 on host
>>       In other words, r in a userns may not set root cgroup settings.
>>     . Verify that UID(r) mapped to 0 in r's userns
>>     . R=cgroup_of(r)
>>     . Set property=value for R/A
>>       * Expect kernel to guarantee hierarchical constraints
>>   * r requests deletion of cgroup A
>>     . lmctfy/cli/commands/destroy.cc (without -f)
>>     . same requirements as setting 'property=value'
>>   * r requests purge of cgroup A
>>     . lmctfy/cli/commands/destroy.cc (with -f)
>>     . same requirements as setting 'property=value'
>>
>> Long-term we will want the cgroup manager to become more intelligent -
>> to place its own limits on clients, to address cpu and device hotplug,
>> etc.  Since we will not be doing that in the first prototype, the daemon
>> will not keep any state about the clients.
>>
>> Client DBus Message API
>>
>> <name>: a-zA-Z0-9
>> <name>: "a-zA-Z0-9 "
>> <controllerlist>: <controller1>[:controllerlist]
>> <valueentry>: key:value
>> <valueentry>: frozen
>> <valueentry>: thawed
>> <values>: valueentry[:values]
>> keys:
>>       {memory,swap}.{limit,soft_limit}
>>       cpus_allowed  # set of allowed cpus
>>       cpus_fraction # % of allowed cpus
>>       cpus_number   # number of allowed cpus
>>       cpu_share_percent   # percent of cpushare
>>       devices_whitelist
>>       devices_blacklist
>>       net_prio_index
>>       net_prio_interface_map
>>       net_classid
>>       hugetlb_limit
>>       blkio_weight
>>       blkio_weight_device
>>       blkio_throttle_{read,write}
>> readkeys:
>>       devices_list
>>       {memory,swap}.{failcnt,max_use,limitnuma_stat}
>>       hugetlb_max_usage
>>       hugetlb_usage
>>       hugetlb_failcnt
>>       cpuacct_stat
>>       <etc>
>> Commands:
>>       ListControllers
>>       Create <name> <controllerlist> <values>
>>       Setvalue <name> <values>
>>       Getvalue <name> <readkeys>
>>       ListChildren <name>
>>       ListTasks <name>
>>       ListControllers <name>
>>       Chown <name> <uid>
>>       Chown <name> <uid>:<gid>
>>       Move <pid> <name>  [[ pid is sent as a SCM_CREDENTIAL ]]
>>       Delete <name>
>>       Delete-force <name>
>>       Kill <name>
>>
>> ------------------------------------------------------------------------------
>> Shape the Mobile Experience: Free Subscription
>> Software experts and developers: Be at the forefront of tech innovation.
>> Intel(R) Software Adrenaline delivers strategic insight and game-changing
>> conversations that shape the rapidly evolving mobile landscape. Sign up now.
>> http://pubads.g.doubleclick.net/gampad/clk?id=63431311&iu=/4140/ostg.clktrk
>> _______________________________________________
>> Lxc-devel mailing list
>> Lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
>> https://lists.sourceforge.net/lists/listinfo/lxc-devel
>>
>
> --
> Michael H. Warfield (AI4NB) | (770) 978-7061 |  mhw-BetbSzk+GohWk0Htik3J/w@public.gmane.org
>    /\/\|=mhw=|\/\/          | (678) 463-0932 |  http://www.wittsend.com/mhw/
>    NIC whois: MHW9          | An optimist believes we live in the best of all
>  PGP Key: 0x674627FF        | possible worlds.  A pessimist is sure of it!
>
