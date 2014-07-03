From: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Subject: Re: [PATCH 4/5] cgroup: distinguish the default and legacy
 hierarchies when handling cftypes
Date: Thu, 3 Jul 2014 07:14:40 -0400
Message-ID: <20140703111440.GC9748@hmsreliant.think-freely.org>
References: <1404345055-8196-1-git-send-email-tj@kernel.org>
 <1404345055-8196-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1404345055-8196-5-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

On Wed, Jul 02, 2014 at 07:50:54PM -0400, Tejun Heo wrote:
> Until now, cftype arrays carried files for both the default and legacy
> hierarchies and the files which needed to be used on only one of them
> were flagged with either CFTYPE_ONLY_ON_DFL or CFTYPE_INSANE.  This
> gets confusing very quickly and we may end up exposing interface files
> to the default hierarchy without thinking it through.
> 
> This patch makes cgroup core provide separate sets of interfaces for
> cftype handling so that the cftypes for the default and legacy
> hierarchies are clearly distinguished.  The previous two patches
> renamed the existing ones so that they clearly indicate that they're
> for the legacy hierarchies.  This patch adds the interface for the
> default hierarchy and apply them selectively depending on the
> hierarchy type.
> 
> * cftypes added through cgroup_subsys->dfl_cftypes and
>   cgroup_add_dfl_cftypes() only show up on the default hierarchy.
> 
> * cftypes added through cgroup_subsys->legacy_cftypes and
>   cgroup_add_legacy_cftypes() only show up on the legacy hierarchies.
> 
> * cgroup_subsys->dfl_cftypes and ->legacy_cftypes can point to the
>   same array for the cases where the interface files are identical on
>   both types of hierarchies.
> 
> * This makes all the existing subsystem interface files legacy-only by
>   default and all subsystems will have no interface file created when
>   enabled on the default hierarchy.  Each subsystem should explicitly
>   review and compose the interface for the default hierarchy.
> 
> * A boot param "cgroup__DEVEL__legacy_files_on_dfl" is added which
>   makes subsystems which haven't decided the interface files for the
>   default hierarchy to present the legacy files on the default
>   hierarchy so that its behavior on the default hierarchy can be
>   tested.  As the awkward name suggests, this is for development only.
> 
> * memcg's CFTYPE_INSANE on "use_hierarchy" is noop now as the whole
>   array isn't used on the default hierarchy.  The flag is removed.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
> Cc: Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
> Cc: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Acked-by: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
