From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 0/3] memcg: Slow down swap allocation as the available
 space gets depleted
Date: Wed, 22 Apr 2020 10:15:14 -0400
Message-ID: <20200422141514.GA362484@cmpxchg.org>
References: <20200417225941.GE43469@mtj.thefacebook.com>
 <CALvZod6M4OsM-t8m_KX9wCkEutdwUMgbP9682eHGQor9JvO_BQ@mail.gmail.com>
 <20200420164740.GF43469@mtj.thefacebook.com>
 <20200420170318.GV27314@dhcp22.suse.cz>
 <20200420170650.GA169746@mtj.thefacebook.com>
 <20200421110612.GD27314@dhcp22.suse.cz>
 <20200421142746.GA341682@cmpxchg.org>
 <20200421161138.GL27314@dhcp22.suse.cz>
 <20200421165601.GA345998@cmpxchg.org>
 <20200422132632.GG30312@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2AHRqHxCmiwXN0EhIIrAV3drjpQwspXxC+Tz9XMuy+8=;
        b=VLtSM6Koh1mVxNBgBhq8VK6hkxnm5iP4u8LwHu4YoEamL6IKzwJK/2XCY2SPIIUV4u
         GV/woLeRdv25GnvF+55c1C4P++fkDZSgXVjb52MTaJouMwu9F91R6If5DHztrDOlG9HX
         MxMe9/Rq4jraUSbZ573bLYVdjdE5LdlzjtkvBOq66+m1e731htK/YGa7Mce8vbVes7IM
         a4aR3P4DZFPZaplzX0VH6EPEUedbOYb7kfKTTyPu45TmFGiRyFm4jtGVy8hpDADMIBt6
         alB77TrenVgS8DRyVj+i8G13iqIQ1UilqQzAlIPARK/fXUMZ7e+TUIkT6l+qnS74DTx9
         6cWw==
Content-Disposition: inline
In-Reply-To: <20200422132632.GG30312-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Apr 22, 2020 at 03:26:32PM +0200, Michal Hocko wrote:
> That being said I believe our discussion is missing an important part.
> There is no description of the swap.high semantic. What can user expect
> when using it?

Good point, we should include that in cgroup-v2.rst. How about this?

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index bcc80269bb6a..49e8733a9d8a 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1370,6 +1370,17 @@ PAGE_SIZE multiple when read back.
 	The total amount of swap currently being used by the cgroup
 	and its descendants.
 
+  memory.swap.high
+	A read-write single value file which exists on non-root
+	cgroups.  The default is "max".
+
+	Swap usage throttle limit.  If a cgroup's swap usage exceeds
+	this limit, allocations inside the cgroup will be throttled.
+
+	This slows down expansion of the group's memory footprint as
+	it runs out of assigned swap space. Compare to memory.swap.max,
+	which stops swapping abruptly and can provoke kernel OOM kills.
+
   memory.swap.max
 	A read-write single value file which exists on non-root
 	cgroups.  The default is "max".
