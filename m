From: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH REPOST 2/2] cgroup, perf_event: make perf_event
 controller work on cgroup2 hierarchy
Date: Mon, 30 Jan 2017 11:05:41 -0300
Message-ID: <20170130140541.GG9082@kernel.org>
References: <1456351975-1899-1-git-send-email-tj@kernel.org>
 <1456351975-1899-3-git-send-email-tj@kernel.org>
 <20170129193520.GA18336@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170129193520.GA18336-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Em Sun, Jan 29, 2017 at 02:35:20PM -0500, Tejun Heo escreveu:
> perf_event is a utility controller whose primary role is identifying
> cgroup membership to filter perf events; however, because it also
> tracks some per-css state, it can't be replaced by pure cgroup
> membership test.  Mark the controller as implicitly enabled on the
> default hierarchy so that perf events can always be filtered based on
> cgroup v2 path as long as the controller is not mounted on a legacy
> hierarchy.
> 
> "perf record" is updated accordingly so that it searches for both v1
> and v2 hierarchies.  A v1 hierarchy is used if perf_event is mounted
> on it; otherwise, it uses the v2 hierarchy.
> 
> v2: Doc updated to reflect more flexible rebinding behavior.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Acked-by: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
> Hello,
> 
> This was posted months ago and acked by Peter.  I thought it was
> applied but apparently wasn't.  Peter asked Arnaldo whether the
> userspace part looked which didn't get replied and that probably was
> how it slipped through the crack.
> 
> Peter, Arnanldo, how should we proceed?  Should I route this through
> the cgroup tree?

It looks ok, haven't tested it tho. I don't have a problem for it to go
thru the cgroup tree. The change is small and restrictred to cgroup
glue in tools/perf/.

- Arnaldo
 
> Thanks.
> 
>  Documentation/cgroup-v2.txt |   12 ++++++++++++
>  kernel/events/core.c        |    6 ++++++
>  tools/perf/util/cgroup.c    |   26 +++++++++++++++++++-------
>  3 files changed, 37 insertions(+), 7 deletions(-)
> 
> --- a/Documentation/cgroup-v2.txt
> +++ b/Documentation/cgroup-v2.txt
> @@ -49,6 +49,8 @@ CONTENTS
>      5-3-2. Writeback
>    5-4. PID
>      5-4-1. PID Interface Files
> +  5-5. Misc
> +    5-5-1. perf_event
>  6. Namespace
>    6-1. Basics
>    6-2. The Root and Views
> @@ -1160,6 +1162,16 @@ through fork() or clone(). These will re
>  of a new process would cause a cgroup policy to be violated.
>  
>  
> +5-5. Misc
> +
> +5-5-1. perf_event
> +
> +perf_event controller, if not mounted on a legacy hierarchy, is
> +automatically enabled on the v2 hierarchy so that perf events can
> +always be filtered by cgroup v2 path.  The controller can still be
> +moved to a legacy hierarchy after v2 hierarchy is populated.
> +
> +
>  6. Namespace
>  
>  6-1. Basics
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -10792,5 +10792,11 @@ struct cgroup_subsys perf_event_cgrp_sub
>  	.css_alloc	= perf_cgroup_css_alloc,
>  	.css_free	= perf_cgroup_css_free,
>  	.attach		= perf_cgroup_attach,
> +	/*
> +	 * Implicitly enable on dfl hierarchy so that perf events can
> +	 * always be filtered by cgroup2 path as long as perf_event
> +	 * controller is not mounted on a legacy hierarchy.
> +	 */
> +	.implicit_on_dfl = true,
>  };
>  #endif /* CONFIG_CGROUP_PERF */
> --- a/tools/perf/util/cgroup.c
> +++ b/tools/perf/util/cgroup.c
> @@ -12,8 +12,8 @@ cgroupfs_find_mountpoint(char *buf, size
>  {
>  	FILE *fp;
>  	char mountpoint[PATH_MAX + 1], tokens[PATH_MAX + 1], type[PATH_MAX + 1];
> +	char path_v1[PATH_MAX + 1], path_v2[PATH_MAX + 2], *path;
>  	char *token, *saved_ptr = NULL;
> -	int found = 0;
>  
>  	fp = fopen("/proc/mounts", "r");
>  	if (!fp)
> @@ -24,31 +24,43 @@ cgroupfs_find_mountpoint(char *buf, size
>  	 * and inspect every cgroupfs mount point to find one that has
>  	 * perf_event subsystem
>  	 */
> +	path_v1[0] = '\0';
> +	path_v2[0] = '\0';
> +
>  	while (fscanf(fp, "%*s %"STR(PATH_MAX)"s %"STR(PATH_MAX)"s %"
>  				STR(PATH_MAX)"s %*d %*d\n",
>  				mountpoint, type, tokens) == 3) {
>  
> -		if (!strcmp(type, "cgroup")) {
> +		if (!path_v1[0] && !strcmp(type, "cgroup")) {
>  
>  			token = strtok_r(tokens, ",", &saved_ptr);
>  
>  			while (token != NULL) {
>  				if (!strcmp(token, "perf_event")) {
> -					found = 1;
> +					strcpy(path_v1, mountpoint);
>  					break;
>  				}
>  				token = strtok_r(NULL, ",", &saved_ptr);
>  			}
>  		}
> -		if (found)
> +
> +		if (!path_v2[0] && !strcmp(type, "cgroup2"))
> +			strcpy(path_v2, mountpoint);
> +
> +		if (path_v1[0] && path_v2[0])
>  			break;
>  	}
>  	fclose(fp);
> -	if (!found)
> +
> +	if (path_v1[0])
> +		path = path_v1;
> +	else if (path_v2[0])
> +		path = path_v2;
> +	else
>  		return -1;
>  
> -	if (strlen(mountpoint) < maxlen) {
> -		strcpy(buf, mountpoint);
> +	if (strlen(path) < maxlen) {
> +		strcpy(buf, path);
>  		return 0;
>  	}
>  	return -1;
