From: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Subject: Re: [PATCH 3/5] cgroup: replace cgroup_add_cftypes() with
 cgroup_add_legacy_cftypes()
Date: Thu, 3 Jul 2014 07:08:08 -0400
Message-ID: <20140703110808.GB9748@hmsreliant.think-freely.org>
References: <1404345055-8196-1-git-send-email-tj@kernel.org>
 <1404345055-8196-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1404345055-8196-4-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

On Wed, Jul 02, 2014 at 07:50:53PM -0400, Tejun Heo wrote:
> Currently, cftypes added by cgroup_add_cftypes() are used for both the
> unified default hierarchy and legacy ones and subsystems can mark each
> file with either CFTYPE_ONLY_ON_DFL or CFTYPE_INSANE if it has to
> appear only on one of them.  This is quite hairy and error-prone.
> Also, we may end up exposing interface files to the default hierarchy
> without thinking it through.
> 
> cgroup_subsys will grow two separate cftype addition functions and
> apply each only on the hierarchies of the matching type.  This will
> allow organizing cftypes in a lot clearer way and encourage subsystems
> to scrutinize the interface which is being exposed in the new default
> hierarchy.
> 
> In preparation, this patch adds cgroup_add_legacy_cftypes() which
> currently is a simple wrapper around cgroup_add_cftypes() and replaces
> all cgroup_add_cftypes() usages with it.
> 
> While at it, this patch drops a completely spurious return from
> __hugetlb_cgroup_file_init().
> 
> This patch doesn't introduce any functional differences.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Cc: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
> Cc: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Acked-by: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
