From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: Attaching a cgroup subsystem to multiple hierarchies
Date: Sat, 8 Feb 2014 10:26:57 +0800
Message-ID: <52F595F1.8020301@huawei.com>
References: <050BD595-BE55-401D-9B61-E877FB9F06A8@gopivotal.com> <20140206185923.GA2781@dhcp22.suse.cz> <1C806CEE-B69E-4F47-A33F-BC8CE4865223@gopivotal.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1C806CEE-B69E-4F47-A33F-BC8CE4865223-6n0RBC2Q8y8S+FvcfC7Uqw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Glyn Normington <gnormington-6n0RBC2Q8y8S+FvcfC7Uqw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

(Add Michal back to the Cc list, and Cc cgroup mailing list)

On 2014/2/7 17:21, Glyn Normington wrote:
> Hi Michal
>=20
> On 6 Feb 2014, at 18:59, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
>=20
>> On Wed 05-02-14 14:39:52, Glyn Normington wrote:
>>> Reading cgroups.txt and casting around the net leads me to believe
>>> that it is possible to attach a cgroup subsystem (e.g. memory) to
>>> multiple hierarchies, but this seems to result in =93mirrored=94
>>> hierarchies which are automatically kept in step with each other -
>>> essentially it looks like the same hierarchy at multiple file syste=
m
>>> paths.
>>>
>>> Take the following interaction for example:
>>>
>>> \begin{verbatim}
>>> $ pwd  =20
>>> /home/vagrant
>>> $ mkdir mem1
>>> $ mkdir mem2
>>> $ sudo su
>>> # mount -t cgroup -o memory none /home/vagrant/mem1
>>> # mount -t cgroup -o memory none /home/vagrant/mem2
>>> # cd mem1
>>> # mkdir inst1 =20
>>> # ls inst1=20
>>> cgroup.clone_children  memory.failcnt ...
>>> # ls ../mem2
>>> cgroup.clone_children  inst1 memory.limit_in_bytes ...
>>> # cd inst1
>>> # echo 1000000 > memory.limit_in_bytes=20
>>> # cat memory.limit_in_bytes=20
>>> 1003520
>>> # cat ../../mem2/inst1/memory.limit_in_bytes=20
>>> 1003520
>>> # echo $$ > tasks
>>> # cat tasks
>>> 1365
>>> 1409
>>> # cat ../../mem2/inst1/tasks
>>> 1365
>>> 1411
>>>
>>> Is this working as intended?
>>
>> Yes, it doesn't make any sense to have two different views on the sa=
me
>> controllers.
>=20
> Then wouldn=92t it be better for the second mount to fail?
>=20

We don't disallow mounting procfs/sysfs to more than one mount point.
Why we want to do this to cgroupfs?

>>
>>> Is there some other way to attach a subsystem to *distinct*
>>> hierarchies?
>>
>> No.
>>
>>> Distinct hierarchies would allow distinct cgroups, distinct setting=
s
>>> (e.g. memory.limit_in_bytes) and distinct partitions of the tasks i=
n
>>> the system.
>>
>> Which one should be applied then?
>=20
> Good question. All of them, I would say: the constraints due to disti=
nct settings would be ANDed together.
>=20
> The implementation would be more complex and less efficient as a subs=
ystem's resources consumed by a process would need charging against eac=
h hierarchy to which the subsystem was attached.
>=20
> I very much doubt this would be worth implementing and I=92m not at a=
ll suggesting it.
>=20

Don't even think about it. :)

>>
>>>
>>> Note: I don=92t have a good use for this function - I=92m simply
>>> trying to reverse engineer the semantics of cgroups to get a precis=
e
>>> understanding.
>>
>> I think there is no need to reverse engineer ;)
>> Documentation/cgroups/cgroups.txt in the kernel tree does give a dec=
ent
>> description IMO.
>=20
> I disagree. For example, cgroups.txt does not clearly state whether o=
r not a single subsystem may be attached to distinct hierarchies.
>=20
> This seems to have caused confusion elsewhere. For example, Red Hat w=
rite =93=85 a single subsystem can be attached to two hierarchies if bo=
th of those hierarchies have only that subsystem attached.=94 ([1]).
>=20

No documentation is perfect, but you can make it better by sending us
a patch.
