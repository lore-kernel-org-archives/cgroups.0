From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: question about memsw of memory cgroup-subsystem
Date: Mon, 16 Apr 2012 16:26:19 +0200
Message-ID: <20120416142619.GA2014@tiehlicka.suse.cz>
References: <op.wco7ekvhn27o5l@gaoqiang-d1.corp.qihoo.net>
 <20120413144954.GA9227@tiehlicka.suse.cz>
 <op.wct9zibjn27o5l@gaoqiang-d1.corp.qihoo.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <op.wct9zibjn27o5l-4p38iKlbJMyYoDLmhA0N64eABQC+30qQrE5yTffgRl4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: gaoqiang <gaoqiangscut-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon 16-04-12 11:43:56, gaoqiang wrote:
> =E5=9C=A8 Fri, 13 Apr 2012 22:49:54 +0800=EF=BC=8CMichal Hocko <mhock=
o@suse.cz> =E5=86=99=E9=81=93:
>=20
> >[CC linux-mm]
> >
> >Hi,
> >
> >On Fri 13-04-12 18:00:10, gaoqiang wrote:
> >>
> >>
> >>I put a single process into a cgroup and set memory.limit_in_bytes
> >>to 100M,and memory.memsw.limit_in_bytes to 1G.
> >>
> >>howevery,the process was oom-killed before mem+swap hit 1G. I tried
> >>many times,and it was killed randomly when memory+swap
> >>
> >>exceed 100M but less than 1G.  what is the matter ?
> >
> >could you be more specific about your kernel version, workload and c=
ould
> >you provide us with GROUP/memory.stat snapshots taken during your te=
st?
> >
> >One reason for oom might be that you are hitting the hard limit (you
> >cannot get over even if memsw limit says more) and you cannot swap o=
ut
> >any pages (e.g. they are mlocked or under writeback).
> >
>=20
> many thanks.
>=20
>=20
> The system is a vmware virtual machine,running centos6.2 with kernel
> 2.6.32-220.7.1.el6.x86_64.

Are you able to reproduce with the vanilla (same version) or a newer
kernel?

> the attachments are memory.stat,=20

When did you take this one? Before/during/after the test

> the test program and the /var/log/message of the oom.
>=20
> the workload is nearly 0,with searal sshd and bash program running.
>=20
> I just did the following command when testing:
>=20
> ./t
> # this program will pause at the "getchar()" line and in another
> terminal,run :
>=20
> cgclear
> service cgconfig restart
> mkdir /cgroup/memory/test
> cd /cgroup/memory/test
> echo 100m > memory.limit_in_bytes
> echo 1G > memory.memsw.limit_in_bytes
> echo 'pid' > tasks
>=20
> # then continue the t command
>=20
>=20
> Apr 16 11:34:50 localhost kernel: t invoked oom-killer: gfp_mask=3D0x=
d0, order=3D0, oom_adj=3D0, oom_score_adj=3D0
> Apr 16 11:34:50 localhost kernel: t cpuset=3D/ mems_allowed=3D0
> Apr 16 11:34:50 localhost kernel: Pid: 15462, comm: t Not tainted 2.6=
=2E32-220.7.1.el6.x86_64 #1
> Apr 16 11:34:50 localhost kernel: Call Trace:
> Apr 16 11:34:50 localhost kernel: [<ffffffff810c2c61>] ? cpuset_print=
_task_mems_allowed+0x91/0xb0
> Apr 16 11:34:50 localhost kernel: [<ffffffff811139e0>] ? dump_header+=
0x90/0x1b0
> Apr 16 11:34:50 localhost kernel: [<ffffffff811693b5>] ? task_in_mem_=
cgroup+0x35/0xb0
> Apr 16 11:34:50 localhost kernel: [<ffffffff8120d7ac>] ? security_rea=
l_capable_noaudit+0x3c/0x70
> Apr 16 11:34:50 localhost kernel: [<ffffffff81113e6a>] ? oom_kill_pro=
cess+0x8a/0x2c0
> Apr 16 11:34:50 localhost kernel: [<ffffffff81113d5e>] ? select_bad_p=
rocess+0x9e/0x120
> Apr 16 11:34:50 localhost kernel: [<ffffffff81114602>] ? mem_cgroup_o=
ut_of_memory+0x92/0xb0
> Apr 16 11:34:50 localhost kernel: [<ffffffff81169357>] ? mem_cgroup_h=
andle_oom+0x147/0x170
> Apr 16 11:34:50 localhost kernel: [<ffffffff81090a90>] ? autoremove_w=
ake_function+0x0/0x40
> Apr 16 11:34:50 localhost kernel: [<ffffffff8116a61b>] ? __mem_cgroup=
_try_charge+0x3bb/0x420
> Apr 16 11:34:50 localhost kernel: [<ffffffff81123851>] ? __alloc_page=
s_nodemask+0x111/0x940
> Apr 16 11:34:50 localhost kernel: [<ffffffff8116b917>] ? mem_cgroup_c=
harge_common+0x87/0xd0
> Apr 16 11:34:50 localhost kernel: [<ffffffff8116bae8>] ? mem_cgroup_n=
ewpage_charge+0x48/0x50
> Apr 16 11:34:50 localhost kernel: [<ffffffff8113beca>] ? handle_pte_f=
ault+0x79a/0xb50
> Apr 16 11:34:50 localhost kernel: [<ffffffff810471c7>] ? pte_alloc_on=
e+0x37/0x50
> Apr 16 11:34:50 localhost kernel: [<ffffffff81171ad9>] ? do_huge_pmd_=
anonymous_page+0xb9/0x370
> Apr 16 11:34:50 localhost kernel: [<ffffffff8100bc0e>] ? apic_timer_i=
nterrupt+0xe/0x20
> Apr 16 11:34:50 localhost kernel: [<ffffffff8113c464>] ? handle_mm_fa=
ult+0x1e4/0x2b0
> Apr 16 11:34:50 localhost kernel: [<ffffffff81042b79>] ? __do_page_fa=
ult+0x139/0x480
> Apr 16 11:34:50 localhost kernel: [<ffffffff811424ea>] ? do_mmap_pgof=
f+0x33a/0x380
> Apr 16 11:34:50 localhost kernel: [<ffffffff814f253e>] ? do_page_faul=
t+0x3e/0xa0
> Apr 16 11:34:50 localhost kernel: [<ffffffff814ef8f5>] ? page_fault+0=
x25/0x30
> Apr 16 11:34:50 localhost kernel: Task in /test killed as a result of=
 limit of /test
