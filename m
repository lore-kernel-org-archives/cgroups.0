From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v13 6/7] mm, oom, docs: describe the cgroup-aware OOM
 killer
Date: Fri, 1 Dec 2017 17:01:49 +0000
Message-ID: <20171201170149.GB27436@castle.DHCP.thefacebook.com>
References: <20171130152824.1591-1-guro@fb.com>
 <20171130152824.1591-7-guro@fb.com>
 <20171201084154.l7i3fxtxd4fzrq7s@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=5ucLoejPufEGIvEvzAtT4ck4G6RLGDiOuJ74k7/eDU8=;
 b=bGjR++dCRzZd88Xu9x2buHq5VYHAH18ZCIQeo9uYb7e++GjDLekxnS71SErpRVMrrZdB
 ZLlf5QIEZfQl0eI3/rGfyjz7bmONCDu20xDQivb9oT6urUcrHaUHfX7HJG0nJAZSFQ7G
 P0dHx7PayRvWWDV7hNZplutW5dHKrwGje1w= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=5ucLoejPufEGIvEvzAtT4ck4G6RLGDiOuJ74k7/eDU8=;
 b=YV/n867gw03AB5+8SPom/D6FqnDrJh5cIlA7XNv9+8WN1KwKl358fSrK4SPqyN1AehKvVyZOb6JTcH8xWsQzkkGtV9FfwoY3MW4CP9dzlXA5JOAr1ZaHGwKLiQ8qKhLAnxc2+8pDAZs/uENlhnzIcpHk7UFqPHK0Ij0ml+QAZoE=
Content-Disposition: inline
In-Reply-To: <20171201084154.l7i3fxtxd4fzrq7s@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Fri, Dec 01, 2017 at 09:41:54AM +0100, Michal Hocko wrote:
> On Thu 30-11-17 15:28:23, Roman Gushchin wrote:
> > @@ -1229,6 +1252,41 @@ to be accessed repeatedly by other cgroups, it may make sense to use
> >  POSIX_FADV_DONTNEED to relinquish the ownership of memory areas
> >  belonging to the affected files to ensure correct memory ownership.
> >  
> > +OOM Killer
> > +~~~~~~~~~~
> > +
> > +Cgroup v2 memory controller implements a cgroup-aware OOM killer.
> > +It means that it treats cgroups as first class OOM entities.
> 
> This should mention groupoom mount option to enable this functionality.
> 
> Other than that looks ok to me
> Acked-by: Michal Hocko <mhocko@suse.com>
> -- 
> Michal Hocko
> SUSE Labs


From 1d9c87128897ee7f27f9651d75b80f73985373e8 Mon Sep 17 00:00:00 2001
From: Roman Gushchin <guro@fb.com>
Date: Fri, 1 Dec 2017 15:34:59 +0000
Subject: [PATCH] mm, oom, docs: document groupoom mount option

Add a note that cgroup-aware OOM logic is disabled by default
and describe how to enable it.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: kernel-team@fb.com
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/cgroup-v2.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index c80a147f94b7..ff8e92db636d 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -1049,6 +1049,9 @@ PAGE_SIZE multiple when read back.
 	and will never kill the unkillable task, even if memory.oom_group
 	is set.
 
+	If cgroup-aware OOM killer is not enabled, ENOTSUPP error
+	is returned on attempt to access the file.
+
   memory.events
 	A read-only flat-keyed file which exists on non-root cgroups.
 	The following entries are defined.  Unless specified
@@ -1258,6 +1261,12 @@ OOM Killer
 Cgroup v2 memory controller implements a cgroup-aware OOM killer.
 It means that it treats cgroups as first class OOM entities.
 
+Cgroup-aware OOM logic is turned off by default and requires
+passing the "groupoom" option on mounting cgroupfs. It can also
+by remounting cgroupfs with the following command::
+
+  # mount -o remount,groupoom $MOUNT_POINT
+
 Under OOM conditions the memory controller tries to make the best
 choice of a victim, looking for a memory cgroup with the largest
 memory footprint, considering leaf cgroups and cgroups with the
-- 
2.14.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
