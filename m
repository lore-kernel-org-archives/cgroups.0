From: Sandipan Das <sandipan-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: Re: [PATCH v11 8/9] hugetlb_cgroup: Add hugetlb_cgroup reservation
 tests
Date: Tue, 4 Feb 2020 21:56:38 +0530
Message-ID: <0fa5d77c-d115-1e30-cb17-d6a48c916922@linux.ibm.com>
References: <20200203232248.104733-1-almasrymina@google.com>
 <20200203232248.104733-8-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200203232248.104733-8-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Mina,

On 04/02/20 4:52 am, Mina Almasry wrote:
> The tests use both shared and private mapped hugetlb memory, and
> monitors the hugetlb usage counter as well as the hugetlb reservation
> counter. They test different configurations such as hugetlb memory usage
> via hugetlbfs, or MAP_HUGETLB, or shmget/shmat, and with and without
> MAP_POPULATE.
> 
> Also add test for hugetlb reservation reparenting, since this is
> a subtle issue.
> 
> Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: sandipan-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org
> 
> ---
> 
> Changes in v11:
> - Modify test to not assume 2MB hugepage size.
> - Updated resv.* to rsvd.*
> Changes in v10:
> - Updated tests to resv.* name changes.
> Changes in v9:
> - Added tests for hugetlb reparenting.
> - Make tests explicitly support cgroup v1 and v2 via script argument.
> Changes in v6:
> - Updates tests for cgroups-v2 and NORESERVE allocations.
> 

There are still a couple of places where 2MB page size is being used.
These are my workarounds to get the tests running on ppc64.

diff --git a/tools/testing/selftests/vm/hugetlb_reparenting_test.sh b/tools/testing/selftests/vm/hugetlb_reparenting_test.sh
index 2be672c2b311..d11d1febccc3 100755
--- a/tools/testing/selftests/vm/hugetlb_reparenting_test.sh
+++ b/tools/testing/selftests/vm/hugetlb_reparenting_test.sh
@@ -29,6 +29,15 @@ if [[ ! -e $CGROUP_ROOT ]]; then
   fi
 fi
 
+function get_machine_hugepage_size() {
+  hpz=$(grep -i hugepagesize /proc/meminfo)
+  kb=${hpz:14:-3}
+  mb=$(($kb / 1024))
+  echo $mb
+}
+
+MB=$(get_machine_hugepage_size)
+
 function cleanup() {
   echo cleanup
   set +e
@@ -67,7 +76,7 @@ function assert_state() {
   fi
 
   local actual_a_hugetlb
-  actual_a_hugetlb="$(cat "$CGROUP_ROOT"/a/hugetlb.2MB.$usage_file)"
+  actual_a_hugetlb="$(cat "$CGROUP_ROOT"/a/hugetlb.${MB}MB.$usage_file)"
   if [[ $actual_a_hugetlb -lt $(($expected_a_hugetlb - $tolerance)) ]] ||
     [[ $actual_a_hugetlb -gt $(($expected_a_hugetlb + $tolerance)) ]]; then
     echo actual a hugetlb = $((${actual_a_hugetlb%% *} / 1024 / 1024)) MB
@@ -95,7 +104,7 @@ function assert_state() {
   fi
 
   local actual_b_hugetlb
-  actual_b_hugetlb="$(cat "$CGROUP_ROOT"/a/b/hugetlb.2MB.$usage_file)"
+  actual_b_hugetlb="$(cat "$CGROUP_ROOT"/a/b/hugetlb.${MB}MB.$usage_file)"
   if [[ $actual_b_hugetlb -lt $(($expected_b_hugetlb - $tolerance)) ]] ||
     [[ $actual_b_hugetlb -gt $(($expected_b_hugetlb + $tolerance)) ]]; then
     echo actual b hugetlb = $((${actual_b_hugetlb%% *} / 1024 / 1024)) MB
@@ -152,7 +161,7 @@ write_hugetlbfs() {
 
 set -e
 
-size=$((2 * 1024 * 1024 * 25)) # 50MB = 25 * 2MB hugepages.
+size=$((${MB} * 1024 * 1024 * 25)) # 50MB = 25 * 2MB hugepages.
 
 cleanup

diff --git a/tools/testing/selftests/vm/charge_reserved_hugetlb.sh b/tools/testing/selftests/vm/charge_reserved_hugetlb.sh
index fa82a66e497a..ca98ad229b75 100755
--- a/tools/testing/selftests/vm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/vm/charge_reserved_hugetlb.sh
@@ -226,7 +226,7 @@ function write_hugetlbfs_and_get_usage() {
 function cleanup_hugetlb_memory() {
   set +e
   local cgroup="$1"
-  if [[ "$(pgrep write_to_hugetlbfs)" != "" ]]; then
+  if [[ "$(pgrep -f write_to_hugetlbfs)" != "" ]]; then
     echo kiling write_to_hugetlbfs
     killall -2 write_to_hugetlbfs
     wait_for_hugetlb_memory_to_get_depleted $cgroup
@@ -264,7 +264,7 @@ function run_test() {
   setup_cgroup "hugetlb_cgroup_test" "$cgroup_limit" "$reservation_limit"
 
   mkdir -p /mnt/huge
-  mount -t hugetlbfs -o pagesize=2M,size=256M none /mnt/huge
+  mount -t hugetlbfs -o pagesize=${MB}M,size=256M none /mnt/huge
 
   write_hugetlbfs_and_get_usage "hugetlb_cgroup_test" "$size" "$populate" \
     "$write" "/mnt/huge/test" "$method" "$private" "$expect_failure" \
@@ -318,7 +318,7 @@ function run_multiple_cgroup_test() {
   setup_cgroup "hugetlb_cgroup_test2" "$cgroup_limit2" "$reservation_limit2"
 
   mkdir -p /mnt/huge
-  mount -t hugetlbfs -o pagesize=2M,size=256M none /mnt/huge
+  mount -t hugetlbfs -o pagesize=${MB}M,size=256M none /mnt/huge
 
   write_hugetlbfs_and_get_usage "hugetlb_cgroup_test1" "$size1" \
     "$populate1" "$write1" "/mnt/huge/test1" "$method" "$private" \

---

Also I had missed running charge_reserved_hugetlb.sh the last time.
Right now, it stops at the following scenario.

Test normal case with write.
private=, populate=, method=2, reserve=
nr hugepages = 10
writing cgroup limit: 83886080
writing reseravation limit: 83886080

Starting:
hugetlb_usage=0
reserved_usage=0
expect_failure is 0
Putting task in cgroup 'hugetlb_cgroup_test'
Method is 2
Executing ./write_to_hugetlbfs -p /mnt/huge/test -s 83886080 -w  -m 2  -l
Writing to this path: /mnt/huge/test
Writing this size: 83886080
Not populating.
Using method=2
Shared mapping.
RESERVE mapping.
Allocating using SHM.
shmid: 0x5, shmget key:0
shmaddr: 0x7dfffb000000
Writing to memory.
Starting the writes:
.write_result is 0
.After write:
hugetlb_usage=16777216
reserved_usage=83886080
....kiling write_to_hugetlbfs
...Received 2.
Deleting the memory
Done deleting the memory
16777216
83886080
Memory charged to hugtlb=16777216
Memory charged to reservation=83886080
expected (83886080) != actual (16777216): Reserved memory charged to hugetlb cgroup.
CLEANUP DONE


The other test script (hugetlb_reparenting_test.sh) passes.
Did not observe anything unusual with hugepage accounting
either.


- Sandipan

