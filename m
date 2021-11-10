From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 3/4] mm, shmem: add tmpfs memcg= option documentation
Date: Wed, 10 Nov 2021 13:19:49 -0800
Message-ID: <20211110211951.3730787-4-almasrymina@google.com>
References: <20211110211951.3730787-1-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
        bh=ht251uoyJjMbFDL2TxmjV/XN4/hXafLiuH05NGnumYk=;
        b=k0TTN636enCe/ZMmeDII0J/CegZ6ncDK7yKWw7ZeBWMxbKHHazE2DId/yW7TYXbfi8
         O5Yq9ZpclOX9PDD/9UKpxnBf8phr0BrRtW8oaGV0zz7VwAvHi+HacqJd9Ybi1dbenSIQ
         G2rDRoKgXjSvJCuLpzq8xVzz5f+YfSB6NtLHQRKgAIQkIMQUjoaENBgNO2hmVTk/CgU+
         4GOME56bKNUHCfHCryFmpcs8fxuv+Ly8oFnLIxdtYd+35ExNUXICX9Xb04z4oxz0uqoT
         fHBB0jJUl1W6L0lcuF4pEp/RzaEu5oBCvoLucY+O0LjmYUulutUJEWpPV00TsQo+hwkM
         iDgw==
In-Reply-To: <20211110211951.3730787-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Cc: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

---
 Documentation/filesystems/tmpfs.rst | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/filesystems/tmpfs.rst b/Documentation/filesystems/tmpfs.rst
index 0408c245785e3..1ab04e8fa9222 100644
--- a/Documentation/filesystems/tmpfs.rst
+++ b/Documentation/filesystems/tmpfs.rst
@@ -137,6 +137,23 @@ mount options.  It can be added later, when the tmpfs is already mounted
 on MountPoint, by 'mount -o remount,mpol=Policy:NodeList MountPoint'.


+If CONFIG_MEMCG is enabled, tmpfs has a mount option to specify the memory
+cgroup to be charged for page allocations.
+
+memcg=/sys/fs/cgroup/unified/test/: data page allocations are charged to
+cgroup /sys/fs/cgroup/unified/test/.
+
+When charging memory to the remote memcg (memcg specified with memcg=) and
+hitting the limit, the oom-killer will be invoked and will attempt to kill
+a process in the remote memcg. If no such processes are found, the remote
+charging process gets an ENOMEM. If the remote charging process is in the
+pagefault path, it gets killed.
+
+Only processes that have access to /sys/fs/cgroup/unified/test/cgroup.procs can
+mount a tmpfs with memcg=/sys/fs/cgroup/unified/test. Thus, a process is able
+to charge memory to a cgroup only if it itself is able to enter that cgroup.
+
+
 To specify the initial root directory you can use the following mount
 options:
