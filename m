From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: Cgroup v2 bug: "domain invalid" node can't be converted to
 "threaded"
Date: Thu, 4 Oct 2018 20:14:55 +0200
Message-ID: <0cf4f9de-70d2-cf94-12d2-283759638e20@gmail.com>
References: <CAKgNAkhHYCMn74TCNiMJ=ccLd7DcmXSbvw3CbZ1YREeG7iJM5g@mail.gmail.com>
 <20181002210741.GJ270328@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZBeAL2uIxDhJvUj5bsgnGyJxC+3ht41XiHdgrhMOzsM=;
        b=BMeOA5ce6w9POAEfDU03i5z0xkdirArRh0S7AE0jFOVrRqQK3tcAMlZoo76YNLSIZ/
         sD3tuvu4BA3a3IlbetHpJpuEUYkKEYnPab+faTE0bAMfeBW1o5FWdhQB3G/o+kBORBzN
         URSHcq57fcJwRZWJ4MjtaOMvore3l959pbCtzZju1e/vITZzfjleCZ5lDe3bl0cajB7a
         FMFM6TZtAsSL2YfSZ2j8QYjFB+99SE2o56ts+iCsRSP5imwatGflbs5/CYRhIa6xpXqv
         1pisgcBJtmmzPiuSkUcEWVFvkZlVjWxGgWHJJXXj3NlhvMB4jon7hTMauOoKbJYr6v4D
         iR+A==
In-Reply-To: <20181002210741.GJ270328@devbig004.ftw2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj@kernel.org>
Cc: mtk.manpages@gmail.com, lkml <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Amin Jamali <ajamali@pivotal.io>, Joao De Almeida Pereira <jpereira@pivotal.io>

Hello Tejun,

On 10/02/2018 11:07 PM, Tejun Heo wrote:
> Hello, Michael.
> 
> Great catch.  Can you please verify whether the following patch fixes
> the issue?
> 
> Thanks.
Against which kernel version should this apply? I get these build
errors on kernel 4.18:

[[
  CC      kernel/cgroup/cgroup.o
kernel/cgroup/cgroup.c: In function ‘cgroup_save_control’:
kernel/cgroup/cgroup.c:2851:9: error: ‘struct cgroup’ has no member named ‘old_dom_cgrp’; did you mean ‘dom_cgrp’?
   dsct->old_dom_cgrp = dsct->dom_cgrp;
         ^~~~~~~~~~~~
         dom_cgrp
kernel/cgroup/cgroup.c: In function ‘cgroup_restore_control’:
kernel/cgroup/cgroup.c:2892:26: error: ‘struct cgroup’ has no member named ‘old_dom_cgrp’; did you mean ‘dom_cgrp’?
   dsct->dom_cgrp = dsct->old_dom_cgrp;
                          ^~~~~~~~~~~~
                          dom_cgrp
make[2]: *** [scripts/Makefile.build:318: kernel/cgroup/cgroup.o] Error 1
make[1]: *** [scripts/Makefile.build:558: kernel/cgroup] Error 2
make: *** [Makefile:1029: kernel] Error 2
$ vi ~/p1.eml kernel/cgroup/cgroup.c
/home/mtk/p1.eml ==> /hdd/backup/home/mtk/p1.eml/2018-10-04_20:11:57
kernel/cgroup/cgroup.c ==> /hdd/backup/hdd/workspace/KERNEL/build/linux-4.18/kernel/cgroup/cgroup.c/2018-10-04_20:11:57
]]

Thanks,

Michael


