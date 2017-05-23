From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Race between cgroup core and the cpuset controller
Date: Tue, 23 May 2017 16:06:45 -0400
Message-ID: <20170523200645.GG13222@htj.duckdns.org>
References: <327ca1f5-7957-fbb9-9e5f-9ba149d40ba2@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tdTLT7yfK5R2+wXuW2fHQ5371X7L4SA8A4hg37VHg08=;
        b=rD6e+yA/+yiitMCAGNTu69kJBQhLitl7HKgqL/jXpBq1dhWvhf6VBoMj8l6wBUbl8u
         TAlmzxaYwAIr9vzzcp4sLbAHHQkh0Yr0xvBDfzfIqlmaCcDuYXherl/IVX+PRJWosVxI
         aHdPgTuR8jb+SI4eSk9nB22auQRoGS9726juILzlFc+zgnjQEjN2V9oEpmi1IIIsW4W0
         IrOsps2etXyt2mG60xRAU2RTllgZ0n8AlNkVCbZ+6UC3h6Ic/sZokZ4eOwyhqUBfJycI
         smN6cAVTXml0EoxlY/QBX9HMF3bY08qejZEgPsFsExaLmrKWL2JAHk+kZKAMjwU+gQuo
         V55w==
Content-Disposition: inline
In-Reply-To: <327ca1f5-7957-fbb9-9e5f-9ba149d40ba2-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

(cc'ing Li and quoting the whole message)

On Mon, May 22, 2017 at 06:14:31PM -0400, Daniel Jordan wrote:
> Hi,
> 
> I found what looks like a race between cgroup core and the cpuset
> controller.
> 
> ---
> 
> /* Mount the cpuset and create parent and child cpusets. */
> # mount -t cpuset nodev /dev/cpuset
> # cd /dev/cpuset
> # mkdir parent
> # mkdir parent/child
> 
> /* Enable cpu_exclusive in both parent and child cpusets. */
> # cd parent
> # /bin/echo 1 > cpu_exclusive
> # /bin/echo 1 > child/cpu_exclusive
> 
> /* Remove the child cpuset and then immediately try making the parent
> non-exclusive. */
> # rmdir child; /bin/echo 0 > cpu_exclusive
> /bin/echo: write error: Device or resource busy
> 
> ---
> 
> I'd expect the last command above to succeed.
> 
> If I do the same steps as above, but make the last command
> 
>   # rmdir child; sleep 1; /bin/echo 0 > cpu_exclusive
> 
> then it works.
> 
> None of the three EBUSY errors from 'man cpuset' apply to this case, so I
> added some debug output that shows what's going on:
> 
> [2710738.469049] cgroup: [cpu  64] entering kill_css
> [2710738.478379] cgroup: [cpu  64] leaving kill_css
> [2710738.487659] [cpu  96] entering is_cpuset_subset
> [2710738.496830] [cpu  96] triggered in is_cpuset_subset  /*
> is_cpu_exclusive(p) > is_cpu_exclusive(q) */
> [2710738.513153] cgroup: [cpu  64] entering css_killed_ref_fn
> [2710738.523873] cgroup: [cpu  64] leaving css_killed_ref_fn
> [2710738.534716] cgroup: [cpu  64] entering css_killed_work_fn
> [2710738.545737] cgroup: [cpu  64] entering offline_css
> [2710738.555644] [cpu  64] entering cpuset_css_offline
> [2710738.565387] [cpu  64] entering is_cpuset_subset
> [2710738.574744] [cpu  64] leaving cpuset_css_offline
> [2710738.584297] cgroup: [cpu  64] leaving offline_css
> [2710738.594010] cgroup: [cpu  64] leaving css_killed_work_fn
> 
> It looks like the task on cpu 64 is kicking off the kworker that eventually
> calls cpuset_css_offline, but that this worker doesn't get started until
> after the "/bin/echo 0 > cpu_exclusive" command on cpu 96 is finished
> running.  That means that the check in is_cpuset_subset that verifies
> whether all child css's are non-exclusive before allowing 'parent' to be
> made exclusive fails because 'child' isn't killed yet.
> 
> Is this expected behavior?
> 
> Should the user have to sleep between commands or thoroughly clean up after
> a cpuset with something like
> 
>   # /bin/echo 0 > child/cpu_exclusive; rmdir child; /bin/echo 0 >
> cpu_exclusive
> 
> to avoid these kinds of failures?

Can you please see whether the following patch fixes the issue?

Thanks.

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index f6501f4f6040..9e29dba49d6c 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -176,9 +176,10 @@ typedef enum {
 } cpuset_flagbits_t;
 
 /* convenient tests for these bits */
-static inline bool is_cpuset_online(const struct cpuset *cs)
+static inline bool is_cpuset_online(struct cpuset *cs)
 {
-	return test_bit(CS_ONLINE, &cs->flags);
+	return test_bit(CS_ONLINE, &cs->flags) &&
+		!percpu_ref_is_dying(&cs->css.refcnt);
 }
 
 static inline int is_cpu_exclusive(const struct cpuset *cs)
