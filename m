From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Subject: Re: Regression from 5.7.17 to 5.9.9 with memory.low cgroup
 constraints
Date: Thu, 10 Dec 2020 12:08:25 +0100
Message-ID: <20201210120825.17ad1122@hemera>
References: <20201125123956.61d9e16a@hemera>
        <20201125182103.GA840171@carbon.dhcp.thefacebook.com>
        <20201203120936.4cadef43@hemera.lan.sysophe.eu>
        <20201203205559.GD1571588@carbon.DHCP.thefacebook.com>
        <20201206123021.6683e2a5@hemera.lan.sysophe.eu>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20201206123021.6683e2a5-pDZhbqX7CfkoGc32E1+a2S4z1YicLaQ4@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hello All,

Since my last changes (allowing the websrv CG to use both NUMA memory
areas) the system as a whole runs reasonably without trashing and also
makes a way better use of memory.

As such it really seems that NUMA node restrictions (memory wise at
least) do not properly interact with reclaim.

Is there a way to see how memory usage is on the different NUMA nodes?

I have the impressions some reclaim was ongoing because memory
allocation was ask on one node which may have been "full" and there
only file cache was being reclaimed (in cgroups where memory.low didn't
protect it).


Thanks,
Bruno

On Sun, 6 Dec 2020 12:30:21 +0100 Bruno Pr=C3=A9mont wrote:
> On Thu, 3 Dec 2020 12:55:59 -0800 Roman Gushchin <guro-b10kYP2dOMg@public=
.gmane.org> wrote:
> > In the meantime Yang Shi discovered a problem related slab shrinkers,
> > which is to some extent similar to what you describe: under certain con=
ditions
> > large amounts of slab memory can be completely excluded from the reclai=
m process.
> >=20
> > Can you, please, check if his fix will solve your problem?
> > Here is the final version: https://www.spinics.net/lists/stable/msg4306=
01.html . =20
>=20
> I've added that patch on top of yours but it seems not to completely
> help either.
> With this patch is seems that such dentries might get reclaimed as a
> last resort instead of not at all.
>=20
> I've added logs since current boot:
>  https://faramir-fj.hosting-restena.lu/cgmon-20201204.txt
>  https://faramir-fj.hosting-restena.lu/cgmon-20201205.txt
>  https://faramir-fj.hosting-restena.lu/cgmon-20201206.txt
> with the memory evolution. Evolution started to degrade over past night
> where memory usage started to increase from 40G tending to full use but
> with only slabs growing (not file cache) and memory assigned to cgroups
> staying more or less constant - even root cgroup's memory stats seem not
> to list a great deal of used memory.
>=20
> The only cgroup not "sufficiently" protected by memory.low (websrv) has
> seen its memory use somehow clamped to about 16G while it should be
> allowed to go up to 32G according to memory.high and of those 16G in
> use at time of writing it only had 100M of file cache left, all the
> rest being slabs.
>=20
>=20
> As system now is using most of its memory I've bumped websrv CG's
> memory.low to 20G so it should stay protected some more (which after a
> few minutes showed its filecache growing again) with the aim of moving
> pressure out of leaf-cgroups to non-cg-assigned-memory.
>=20
> Somehow this move seems to prove getting me some success.
>=20
>=20
> I will report back later today or tomorrow with more details on the
> evolution with "no unused" memory. At least production service tends not
> to suffer (more than from storage response time).
>=20
>=20
>=20
> I have the impression that memory reclaim now only looks at cgroup and
> if it can make some progress it will not bother looking anywhere else.
>=20
> I also have the vague impression that distribution of my tasks on the
> two NUMA nodes somehow impacts when or how memory reclaim happens.
>=20
> NUMA node0 CPU(s):     0-5,12-17
> NUMA node1 CPU(s):     6-11,18-23
>=20
>             CPUs    MEMs
>   system:    0-3     0
>   websrv:   8-11     0        (allowed mems=3D0-1 as of 2020-12-06 12:18
>                                after increasing memory.low from 4G
>                                to 20G which did release quite some
>                                pression and allow)
>   website: 12-23     1
>   remote:    4-7     0
>     (assignment done using cpuset cgroup)
>=20
> (seems NUMA distribution changed or I missed the non-linear node
> distribution of CPUs - cores versus hyperthreading as my Intent was to
> have website on 1 socket and the rest on the other socket. Memory is
> mapped as I planned it, but tasks not really)
>=20
>=20
> So calculating:
>   system: 128M..8G     mems=3D0    \
>   remote: 1G..14G      mems=3D0     }-->   5G..54G
>   websrv: 4G..32G      mems=3D0    /
>   website: 16G..       mems=3D1
>=20
> But with everything except websrv lying below its low limit I wonder why
> reclaim only hits the cgroups's file cache but still mostly ignores its
> slabs.
>=20
>=20
> Bruno
>=20
> > > Compared to initial occurrence I do now have some more details (all b=
ut
> > > /proc/slabinfo since boot) and according to /proc/slabinfo a good deal
> > > of reclaimable slabs seem to be dentries (and probably
> > > xfs_inode/xfs_ifork related to them) - not sure if those are assigned
> > > to cgroups or not-accounted and not seen as candidate for reclaim...
> > >=20
> > > xfs_buf           444908 445068    448   36    4 : tunables    0    0=
    0 : slabdata  12363  12363      0
> > > xfs_bui_item           0      0    232   35    2 : tunables    0    0=
    0 : slabdata      0      0      0
> > > xfs_bud_item           0      0    200   40    2 : tunables    0    0=
    0 : slabdata      0      0      0
> > > xfs_cui_item           0      0    456   35    4 : tunables    0    0=
    0 : slabdata      0      0      0