> ------ 8< ------
> Subject: cgroup: Fix dom_cgrp propagation when enabling threaded mode
> 
> A cgroup which is already a threaded domain may be converted into a
> threaded cgroup if the prerequisite conditions are met.  When this
> happens, all threaded descendant should also have their ->dom_cgrp
> updated to the new threaded domain cgroup.  Unfortunately, this
> propagation was missing leading to the following failure.
> 
>   # cd /sys/fs/cgroup/unified
>   # cat cgroup.subtree_control    # show that no controllers are enabled
> 
>   # mkdir -p mycgrp/a/b/c
>   # echo threaded > mycgrp/a/b/cgroup.type
> 
>   At this point, the hierarchy looks as follows:
> 
>       mycgrp [d]
> 	  a [dt]
> 	      b [t]
> 		  c [inv]
> 
>   Now let's make node "a" threaded (and thus "mycgrp" s made "domain threaded"):
> 
>   # echo threaded > mycgrp/a/cgroup.type
> 
>   By this point, we now have a hierarchy that looks as follows:
> 
>       mycgrp [dt]
> 	  a [t]
> 	      b [t]
> 		  c [inv]
> 
>   But, when we try to convert the node "c" from "domain invalid" to
>   "threaded", we get ENOTSUP on the write():
> 
>   # echo threaded > mycgrp/a/b/c/cgroup.type
>   sh: echo: write error: Operation not supported
> 
> This patch fixes the problem by
> 
> * Moving the opencoded ->dom_cgrp save and restoration in
>   cgroup_enable_threaded() into cgroup_{save|restore}_control() so
>   that mulitple cgroups can be handled.
>   
> * Updating all threaded descendants' ->dom_cgrp to point to the new
>   dom_cgrp when enabling threaded mode.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
> Link: https://lore.kernel.org/r/CAKgNAkhHYCMn74TCNiMJ=ccLd7DcmXSbvw3CbZ1YREeG7iJM5g@mail.gmail.com
> Fixes: 454000adaa2a ("cgroup: introduce cgroup->dom_cgrp and threaded css_set handling")
> Cc: stable@vger.kernel.org # v4.14+
> ---
>  kernel/cgroup/cgroup.c |   25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
> 
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -2836,11 +2836,12 @@ restart:
>  }
>  
>  /**
> - * cgroup_save_control - save control masks of a subtree
> + * cgroup_save_control - save control masks and dom_cgrp of a subtree
>   * @cgrp: root of the target subtree
>   *
> - * Save ->subtree_control and ->subtree_ss_mask to the respective old_
> - * prefixed fields for @cgrp's subtree including @cgrp itself.
> + * Save ->subtree_control, ->subtree_ss_mask and ->dom_cgrp to the
> + * respective old_ prefixed fields for @cgrp's subtree including @cgrp
> + * itself.
>   */
>  static void cgroup_save_control(struct cgroup *cgrp)
>  {
> @@ -2850,6 +2851,7 @@ static void cgroup_save_control(struct c
>  	cgroup_for_each_live_descendant_pre(dsct, d_css, cgrp) {
>  		dsct->old_subtree_control = dsct->subtree_control;
>  		dsct->old_subtree_ss_mask = dsct->subtree_ss_mask;
> +		dsct->old_dom_cgrp = dsct->dom_cgrp;
>  	}
>  }
>  
> @@ -2875,11 +2877,12 @@ static void cgroup_propagate_control(str
>  }
>  
>  /**
> - * cgroup_restore_control - restore control masks of a subtree
> + * cgroup_restore_control - restore control masks and dom_cgrp of a subtree
>   * @cgrp: root of the target subtree
>   *
> - * Restore ->subtree_control and ->subtree_ss_mask from the respective old_
> - * prefixed fields for @cgrp's subtree including @cgrp itself.
> + * Restore ->subtree_control, ->subtree_ss_mask and ->dom_cgrp from the
> + * respective old_ prefixed fields for @cgrp's subtree including @cgrp
> + * itself.
>   */
>  static void cgroup_restore_control(struct cgroup *cgrp)
>  {
> @@ -2889,6 +2892,7 @@ static void cgroup_restore_control(struc
>  	cgroup_for_each_live_descendant_post(dsct, d_css, cgrp) {
>  		dsct->subtree_control = dsct->old_subtree_control;
>  		dsct->subtree_ss_mask = dsct->old_subtree_ss_mask;
> +		dsct->dom_cgrp = dsct->old_dom_cgrp;
>  	}
>  }
>  
> @@ -3196,6 +3200,8 @@ static int cgroup_enable_threaded(struct
>  {
>  	struct cgroup *parent = cgroup_parent(cgrp);
>  	struct cgroup *dom_cgrp = parent->dom_cgrp;
> +	struct cgroup *dsct;
> +	struct cgroup_subsys_state *d_css;
>  	int ret;
>  
>  	lockdep_assert_held(&cgroup_mutex);
> @@ -3225,12 +3231,13 @@ static int cgroup_enable_threaded(struct
>  	 */
>  	cgroup_save_control(cgrp);
>  
> -	cgrp->dom_cgrp = dom_cgrp;
> +	cgroup_for_each_live_descendant_pre(dsct, d_css, cgrp)
> +		if (dsct == cgrp || cgroup_is_threaded(dsct))
> +			dsct->dom_cgrp = dom_cgrp;
> +
>  	ret = cgroup_apply_control(cgrp);
>  	if (!ret)
>  		parent->nr_threaded_children++;
> -	else
> -		cgrp->dom_cgrp = cgrp;
>  
>  	cgroup_finalize_control(cgrp, ret);
>  	return ret;
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
