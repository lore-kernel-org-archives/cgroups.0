From: "Michael H. Warfield" <mhw-BetbSzk+GohWk0Htik3J/w@public.gmane.org>
Subject: Re: cgroup management daemon
Date: Mon, 25 Nov 2013 21:18:04 -0500
Message-ID: <1385432284.8590.52.camel@mtking.wittsend.com>
References: <20131125224335.GA15481@mail.hallyn.com>
Reply-To: mhw-BetbSzk+GohWk0Htik3J/w@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6567382869513492212=="
Return-path: <lxc-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20131125224335.GA15481-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/lxc-devel>,
	<mailto:lxc-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=lxc-devel>
List-Post: <mailto:lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:lxc-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/lxc-devel>,
	<mailto:lxc-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: lxc-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: =?ISO-8859-1?Q?St=E9phane?= Graber <stgraber-/Ni+VN9Krahg9hUCZPvPmw@public.gmane.org>, mhw-BetbSzk+GohWk0Htik3J/w@public.gmane.org, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--===============6567382869513492212==
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-xS3U/j5WgVplxl3XAh9F"


--=-xS3U/j5WgVplxl3XAh9F
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Serge...

You have no idea how much I dread mentioning this (well, after
LinuxPlumbers, maybe you can) but...  You do realize that some of this
is EXACTLY what the systemd crowd was talking about there in NOLA back
then.  I sat in those session grinding my teeth and listening to
comments from some others around me about when systemd might subsume
bash or even vi or quake.

Somehow, you and others have tagged me as a "systemd expert" but I am
far from it and even you noted that Lennart and I were on the edge of a
physical discussion when I made some "off the cuff" remarks there about
systemd design during my talk.  I personally rank systemd in the same
category as NetworkMangler (err, NetworkManager) in its propensity for
committing inexplicable random acts of terrorism and changing its
behavior from release to release to release.  I'm not a fan and I'm not
an expert, but I have to be involved with it and watch the damned thing
like a trapped rat, like it or not.

Like it or not, we can not go off on divergent designs.  As much as they
have delusions of taking over the Linux world, they are still going to
be a major factor and this sort of thing needs to be coordinated.  We
are going to need exactly what you are proposing whether we have systemd
in play or not.  IF we CAN kick it to the curb, when we need to, we
still need to know how to without tearing shit up and breaking shit that
thinks it's there.  Ideally, it shouldn't matter if systemd where in
play or not.

All I ask is that we not get too far off track that we have a major
architectural divergence here.  The risk is there.

Mike


