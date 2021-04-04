From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [cgroup:for-next 3/3] include/linux/misc_cgroup.h:98:15:
 warning: no previous prototype for function 'misc_cg_res_total_usage'
Date: Sun, 4 Apr 2021 18:32:31 -0400
Message-ID: <YGo+f3XoA4CtRAPt@mtj.duckdns.org>
References: <202104050523.t4Om6TmY-lkp@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:84;0;0cto;
        bh=SN4VFWPC+wyT3rAIlOFAZrVOzwF1f5acphi1J3LvQE4=;
        b=IcxlWit8/x/S9P/7qVO3qYhsEBUtBlcNWYvDi9nd27E/reKm+n/IP139Q3c/CDGzi0
         Y+U0crP/86CKn2RQW3PWLEnCrs60J0Zbe/s1sAD+HldgpTPoh6RSvTHXayc6WtCXcTCK
         eUGmhJe/zG20v9fqhZY1NxcexG0tFPrkFplpmkuO1dC3Ne+7UdCNptkEcKUnvDkwNmzQ
         do75If8L2N+8xydA5cYJgAuqBDDMnAsxHm+8XVJaLUyNQf8GirA5THfaYU7p7Gmhp6Uz
         6Hj0kEfWuh5fnoIdwtJYB0Gu9X2DQosKLgIPBV0+qJUMn58aaW1ISXjHaP+QZ/uZjV4+
         RKzA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <202104050523.t4Om6TmY-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, clang-built-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Applied the following patch to cgroup/for-5.13.

Thanks.
----- 8< -----
From dd3f4e4972f146a685930ccfed95e4e1d13d952a Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Sun, 4 Apr 2021 18:29:37 -0400
Subject: [PATCH] cgroup: misc: mark dummy misc_cg_res_total_usage() static
 inline

The dummy implementation was missing static inline triggering the following
compile warning on llvm.

   In file included from arch/x86/kvm/svm/sev.c:17:
>> include/linux/misc_cgroup.h:98:15: warning: no previous prototype for function 'misc_cg_res_total_usage' [-Wmissing-prototypes]
   unsigned long misc_cg_res_total_usage(enum misc_res_type type)
                 ^
   include/linux/misc_cgroup.h:98:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   unsigned long misc_cg_res_total_usage(enum misc_res_type type)
   ^
   static
   1 warning generated.

Add it.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/linux/misc_cgroup.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index c5af592481c0..da2367e2ac1e 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -95,7 +95,7 @@ static inline void put_misc_cg(struct misc_cg *cg)
 
 #else /* !CONFIG_CGROUP_MISC */
 
-unsigned long misc_cg_res_total_usage(enum misc_res_type type)
+static inline unsigned long misc_cg_res_total_usage(enum misc_res_type type)
 {
 	return 0;
 }
-- 
2.31.1