> Apr 16 11:34:50 localhost kernel: memory: usage 102400kB, limit 10240=
0kB, failcnt 756
> Apr 16 11:34:50 localhost kernel: memory+swap: usage 206240kB, limit =
1048576kB, failcnt 0
> Apr 16 11:34:50 localhost kernel: Mem-Info:
[...]
> Apr 16 11:34:50 localhost kernel: active_anon:14198 inactive_anon:664=
06 isolated_anon:0
> Apr 16 11:34:50 localhost kernel: active_file:62480 inactive_file:885=
38 isolated_file:0
> Apr 16 11:34:50 localhost kernel: unevictable:0 dirty:0 writeback:128=
22 unstable:0
> Apr 16 11:34:50 localhost kernel: free:27898 slab_reclaimable:8884 sl=
ab_unreclaimable:9427
> Apr 16 11:34:50 localhost kernel: mapped:2723 shmem:68 pagetables:174=
7 bounce:0

There still seem to be a lot of anon memory that could be reclaimed...
[...]
> Apr 16 11:34:50 localhost kernel: 211205 total pagecache pages
> Apr 16 11:34:50 localhost kernel: 60108 pages in swap cache
> Apr 16 11:34:50 localhost kernel: Swap cache stats: add 1240384, dele=
te 1180276, find 400/507
> Apr 16 11:34:50 localhost kernel: Free swap  =3D 1720104kB

And a lot of swap space where to put that memory. I do not see any
reason why we should fail to swap out some memory and so get down under
the hard limit. Btw. oom would come sooner or later with your test case=
=2E

Anyway there were quite "some" fixes since 2.6.32...

> Apr 16 11:34:50 localhost kernel: Total swap =3D 2064376kB
> Apr 16 11:34:50 localhost kernel: 294896 pages RAM
> Apr 16 11:34:50 localhost kernel: 7632 pages reserved
> Apr 16 11:34:50 localhost kernel: 100154 pages shared
> Apr 16 11:34:50 localhost kernel: 171738 pages non-shared
> Apr 16 11:34:50 localhost kernel: [ pid ]   uid  tgid total_vm      r=
ss cpu oom_adj oom_score_adj name
> Apr 16 11:34:50 localhost kernel: [15462]   500 15462    58346    129=
03   3       0             0 t
> Apr 16 11:34:50 localhost kernel: Memory cgroup out of memory: Kill p=
rocess 15462 (t) score 1000 or sacrifice child
> Apr 16 11:34:50 localhost kernel: Killed process 15462, UID 500, (t) =
total-vm:233384kB, anon-rss:51228kB, file-rss:384kB
--=20
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9   =20
Czech Republic