> > > xfs_cud_item           0      0    200   40    2 : tunables    0    0=
    0 : slabdata      0      0      0
> > > xfs_rui_item           0      0    712   46    8 : tunables    0    0=
    0 : slabdata      0      0      0
> > > xfs_rud_item           0      0    200   40    2 : tunables    0    0=
    0 : slabdata      0      0      0
> > > xfs_icr                0    156    208   39    2 : tunables    0    0=
    0 : slabdata      4      4      0
> > > xfs_ili           1223169 1535904    224   36    2 : tunables    0   =
 0    0 : slabdata  42664  42664      0
> > > xfs_inode         12851565 22081140   1088   30    8 : tunables    0 =
   0    0 : slabdata 736038 736038      0
> > > xfs_efi_item           0    280    456   35    4 : tunables    0    0=
    0 : slabdata      8      8      0
> > > xfs_efd_item           0    280    464   35    4 : tunables    0    0=
    0 : slabdata      8      8      0
> > > xfs_buf_item           7    216    296   27    2 : tunables    0    0=
    0 : slabdata      8      8      0
> > > xf_trans               0    224    288   28    2 : tunables    0    0=
    0 : slabdata      8      8      0
> > > xfs_ifork         12834992 46309928     72   56    1 : tunables    0 =
   0    0 : slabdata 826963 826963      0
> > > xfs_da_state           0    224    512   32    4 : tunables    0    0=
    0 : slabdata      7      7      0
> > > xfs_btree_cur          0    224    256   32    2 : tunables    0    0=
    0 : slabdata      7      7      0
> > > xfs_bmap_free_item      0    230     88   46    1 : tunables    0    =
0    0 : slabdata      5      5      0
> > > xfs_log_ticket         4    296    216   37    2 : tunables    0    0=
    0 : slabdata      8      8      0
> > > fat_inode_cache        0      0    744   44    8 : tunables    0    0=
    0 : slabdata      0      0      0
> > > fat_cache              0      0     64   64    1 : tunables    0    0=
    0 : slabdata      0      0      0
> > > mnt_cache            114    180    448   36    4 : tunables    0    0=
    0 : slabdata      5      5      0
> > > filp                6228  15582    384   42    4 : tunables    0    0=
    0 : slabdata    371    371      0
> > > inode_cache         6669  16016    608   26    4 : tunables    0    0=
    0 : slabdata    616    616      0
> > > dentry            8092159 15642504    224   36    2 : tunables    0  =
  0    0 : slabdata 434514 434514      0
> > >=20
> > >=20
> > >=20
> > > The full collected details are available at
> > >   https://faramir-fj.hosting-restena.lu/cgmon-20201203.txt=20
> > > (please take a copy as that file will not stay there forever)
> > >=20
> > > A visual graph of memory evolution is available at
> > >   https://faramir-fj.hosting-restena.lu/system-memory-20201203.png=20
> > > with reboot on Tuesday morning and steady increase of slabs starting
> > > Webnesday evening correlating with start of backup until trashing
> > > started at about 3:30 and the large drop in memory being me doing
> > >   echo 2 > /proc/sys/vm/drop_caches
> > > which stopped the trashing as well.
> > >=20
> > >=20
> > > Against what does memcg attempt reclaim when it tries to satisfy a CG=
's
> > > low limit? Only against siblings or also against root or not-accounte=
d?
> > > How does it take into account slabs where evictable entries will cause
> > > unevictable entries to be freed as well? =20
> >=20
> > Low limits are working by excluding some portions of memory from the re=
claim,
> > not by adding a memory pressure to something else.
> >  =20
> > >  =20
> > > > > My setup, server has 64G of RAM:
> > > > >   root
> > > > >    + system        { min=3D0, low=3D128M, high=3D8G, max=3D8G }
> > > > >      + base        { no specific constraints }
> > > > >      + backup      { min=3D0, low=3D32M, high=3D2G, max=3D2G }
> > > > >      + shell       { no specific constraints }
> > > > >   + websrv         { min=3D0, low=3D4G, high=3D32G, max=3D32G }
> > > > >   + website        { min=3D0, low=3D16G, high=3D40T, max=3D40T }
> > > > >     + website1     { min=3D0, low=3D64M, high=3D2G, max=3D2G }
> > > > >     + website2     { min=3D0, low=3D64M, high=3D2G, max=3D2G }
> > > > >       ...
> > > > >   + remote         { min=3D0, low=3D1G, high=3D14G, max=3D14G }
> > > > >     + webuser1     { min=3D0, low=3D64M, high=3D2G, max=3D2G }
> > > > >     + webuser2     { min=3D0, low=3D64M, high=3D2G, max=3D2G }
> > > > >       ... =20
> > >=20
> > > Also interesting is that backup which is forced into 2G
> > > (system/backup CG) causes amount of slabs assigned to websrv CG to
> > > increase until that CG has almost only slab entries assigned to it to
> > > fill 16G, like file cache being reclaimed but not slab entries even if
> > > there is almost no file cache left and tons of slabs.
> > > What I'm also surprised is the so much memory remains completely unus=
ed
> > > (instead of being used for file caches).
> > >=20
> > > According to the documentation if I didn't get it wrong any limits of
> > > child CGs (e.g. webuser1...) are applied up to what their parent's
> > > limits allow. Thus, if looking at e.g. remote -> webuser1... even if I
> > > have 1000 webuserN they wont "reserve" 65G for themselves via
> > > memory.low limit when their parent sets memory.low to 1G?
> > > Or does this depend on on CG mount options (memory_recursiveprot)? =20
> >=20
> > It does. What you're describing is the old (!memory_recursiveprot) beha=
vior.
> >=20
> > Thanks! =20
>=20

