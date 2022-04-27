From: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] cgroup/cpuset: Remove cpus_allowed/mems_allowed setup
 in cpuset_init_smp()
Date: Wed, 27 Apr 2022 09:06:54 +0800
Message-ID: <20220427010654.GC84190@shbuild999.sh.intel.com>
References: <20220425155505.1292896-1-longman@redhat.com>
 <20220426032337.GA84190@shbuild999.sh.intel.com>
 <be293d58-1084-b586-2267-6a1e6a400762@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651021619; x=1682557619;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qXiurggk6lNRwvUejqTYj42K/KnKmAqkVluTK7PeL+g=;
  b=dXR7FtgY3Mxx1t/ANn1Lw9iD+nVbMwHDNG5vLz7Xk/kR3QBS87xhkiel
   9j78xCD2KsPiCzPU6zbX7gEWuwGwY3lOWwF1MTUFCVvP2DAMNJLJ4c0cu
   EHG+wyVIXSGTe+QR3Fv+m5efsQh3n+sMiRfId4TsVcjwhxo7Lvyk0eGVG
   lZjxneFly37peSAXycvrM1GCh5AT3B7gPjzClGXmbZJvV2Zrb58gK03TN
   mmMSHCC5c6sMXZoNCgM5OjQQNnunL8nkF9JDAmVsdRf2X+c/xm6fLCErO
   O/N1WkqyKT8vO9fUM22ASvVBeP8L5WDPShGQQR4JosPBecdt8GJNg+sG7
   A==;
Content-Disposition: inline
In-Reply-To: <be293d58-1084-b586-2267-6a1e6a400762-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Apr 26, 2022 at 10:58:21PM +0800, Waiman Long wrote:
> On 4/25/22 23:23, Feng Tang wrote:
> > Hi Waiman,
> >
> > On Mon, Apr 25, 2022 at 11:55:05AM -0400, Waiman Long wrote:
> >> There are 3 places where the cpu and node masks of the top cpuset can
> >> be initialized in the order they are executed:
> >>   1) start_kernel -> cpuset_init()
> >>   2) start_kernel -> cgroup_init() -> cpuset_bind()
> >>   3) kernel_init_freeable() -> do_basic_setup() -> cpuset_init_smp()
> >>
> >> The first cpuset_init() function just sets all the bits in the masks.
> >> The last one executed is cpuset_init_smp() which sets up cpu and node
> >> masks suitable for v1, but not v2.  cpuset_bind() does the right setup
> >> for both v1 and v2.
> >>
> >> For systems with cgroup v2 setup, cpuset_bind() is called once. For
> >> systems with cgroup v1 setup, cpuset_bind() is called twice. It is
> >> first called before cpuset_init_smp() in cgroup v2 mode.  Then it is
> >> called again when cgroup v1 filesystem is mounted in v1 mode after
> >> cpuset_init_smp().
> >>
> >>    [    2.609781] cpuset_bind() called - v2 = 1
> >>    [    3.079473] cpuset_init_smp() called
> >>    [    7.103710] cpuset_bind() called - v2 = 0
> > I run some test, on a server with centOS, this did happen that
> > cpuset_bind() is called twice, first as v2 during kernel boot,
> > and then as v1 post-boot.
> >
> > However on a QEMU running with a basic debian rootfs image,
> > the second  call of cpuset_bind() didn't happen.
> 
> The first time cpuset_bind() is called in cgroup_init(), the kernel 
> doesn't know if userspace is going to mount v1 or v2 cgroup. By default, 
> it is assumed to be v2. However, if userspace mounts the cgroup v1 
> filesystem for cpuset, cpuset_bind() will be run at this point by 
> rebind_subsystem() to set up cgroup v1 environment and 
> cpus_allowed/mems_allowed will be correctly set at this point. Mounting 
> the cgroup v2 filesystem, however, does not cause rebind_subsystem() to 
> run and hence cpuset_bind() is not called again.
> 
> Is the QEMU setup not mounting any cgroup filesystem at all? If so, does 
> it matter whether v1 or v2 setup is used?

When I got the cpuset binding error report, I tried first on qemu to
reproduce and failed (due to there was no memory hotplug), then I
reproduced it on a real server. For both system, I used "cgroup_no_v1=all"
cmdline parameter to test cgroup-v2, could this be the reason? (TBH,
this is the first time I use cgroup-v2).

Here is the info dump:

# mount | grep cgroup
tmpfs on /sys/fs/cgroup type tmpfs (ro,nosuid,nodev,noexec,mode=755)
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/lib/systemd/systemd-cgroups-agent,name=systemd)

#cat /proc/filesystems | grep cgroup
nodev   cgroup
nodev   cgroup2

Thanks,
Feng

> >> As a result, cpu and memory node hot add may fail to update the cpu and
> >> node masks of the top cpuset to include the newly added cpu or node in
> >> a cgroup v2 environment.
> >>
> >> smp_init() is called after the first two init functions.  So we don't
> >> have a complete list of active cpus and memory nodes until later in
> >> cpuset_init_smp() which is the right time to set up effective_cpus
> >> and effective_mems.
> >>
> >> To fix this problem, the potentially incorrect cpus_allowed &
> >> mems_allowed setup in cpuset_init_smp() are removed.  For cgroup v2
> >> systems, the initial cpuset_bind() call will set them up correctly.
> >> For cgroup v1 systems, the second call to cpuset_bind() will do the
> >> right setup.
> >>
> >> cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> ---
> >>   kernel/cgroup/cpuset.c | 5 +++--
> >>   1 file changed, 3 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> >> index 9390bfd9f1cd..6bd8f5ef40fe 100644
> >> --- a/kernel/cgroup/cpuset.c
> >> +++ b/kernel/cgroup/cpuset.c
> >> @@ -3390,8 +3390,9 @@ static struct notifier_block cpuset_track_online_nodes_nb = {
> >>    */
> >>   void __init cpuset_init_smp(void)
> >>   {
> >> -	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
> >> -	top_cpuset.mems_allowed = node_states[N_MEMORY];
> > So can we keep line
> >    cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
> >
> > and only remove line
> >         top_cpuset.mems_allowed = node_states[N_MEMORY];
> > ?
> 
> That may cause cpusets.cpu to be set incorrectly for systems using 
> cgroup v2. What is really important is that effective_cpus and 
> effective_mems are set correctly.
> 
> Cheers,
> Longman
> 
