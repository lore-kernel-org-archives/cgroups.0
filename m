From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [1/3] cgroup: "cgroup.subtree_control" should be writeable by
 delegatee
Date: Sun, 25 Jun 2017 00:27:17 -0400
Message-ID: <20170625042717.GA14158@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=95Mfe0S+ZKtLIyYzm4npCQTeAECToQBOubGYJ5tScO8=;
        b=oYv9bLOPapOW4yiNcyCA6ewkY0jtCrSWm/5xGp+NJo/EevL4xb4A7VPvrrNkqxwQCx
         uNXuBPXZNtNClHcPKdzWYwEuUSXeCSQq+lKSV7eFIHSPMSq1Vi5Wz21R2/1SDcL01Atj
         Br9BhrVyKZywhGXsHvXLFIA4zq3webrn7vcvIfgN8lv3+I4nMR84+WllkRK/yIpejFWb
         kenVF5Yz4EjOhKKRls6yvIJXkdRe8vtYHOFKEjp20uXZs+Mernu9w/GZhFPS7tunRunY
         RBwmYPJPsNNslXixD2dVyuLBKy8XF1yM12GWuhZu+PklRnp7TjuKLP89qAUSlbNNc7AP
         DjJA==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aravind Anbudurai <aru7-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

"cgroup.subtree_control" determines which resource types a cgroup
wants to control.  Unlike actual resource knobs, this is an attribute
which belongs to the cgroup itself instead of its parent and thus
should be writeable by the delegatee in a delegated cgroup.

Update delegation documentation accordingly.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 Documentation/cgroup-v2.txt |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -309,10 +309,11 @@ file.
 2-5-1. Model of Delegation
 
 A cgroup can be delegated to a less privileged user by granting write
-access of the directory and its "cgroup.procs" file to the user.  Note
-that resource control interface files in a given directory control the
-distribution of the parent's resources and thus must not be delegated
-along with the directory.
+access of the directory and its "cgroup.procs" and
+"cgroup.subtree_control" files to the user.  Note that resource
+control interface files in a given directory control the distribution
+of the parent's resources and thus must not be delegated along with
+the directory.
 
 Once delegated, the user can build sub-hierarchy under the directory,
 organize processes as it sees fit and further distribute the resources
