From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock
Date: Tue, 25 Aug 2020 11:26:58 +0800
Message-ID: <ec62a835-f79d-2b8c-99c7-120834703b42@linux.alibaba.com>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200824114204.cc796ca182db95809dd70a47@linux-foundation.org>
 <alpine.LSU.2.11.2008241231460.1065@eggly.anvils>
 <20200825015627.3c3pnwauqznnp3gc@ca-dmjordan1.us.oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200825015627.3c3pnwauqznnp3gc-S51bK0XF4qpuJJETbFA3a0B3C2bhBk7L0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org



=D4=DA 2020/8/25 =C9=CF=CE=E79:56, Daniel Jordan =D0=B4=B5=C0:
> On Mon, Aug 24, 2020 at 01:24:20PM -0700, Hugh Dickins wrote:
>> On Mon, 24 Aug 2020, Andrew Morton wrote:
>>> On Mon, 24 Aug 2020 20:54:33 +0800 Alex Shi <alex.shi-KPsoFbNs7GizrGE5b=
RqYAgC/G2K4zDHf@public.gmane.org> wrote:
>> Andrew demurred on version 17 for lack of review.  Alexander Duyck has
>> been doing a lot on that front since then.  I have intended to do so,
>> but it's a mirage that moves away from me as I move towards it: I have
>=20
> Same, I haven't been able to keep up with the versions or the recent revi=
ew
> feedback.  I got through about half of v17 last week and hope to have mor=
e time
> for the rest this week and beyond.
>=20
>>>> Following Daniel Jordan's suggestion, I have run 208 'dd' with on 104
>>>> containers on a 2s * 26cores * HT box with a modefied case:
>=20
> Alex, do you have a pointer to the modified readtwice case?

Sorry, no. my developer machine crashed, so I lost case my container and mo=
dified
case. I am struggling to get my container back from a account problematic r=
epository.=20

But some testing scripts is here, generally, the original readtwice case wi=
ll
run each of threads on each of cpus. The new case will run one container on=
 each cpus,
and just run one readtwice thead in each of containers.

Here is readtwice case changes(Just a reference)
diff --git a/case-lru-file-readtwice b/case-lru-file-readtwice
index 85533b248634..48c6b5f44256 100755
--- a/case-lru-file-readtwice
+++ b/case-lru-file-readtwice
@@ -15,12 +15,9 @@

 . ./hw_vars

-for i in `seq 1 $nr_task`
-do
        create_sparse_file $SPARSE_FILE-$i $((ROTATE_BYTES / nr_task))
        timeout --foreground -s INT ${runtime:-600} dd bs=3D4k if=3D$SPARSE=
_FILE-$i of=3D/dev/null > $TMPFS_MNT/dd-output-1-$i 2>&1 &
        timeout --foreground -s INT ${runtime:-600} dd bs=3D4k if=3D$SPARSE=
_FILE-$i of=3D/dev/null > $TMPFS_MNT/dd-output-2-$i 2>&1 &
-done

 wait
 sleep 1
@@ -31,7 +28,7 @@ do
                echo "dd output file empty: $file" >&2
        }
        cat $file
-       rm  $file
+       #rm  $file
 done

 rm `seq -f $SPARSE_FILE-%g 1 $nr_task`

And here is how to running the case:=20
--------
#run all case on 24 cpu machine, lrulockv2 is the container with modified c=
ase.
for ((i=3D0; i<24; i++))
do
        #btw, vm-scalability need create 23 loop devices
        docker run --privileged=3Dtrue --rm lrulockv2 bash -c " sleep 20000=
" &
done
sleep 15  #wait all container ready.=20

#kick testing
for i in `docker ps | sed '1 d' | awk '{print $1 }'` ;do docker exec --priv=
ileged=3Dtrue -it $i bash -c "cd vm-scalability/; bash -x ./run case-lru-fi=
le-readtwice "& done

#show testing result for all
for i in `docker ps | sed '1 d' | awk '{print $1 }'` ;do echo =3D=3D=3D $i =
=3D=3D=3D; docker exec $i bash -c 'cat /tmp/vm-scalability-tmp/dd-output-* =
'  & done
for i in `docker ps | sed '1 d' | awk '{print $1 }'` ;do echo =3D=3D=3D $i =
=3D=3D=3D; docker exec $i bash -c 'cat /tmp/vm-scalability-tmp/dd-output-* =
'  & done | grep MB | awk 'BEGIN {a=3D0
;} { a+=3D$8} END {print NR, a/(NR)}'


>=20
> Even better would be a description of the problem you're having in produc=
tion
> with lru_lock.  We might be able to create at least a simulation of it to=
 show
> what the expected improvement of your real workload is.

we are using thousands memcgs in a machine, but as a simulation, I guess ab=
ove case
could be helpful to show the problem.

Thanks a lot!
Alex

>=20
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git=
/tree/case-lru-file-readtwice
>>>> With this patchset, the readtwice performance increased about 80%
>>>> in concurrent containers.
>>>
>>> That's rather a slight amount of performance testing for a huge
>>> performance patchset!
>>
>> Indeed.  And I see that clause about readtwice performance increased 80%
>> going back eight months to v6: a lot of fundamental bugs have been fixed
>> in it since then, so I do think it needs refreshing.  It could be faster
>> now: v16 or v17 fixed the last bug I knew of, which had been slowing
>> down reclaim considerably.
>>
>> When I last timed my repetitive swapping loads (not loads anyone sensible
>> would be running with), across only two memcgs, Alex's patchset was
>> slightly faster than without: it really did make a difference.  But
>> I tend to think that for all patchsets, there exists at least one
>> test that shows it faster, and another that shows it slower.

In my testing, case-lru-file-mmap-read has a bit slower, 10+% on 96 thread =
machine,
when memcg is enabled but unused, that may due to longer pointer jumpping o=
n=20
lruvec than pgdat->lru_lock, since cgroup_disable=3Dmemory could fully remo=
ve the
regression with the new lock path.

I tried reusing page->prviate to store lruvec pointer, that could remove so=
me=20
regression on this, since private is generally unused on a lru page. But th=
e patch
is too buggy now.=20

BTW,=20
Guess memcg would cause more memory disturb on a large machine, if it's ena=
bled but
unused, isn't it?


>>
>>> Is more detailed testing planned?
>>
>> Not by me, performance testing is not something I trust myself with,
>> just get lost in the numbers: Alex, this is what we hoped for months
>> ago, please make a more convincing case, I hope Daniel and others
>> can make more suggestions.  But my own evidence suggests it's good.
>=20
> I ran a few benchmarks on v17 last week (sysbench oltp readonly, kerndeve=
l from
> mmtests, a memcg-ized version of the readtwice case I cooked up) and then=
 today
> discovered there's a chance I wasn't running the right kernels, so I'm re=
doing
> them on v18.  Plan to look into what other, more "macro" tests would be
> sensitive to these changes.
>=20
