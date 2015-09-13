From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/3] memcg: drop unnecessary cold-path tests from
 __memcg_kmem_bypass()
Date: Sun, 13 Sep 2015 16:15:09 -0400
Message-ID: <20150913201509.GE25369@htj.duckdns.org>
References: <20150913201416.GC25369@htj.duckdns.org>
 <20150913201442.GD25369@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=WQmy2ZUjrNxY3c/IuqeeI1gTM8jLR+u9ccULpDzBrQM=;
        b=DMDDOcldRMrU6YZtNGp1eBHJXHeRSHvYwuEJdI1ptZwmfF1gEOGjrZqy/BjCcE7boP
         8RHsFIP1LfICdFUHCiU8bRrzN+tX6pgRXHjvybLnUPVcEvsUtKaPsq7+sYDisZZHNGWh
         c5oWPiI5VVQaLEMoO9PBM9ooDM8g7ewifUDLYgeMthMV74dwUTPhC+sBFgIAnzPV+2Ri
         oYx1ZZQCgQyKTvZ0QRIJGylcYmrcGRb2Thkvvx7hjx6/UmQwhoQXmsktBHSImPD7L6bk
         HIP4ED83VlUEvTh5YtvhH1K21xFOlNE21H3dEctUaBmW1FSANhsAe6wWA5k6AnAhdHpg
         u7VQ==
Content-Disposition: inline
In-Reply-To: <20150913201442.GD25369-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

__memcg_kmem_bypass() decides whether a kmem allocation should be
bypassed to the root memcg.  Some conditions that it tests are valid
criteria regarding who should be held accountable; however, there are
a couple unnecessary tests for cold paths - __GFP_FAIL and
fatal_signal_pending().

The previous patch updated try_charge() to handle both __GFP_FAIL and
dying tasks correctly and the only thing these two tests are doing is
making accounting less accurate and sprinkling tests for cold path
conditions in the hot paths.  There's nothing meaningful gained by
these extra tests.

This patch removes the two unnecessary tests from
__memcg_kmem_bypass().

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/memcontrol.h |   14 --------------
 1 file changed, 14 deletions(-)

--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -780,24 +780,10 @@ static inline bool __memcg_kmem_bypass(g
 {
 	if (!memcg_kmem_enabled())
 		return true;
-
 	if (gfp & __GFP_NOACCOUNT)
 		return true;
-	/*
-	 * __GFP_NOFAIL allocations will move on even if charging is not
-	 * possible. Therefore we don't even try, and have this allocation
-	 * unaccounted. We could in theory charge it forcibly, but we hope
-	 * those allocations are rare, and won't be worth the trouble.
-	 */
-	if (gfp & __GFP_NOFAIL)
-		return true;
 	if (in_interrupt() || (!current->mm) || (current->flags & PF_KTHREAD))
 		return true;
-
-	/* If the test is dying, just let it go. */
-	if (unlikely(fatal_signal_pending(current)))
-		return true;
-
 	return false;
 }
 
