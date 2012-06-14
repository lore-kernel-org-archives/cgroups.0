From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -V9 15/15] hugetlb/cgroup: add HugeTLB controller
 documentation
Date: Thu, 14 Jun 2012 12:07:55 +0200
Message-ID: <20120614100755.GM27397@tiehlicka.suse.cz>
References: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1339583254-895-16-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1339583254-895-16-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 13-06-12 15:57:34, Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Reviewed-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Minor nid below
> ---
>  Documentation/cgroups/hugetlb.txt |   45 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
>  create mode 100644 Documentation/cgroups/hugetlb.txt
> 
> diff --git a/Documentation/cgroups/hugetlb.txt b/Documentation/cgroups/hugetlb.txt
> new file mode 100644
> index 0000000..a9faaca
> --- /dev/null
> +++ b/Documentation/cgroups/hugetlb.txt
[...]
> +With the above step, the initial or the parent HugeTLB group becomes
> +visible at /sys/fs/cgroup. At bootup, this group includes all the tasks in
> +the system. /sys/fs/cgroup/tasks lists the tasks in this cgroup.
> +
> +New groups can be created under the parent group /sys/fs/cgroup.
> +
> +# cd /sys/fs/cgroup
> +# mkdir g1
> +# echo $$ > g1/tasks
> +
> +The above steps create a new group g1 and move the current shell
> +process (bash) into it.

This is probably not needed as it is already described in the generic
cgroups description

> +
> +Brief summary of control files
> +
> + hugetlb.<hugepagesize>.limit_in_bytes     # set/show limit of "hugepagesize" hugetlb usage
> + hugetlb.<hugepagesize>.max_usage_in_bytes # show max "hugepagesize" hugetlb  usage recorded
> + hugetlb.<hugepagesize>.usage_in_bytes     # show current res_counter usage for "hugepagesize" hugetlb
> + hugetlb.<hugepagesize>.failcnt		   # show the number of allocation failure due to HugeTLB limit
> +
> +For a system supporting two hugepage size (16M and 16G) the control
> +files include:
> +
> +hugetlb.16GB.limit_in_bytes
> +hugetlb.16GB.max_usage_in_bytes
> +hugetlb.16GB.usage_in_bytes
> +hugetlb.16GB.failcnt
> +hugetlb.16MB.limit_in_bytes
> +hugetlb.16MB.max_usage_in_bytes
> +hugetlb.16MB.usage_in_bytes
> +hugetlb.16MB.failcnt
> -- 
> 1.7.10
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