On Mon, 2013-11-25 at 22:43 +0000, Serge E. Hallyn wrote:=20
> Hi,
>=20
> as i've mentioned several times, I want to write a standalone cgroup
> management daemon.  Basic requirements are that it be a standalone
> program; that a single instance running on the host be usable from
> containers nested at any depth; that it not allow escaping ones
> assigned limits; that it not allow subjegating tasks which do not
> belong to you; and that, within your limits, you be able to parcel
> those limits to your tasks as you like. =20
>=20
> Additionally, Tejun has specified that we do not want users to be
> too closely tied to the cgroupfs implementation.  Therefore
> commands will be just a hair more general than specifying cgroupfs
> filenames and values.  I may go so far as to avoid specifying
> specific controllers, as AFAIK there should be no redundancy in
> features.  On the other hand, I don't want to get too general.
> So I'm basing the API loosely on the lmctfy command line API.
>=20
> One of the driving goals is to enable nested lxc as simply and safely as
> possible.  If this project is a success, then a large chunk of code can
> be removed from lxc.  I'm considering this project a part of the larger
> lxc project, but given how central it is to systems management that
> doesn't mean that I'll consider anyone else's needs as less important
> than our own.
>=20
> This document consists of two parts.  The first describes how I
> intend the daemon (cgmanager) to be structured and how it will
> enforce the safety requirements.  The second describes the commands=20
> which clients will be able to send to the manager.  The list of
> controller keys which can be set is very incomplete at this point,
> serving mainly to show the approach I was thinking of taking.
>=20
> Summary
>=20
> Each 'host' (identified by a separate instance of the linux kernel) will
> have exactly one running daemon to manage control groups.  This daemon
> will answer cgroup management requests over a dbus socket, located at
> /sys/fs/cgroup/manager.  This socket can be bind-mounted into various
> containers, so that one daemon can support the whole system.
>=20
> Programs will be able to make cgroup requests using dbus calls, or
> indirectly by linking against lmctfy which will be modified to use the
> dbus calls if available.
>=20
> Outline:
>   . A single manager, cgmanager, is started on the host, very early
>     during boot.  It has very few dependencies, and requires only
>     /proc, /run, and /sys to be mounted, with /etc ro.  It will mount
>     the cgroup hierarchies in a private namespace and set defaults
>     (clone_children, use_hierarchy, sane_behavior, release_agent?) It
>     will open a socket at /sys/fs/cgroup/cgmanager (in a small tmpfs).
>   . A client (requestor 'r') can make cgroup requests over
>     /sys/fs/cgroup/manager using dbus calls.  Detailed privilege
>     requirements for r are listed below.
>   . The client request will pertain an existing or new cgroup A.  r's
>     privilege over the cgroup must be checked.  r is said to have
>     privilege over A if A is owned by r's uid, or if A's owner is mapped
>     into r's user namespace, and r is root in that user namespace.
>   . The client request may pertain a victim task v, which may be moved
>     to a new cgroup.  In that case r's privilege over both the cgroup
>     and v must be checked.  r is said to have privilege over v if v
>     is mapped in r's pid namespace, v's uid is mapped into r's user ns,
>     and r is root in its userns.  Or if r and v have the same uid
>     and v is mapped in r's pid namespace.
>   . r's credentials will be taken from socket's peercred, ensuring that
>     pid and uid are translated.
>   . r passes PID(v) as a SCM_CREDENTIAL, so that cgmanager receives the
>     translated global pid.  It will then read UID(v) from /proc/PID(v)/st=
atus,
>     which is the global uid, and check /proc/PID(r)/uid_map to see whethe=
r
>     UID is mapped there.
>   . dbus-send can be enhanced to send a pid as SCM_CREDENTIAL to have
>     the kernel translate it for the reader.  Only 'move task v to cgroup
>     A' will require a SCM_CREDENTIAL to be sent.
>=20
> Privilege requirements by action:
>     * Requestor of an action (r) over a socket may only make
>       changes to cgroups over which it has privilege.
>     * Requestors may be limited to a certain #/depth of cgroups
>       (to limit memory usage) - DEFER?
>     * Cgroup hierarchy is responsible for resource limits
>     * A requestor must either be uid 0 in its userns with victim mapped
>       ito its userns, or the same uid and in same/ancestor pidns as the
>       victim
>     * If r requests creation of cgroup '/x', /x will be interpreted
>       as relative to r's cgroup.  r cannot make changes to cgroups not
>       under its own current cgroup.
>     * If r is not in the initial user_ns, then it may not change settings
>       in its own cgroup, only descendants.  (Not strictly necessary -
>       we could require the use of extra cgroups when wanted, as lxc does
>       currently)
>     * If r requests creation of cgroup '/x', it must have write access
>       to its own cgroup  (not strictly necessary)
>     * If r requests chown of cgroup /x to uid Y, Y is passed in a
>       ucred over the unix socket, and therefore translated to init
>       userns.
>     * if r requests setting a limit under /x, then
>       . either r must be root in its own userns, and UID(/x) be mapped
>         into its userns, or else UID(r) =3D=3D UID(/x)
>       . /x must not be / (not strictly necessary, all users know to
>         ensure an extra cgroup layer above '/')
>       . setns(UIDNS(r)) would not work, due to in-kernel capable() checks
>         which won't be satisfied.  Therefore we'll need to do privilege
>         checks ourselves, then perform the write as the host root user.
>         (see devices.allow/deny).  Further we need to support older kerne=
ls
>         which don't support setns for pid.
>     * If r requests action on victim V, it passes V's pid in a ucred,
>       so that gets translated.
>       Daemon will verify that V's uid is mapped into r's userns.  Since
>       r is either root or the same uid as V, it is allowed to classify.
>=20
> The above addresses
>     * creating cgroups
>     * chowning cgroups
>     * setting cgroup limits
>     * moving tasks into cgroups
>   . but does not address a 'cgexec <group> -- command' type of behavior.
>     * To handle that (specifically for upstart), recommend that r do:
>       if (!pid) {
>         request_reclassify(cgroup, getpid());
>         do_execve();
>       }
>   . alternatively, the daemon could, if kernel is new enough, setns to
>     the requestor's namespaces to execute a command in a new cgroup.
>     The new command would be daemonized to that pid namespaces' pid 1.
>=20
> Types of requests:
>   * r requests creating cgroup A'/A
>     . lmctfy/cli/commands/create.cc
>     . Verify that UID(r) mapped to 0 in r's userns
>     . R=3Dcgroup_of(r)
>     . Verify that UID(R) is mapped into r's userns
>     . Create R/A'/A
>     . chown R/A'/A to UID(r)
>   * r requests to move task x to cgroup A.
>     . lmctfy/cli/commands/enter.cc
>     . r must send PID(x) as ancillary message
>     . Verify that UID(r) mapped to 0 in r's userns, and UID(x) is mapped =
into
>       that userns
>       (is it safe to allow if UID(x) =3D=3D UID(r))?
>     . R=3Dcgroup_of(r)
>     . Verify that R/A is owned by UID(r) or UID(x)?  (not sure that's nee=
ded)
>     . echo PID(x) >> /R/A/tasks
>   * r requests chown of cgroup A to uid X
>     . X is passed in ancillary message
>       * ensures it is valid in r's userns
>       * maps the userid to host for us
>     . Verify that UID(r) mapped to 0 in r's userns
>     . R=3Dcgroup_of(r)
>     . Chown R/A to X
>   * r requests cgroup A's 'property=3Dvalue'
>     . Verify that either
>       * A !=3D ''
>       * UID(r) =3D=3D 0 on host
>       In other words, r in a userns may not set root cgroup settings.
>     . Verify that UID(r) mapped to 0 in r's userns
>     . R=3Dcgroup_of(r)
>     . Set property=3Dvalue for R/A
>       * Expect kernel to guarantee hierarchical constraints
>   * r requests deletion of cgroup A
>     . lmctfy/cli/commands/destroy.cc (without -f)
>     . same requirements as setting 'property=3Dvalue'
>   * r requests purge of cgroup A
>     . lmctfy/cli/commands/destroy.cc (with -f)
>     . same requirements as setting 'property=3Dvalue'
>=20
> Long-term we will want the cgroup manager to become more intelligent -
> to place its own limits on clients, to address cpu and device hotplug,
> etc.  Since we will not be doing that in the first prototype, the daemon
> will not keep any state about the clients.
>=20
> Client DBus Message API
>=20
> <name>: a-zA-Z0-9
> <name>: "a-zA-Z0-9 "
> <controllerlist>: <controller1>[:controllerlist]
> <valueentry>: key:value
> <valueentry>: frozen
> <valueentry>: thawed
> <values>: valueentry[:values]
> keys:
> 	{memory,swap}.{limit,soft_limit}
> 	cpus_allowed  # set of allowed cpus
> 	cpus_fraction # % of allowed cpus
> 	cpus_number   # number of allowed cpus
> 	cpu_share_percent   # percent of cpushare
> 	devices_whitelist
> 	devices_blacklist
> 	net_prio_index
> 	net_prio_interface_map
> 	net_classid
> 	hugetlb_limit
> 	blkio_weight
> 	blkio_weight_device
> 	blkio_throttle_{read,write}
> readkeys:
> 	devices_list
> 	{memory,swap}.{failcnt,max_use,limitnuma_stat}
> 	hugetlb_max_usage
> 	hugetlb_usage
> 	hugetlb_failcnt
> 	cpuacct_stat
> 	<etc>
> Commands:
> 	ListControllers
> 	Create <name> <controllerlist> <values>
> 	Setvalue <name> <values>
> 	Getvalue <name> <readkeys>
> 	ListChildren <name>
> 	ListTasks <name>
> 	ListControllers <name>
> 	Chown <name> <uid>
> 	Chown <name> <uid>:<gid>
> 	Move <pid> <name>  [[ pid is sent as a SCM_CREDENTIAL ]]
> 	Delete <name>
> 	Delete-force <name>
> 	Kill <name>
>=20
> -------------------------------------------------------------------------=
-----
> Shape the Mobile Experience: Free Subscription
> Software experts and developers: Be at the forefront of tech innovation.
> Intel(R) Software Adrenaline delivers strategic insight and game-changing=
=20
> conversations that shape the rapidly evolving mobile landscape. Sign up n=
ow.=20
> http://pubads.g.doubleclick.net/gampad/clk?id=3D63431311&iu=3D/4140/ostg.=
clktrk
> _______________________________________________
> Lxc-devel mailing list
> Lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/lxc-devel
>=20

