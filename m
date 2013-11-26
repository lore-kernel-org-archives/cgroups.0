From: =?iso-8859-1?Q?St=E9phane?= Graber <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup management daemon
Date: Mon, 25 Nov 2013 19:11:39 -0500
Message-ID: <20131126001139.GL26027@castiana>
References: <20131125224335.GA15481@mail.hallyn.com> <5293E544.10805@yuhu.biz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6014427733398399076=="
Return-path: <lxc-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <5293E544.10805-NV7Lj0SOnH0@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/lxc-devel>,
	<mailto:lxc-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=lxc-devel>
List-Post: <mailto:lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:lxc-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/lxc-devel>,
	<mailto:lxc-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: lxc-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Marian Marinov <mm-NV7Lj0SOnH0@public.gmane.org>
Cc: Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>


--===============6014427733398399076==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0qVF/w3MHQqLSynd"
Content-Disposition: inline


--0qVF/w3MHQqLSynd
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 26, 2013 at 02:03:16AM +0200, Marian Marinov wrote:
> On 11/26/2013 12:43 AM, Serge E. Hallyn wrote:
> > Hi,
> >
> > as i've mentioned several times, I want to write a standalone cgroup
> > management daemon.  Basic requirements are that it be a standalone
> > program; that a single instance running on the host be usable from
> > containers nested at any depth; that it not allow escaping ones
> > assigned limits; that it not allow subjegating tasks which do not
> > belong to you; and that, within your limits, you be able to parcel
> > those limits to your tasks as you like.
> >
> > Additionally, Tejun has specified that we do not want users to be
> > too closely tied to the cgroupfs implementation.  Therefore
> > commands will be just a hair more general than specifying cgroupfs
> > filenames and values.  I may go so far as to avoid specifying
> > specific controllers, as AFAIK there should be no redundancy in
> > features.  On the other hand, I don't want to get too general.
> > So I'm basing the API loosely on the lmctfy command line API.
> >
> > One of the driving goals is to enable nested lxc as simply and safely as
> > possible.  If this project is a success, then a large chunk of code can
> > be removed from lxc.  I'm considering this project a part of the larger
> > lxc project, but given how central it is to systems management that
> > doesn't mean that I'll consider anyone else's needs as less important
> > than our own.
> >
> > This document consists of two parts.  The first describes how I
> > intend the daemon (cgmanager) to be structured and how it will
> > enforce the safety requirements.  The second describes the commands
> > which clients will be able to send to the manager.  The list of
> > controller keys which can be set is very incomplete at this point,
> > serving mainly to show the approach I was thinking of taking.
> >
> > Summary
> >
> > Each 'host' (identified by a separate instance of the linux kernel) will
> > have exactly one running daemon to manage control groups.  This daemon
> > will answer cgroup management requests over a dbus socket, located at
> > /sys/fs/cgroup/manager.  This socket can be bind-mounted into various
> > containers, so that one daemon can support the whole system.
> >
> > Programs will be able to make cgroup requests using dbus calls, or
> > indirectly by linking against lmctfy which will be modified to use the
> > dbus calls if available.
> >
> > Outline:
> >    . A single manager, cgmanager, is started on the host, very early
> >      during boot.  It has very few dependencies, and requires only
> >      /proc, /run, and /sys to be mounted, with /etc ro.  It will mount
> >      the cgroup hierarchies in a private namespace and set defaults
> >      (clone_children, use_hierarchy, sane_behavior, release_agent?) It
> >      will open a socket at /sys/fs/cgroup/cgmanager (in a small tmpfs).
> >    . A client (requestor 'r') can make cgroup requests over
> >      /sys/fs/cgroup/manager using dbus calls.  Detailed privilege
> >      requirements for r are listed below.
> >    . The client request will pertain an existing or new cgroup A.  r's
> >      privilege over the cgroup must be checked.  r is said to have
> >      privilege over A if A is owned by r's uid, or if A's owner is mapp=
ed
> >      into r's user namespace, and r is root in that user namespace.
> >    . The client request may pertain a victim task v, which may be moved
> >      to a new cgroup.  In that case r's privilege over both the cgroup
> >      and v must be checked.  r is said to have privilege over v if v
> >      is mapped in r's pid namespace, v's uid is mapped into r's user ns,
> >      and r is root in its userns.  Or if r and v have the same uid
> >      and v is mapped in r's pid namespace.
> >    . r's credentials will be taken from socket's peercred, ensuring that
> >      pid and uid are translated.
> >    . r passes PID(v) as a SCM_CREDENTIAL, so that cgmanager receives the
> >      translated global pid.  It will then read UID(v) from /proc/PID(v)=
/status,
> >      which is the global uid, and check /proc/PID(r)/uid_map to see whe=
ther
> >      UID is mapped there.
> >    . dbus-send can be enhanced to send a pid as SCM_CREDENTIAL to have
> >      the kernel translate it for the reader.  Only 'move task v to cgro=
up
> >      A' will require a SCM_CREDENTIAL to be sent.
> >
> > Privilege requirements by action:
> >      * Requestor of an action (r) over a socket may only make
> >        changes to cgroups over which it has privilege.
> >      * Requestors may be limited to a certain #/depth of cgroups
> >        (to limit memory usage) - DEFER?
> >      * Cgroup hierarchy is responsible for resource limits
> >      * A requestor must either be uid 0 in its userns with victim mapped
> >        ito its userns, or the same uid and in same/ancestor pidns as the
> >        victim
> >      * If r requests creation of cgroup '/x', /x will be interpreted
> >        as relative to r's cgroup.  r cannot make changes to cgroups not
> >        under its own current cgroup.
> >      * If r is not in the initial user_ns, then it may not change setti=
ngs
> >        in its own cgroup, only descendants.  (Not strictly necessary -
> >        we could require the use of extra cgroups when wanted, as lxc do=
es
> >        currently)
> >      * If r requests creation of cgroup '/x', it must have write access
> >        to its own cgroup  (not strictly necessary)
> >      * If r requests chown of cgroup /x to uid Y, Y is passed in a
> >        ucred over the unix socket, and therefore translated to init
> >        userns.
> >      * if r requests setting a limit under /x, then
> >        . either r must be root in its own userns, and UID(/x) be mapped
> >          into its userns, or else UID(r) =3D=3D UID(/x)
> >        . /x must not be / (not strictly necessary, all users know to
> >          ensure an extra cgroup layer above '/')
> >        . setns(UIDNS(r)) would not work, due to in-kernel capable() che=
cks
> >          which won't be satisfied.  Therefore we'll need to do privilege
> >          checks ourselves, then perform the write as the host root user.
> >          (see devices.allow/deny).  Further we need to support older ke=
rnels
> >          which don't support setns for pid.
> >      * If r requests action on victim V, it passes V's pid in a ucred,
> >        so that gets translated.
> >        Daemon will verify that V's uid is mapped into r's userns.  Since
> >        r is either root or the same uid as V, it is allowed to classify.
> >
> > The above addresses
> >      * creating cgroups
> >      * chowning cgroups
> >      * setting cgroup limits
> >      * moving tasks into cgroups
> >    . but does not address a 'cgexec <group> -- command' type of behavio=
r.
> >      * To handle that (specifically for upstart), recommend that r do:
> >        if (!pid) {
> >          request_reclassify(cgroup, getpid());
> >          do_execve();
> >        }
> >    . alternatively, the daemon could, if kernel is new enough, setns to
> >      the requestor's namespaces to execute a command in a new cgroup.
> >      The new command would be daemonized to that pid namespaces' pid 1.
> >
> > Types of requests:
> >    * r requests creating cgroup A'/A
> >      . lmctfy/cli/commands/create.cc
> >      . Verify that UID(r) mapped to 0 in r's userns
> >      . R=3Dcgroup_of(r)
> >      . Verify that UID(R) is mapped into r's userns
> >      . Create R/A'/A
> >      . chown R/A'/A to UID(r)
> >    * r requests to move task x to cgroup A.
> >      . lmctfy/cli/commands/enter.cc
> >      . r must send PID(x) as ancillary message
> >      . Verify that UID(r) mapped to 0 in r's userns, and UID(x) is mapp=
ed into
> >        that userns
> >        (is it safe to allow if UID(x) =3D=3D UID(r))?
> >      . R=3Dcgroup_of(r)
> >      . Verify that R/A is owned by UID(r) or UID(x)?  (not sure that's =
needed)
> >      . echo PID(x) >> /R/A/tasks
> >    * r requests chown of cgroup A to uid X
> >      . X is passed in ancillary message
> >        * ensures it is valid in r's userns
> >        * maps the userid to host for us
> >      . Verify that UID(r) mapped to 0 in r's userns
> >      . R=3Dcgroup_of(r)
> >      . Chown R/A to X
> >    * r requests cgroup A's 'property=3Dvalue'
> >      . Verify that either
> >        * A !=3D ''
> >        * UID(r) =3D=3D 0 on host
> >        In other words, r in a userns may not set root cgroup settings.
> >      . Verify that UID(r) mapped to 0 in r's userns
> >      . R=3Dcgroup_of(r)
> >      . Set property=3Dvalue for R/A
> >        * Expect kernel to guarantee hierarchical constraints
> >    * r requests deletion of cgroup A
> >      . lmctfy/cli/commands/destroy.cc (without -f)
> >      . same requirements as setting 'property=3Dvalue'
> >    * r requests purge of cgroup A
> >      . lmctfy/cli/commands/destroy.cc (with -f)
> >      . same requirements as setting 'property=3Dvalue'
> >
> > Long-term we will want the cgroup manager to become more intelligent -
> > to place its own limits on clients, to address cpu and device hotplug,
> > etc.  Since we will not be doing that in the first prototype, the daemon
> > will not keep any state about the clients.
> >
> > Client DBus Message API
> >
> > <name>: a-zA-Z0-9
> > <name>: "a-zA-Z0-9 "
> > <controllerlist>: <controller1>[:controllerlist]
> > <valueentry>: key:value
> > <valueentry>: frozen
> > <valueentry>: thawed
> > <values>: valueentry[:values]
> > keys:
> > 	{memory,swap}.{limit,soft_limit}
> > 	cpus_allowed  # set of allowed cpus
> > 	cpus_fraction # % of allowed cpus
> > 	cpus_number   # number of allowed cpus
> > 	cpu_share_percent   # percent of cpushare
> > 	devices_whitelist
> > 	devices_blacklist
> > 	net_prio_index
> > 	net_prio_interface_map
> > 	net_classid
> > 	hugetlb_limit
> > 	blkio_weight
> > 	blkio_weight_device
> > 	blkio_throttle_{read,write}
> > readkeys:
> > 	devices_list
> > 	{memory,swap}.{failcnt,max_use,limitnuma_stat}
> > 	hugetlb_max_usage
> > 	hugetlb_usage
> > 	hugetlb_failcnt
> > 	cpuacct_stat
> > 	<etc>
> > Commands:
> > 	ListControllers
> > 	Create <name> <controllerlist> <values>
> > 	Setvalue <name> <values>
> > 	Getvalue <name> <readkeys>
> > 	ListChildren <name>
> > 	ListTasks <name>
> > 	ListControllers <name>
> > 	Chown <name> <uid>
> > 	Chown <name> <uid>:<gid>
> > 	Move <pid> <name>  [[ pid is sent as a SCM_CREDENTIAL ]]
> > 	Delete <name>
> > 	Delete-force <name>
> > 	Kill <name>
> >
>=20
> I really like the idea, but I have a few comments.
> I'm not familiar with the dbus, but how will you identify a request made =
on dbus?
> I mean will you get its pid? What if the container has its own PID namesp=
ace, how will this be handled?

