From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-3.16] cgroup: fix rcu_read_lock() leak in
 update_if_frozen()
Date: Fri, 9 May 2014 23:29:41 -0400
Message-ID: <20140510032941.GE22539@mtj.dyndns.org>
References: <5369104d.Nn5Lpp7nwOehwnnC%fengguang.wu@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=sPt3a4ksgPWlzfjIkd0fX92mHIZMaqawR/h1H1cWzY8=;
        b=fgDB2GbrCF1oYgTF3Q90YBqvo2zTSANtjrEY92nOHBTdBl96jc5TCxAKYZivej0ZUO
         C4Bkl4Pyz68IQ08bsv670rEuogt1KxpOnRL7ni24u+/m0BrDzACPaS9jblSI7sACNbBp
         80bfvl8AY083BCSrSC2DwNMXeSRCqvlh2lCDivPoLnIiAsQMwLQMkAuEUx2iDkSz6vzh
         ny8qA/fgmy8kRm0nGst0DIbD395sk82Ky5HxEOvVhREZtmvguEV8fqpedB4B8f8h/4Bb
         l1L8FYwQKsGPecOMd+ssA3BInSDkC3xglKhAXt2wGPMS18EgWWniVoBMBYGNKwUtBS22
         Ovwg==
Content-Disposition: inline
In-Reply-To: <5369104d.Nn5Lpp7nwOehwnnC%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

While updating cgroup_freezer locking, 68fafb77d827 ("cgroup_freezer:
replace freezer->lock with freezer_mutex") introduced a bug in
update_if_frozen() where it returns with rcu_read_lock() held.  Fix it
by adding rcu_read_unlock() before returning.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup_freezer.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -267,8 +267,10 @@ static void update_if_frozen(struct cgro
 		struct freezer *child = css_freezer(pos);
 
 		if ((child->state & CGROUP_FREEZER_ONLINE) &&
-		    !(child->state & CGROUP_FROZEN))
+		    !(child->state & CGROUP_FROZEN)) {
+			rcu_read_unlock();
 			return;
+		}
 	}
 	rcu_read_unlock();
 
