From: Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [QUESTION] Cgroup namespace and cgroup v2
Date: Tue, 20 Oct 2020 15:12:28 -0600
Message-ID: <d223c6ba-9fcf-8728-214b-1bce30f26441@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=NVS75jl5f3ZgS5RJJBrIX/ZDaY9HPmTwQMgddPNnFP4=;
 b=ITEA31dhyG2ZaX0WelBf8u1mPcB1AUi+3fjjumdh1jFXOGy+NcjMnJ9fV7VbLo7SwqzX
 H0V2Hx28us78znyAM+p2CZtweBsZGimLEpmdsSbz3G1Hm3vKbbswaiGvFNDJhoEu12ok
 XmBQo++6Q5/BVRdMrQHHGNSQUdiD4ipULj4ZqWAXqZJW9SecP/KXUmtKm0c6mY+G5cpI
 g5lnXRTNs/bahjyixBQ0XTLGJ6pp9rYQPoDGgLGCUaQo6VSWQ0GuKOn4UhhpIk7BPWMm
 p2/+7b/aMrDl4dhnH5RhC8REXGbA77wxG5yvvEEJvXcNk2KtwNKfVSWCK+gCyuUj1DiY Pg== 
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I am in the process of adding automated cgroup v2 testing to
libcgroup and ran into an unsatisfactory user experience when
using cgroup v2 and cgroup namespaces.

I used lxc to create a container on a cgroup v2 system.  lxc
uses cgroup namespaces to remap /sys/fs/cgroup/mycontainer/ on
the host to /sys/fs/cgroup/ within the container.  Within the
container, I then created a cgroup - /sys/fs/cgroup/MyCgroup/ and
placed a long-running process in it.  (Note that as part of the
container creation, there are other cgroups in /sys/fs/cgroup/.)

I then used cgdelete to recursively delete the MyCgroup/ folder.
In recursive mode, cgdelete will move processes from a child
cgroup to its parent.  But this fails on a cgroup v2 system in a
cgroup namespace because the root cgroup is a non-leaf cgroup.

A couple questions/thoughts:

* As outlined above, the behavior of the "root" cgroup in a cgroup
   namespace on a v2 system differs from the behavior of the
   unnamespaced root cgroup.  At best this is inconsistent; at worst,
   this may leak information to an unethical program.  Any ideas how
   we can make the behavior more consistent for the user and
   libcgroup?

* I will likely add a flag to cgdelete to simply kill processes in
   a cgroup rather than try and move them to the parent cgroup.
   Moving processes to the parent cgroup is somewhat challenging
   even in a cgroup v1 system due to permissions, etc.

tl;dr - I can't move a process to the root cgroup within a cgroup
         v2 cgroup namespace because its "root" is a non-leaf cgroup

Thanks.

Tom