--=20
Michael H. Warfield (AI4NB) | (770) 978-7061 |  mhw-BetbSzk+GohWk0Htik3J/w@public.gmane.org
   /\/\|=3Dmhw=3D|\/\/          | (678) 463-0932 |  http://www.wittsend.com=
/mhw/
   NIC whois: MHW9          | An optimist believes we live in the best of a=
ll
 PGP Key: 0x674627FF        | possible worlds.  A pessimist is sure of it!


--=-xS3U/j5WgVplxl3XAh9F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQEVAwUAUpQE3MDrlnVnRif/AQi4QAf9HCSRU02TAGYRnQN9JATKCJSH9q2f7pvh
uLvwrkgK1QaaUL5+0pjEw00CC3KMeyK9FnEdyayCnnifJj1ynri2Qh/Z6YSwXShm
SGsv0TUbQZeTMSBHH7Qs+ifED2tIqwCU0vqqLHYhapTZgW1RBbJH6uD03kP2PHsN
NBUKiKKCopsyGbb2M0VVSocZTpMYnfT0/lFBq19uh7ULWHdrbYBB8JtZHWLezxlL
ymw2Oy1Qh9tJQ46S4b+QZdIB1OwMhIZzslB6SQn98MaTHC0LS7SajhiQ75ZvlsSL
2hYDSLI2zAgq9FpNcDANDwO5Vj6xc3ktGYRjPZbJWxkkRLzavaBy6A==
=ZdLy
-----END PGP SIGNATURE-----

--=-xS3U/j5WgVplxl3XAh9F--



--===============6567382869513492212==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Shape the Mobile Experience: Free Subscription
Software experts and developers: Be at the forefront of tech innovation.
Intel(R) Software Adrenaline delivers strategic insight and game-changing 
conversations that shape the rapidly evolving mobile landscape. Sign up now. 
http://pubads.g.doubleclick.net/gampad/clk?id=63431311&iu=/4140/ostg.clktrk
--===============6567382869513492212==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Lxc-devel mailing list
Lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/lxc-devel

--===============6567382869513492212==--


