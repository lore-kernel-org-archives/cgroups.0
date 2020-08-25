From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock
Date: Tue, 25 Aug 2020 16:52:54 +0800
Message-ID: <4cc9f54a-9eda-9966-df9a-a00bc9e88f4c@linux.alibaba.com>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200824114204.cc796ca182db95809dd70a47@linux-foundation.org>
 <alpine.LSU.2.11.2008241231460.1065@eggly.anvils>
 <20200825015627.3c3pnwauqznnp3gc@ca-dmjordan1.us.oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200825015627.3c3pnwauqznnp3gc@ca-dmjordan1.us.oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Daniel Jordan <daniel.m.jordan@oracle.com>, Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mgorman@techsingularity.net, tj@kernel.org, khlebnikov@yandex-team.ru, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com



=D4=DA 2020/8/25 =C9=CF=CE=E79:56, Daniel Jordan =D0=B4=B5=C0:
> On Mon, Aug 24, 2020 at 01:24:20PM -0700, Hugh Dickins wrote:
>> On Mon, 24 Aug 2020, Andrew Morton wrote:
>>> On Mon, 24 Aug 2020 20:54:33 +0800 Alex Shi <alex.shi@linux.alibaba.com=
> wrote:
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
>=20

Hi Daniel,

my readtwice modification like below.

diff --git a/case-lru-file-readtwice b/case-lru-file-readtwice
index 85533b248634..57cb97d121ae 100755
--- a/case-lru-file-readtwice
+++ b/case-lru-file-readtwice
@@ -15,23 +15,30 @@

 . ./hw_vars

-for i in `seq 1 $nr_task`
-do
-       create_sparse_file $SPARSE_FILE-$i $((ROTATE_BYTES / nr_task))
-       timeout --foreground -s INT ${runtime:-600} dd bs=3D4k if=3D$SPARSE=
_FILE-$i of=3D/dev/null > $TMPFS_MNT/dd-output-1-$i 2>&1 &
-       timeout --foreground -s INT ${runtime:-600} dd bs=3D4k if=3D$SPARSE=
_FILE-$i of=3D/dev/null > $TMPFS_MNT/dd-output-2-$i 2>&1 &
-done
+OUT_DIR=3D$(hostname)-${nr_task}c-$(((mem + (1<<29))>>30))g
+TEST_CASES=3D${@:-$(echo case-*)}
+
+echo $((1<<30)) > /proc/sys/vm/max_map_count
+echo $((1<<20)) > /proc/sys/kernel/threads-max
+echo 1 > /proc/sys/vm/overcommit_memory
+#echo 3 > /proc/sys/vm/drop_caches
+
+
+i=3D1
+
+if [ "$1" =3D=3D "m" ];then
+       mount_tmpfs
+       create_sparse_root
+       create_sparse_file $SPARSE_FILE-$i $((ROTATE_BYTES))
+       exit
+fi
+
+
+if [ "$1" =3D=3D "r" ];then
+       (timeout --foreground -s INT ${runtime:-300} dd bs=3D4k if=3D$SPARS=
E_FILE-$i of=3D/dev/null > $TMPFS_MNT/dd-output-1-$i 2>&1)&
+       (timeout --foreground -s INT ${runtime:-300} dd bs=3D4k if=3D$SPARS=
E_FILE-$i of=3D/dev/null > $TMPFS_MNT/dd-output-2-$i 2>&1)&
+fi

 wait
 sleep 1

-for file in $TMPFS_MNT/dd-output-*
-do
-       [ -s "$file" ] || {
-               echo "dd output file empty: $file" >&2
-       }
-       cat $file
-       rm  $file
-done
-
-rm `seq -f $SPARSE_FILE-%g 1 $nr_task`
diff --git a/hw_vars b/hw_vars
index 8731cefb9f57..ceeaa9f17c0b 100755
--- a/hw_vars
+++ b/hw_vars
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/sh -ex

 if [ -n "$runtime" ]; then
        USEMEM=3D"$CMD ./usemem --runtime $runtime"
@@ -43,7 +43,7 @@ create_loop_devices()
        modprobe loop 2>/dev/null
        [ -e "/dev/loop0" ] || modprobe loop 2>/dev/null

-       for i in $(seq 0 8)
+       for i in $(seq 0 104)
        do
                [ -e "/dev/loop$i" ] && continue
                mknod /dev/loop$i b 7 $i
