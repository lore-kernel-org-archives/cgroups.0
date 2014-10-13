From: Heena Sirwani <heenasirwani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v5 0/2] cpuset: Replace instances of time_t with time64_t to
 solve y2038 problem
Date: Mon, 13 Oct 2014 10:19:51 +0530
Message-ID: <cover.1413174804.git.heenasirwani@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=WLHFp65qWYOAp6/v6/9zGUcggD+iGJrGc+Te2k5qw70=;
        b=xBbmiHAEoJ0hy2WQ2VgxDnHUdOvzteOlYFxCiIPbdDsAsVQdudgCyPiG7Rc7+vTNnD
         Ml19+zcyU337cCvhE2YmrFNr/RZidnUBOXXQ9hrFhgNfIxBEpJU6wrs9/ehT9sqyPVEC
         j0E4Y0lTcrE8GpmHSxEbvdAUHNOIdn3jfDPZv/Gyq3VEbIk9vYvLcixrR1r1keQjjGSu
         qJlt7yUVRhENnZL+krBJvYa3QezJut79Lfx3LQSDYR4DYtKhpe/O7FT8RF/YK+Eq1mLj
         4yF8lUgVDtzRuGP7jF9HkCE9AySFyVzRTan6JEgctkzYvR/ac8oMpy1iQzbfXTcsIE9p
         wddw==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: opw-kernel-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: arnd-r2nGTMty4D4@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The following patchset replaces instances of time_t with time64_t to
address the y2038 problem. The patchset also makes the code independent
of settimeofday().

Changes in v2:
        - Changed the function get_seconds() that return a 32-bit
	  integer to ktime_get_real_ts64() that returns a struct of
	  type timespec64 and use the tv_sec part which is 64-bit.

	- Change the type of ticks from time_t to u32. We keep ticks as
	  32-bits as the function uses 32-bit arithmetic which would
	  prove less expensive than 64-bit arithmetic and the function
	  is expected to be called atleast once every 32 seconds.

Changes in v3:
	- Changed commenting style.

Changes in v4:
	- Changed the subject tag.

Changes in v5:
	- Changed a comment and added a patch that make the code
	  independent of settimeofday().

Heena Sirwani (2):
  cpuset: Replace all instances of time_t with time64_t
  cpuset: Replace ktime_get_real_ts64() with ktime_get_ts64()

 kernel/cpuset.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

-- 
1.9.1
