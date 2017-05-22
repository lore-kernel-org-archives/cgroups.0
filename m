From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Race between cgroup core and the cpuset controller
Date: Mon, 22 May 2017 18:14:31 -0400
Message-ID: <327ca1f5-7957-fbb9-9e5f-9ba149d40ba2@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I found what looks like a race between cgroup core and the cpuset 
controller.

---

/* Mount the cpuset and create parent and child cpusets. */
# mount -t cpuset nodev /dev/cpuset
# cd /dev/cpuset
# mkdir parent
# mkdir parent/child

/* Enable cpu_exclusive in both parent and child cpusets. */
# cd parent
# /bin/echo 1 > cpu_exclusive
# /bin/echo 1 > child/cpu_exclusive

/* Remove the child cpuset and then immediately try making the parent 
non-exclusive. */
# rmdir child; /bin/echo 0 > cpu_exclusive
/bin/echo: write error: Device or resource busy

---

I'd expect the last command above to succeed.

If I do the same steps as above, but make the last command

   # rmdir child; sleep 1; /bin/echo 0 > cpu_exclusive

then it works.

None of the three EBUSY errors from 'man cpuset' apply to this case, so 
I added some debug output that shows what's going on:

[2710738.469049] cgroup: [cpu  64] entering kill_css
[2710738.478379] cgroup: [cpu  64] leaving kill_css
[2710738.487659] [cpu  96] entering is_cpuset_subset
[2710738.496830] [cpu  96] triggered in is_cpuset_subset  /* 
is_cpu_exclusive(p) > is_cpu_exclusive(q) */
[2710738.513153] cgroup: [cpu  64] entering css_killed_ref_fn
[2710738.523873] cgroup: [cpu  64] leaving css_killed_ref_fn
[2710738.534716] cgroup: [cpu  64] entering css_killed_work_fn
[2710738.545737] cgroup: [cpu  64] entering offline_css
[2710738.555644] [cpu  64] entering cpuset_css_offline
[2710738.565387] [cpu  64] entering is_cpuset_subset
[2710738.574744] [cpu  64] leaving cpuset_css_offline
[2710738.584297] cgroup: [cpu  64] leaving offline_css
[2710738.594010] cgroup: [cpu  64] leaving css_killed_work_fn

It looks like the task on cpu 64 is kicking off the kworker that 
eventually calls cpuset_css_offline, but that this worker doesn't get 
started until after the "/bin/echo 0 > cpu_exclusive" command on cpu 96 
is finished running.  That means that the check in is_cpuset_subset that 
verifies whether all child css's are non-exclusive before allowing 
'parent' to be made exclusive fails because 'child' isn't killed yet.

Is this expected behavior?

Should the user have to sleep between commands or thoroughly clean up 
after a cpuset with something like

   # /bin/echo 0 > child/cpu_exclusive; rmdir child; /bin/echo 0 > 
cpu_exclusive

to avoid these kinds of failures?

Thank you,
Daniel