DBus is essentially just an IPC protocol that can be used over a variety
of medium.

In the case of this cgroup manager, we'll be using the DBus protocol on
top of a standard UNIX socket. One of the properties of unix sockets is
that you can get the uid, gid and pid of your peer. As this information
is provided by the kernel, it'll automatically be translated to match
your vision of the pid and user tree.

That's why we're also planning on abusing SCM_CRED a tiny bit so that
when a container or sub-container is asking for a pid to be moved into a
cgroup, instead of passing that pid as a standard integer over dbus,
it'll instead use the SCM_CRED mechanism, sending a ucred structure
instead which will then get magically mapped to the right namespace when
accessed by the manager and saving us a whole lot of pid/uid mapping
logic in the process.

>=20
> I know that this may sound a bit radical, but I propose that the daemon i=
s using simple unix sockets.
> The daemon should have an easy way of adding more sockets to newly starte=
d containers and each newly created socket=20
> should know the base cgroup to which it belongs. This way the daemon can =
clearly identify which request is limited to=20
> what cgroup without many lookups and will be easier to enforce the above =
mentioned restrictions.

So it looks like our current design already follows your recommendation
since we're indeed using a standard unix socket, it's just that instead
of re-inventing the wheel, we use a standard IPC protocol on top of it.

>=20
> Marian
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

--=20
St=E9phane Graber
Ubuntu developer
http://www.ubuntu.com

--0qVF/w3MHQqLSynd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCgAGBQJSk+c7AAoJEMY4l01keS1n92wQAJVs9btOW6zjdivrG5cn1j2N
SopF0HUEJHFpIhlYbnE5p9zcZ4cBol4TlvtdPuPr58gMk/G9v38yMiWvz9X4UvnH
L9aMJPhh2us7eNEtrp4v64fEWVQACeguRDaGUFWezO6YL7KbEtaZexzniX6sr3hm
XcnNh11BzGocVnrC2RervrE9poVNb3ayC4/1r+94eShx+0qx7BhqiRj6u7DyzMvF
cZ/tImYrNvIiH1YL2Xos4ZinP7k3HPcT6y9qrD088wLfjjFQMNBQPcT/Zk7HC6m+
bnoZtssDfruH7td/V8TOMl3DUDhqrKDUWSBdThNNYWknqGG/i2c3CAIoba1jTgJ+
x00Tg6MoLqSANjCEOsSWC65Zg0Dq6F3E39/wUbDiD4SvngZ2lyaeFYk42iTtY4rN
R+7uGWNOu8euxbWQ9CtUz/8XEiS3MYybI+yuiTpB4WeZ9E9lNAATmTw/2LZFL3U0
llAEmpd3VZ0KlpRTvWrcVh3UiQ1hSxmnzI/rZ1fV6NMpdlUqBXQSo+LahFDbfv9H
RRqi89XSd5PiooC381y5Nq8o8UJa3R3QEpqiRVht8Pls2ocM3dMMKvouig7QDHVx
M4TSH20bpdPDi0HJ/faeIrbE7Gw26Wp7uv7mgIMGnepPPvNLZWN/KQW5Mw13NL6W
8LQ7yZCzLNDBSb9zzSkX
=0eUX
-----END PGP SIGNATURE-----

--0qVF/w3MHQqLSynd--


--===============6014427733398399076==
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
--===============6014427733398399076==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Lxc-devel mailing list
Lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/lxc-devel

--===============6014427733398399076==--

